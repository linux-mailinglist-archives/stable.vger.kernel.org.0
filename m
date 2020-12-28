Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32B82E3F9C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502275AbgL1O1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502262AbgL1O1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C73C4207B2;
        Mon, 28 Dec 2020 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165625;
        bh=YUvDYKl1YaQMAKEZb9Jty3IKzOJ0k5YRbzPmcB8eCt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oc1Nd6Bg2cjBDVwKcbXZHupxzfjs6MLEdyLJ/z3AX09Me1qJZR45wLeHkfGwyws4T
         qcbaMcxPEkJVZ8xMxb7ZA/yyubUHRdiLGKqa5FREYvEBYygORpHmypfv+9/W7W+pQe
         0mO/RIFhoBGJ9eVAj8uZdqxdB5+FKo9AnZl3vy/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 597/717] KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
Date:   Mon, 28 Dec 2020 13:49:55 +0100
Message-Id: <20201228125049.515721353@linuxfoundation.org>
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
@@ -214,6 +214,7 @@ enum vcpu_sysreg {
 #define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
 #define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
 #define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
+#define c2_TTBCR2	(c2_TTBCR + 1)	/* Translation Table Base Control R. 2 */
 #define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
 #define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
 #define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1987,6 +1987,7 @@ static const struct sys_reg_desc cp15_re
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
+	{ Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, c2_TTBCR2 },
 	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, c3_DACR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, c5_DFSR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, c5_IFSR },


