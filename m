Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602B7566A8D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiGEMAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiGEMAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A635817E02;
        Tue,  5 Jul 2022 04:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433996174B;
        Tue,  5 Jul 2022 11:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56841C341CD;
        Tue,  5 Jul 2022 11:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022389;
        bh=nH/iHHTgnKhb3862t/o5lYm7uKzkZ4FjTsdDg0b0vZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LomNs9icWo6Ir/bCREsK1cDpFkM5EW+qBNP5hiSrhInU2+LAz5KxOazOVEcf6kmsJ
         yeDO+1bQqt6zZqY4o8ovY97eCw2Wcn7p3PmuzirZJ1WT2EAzNP3MNGlmmu4h/qR4O6
         jmLnKBAaZ0hKnfWrukvt890gj0lXKjDC1RNlkbZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Lesokhin <ilyal@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 19/29] net: Rename and export copy_skb_header
Date:   Tue,  5 Jul 2022 13:58:00 +0200
Message-Id: <20220705115606.315387213@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
References: <20220705115605.742248854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lesokhin <ilyal@mellanox.com>

commit 08303c189581c985e60f588ad92a041e46b6e307 upstream.

[ jgross@suse.com: added as needed by XSA-403 mitigation ]

copy_skb_header is renamed to skb_copy_header and
exported. Exposing this function give more flexibility
in copying SKBs.
skb_copy and skb_copy_expand do not give enough control
over which parts are copied.

Signed-off-by: Ilya Lesokhin <ilyal@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    1 +
 net/core/skbuff.c      |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -975,6 +975,7 @@ static inline struct sk_buff *alloc_skb_
 struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src);
 int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask);
 struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t priority);
+void skb_copy_header(struct sk_buff *new, const struct sk_buff *old);
 struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t priority);
 struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 				   gfp_t gfp_mask, bool fclone);
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1071,7 +1071,7 @@ static void skb_headers_offset_update(st
 	skb->inner_mac_header += off;
 }
 
-static void copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
+void skb_copy_header(struct sk_buff *new, const struct sk_buff *old)
 {
 	__copy_skb_header(new, old);
 
@@ -1079,6 +1079,7 @@ static void copy_skb_header(struct sk_bu
 	skb_shinfo(new)->gso_segs = skb_shinfo(old)->gso_segs;
 	skb_shinfo(new)->gso_type = skb_shinfo(old)->gso_type;
 }
+EXPORT_SYMBOL(skb_copy_header);
 
 static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 {
@@ -1122,7 +1123,7 @@ struct sk_buff *skb_copy(const struct sk
 	if (skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len))
 		BUG();
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 	return n;
 }
 EXPORT_SYMBOL(skb_copy);
@@ -1185,7 +1186,7 @@ struct sk_buff *__pskb_copy_fclone(struc
 		skb_clone_fraglist(n);
 	}
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 out:
 	return n;
 }
@@ -1356,7 +1357,7 @@ struct sk_buff *skb_copy_expand(const st
 			  skb->len + head_copy_len))
 		BUG();
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 
 	skb_headers_offset_update(n, newheadroom - oldheadroom);
 


