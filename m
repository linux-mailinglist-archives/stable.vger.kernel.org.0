Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454BF33D519
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 14:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhCPNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 09:44:04 -0400
Received: from foss.arm.com ([217.140.110.172]:41256 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235409AbhCPNnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 09:43:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB4C931B;
        Tue, 16 Mar 2021 06:43:34 -0700 (PDT)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.27.34])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C3E233F792;
        Tue, 16 Mar 2021 06:43:33 -0700 (PDT)
From:   Vladimir Murzin <vladimir.murzin@arm.com>
To:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
        dbrazdil@google.com
Subject: [PATCH v2][for-stable-v5.11] arm64: Unconditionally set virtual cpu id registers
Date:   Tue, 16 Mar 2021 13:43:19 +0000
Message-Id: <20210316134319.89472-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
reorganized el2 setup in such way that virtual cpu id registers set
only in nVHE, yet they used (and need) to be set irrespective VHE
support.

Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
Changelog

  v1 -> v2
     - Drop the reference to 32bit guests from commit message (per Marc)

There is no upstream fix since issue went away due to code there has
been reworked in 5.12: nVHE comes first, so virtual cpu id register
are always set.

Maintainers, please, Ack.

 arch/arm64/include/asm/el2_setup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index f988e94cdf9e..db87daca6b8c 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -113,7 +113,7 @@
 .endm
 
 /* Virtual CPU ID registers */
-.macro __init_el2_nvhe_idregs
+.macro __init_el2_idregs
 	mrs	x0, midr_el1
 	mrs	x1, mpidr_el1
 	msr	vpidr_el2, x0
@@ -165,6 +165,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_idregs
 
 	/*
 	 * When VHE is not in use, early init of EL2 needs to be done here.
@@ -173,7 +174,6 @@
 	 * will be done via the _EL1 system register aliases in __cpu_setup.
 	 */
 .ifeqs "\mode", "nvhe"
-	__init_el2_nvhe_idregs
 	__init_el2_nvhe_cptr
 	__init_el2_nvhe_sve
 	__init_el2_nvhe_prepare_eret
-- 
2.24.0

