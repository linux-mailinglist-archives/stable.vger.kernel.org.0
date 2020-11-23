Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB362C0861
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbgKWMt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732886AbgKWMtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8364020657;
        Mon, 23 Nov 2020 12:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135757;
        bh=e/9RmL65GabLycN58Tjmo7Bmxt74EK95SdaR3fKmy38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWDhxPGPpcef4b5KdtHjcDx3qGXh+e46VqED2i1/pGlY98kG+lsmW5f/OqaN4GUn0
         zX+Q10GnJfx/Ut117TmqqSKvkLimMDMZmELnA8GOMf4tX4iXSvg8JamFcfg1HIP1Bf
         1tf0OXMsaCR1tk100w6ARE1RNwXErTtK4H0PLgRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 177/252] efi/arm: set HSCTLR Thumb2 bit correctly for HVC calls from HYP
Date:   Mon, 23 Nov 2020 13:22:07 +0100
Message-Id: <20201123121844.138489055@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit fbc81ec5b85d43a4b22e49ec0e643fa7dec2ea40 ]

Commit

  db227c19e68db353 ("ARM: 8985/1: efi/decompressor: deal with HYP mode boot gracefully")

updated the EFI entry code to permit firmware to invoke the EFI stub
loader in HYP mode, with the MMU either enabled or disabled, neither
of which is permitted by the EFI spec, but which does happen in the
field.

In the MMU on case, we remain in HYP mode as configured by the firmware,
and rely on the fact that any HVC instruction issued in this mode will
be dispatched via the SVC slot in the HYP vector table. However, this
slot will point to a Thumb2 symbol if the kernel is built in Thumb2
mode, and so we have to configure HSCTLR to ensure that the exception
handlers are invoked in Thumb2 mode as well.

Fixes: db227c19e68db353 ("ARM: 8985/1: efi/decompressor: deal with HYP mode boot gracefully")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/head.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 434a16982e344..19499d636bc88 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1476,6 +1476,9 @@ ENTRY(efi_enter_kernel)
 		@ issued from HYP mode take us to the correct handler code. We
 		@ will disable the MMU before jumping to the kernel proper.
 		@
+ ARM(		bic	r1, r1, #(1 << 30)	) @ clear HSCTLR.TE
+ THUMB(		orr	r1, r1, #(1 << 30)	) @ set HSCTLR.TE
+		mcr	p15, 4, r1, c1, c0, 0
 		adr	r0, __hyp_reentry_vectors
 		mcr	p15, 4, r0, c12, c0, 0	@ set HYP vector base (HVBAR)
 		isb
-- 
2.27.0



