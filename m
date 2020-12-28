Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD52E3BFC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406528AbgL1N5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406512AbgL1N5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36CAA20731;
        Mon, 28 Dec 2020 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163785;
        bh=gRqv+bXUF7OfOcorPigBcxLaD+/i8zlRLh0gtR/jp0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCexUYnKBG4SswQ55OnqnWheEUZa7z8NAQn2gDfFMEplO881zLAwTrYG/BNqHfb18
         Pqh6xKNcs/yl52utj8W5DdCHHx1Ct6Miaycb0gG5xfNRxd0np/y/4sXgtwx7g+yEFj
         wAx9smK8Vp0KBuppAQZWB4G8QSQFltHqbw3Ah8fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 376/453] KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
Date:   Mon, 28 Dec 2020 13:50:12 +0100
Message-Id: <20201228124955.296753643@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit ca4e514774930f30b66375a974b5edcbebaf0e7e upstream.

ARMv8.2 introduced TTBCR2, which shares TCR_EL1 with TTBCR.
Gracefully handle traps to this register when HCR_EL2.TVM is set.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/kvm_host.h |    1 +
 arch/arm64/kvm/sys_regs.c         |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -182,6 +182,7 @@ enum vcpu_sysreg {
 #define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
 #define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
 #define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
+#define c2_TTBCR2	(c2_TTBCR + 1)	/* Translation Table Base Control R. 2 */
 #define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
 #define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
 #define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1837,6 +1837,7 @@ static const struct sys_reg_desc cp15_re
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
+	{ Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, c2_TTBCR2 },
 	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, c3_DACR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, c5_DFSR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, c5_IFSR },


