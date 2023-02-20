Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B035369CE53
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjBTN6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjBTN6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07871E5F0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EED760EB8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBE7C433EF;
        Mon, 20 Feb 2023 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901473;
        bh=g0alahQXIccgaTxo57XE7sliBK9bf/QuHrP4Km4ph1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSM5LoMNjJXjitYOzgU2GDAf6LYMRtm8CibplaAGSn5MiH6Gdjr6B+/zOnmpWQ8MM
         F1u80Ki1np9AUaGtqyuPL5hxXWH2oIlB1yQ2QBFy6Q15n1bHBkuBo9rRKpkKTNOhwJ
         F5CgpOrWipgZs4ru1dpKPcIHaqyGfzzgCrRRKOOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/118] mptcp: deduplicate error paths on endpoint creation
Date:   Mon, 20 Feb 2023 14:35:19 +0100
Message-Id: <20230220133600.537802253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 976d302fb6165ad620778d7ba834cde6e3fe9f9f ]

When endpoint creation fails, we need to free the newly allocated
entry and eventually destroy the paired mptcp listener socket.

Consolidate such action in a single point let all the errors path
reach it.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ad2171009d96 ("mptcp: fix locking for in-kernel listener creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9813ed0fde9bd..fdf2ee29f7623 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1003,16 +1003,12 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 		return err;
 
 	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (!msk)
+		return -EINVAL;
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (!ssock)
+		return -EINVAL;
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1022,20 +1018,16 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	err = kernel_listen(ssock, backlog);
 	if (err) {
 		pr_warn("kernel_listen error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	return 0;
-
-out:
-	sock_release(entry->lsk);
-	return err;
 }
 
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
@@ -1327,7 +1319,7 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "can't allocate addr");
 		return -ENOMEM;
@@ -1338,22 +1330,21 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		ret = mptcp_pm_nl_create_listen_socket(skb->sk, entry);
 		if (ret) {
 			GENL_SET_ERR_MSG(info, "create listen socket error");
-			kfree(entry);
-			return ret;
+			goto out_free;
 		}
 	}
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
-		if (entry->lsk)
-			sock_release(entry->lsk);
-		kfree(entry);
-		return ret;
+		goto out_free;
 	}
 
 	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk));
-
 	return 0;
+
+out_free:
+	__mptcp_pm_release_addr_entry(entry);
+	return ret;
 }
 
 int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
-- 
2.39.0



