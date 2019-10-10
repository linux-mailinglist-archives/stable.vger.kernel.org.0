Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1E8D25E1
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbfJJJCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733279AbfJJIjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6817121D6C;
        Thu, 10 Oct 2019 08:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696753;
        bh=rdcIxeP4m44G4RKG8Wgygl8lX/dUoxoPTmdfFUaKgR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR53nh5fRv5BAFO6rre0kbiF9aUrAWMbXxybj5FpYSv24a6gjnEuwS3wqn1sv290q
         8Wck1Aa1yOUqnoHEqcxb8ukDMC9LVG+vRaWmpL590OGa7xOpRLlA3BMoxexu6ZkfkS
         84/7mSlTzwjvQWVStkzVzyaH8iQefP63v08Jmor4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 041/148] crypto: skcipher - Unmap pages after an external error
Date:   Thu, 10 Oct 2019 10:35:02 +0200
Message-Id: <20191010083613.631776460@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 0ba3c026e685573bd3534c17e27da7c505ac99c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/skcipher.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -90,7 +90,7 @@ static inline u8 *skcipher_get_spot(u8 *
 	return max(start, end_page);
 }
 
-static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
+static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
 
@@ -98,19 +98,21 @@ static void skcipher_done_slow(struct sk
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
@@ -126,7 +128,7 @@ unmap_src:
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (err) {
+		if (err > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
@@ -134,27 +136,29 @@ unmap_src:
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


