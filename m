Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650BB657DD8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiL1Prj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiL1PrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE0F165A3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F401561542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B44C433EF;
        Wed, 28 Dec 2022 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242432;
        bh=z/jxJhufFLOkzP57XxHxKV0muowwsriGrwZehCrrI/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mE0BhpR/BALAiYiz8Ko7bDUWTVos+498tf6O7VlEnpfya6hGtHfT0CqqotBJ9lHoc
         y1tL860W8VvZcpdH7k7ObqUtJdUnMWNMTPKz0mZQjs18DAxScfBE84mCuKndd4rteo
         NAwtQNLmmTLCr0AtlSqv8uMOH8ub/47fv+4Jd6l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0369/1146] bpf: Move skb->len == 0 checks into __bpf_redirect
Date:   Wed, 28 Dec 2022 15:31:48 +0100
Message-Id: <20221228144340.187950172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index fcb3e6c5e03c..6094ef7cffcd 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -980,9 +980,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
-	if (!skb->len)
-		return -EINVAL;
-
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..b35f642d117f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2124,6 +2124,11 @@ static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
 {
 	unsigned int mlen = skb_network_offset(skb);
 
+	if (unlikely(skb->len <= mlen)) {
+		kfree_skb(skb);
+		return -ERANGE;
+	}
+
 	if (mlen) {
 		__skb_pull(skb, mlen);
 
@@ -2145,7 +2150,7 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
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



