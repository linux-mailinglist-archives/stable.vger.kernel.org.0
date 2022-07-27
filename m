Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EC458309D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242527AbiG0Rjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242861AbiG0RjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:39:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9A288758;
        Wed, 27 Jul 2022 09:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C5EB821C5;
        Wed, 27 Jul 2022 16:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9639C433D6;
        Wed, 27 Jul 2022 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940668;
        bh=/eMDGI/9OToQZPUaNvF2iNvmdwDeVgUaWbAg4meaaP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOdIV9hgn5tGTajYaQyR1g8oNsLp+g9Ov+Aa0jsyWGbJ0O8oF446y9rCsLWjve5no
         2xYpUYngz/Z1GPVYCHI0LnWci3i8PyRg8MEYTLAX6wGr41TJYc9E6FYj9qzjkkDv1d
         hegrwc8uZwmNB64m5r6wRTuIBMKXyyKUoSL4TZpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 106/158] amt: drop unexpected query message
Date:   Wed, 27 Jul 2022 18:12:50 +0200
Message-Id: <20220727161025.717770820@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 239d886601e38d948a28f3b2a1c9ce5f01bf75f2 ]

AMT gateway interface should not receive unexpected query messages.
In order to drop unexpected query messages, it checks nonce.
And it also checks ready4 and ready6 variables to drop duplicated messages.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 0811a5211ec4..5c65908abd5a 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -967,8 +967,11 @@ static void amt_event_send_request(struct amt_dev *amt)
 		goto out;
 	}
 
-	if (!amt->req_cnt)
+	if (!amt->req_cnt) {
+		WRITE_ONCE(amt->ready4, false);
+		WRITE_ONCE(amt->ready6, false);
 		get_random_bytes(&amt->nonce, sizeof(__be32));
+	}
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
@@ -2353,6 +2356,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	if (amtmq->reserved || amtmq->version)
 		return true;
 
+	if (amtmq->nonce != amt->nonce)
+		return true;
+
 	hdr_size -= sizeof(*eth);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
 		return true;
@@ -2367,6 +2373,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
+		if (READ_ONCE(amt->ready4))
+			return true;
+
 		if (!pskb_may_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS +
 				   sizeof(*ihv3)))
 			return true;
@@ -2389,6 +2398,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		struct mld2_query *mld2q;
 		struct ipv6hdr *ip6h;
 
+		if (READ_ONCE(amt->ready6))
+			return true;
+
 		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
 				   sizeof(*mld2q)))
 			return true;
-- 
2.35.1



