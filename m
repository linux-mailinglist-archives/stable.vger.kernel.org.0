Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33823772
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbfETMtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388308AbfETMVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2573E2173E;
        Mon, 20 May 2019 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354908;
        bh=brbknLHE7yJVvOZb/Zphk7t5bwLxvePh41BHFAzt/wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kxa/11oS66QXDe/mIK8lQg/YXX5yq+R6nfox0R8Gj1FMe7MVSSqSas6f/6Ea1FHR7
         dnksePG2QOUZ6yUDVvOvMGyjUKbX5wHAtHlUcHOEvuOMrl/8apu25spikX4iEVZ+XA
         09m6cgh4zShxHbB+80yHRIUnUY8o6a804VC/RfYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 024/105] crypto: skcipher - dont WARN on unprocessed data after slow walk step
Date:   Mon, 20 May 2019 14:13:30 +0200
Message-Id: <20190520115248.690508157@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit dcaca01a42cc2c425154a13412b4124293a6e11e upstream.

skcipher_walk_done() assumes it's a bug if, after the "slow" path is
executed where the next chunk of data is processed via a bounce buffer,
the algorithm says it didn't process all bytes.  Thus it WARNs on this.

However, this can happen legitimately when the message needs to be
evenly divisible into "blocks" but isn't, and the algorithm has a
'walksize' greater than the block size.  For example, ecb-aes-neonbs
sets 'walksize' to 128 bytes and only supports messages evenly divisible
into 16-byte blocks.  If, say, 17 message bytes remain but they straddle
scatterlist elements, the skcipher_walk code will take the "slow" path
and pass the algorithm all 17 bytes in the bounce buffer.  But the
algorithm will only be able to process 16 bytes, triggering the WARN.

Fix this by just removing the WARN_ON().  Returning -EINVAL, as the code
already does, is the right behavior.

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/skcipher.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -131,8 +131,13 @@ unmap_src:
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
+		if (err) {
+			/*
+			 * Didn't process all bytes.  Either the algorithm is
+			 * broken, or this was the last step and it turned out
+			 * the message wasn't evenly divisible into blocks but
+			 * the algorithm requires it.
+			 */
 			err = -EINVAL;
 			goto finish;
 		}


