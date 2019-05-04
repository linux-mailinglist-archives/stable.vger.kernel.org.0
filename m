Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E081390A
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfEDK01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfEDK00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D589E2084A;
        Sat,  4 May 2019 10:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965585;
        bh=ls4QDGuqYdGPmgaeQMHr6F52iikuwmWvSQiGIdTpikY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxBfpZlT2BAj0LUHRO88Bkx0ucnubtBXmcCEYN2M0oOBLys62loRaqCjXqSR0z0oD
         UTjdCn8S4m2MeuHsEwqbPb6qb2W9mhM/Y/BWRa7sGC1M9AHkKzc3zdysrMlEzzPiFt
         aybMAd8CoKsaIqLO6E5jqujmuxlOKwOy6wlS0bdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 27/32] net/tls: fix copy to fragments in reencrypt
Date:   Sat,  4 May 2019 12:25:12 +0200
Message-Id: <20190504102453.318811912@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit eb3d38d5adb520435d4e4af32529ccb13ccc9935 ]

Fragments may contain data from other records so we have to account
for that when we calculate the destination and max length of copy we
can perform.  Note that 'offset' is the offset within the message,
so it can't be passed as offset within the frag..

Here skb_store_bits() would have realised the call is wrong and
simply not copy data.

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -579,7 +579,7 @@ void handle_device_resync(struct sock *s
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 {
 	struct strp_msg *rxm = strp_msg(skb);
-	int err = 0, offset = rxm->offset, copy, nsg;
+	int err = 0, offset = rxm->offset, copy, nsg, data_len, pos;
 	struct sk_buff *skb_iter, *unused;
 	struct scatterlist sg[1];
 	char *orig_buf, *buf;
@@ -610,9 +610,10 @@ static int tls_device_reencrypt(struct s
 	else
 		err = 0;
 
+	data_len = rxm->full_len - TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+
 	if (skb_pagelen(skb) > offset) {
-		copy = min_t(int, skb_pagelen(skb) - offset,
-			     rxm->full_len - TLS_CIPHER_AES_GCM_128_TAG_SIZE);
+		copy = min_t(int, skb_pagelen(skb) - offset, data_len);
 
 		if (skb->decrypted)
 			skb_store_bits(skb, offset, buf, copy);
@@ -621,16 +622,30 @@ static int tls_device_reencrypt(struct s
 		buf += copy;
 	}
 
+	pos = skb_pagelen(skb);
 	skb_walk_frags(skb, skb_iter) {
-		copy = min_t(int, skb_iter->len,
-			     rxm->full_len - offset + rxm->offset -
-			     TLS_CIPHER_AES_GCM_128_TAG_SIZE);
+		int frag_pos;
+
+		/* Practically all frags must belong to msg if reencrypt
+		 * is needed with current strparser and coalescing logic,
+		 * but strparser may "get optimized", so let's be safe.
+		 */
+		if (pos + skb_iter->len <= offset)
+			goto done_with_frag;
+		if (pos >= data_len + rxm->offset)
+			break;
+
+		frag_pos = offset - pos;
+		copy = min_t(int, skb_iter->len - frag_pos,
+			     data_len + rxm->offset - offset);
 
 		if (skb_iter->decrypted)
-			skb_store_bits(skb_iter, offset, buf, copy);
+			skb_store_bits(skb_iter, frag_pos, buf, copy);
 
 		offset += copy;
 		buf += copy;
+done_with_frag:
+		pos += skb_iter->len;
 	}
 
 free_buf:


