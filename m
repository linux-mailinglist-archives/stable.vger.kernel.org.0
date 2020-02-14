Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2D315F40D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgBNSSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbgBNPuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A6B22314;
        Fri, 14 Feb 2020 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695453;
        bh=+CBIJZj63ooSb9bI1j6y1JoV7Zz9dEHl9Rd4swku03k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzSjXzmv+1DEuZ8nvx1tPPT1d3w2P6J5SlFTlLtJtzDivuzBGtfKCZRczANbmwp69
         QK4UHUuRoTLT+rS9vPVTM4ecwbGE4XHBKoEC2Dyl0DldMctPAYgEdnTuBKrtqZDLWk
         D5LZiOZjRa2qs1lEgey9nSuYK7pSf5a8BYaoPu8M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 092/542] crypto: arm/chacha - fix build failured when kernel mode NEON is disabled
Date:   Fri, 14 Feb 2020 10:41:24 -0500
Message-Id: <20200214154854.6746-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 0bc81767c5bd9d005fae1099fb39eb3688370cb1 ]

When the ARM accelerated ChaCha driver is built as part of a configuration
that has kernel mode NEON disabled, we expect the compiler to propagate
the build time constant expression IS_ENABLED(CONFIG_KERNEL_MODE_NEON) in
a way that eliminates all the cross-object references to the actual NEON
routines, which allows the chacha-neon-core.o object to be omitted from
the build entirely.

Unfortunately, this fails to work as expected in some cases, and we may
end up with a build error such as

  chacha-glue.c:(.text+0xc0): undefined reference to `chacha_4block_xor_neon'

caused by the fact that chacha_doneon() has not been eliminated from the
object code, even though it will never be called in practice.

Let's fix this by adding some IS_ENABLED(CONFIG_KERNEL_MODE_NEON) tests
that are not strictly needed from a logical point of view, but should
help the compiler infer that the NEON code paths are unreachable in
those cases.

Fixes: b36d8c09e710c71f ("crypto: arm/chacha - remove dependency on generic ...")
Reported-by: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/chacha-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 6ebbb2b241d2b..6fdb0ac62b3d8 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -115,7 +115,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		if (!neon) {
+		if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
 				     nbytes, state, ctx->nrounds);
 			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
@@ -159,7 +159,7 @@ static int do_xchacha(struct skcipher_request *req, bool neon)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (!neon) {
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 		hchacha_block_arm(state, subctx.key, ctx->nrounds);
 	} else {
 		kernel_neon_begin();
-- 
2.20.1

