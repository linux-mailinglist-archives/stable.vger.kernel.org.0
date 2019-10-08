Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833A2CF3FC
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfJHHfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:35:13 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58695 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730171AbfJHHfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:35:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EFFD85C1;
        Tue,  8 Oct 2019 03:35:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pQ1Q9z
        EhrsibqefjZyl+JLWZ2v/VAMTOq8+YKzMU9oY=; b=L8pgTsu/Nnc4IkdHfseeyQ
        XsFLrTtBN4GC6wrBhFTi0JkQxhAL5kzivGcefg82hqvWI+YGJbQaG9Ar0AO40UWL
        ebgVgCJmgjdk5RjQXOpyTfKh1fgWSLjtnhnjFqavJmuvYrumBYjZduv4DAfebqYz
        RjW4JvZBq+nGaMG5895kd7HkaApG7+dmS0UtWEBjbzUThZqwUdTUeZhxZKAlriPB
        b9hL/9seXh24dZTgmgAjOgS6DbNse68TwTOzDavepoMibcusuNOH40YStnafx/zA
        j9RGGme43N+52gTbNrKXIczaZPKyw9Vd1pw+ISBO/X1HFnwv0gPUlmAcVNfQcXyA
        ==
X-ME-Sender: <xms:LzycXYFILFeSh18CgSgdUKe0O0z3HeTx95b_gxgIsB0pbNVgERmL2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:LzycXdAS7jABp5o3_wNxdZiGoaEdsjs9ue8T5HcOq9a6brdRXJWcmA>
    <xmx:LzycXVyAQCxc4kcPag4MVQ0CHqkFr22Tr3TOd7BVgf7v2VYpi8U1Jw>
    <xmx:LzycXaUdm9RTvcaSTH1Ov2lGVuA-1nCJ7iT41MjC48FQm9Fc8HBbsQ>
    <xmx:LzycXWnVbCq50RCL-AQrQ1GNMPbZ0TyLgz6E597I8G29nb-gy4TKOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 491BED6005E;
        Tue,  8 Oct 2019 03:35:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: skcipher - Unmap pages after an external error" failed to apply to 4.9-stable tree
To:     herbert@gondor.apana.org.au, ard.biesheuvel@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:35:02 +0200
Message-ID: <15705201025117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ba3c026e685573bd3534c17e27da7c505ac99c4 Mon Sep 17 00:00:00 2001
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 6 Sep 2019 13:13:06 +1000
Subject: [PATCH] crypto: skcipher - Unmap pages after an external error

skcipher_walk_done may be called with an error by internal or
external callers.  For those internal callers we shouldn't unmap
pages but for external callers we must unmap any pages that are
in use.

This patch distinguishes between the two cases by checking whether
walk->nbytes is zero or not.  For internal callers, we now set
walk->nbytes to zero prior to the call.  For external callers,
walk->nbytes has always been non-zero (as zero is used to indicate
the termination of a walk).

Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 5cde0af2a982 ("[CRYPTO] cipher: Added block cipher type")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 5d836fc3df3e..22753c1c7202 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -90,7 +90,7 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
-static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
+static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
 
@@ -98,19 +98,21 @@ static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 	addr = skcipher_get_spot(addr, bsize);
 	scatterwalk_copychunks(addr, &walk->out, bsize,
 			       (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
+	return 0;
 }
 
 int skcipher_walk_done(struct skcipher_walk *walk, int err)
 {
-	unsigned int n; /* bytes processed */
-	bool more;
+	unsigned int n = walk->nbytes;
+	unsigned int nbytes = 0;
 
-	if (unlikely(err < 0))
+	if (!n)
 		goto finish;
 
-	n = walk->nbytes - err;
-	walk->total -= n;
-	more = (walk->total != 0);
+	if (likely(err >= 0)) {
+		n -= err;
+		nbytes = walk->total - n;
+	}
 
 	if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
 				    SKCIPHER_WALK_SLOW |
@@ -126,7 +128,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (err) {
+		if (err > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
@@ -134,27 +136,29 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 			 * the algorithm requires it.
 			 */
 			err = -EINVAL;
-			goto finish;
-		}
-		skcipher_done_slow(walk, n);
-		goto already_advanced;
+			nbytes = 0;
+		} else
+			n = skcipher_done_slow(walk, n);
 	}
 
+	if (err > 0)
+		err = 0;
+
+	walk->total = nbytes;
+	walk->nbytes = 0;
+
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
-already_advanced:
-	scatterwalk_done(&walk->in, 0, more);
-	scatterwalk_done(&walk->out, 1, more);
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
 
-	if (more) {
+	if (nbytes) {
 		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
 			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
 		return skcipher_walk_next(walk);
 	}
-	err = 0;
-finish:
-	walk->nbytes = 0;
 
+finish:
 	/* Short-circuit for the common/fast path. */
 	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
 		goto out;

