Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0931F66C6EF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjAPQ0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjAPQ0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78788274B1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B907FB80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B8C433EF;
        Mon, 16 Jan 2023 16:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885669;
        bh=nduDFTynn5+kV0dyGAArArcLX8kyf/qFN1DWJTvfPbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuPV6FsvQP0AyhX/6mx/JWPAgkWXrAUpq7/g6nAyjWSV0mugLVgHCXpCrxjy+EysS
         qHKQcwRQyv9zBU5SlUgRFOKUm+4TDI9RyAGMOE8qmKVq+7Vy3z22Dfojyjmxc02I1t
         BYvFo7LIixLPMKQuahMBfUZUISCmD7nUJ+VRAqTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/658] bpf: Move skb->len == 0 checks into __bpf_redirect
Date:   Mon, 16 Jan 2023 16:43:48 +0100
Message-Id: <20230116154915.856153392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 114039b342014680911c35bd6b72624180fd669a ]

To avoid potentially breaking existing users.

Both mac/no-mac cases have to be amended; mac_header >= network_header
is not enough (verified with a new test, see next patch).

Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221121180340.1983627-1-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 3 ---
 net/core/filter.c  | 7 ++++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d78c4cc30a28..591d146a5308 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -201,9 +201,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
-	if (!skb->len)
-		return -EINVAL;
-
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index e81f7772161a..6fd9173e18b7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2071,6 +2071,11 @@ static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
 {
 	unsigned int mlen = skb_network_offset(skb);
 
+	if (unlikely(skb->len <= mlen)) {
+		kfree_skb(skb);
+		return -ERANGE;
+	}
+
 	if (mlen) {
 		__skb_pull(skb, mlen);
 
@@ -2092,7 +2097,7 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 				 u32 flags)
 {
 	/* Verify that a link layer header is carried */
-	if (unlikely(skb->mac_header >= skb->network_header)) {
+	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0)) {
 		kfree_skb(skb);
 		return -ERANGE;
 	}
-- 
2.35.1



