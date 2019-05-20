Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076BF234F7
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390498AbfETMcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732867AbfETMcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:32:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB33620675;
        Mon, 20 May 2019 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355529;
        bh=XvtAsDLEUGLG/5JAIEZjsWSHoExQuKV9bR/WUi5O0OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xivpAq9og8u48w6NSGY/5M92UWjrrTyYpcg1fTzXOs1hVEhv9Kl+kI0XCPFkEOFLz
         sVvkyM2+p/OcHxme2bzOGdrvROGc59Asa85MyoOFkOehLHXyFSbSELbiCFCitVqAHP
         d+r8VdH1CunnfAGHBY/Snc8A3wJAhi3UXXvhrZWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 027/128] crypto: chacha-generic - fix use as arm64 no-NEON fallback
Date:   Mon, 20 May 2019 14:13:34 +0200
Message-Id: <20190520115251.446287556@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 7aceaaef04eaaf6019ca159bc354d800559bba1d upstream.

The arm64 implementations of ChaCha and XChaCha are failing the extra
crypto self-tests following my patches to test the !may_use_simd() code
paths, which previously were untested.  The problem is as follows:

When !may_use_simd(), the arm64 NEON implementations fall back to the
generic implementation, which uses the skcipher_walk API to iterate
through the src/dst scatterlists.  Due to how the skcipher_walk API
works, walk.stride is set from the skcipher_alg actually being used,
which in this case is the arm64 NEON algorithm.  Thus walk.stride is
5*CHACHA_BLOCK_SIZE, not CHACHA_BLOCK_SIZE.

This unnecessarily large stride shouldn't cause an actual problem.
However, the generic implementation computes round_down(nbytes,
walk.stride).  round_down() assumes the round amount is a power of 2,
which 5*CHACHA_BLOCK_SIZE is not, so it gives the wrong result.

This causes the following case in skcipher_walk_done() to be hit,
causing a WARN() and failing the encryption operation:

	if (WARN_ON(err)) {
		/* unexpected case; didn't process all bytes */
		err = -EINVAL;
		goto finish;
	}

Fix it by rounding down to CHACHA_BLOCK_SIZE instead of walk.stride.

(Or we could replace round_down() with rounddown(), but that would add a
slow division operation every time, which I think we should avoid.)

Fixes: 2fe55987b262 ("crypto: arm64/chacha - use combined SIMD/ALU routine for more speed")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/chacha_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -52,7 +52,7 @@ static int chacha_stream_xor(struct skci
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
+			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
 
 		chacha_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
 			       nbytes, ctx->nrounds);


