Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC9018A966
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 00:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCRXpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 19:45:40 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39549 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCRXpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 19:45:40 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 61a86ec8;
        Wed, 18 Mar 2020 23:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=Mi5YhE72SdMzw/1uGPsgnecyYHI=; b=q+YVXz8dZd7X/A/U1Zm5
        KFIOHvmPa//FtTeI30+4HhUkygu8EtzIQIeb1QD71+yVFbqzvVcFzsLj18OfJD0t
        IeV5zqNTci3wQeSmJNhtEAV5Cd55sk5Nqaw+NF0BunsP36+t15K+inZ40OltsQJb
        LbOFW+We7Yxm6A8nmRxEWw7YZ5K2Zm+Upyy4w6BfrhYtlz9BTZqqdQF4r2kX/Cd6
        8GMfMLktgK0TBoSSdZU/HPcT9s8qXuyhQrKltQsffboIMYsF+tYxv22k0h2Q7il5
        dB9pkm7K7HquUHxWqSlg90IEDosXqwSF1FLBHcBiq7ysWosVD2HIDtKS21kOtt9I
        Uw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e5df53bb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 18 Mar 2020 23:39:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH URGENT crypto] crypto: arm64/chacha - correctly walk through blocks
Date:   Wed, 18 Mar 2020 17:45:18 -0600
Message-Id: <20200318234518.83906-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior, passing in chunks of 2, 3, or 4, followed by any additional
chunks would result in the chacha state counter getting out of sync,
resulting in incorrect encryption/decryption, which is a pretty nasty
crypto vuln, dating back to 2018. WireGuard users never experienced this
prior, because we have always, out of tree, used a different crypto
library, until the recent Frankenzinc addition. This commit fixes the
issue by advancing the pointers and state counter by the actual size
processed.

Fixes: f2ca1cbd0fb5 ("crypto: arm64/chacha - optimize for arbitrary length inputs")
Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/crypto/chacha-neon-glue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index c1f9660d104c..debb1de0d3dd 100644
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
+		state[12] += round_up(l, CHACHA_BLOCK_SIZE) / CHACHA_BLOCK_SIZE;
 	}
 }
 
-- 
2.25.1

