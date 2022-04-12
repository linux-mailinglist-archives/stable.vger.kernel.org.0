Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC984FD519
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354000AbiDLHqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357164AbiDLHju (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF713E01;
        Tue, 12 Apr 2022 00:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE7E3B81A8F;
        Tue, 12 Apr 2022 07:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC49C385A6;
        Tue, 12 Apr 2022 07:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747592;
        bh=bnNakFxqskyH9Z6SrX9IiVWIDVGGSYF51Zlbl2yDyU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7QhNBnL4DbKr+LSkZNAp5JNKLkeQ7vztwVgQb881Vtw7fi5tcW5V7rXB7Ebwl4Y/
         NERoZ1Z480tgSHW84r2tnfXd0PinHa6KGVxRbGp2HU5hwdlbFT5kEtFvohg7Vijd+l
         sgST0Uuk7WFeZLSJudkoJ+V0x3GWPRslD7u7S7nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 108/343] mctp: make __mctp_dev_get() take a refcount hold
Date:   Tue, 12 Apr 2022 08:28:46 +0200
Message-Id: <20220412062954.511957104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit dc121c0084910db985cf1c8ba6fce5d8c307cc02 ]

Previously there was a race that could allow the mctp_dev refcount
to hit zero:

rcu_read_lock();
mdev = __mctp_dev_get(dev);
// mctp_unregister() happens here, mdev->refs hits zero
mctp_dev_hold(dev);
rcu_read_unlock();

Now we make __mctp_dev_get() take the hold itself. It is safe to test
against the zero refcount because __mctp_dev_get() is called holding
rcu_read_lock and mctp_dev uses kfree_rcu().

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c     | 21 ++++++++++++++++++---
 net/mctp/route.c      |  5 ++++-
 net/mctp/test/utils.c |  1 -
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index ef2755f82f87..f86ef6d751bd 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -24,12 +24,25 @@ struct mctp_dump_cb {
 	size_t a_idx;
 };
 
-/* unlocked: caller must hold rcu_read_lock */
+/* unlocked: caller must hold rcu_read_lock.
+ * Returned mctp_dev has its refcount incremented, or NULL if unset.
+ */
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev)
 {
-	return rcu_dereference(dev->mctp_ptr);
+	struct mctp_dev *mdev = rcu_dereference(dev->mctp_ptr);
+
+	/* RCU guarantees that any mdev is still live.
+	 * Zero refcount implies a pending free, return NULL.
+	 */
+	if (mdev)
+		if (!refcount_inc_not_zero(&mdev->refs))
+			return NULL;
+	return mdev;
 }
 
+/* Returned mctp_dev does not have refcount incremented. The returned pointer
+ * remains live while rtnl_lock is held, as that prevents mctp_unregister()
+ */
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev)
 {
 	return rtnl_dereference(dev->mctp_ptr);
@@ -123,6 +136,7 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 				if (mdev) {
 					rc = mctp_dump_dev_addrinfo(mdev,
 								    skb, cb);
+					mctp_dev_put(mdev);
 					// Error indicates full buffer, this
 					// callback will get retried.
 					if (rc < 0)
@@ -297,7 +311,7 @@ void mctp_dev_hold(struct mctp_dev *mdev)
 
 void mctp_dev_put(struct mctp_dev *mdev)
 {
-	if (refcount_dec_and_test(&mdev->refs)) {
+	if (mdev && refcount_dec_and_test(&mdev->refs)) {
 		dev_put(mdev->dev);
 		kfree_rcu(mdev, rcu);
 	}
@@ -369,6 +383,7 @@ static size_t mctp_get_link_af_size(const struct net_device *dev,
 	if (!mdev)
 		return 0;
 	ret = nla_total_size(4); /* IFLA_MCTP_NET */
+	mctp_dev_put(mdev);
 	return ret;
 }
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index e52cef750500..05fbd318eb98 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -786,7 +786,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 {
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb = mctp_cb(skb);
-	struct mctp_route tmp_rt;
+	struct mctp_route tmp_rt = {0};
 	struct mctp_sk_key *key;
 	struct net_device *dev;
 	struct mctp_hdr *hdr;
@@ -892,6 +892,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		mctp_route_release(rt);
 
 	dev_put(dev);
+	mctp_dev_put(tmp_rt.dev);
 
 	return rc;
 
@@ -1057,11 +1058,13 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 
 	rt->output(rt, skb);
 	mctp_route_release(rt);
+	mctp_dev_put(mdev);
 
 	return NET_RX_SUCCESS;
 
 err_drop:
 	kfree_skb(skb);
+	mctp_dev_put(mdev);
 	return NET_RX_DROP;
 }
 
diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
index 7b7918702592..e03ba66bbe18 100644
--- a/net/mctp/test/utils.c
+++ b/net/mctp/test/utils.c
@@ -54,7 +54,6 @@ struct mctp_test_dev *mctp_test_create_dev(void)
 
 	rcu_read_lock();
 	dev->mdev = __mctp_dev_get(ndev);
-	mctp_dev_hold(dev->mdev);
 	rcu_read_unlock();
 
 	return dev;
-- 
2.35.1



