Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AAF2A5665
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733287AbgKCV1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733281AbgKCVAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:00:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A0A32053B;
        Tue,  3 Nov 2020 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437245;
        bh=7/hHWmELrywRyUTfND9I6MH97zefn481LNViXn29u3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKgMlpn9+dfgg+omjX6KmcdtfzkDSsy8WgeRVox9u+DJjl0SMq7BZG6/Tvtl4qXnM
         E+iyzLY185CnRi3TRx3/nyXwiJ9DVcS153vQLAgpocBMqeBWS62O0prrSjEbeQnkgZ
         zudFuAppPMHQvNCLoseRtt+FU225hpXPuirvuO2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 209/214] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR
Date:   Tue,  3 Nov 2020 21:37:37 +0100
Message-Id: <20201103203310.183833763@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -209,6 +209,7 @@ enum vcpu_sysreg {
 #define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
 #define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
 #define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
+#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1746,9 +1746,9 @@ static const struct sys_reg_desc cp14_re
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
@@ -1763,7 +1763,7 @@ static const struct sys_reg_desc cp14_re
 	{ Op1( 0), CRn( 0), CRm( 6), Op2( 2), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32, NULL, cp14_DBGVCR },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),


