Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1562ABC77
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgKINhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbgKINDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F50920663;
        Mon,  9 Nov 2020 13:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927032;
        bh=hPgsxO9ZApL6kah0bzEpqu+hBXmweWunePuwqSSb7Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4FnaBwXWq3S5Lg/kK+iIOeQamCh5Ebuw4LglwQj6b9Hdi+TFNku/4ZO7lPkgTKJ0
         79SBKNGSYyVMgvaZuDXpR7+is4RB4YsKXXt93LHO0bhGwU88bLbypRGkrFXl2EwQxb
         svVU20r1wHUwjsdS8iYiPRVOmOid0QhrC3QrKjII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.9 088/117] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR
Date:   Mon,  9 Nov 2020 13:55:14 +0100
Message-Id: <20201109125029.868357384@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 4a1c2c7f63c52ccb11770b5ae25920a6b79d3548 upstream.

The DBGD{CCINT,SCRext} and DBGVCR register entries in the cp14 array
are missing their target register, resulting in all accesses being
targetted at the guard sysreg (indexed by __INVALID_SYSREG__).

Point the emulation code at the actual register entries.

Fixes: bdfb4b389c8d ("arm64: KVM: add trap handlers for AArch32 debug registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201029172409.2768336-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/kvm_host.h |    1 +
 arch/arm64/kvm/sys_regs.c         |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -188,6 +188,7 @@ enum vcpu_sysreg {
 #define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
 #define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
 #define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
+#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1207,9 +1207,9 @@ static const struct sys_reg_desc cp14_re
 	{ Op1( 0), CRn( 0), CRm( 1), Op2( 0), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(1),
 	/* DBGDCCINT */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32, NULL, cp14_DBGDCCINT },
 	/* DBGDSCRext */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32, NULL, cp14_DBGDSCRext },
 	DBG_BCR_BVR_WCR_WVR(2),
 	/* DBGDTR[RT]Xint */
 	{ Op1( 0), CRn( 0), CRm( 3), Op2( 0), trap_raz_wi },
@@ -1224,7 +1224,7 @@ static const struct sys_reg_desc cp14_re
 	{ Op1( 0), CRn( 0), CRm( 6), Op2( 2), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32, NULL, cp14_DBGVCR },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),


