Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D47D2431
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfJJIuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389891AbfJJIuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECC221D56;
        Thu, 10 Oct 2019 08:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697400;
        bh=AeqJ5tmv4YwVwMSoBXqkp2XYljEqJPW8+tr6/fYaEbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHw9Ac0yaprbk23zkdHcOBrwKdGDyyGqpq4sR7yCsc4Zwm8gdpeKVkP5/DU2Qd/Mk
         ipHUx23FEEOA1nbomGb/zsiaW2wehBlYhsByQ6vHES0K9HXTByAsKTNa7PqQ5DXOu2
         0pPazqx6vNJCdfhVJGD0kEoP3XBVcshGlZp0Qxc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 14/61] crypto: skcipher - Unmap pages after an external error
Date:   Thu, 10 Oct 2019 10:36:39 +0200
Message-Id: <20191010083457.804941832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
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
@@ -95,7 +95,7 @@ static inline u8 *skcipher_get_spot(u8 *
 	return max(start, end_page);
 }
 
-static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
+static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
 
@@ -103,19 +103,21 @@ static void skcipher_done_slow(struct sk
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
@@ -131,7 +133,7 @@ unmap_src:
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (err) {
+		if (err > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
@@ -139,27 +141,29 @@ unmap_src:
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


