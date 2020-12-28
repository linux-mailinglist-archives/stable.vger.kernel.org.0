Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940252E37D2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgL1NBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbgL1NBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9B322582;
        Mon, 28 Dec 2020 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160444;
        bh=YStn6+xfoChb/ZUebmuhPMCzr1wh5qHt8/j/I5c1E2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=porwXkBnm5bSJDxom3qbz8z0QDLkHbsEeKjjZOBbYU4F0Z0fM08iNmBc24+prxeA+
         rMdlNjHeSRQWXDMs0TcyH7Hkr3wtTIz0sf90uokz2Fp0YVRE9dTdQfhMnUyklSb+B8
         6LpwRaM6GIDnGR46rD7tspO0OywfsUGoW2RDVdu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 052/175] ARM: p2v: fix handling of LPAE translation in BE mode
Date:   Mon, 28 Dec 2020 13:48:25 +0100
Message-Id: <20201228124855.773909374@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 4e79f0211b473f8e1eab8211a9fd50cc41a3a061 ]

When running in BE mode on LPAE hardware with a PA-to-VA translation
that exceeds 4 GB, we patch bits 39:32 of the offset into the wrong
byte of the opcode. So fix that, by rotating the offset in r0 to the
right by 8 bits, which will put the 8-bit immediate in bits 31:24.

Note that this will also move bit #22 in its correct place when
applying the rotation to the constant #0x400000.

Fixes: d9a790df8e984 ("ARM: 7883/1: fix mov to mvn conversion in case of 64 bit phys_addr_t and BE")
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head.S | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 04286fd9e09ce..2e336acd68b0a 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -673,12 +673,8 @@ ARM_BE8(rev16	ip, ip)
 	ldrcc	r7, [r4], #4	@ use branch for delay slot
 	bcc	1b
 	bx	lr
-#else
-#ifdef CONFIG_CPU_ENDIAN_BE8
-	moveq	r0, #0x00004000	@ set bit 22, mov to mvn instruction
 #else
 	moveq	r0, #0x400000	@ set bit 22, mov to mvn instruction
-#endif
 	b	2f
 1:	ldr	ip, [r7, r3]
 #ifdef CONFIG_CPU_ENDIAN_BE8
@@ -687,7 +683,7 @@ ARM_BE8(rev16	ip, ip)
 	tst	ip, #0x000f0000	@ check the rotation field
 	orrne	ip, ip, r6, lsl #24 @ mask in offset bits 31-24
 	biceq	ip, ip, #0x00004000 @ clear bit 22
-	orreq	ip, ip, r0      @ mask in offset bits 7-0
+	orreq	ip, ip, r0, ror #8  @ mask in offset bits 7-0
 #else
 	bic	ip, ip, #0x000000ff
 	tst	ip, #0xf00	@ check the rotation field
-- 
2.27.0



