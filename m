Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE332E4262
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436785AbgL1OCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436779AbgL1OCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BCDA20731;
        Mon, 28 Dec 2020 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164088;
        bh=0fnv0UIBbTODUrQK1CeIPBPfnLukRyy9Epf9av9hHnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyIvn5jWGVWejFcSPvzAY9CJIzqKp/7CG1mPJlVctkfymbObbQtvyGBLJ0K6sy47E
         GDKO208yPHv6Bq3homh7JxY0pApwJ7qHgZGHKkCZpb8X1f20jCBlVlZli7kwqLaL6Q
         M+82gZFiDwjWZislf4eFGbUBijQRlSktqHWb8WzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/717] crypto: arm64/poly1305-neon - reorder PAC authentication with SP update
Date:   Mon, 28 Dec 2020 13:40:54 +0100
Message-Id: <20201228125023.678780150@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 519a0d7e495a6d3ce62594e485aea2a3a4a2ca0a ]

PAC pointer authentication signs the return address against the value
of the stack pointer, to prevent stack overrun exploits from corrupting
the control flow. However, this requires that the AUTIASP is issued with
SP holding the same value as it held when the PAC value was generated.
The Poly1305 NEON code got this wrong, resulting in crashes on PAC
capable hardware.

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/poly1305-armv8.pl       | 2 +-
 arch/arm64/crypto/poly1305-core.S_shipped | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly1305-armv8.pl
index 6e5576d19af8f..cbc980fb02e33 100644
--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -840,7 +840,6 @@ poly1305_blocks_neon:
 	 ldp	d14,d15,[sp,#64]
 	addp	$ACC2,$ACC2,$ACC2
 	 ldr	x30,[sp,#8]
-	 .inst	0xd50323bf		// autiasp
 
 	////////////////////////////////////////////////////////////////
 	// lazy reduction, but without narrowing
@@ -882,6 +881,7 @@ poly1305_blocks_neon:
 	str	x4,[$ctx,#8]		// set is_base2_26
 
 	ldr	x29,[sp],#80
+	 .inst	0xd50323bf		// autiasp
 	ret
 .size	poly1305_blocks_neon,.-poly1305_blocks_neon
 
diff --git a/arch/arm64/crypto/poly1305-core.S_shipped b/arch/arm64/crypto/poly1305-core.S_shipped
index 8d1c4e420ccdc..fb2822abf63aa 100644
--- a/arch/arm64/crypto/poly1305-core.S_shipped
+++ b/arch/arm64/crypto/poly1305-core.S_shipped
@@ -779,7 +779,6 @@ poly1305_blocks_neon:
 	 ldp	d14,d15,[sp,#64]
 	addp	v21.2d,v21.2d,v21.2d
 	 ldr	x30,[sp,#8]
-	 .inst	0xd50323bf		// autiasp
 
 	////////////////////////////////////////////////////////////////
 	// lazy reduction, but without narrowing
@@ -821,6 +820,7 @@ poly1305_blocks_neon:
 	str	x4,[x0,#8]		// set is_base2_26
 
 	ldr	x29,[sp],#80
+	 .inst	0xd50323bf		// autiasp
 	ret
 .size	poly1305_blocks_neon,.-poly1305_blocks_neon
 
-- 
2.27.0



