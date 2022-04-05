Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD1F4F3A23
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379187AbiDELkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354450AbiDEKOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BE76A010;
        Tue,  5 Apr 2022 03:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 63D65CE0B18;
        Tue,  5 Apr 2022 10:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B977C385A1;
        Tue,  5 Apr 2022 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152808;
        bh=KbcFA6Q3yLM52ALUUVmwuNRPyePwNo0MqRUxe/NNLCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=My4WcbdphqvY4aecczTqtxcpeWdoOZHUhRrTxzT9gIV6TQxgnffgYueAiC2J5+ihN
         PGIppOILZOrflMHKPKXwyyHhv3y9fEXfTP9TXNimaLQDXiRmVGaRppQg1kP80pTAvE
         4oB7k5hnF57uWxd4PFmWMc2oKKyUt10exKp2eDNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 871/913] net: add skb_set_end_offset() helper
Date:   Tue,  5 Apr 2022 09:32:13 +0200
Message-Id: <20220405070405.932435069@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 763087dab97547230a6807c865a6a5ae53a59247 upstream.

We have multiple places where this helper is convenient,
and plan using it in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   10 ++++++++++
 net/core/skbuff.c      |   19 +++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1436,6 +1436,11 @@ static inline unsigned int skb_end_offse
 {
 	return skb->end;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = offset;
+}
 #else
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
@@ -1446,6 +1451,11 @@ static inline unsigned int skb_end_offse
 {
 	return skb->end - skb->head;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = skb->head + offset;
+}
 #endif
 
 /* Internal */
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -203,7 +203,7 @@ static void __build_skb_around(struct sk
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
-	skb->end = skb->tail + size;
+	skb_set_end_offset(skb, size);
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
 
@@ -1738,11 +1738,10 @@ int pskb_expand_head(struct sk_buff *skb
 	skb->head     = data;
 	skb->head_frag = 0;
 	skb->data    += off;
+
+	skb_set_end_offset(skb, size);
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end      = size;
 	off           = nhead;
-#else
-	skb->end      = skb->head + size;
 #endif
 	skb->tail	      += off;
 	skb_headers_offset_update(skb, nhead);
@@ -6159,11 +6158,7 @@ static int pskb_carve_inside_header(stru
 	skb->head = data;
 	skb->data = data;
 	skb->head_frag = 0;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_set_tail_pointer(skb, skb_headlen(skb));
 	skb_headers_offset_update(skb, 0);
 	skb->cloned = 0;
@@ -6301,11 +6296,7 @@ static int pskb_carve_inside_nonlinear(s
 	skb->head = data;
 	skb->head_frag = 0;
 	skb->data = data;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_reset_tail_pointer(skb);
 	skb_headers_offset_update(skb, 0);
 	skb->cloned   = 0;


