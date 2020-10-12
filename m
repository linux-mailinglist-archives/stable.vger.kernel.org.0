Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78128B8D8
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389669AbgJLNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389649AbgJLNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7051F2224A;
        Mon, 12 Oct 2020 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510252;
        bh=fiJukRJ+WRGEyZJetaXIXsfY+w7AKHEaZnV+x7b20t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yksbV5hEWypvWLHJXSV9w5a8X/kgpswvYaNlexgCMmkB3oZcH7Ajodw2v1c6ZtfB4
         u3yjaNNZ3pOuOGshIjNZ4tjxWLn2v8xrinz51sox55LpIwmOsY2MEa62wS97dY3eS4
         JJwskODZ0V06E5bVxNKC+OPpDuMYlpxs238g7P+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.8 006/124] crypto: arm64: Use x16 with indirect branch to bti_c
Date:   Mon, 12 Oct 2020 15:30:10 +0200
Message-Id: <20201012133147.153980512@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

commit 39e4716caa598a07a98598b2e7cd03055ce25fb9 upstream.

The AES code uses a 'br x7' as part of a function called by
a macro. That branch needs a bti_j as a target. This results
in a panic as seen below. Using x16 (or x17) with an indirect
branch keeps the target bti_c.

  Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
  CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
  pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
  pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
  lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
  sp : ffff80001052b730

  aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
   __xts_crypt+0xb0/0x2dc [aes_neon_bs]
   xts_encrypt+0x28/0x3c [aes_neon_bs]
  crypto_skcipher_encrypt+0x50/0x84
  simd_skcipher_encrypt+0xc8/0xe0
  crypto_skcipher_encrypt+0x50/0x84
  test_skcipher_vec_cfg+0x224/0x5f0
  test_skcipher+0xbc/0x120
  alg_test_skcipher+0xa0/0x1b0
  alg_test+0x3dc/0x47c
  cryptomgr_test+0x38/0x60

Fixes: 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
Cc: <stable@vger.kernel.org> # 5.6.x-
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Suggested-by: Dave P Martin <Dave.Martin@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20201006163326.2780619-1-jeremy.linton@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/aes-neonbs-core.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
 
 0:	mov		bskey, x21
 	mov		rounds, x22
-	br		x7
+	br		x16
 SYM_FUNC_END(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
@@ -806,7 +806,7 @@ SYM_FUNC_END(__xts_crypt8)
 	uzp1		v30.4s, v30.4s, v25.4s
 	ld1		{v25.16b}, [x24]
 
-99:	adr		x7, \do8
+99:	adr		x16, \do8
 	bl		__xts_crypt8
 
 	ldp		q16, q17, [sp, #.Lframe_local_offset]


