Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8D018AAA8
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 03:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCSC15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 22:27:57 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:52455 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSC15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 22:27:57 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4babc347;
        Thu, 19 Mar 2020 02:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=SJruqN6zl5PSRzknEp7SsMu9J
        i0=; b=hvEOZxegwHJzTtT2ITiJ3UP0B6BqFtz4WlCAb2UGEMTh9dBxUZWqYLKpS
        VmJEt0nGzyUl3Yv8LR3SpdO/KYThTQZ+caOwvrqtllLJd+72MQlSvakj1kAynwhz
        F19s7EMuhZRrnifUvDB1h2DQesfiuikCevuT96F/Toifw8jUvfh8ahc9gdXxDfQp
        sIWw8/rhU7pv9HcvMsu47ggzAmM9jsOd54XVbelYuaADUsvbSscIV6pGfYRm/S8p
        76ARaEz5puvfT7CkGOueDbS6CCK421xwyO7PwG/DnQVpau+Df8uzHjC1zFBEwy0P
        aoUn/tAnnJLM8x9YIdKFfLIpHfQLQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bfeca116 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 02:21:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk through blocks
Date:   Wed, 18 Mar 2020 20:27:32 -0600
Message-Id: <20200319022732.166085-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm64/crypto/chacha-neon-glue.c   |  8 ++++----
 lib/crypto/chacha20poly1305-selftest.c | 11 ++++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index c1f9660d104c..37ca3e889848 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -55,10 +55,10 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
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
 
diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
index c391a91364e9..fa43deda2660 100644
--- a/lib/crypto/chacha20poly1305-selftest.c
+++ b/lib/crypto/chacha20poly1305-selftest.c
@@ -9028,10 +9028,15 @@ bool __init chacha20poly1305_selftest(void)
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
 
-- 
2.25.1

