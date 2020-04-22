Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9639E1B50CA
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 01:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgDVXTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 19:19:10 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:43125 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgDVXTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 19:19:08 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 54d56bd2;
        Wed, 22 Apr 2020 23:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=2ctCQDriktgX2OaH1HEUsyi2w
        ic=; b=NuulK9HiXMmy6kNr2uzQyrPQg8BHVUPmbQOivtEo76JyahCeZWNiRI+vG
        ymYG1Smy1G8Sf9zsbsdrJVgw50+H2CubF/9hJEr4e/z1VXfbVbvK/yQ3tXZUwj6N
        zazAqt2NfbmZ5kX2C9tMGYy4VLXOnzk0q/t0YgesaAoFywx3EZ2COX7ltDAvpDEK
        Fl/tkKA/UyuZC7mGWCgY5em4ZaLMlDOJmKvYvbkTqmE4W/ZMPjxCjO0BrmMP4F3K
        XTi2UKj+gTyibrwNTZX4C22pOGmAXVK80QFtofx0K71eCKaaNsOZy8JIgrVPUtJ6
        kMVJbnKypyHjB9uPQyStkU1x770sA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 97c28892 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 23:08:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
Subject: [PATCH crypto-stable v3 2/2] crypto: arch/nhpoly1305 - process in explicit 4k chunks
Date:   Wed, 22 Apr 2020 17:18:54 -0600
Message-Id: <20200422231854.675965-2-Jason@zx2c4.com>
In-Reply-To: <20200422231854.675965-1-Jason@zx2c4.com>
References: <20200422200344.239462-1-Jason@zx2c4.com>
 <20200422231854.675965-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rather than chunking via PAGE_SIZE, this commit changes the arch
implementations to chunk in explicit 4k parts, so that calculations on
maximum acceptable latency don't suddenly become invalid on platforms
where PAGE_SIZE isn't 4k, such as arm64.

Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
Fixes: 012c82388c03 ("crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305")
Fixes: a00fa0c88774 ("crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305")
Fixes: 16aae3595a9d ("crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305")
Cc: Eric Biggers <ebiggers@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/crypto/nhpoly1305-neon-glue.c   | 2 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 2 +-
 arch/x86/crypto/nhpoly1305-avx2-glue.c   | 2 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
index ae5aefc44a4d..ffa8d73fe722 100644
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
@@ -30,7 +30,7 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index 895d3727c1fb..c5405e6a6db7 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -30,7 +30,7 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
index f7567cbd35b6..80fcb85736e1 100644
--- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -29,7 +29,7 @@ static int nhpoly1305_avx2_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_avx2);
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
index a661ede3b5cf..cc6b7c1a2705 100644
--- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -29,7 +29,7 @@ static int nhpoly1305_sse2_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_sse2);
-- 
2.26.2

