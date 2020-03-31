Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A832198F5D
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgCaJCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbgCaJCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:02:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8AEE20B1F;
        Tue, 31 Mar 2020 09:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645361;
        bh=30e+BOjBRMZX1chEUl1D2tJ/ugmBsBS8AolC6eIZE30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBBmc07Fl2OMmxAnsSEpOZgBCW5XSJhZioWSPrCshS0HLgbr+Zlobytwu0xVvaEaE
         95mbNkjQ15FeXEG9FBrfAMdNq5lhJI/RoLGjEPWOTMlNnE5aWm/Emq36oO+JGJukMP
         qACOG+o5rAj/SojlDaMhhzd06vrB98tL/iLmtz+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Emil Renner Berthing <kernel@esmil.dk>
Subject: [PATCH 5.5 007/170] crypto: arm64/chacha - correctly walk through blocks
Date:   Tue, 31 Mar 2020 10:57:01 +0200
Message-Id: <20200331085424.929075860@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit c8cfcb78c65877313cda7bcbace624d3dbd1f3b3 upstream.

Prior, passing in chunks of 2, 3, or 4, followed by any additional
chunks would result in the chacha state counter getting out of sync,
resulting in incorrect encryption/decryption, which is a pretty nasty
crypto vuln: "why do images look weird on webpages?" WireGuard users
never experienced this prior, because we have always, out of tree, used
a different crypto library, until the recent Frankenzinc addition. This
commit fixes the issue by advancing the pointers and state counter by
the actual size processed. It also fixes up a bug in the (optional,
costly) stride test that prevented it from running on arm64.

Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/chacha-neon-glue.c   |    8 ++++----
 lib/crypto/chacha20poly1305-selftest.c |   11 ++++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -55,10 +55,10 @@ static void chacha_doneon(u32 *state, u8
 			break;
 		}
 		chacha_4block_xor_neon(state, dst, src, nrounds, l);
-		bytes -= CHACHA_BLOCK_SIZE * 5;
-		src += CHACHA_BLOCK_SIZE * 5;
-		dst += CHACHA_BLOCK_SIZE * 5;
-		state[12] += 5;
+		bytes -= l;
+		src += l;
+		dst += l;
+		state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
 	}
 }
 
--- a/lib/crypto/chacha20poly1305-selftest.c
+++ b/lib/crypto/chacha20poly1305-selftest.c
@@ -9028,10 +9028,15 @@ bool __init chacha20poly1305_selftest(vo
 	     && total_len <= 1 << 10; ++total_len) {
 		for (i = 0; i <= total_len; ++i) {
 			for (j = i; j <= total_len; ++j) {
+				k = 0;
 				sg_init_table(sg_src, 3);
-				sg_set_buf(&sg_src[0], input, i);
-				sg_set_buf(&sg_src[1], input + i, j - i);
-				sg_set_buf(&sg_src[2], input + j, total_len - j);
+				if (i)
+					sg_set_buf(&sg_src[k++], input, i);
+				if (j - i)
+					sg_set_buf(&sg_src[k++], input + i, j - i);
+				if (total_len - j)
+					sg_set_buf(&sg_src[k++], input + j, total_len - j);
+				sg_init_marker(sg_src, k);
 				memset(computed_output, 0, total_len);
 				memset(input, 0, total_len);
 


