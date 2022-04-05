Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02284F2FAE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbiDEI4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241139AbiDEIcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D3FB93;
        Tue,  5 Apr 2022 01:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FF860B0A;
        Tue,  5 Apr 2022 08:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D183C385A2;
        Tue,  5 Apr 2022 08:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147313;
        bh=R7z4dNtHDM1ZIK27/IYmVTd0GpqG9Hlim6aALNN1RCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd6KwoXijtSMyV7NlezPxEWxCg23i0gMEYM9JtLDCkaghYnkLFRoI8Q9NglyjxbUJ
         oXr5XyATwmOInKE9Ad6S7w3esqdFOuHEoUybM0Jn3uqk+cG6m+f87JzYmOsPfn9y9w
         G28xZKMVjYIGHcUDy451i/v/932Z1jWZ8nb8y+d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 1078/1126] net: add skb_set_end_offset() helper
Date:   Tue,  5 Apr 2022 09:30:25 +0200
Message-Id: <20220405070439.095212079@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1475,6 +1475,11 @@ static inline unsigned int skb_end_offse
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
@@ -1485,6 +1490,11 @@ static inline unsigned int skb_end_offse
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
@@ -201,7 +201,7 @@ static void __build_skb_around(struct sk
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
-	skb->end = skb->tail + size;
+	skb_set_end_offset(skb, size);
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
 
@@ -1736,11 +1736,10 @@ int pskb_expand_head(struct sk_buff *skb
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
@@ -6044,11 +6043,7 @@ static int pskb_carve_inside_header(stru
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
@@ -6186,11 +6181,7 @@ static int pskb_carve_inside_nonlinear(s
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


