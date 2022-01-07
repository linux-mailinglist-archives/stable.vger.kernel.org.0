Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F9D487D3E
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 20:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiAGToE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 14:44:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54828 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiAGToE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 14:44:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F92B82766
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED73C36AF6;
        Fri,  7 Jan 2022 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641584641;
        bh=pUhhdPd+RzZRxCZiQKKatqdJiYDHPOjal68wgZclLUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLcWua10BSWFs1tzn8R0O9LdAEPfjI2J/mCkZIYGMP1etayiU740tg8inPMM/9UAz
         83L6chu71gxLPrNskNJHYeddudOhCqOCzkqSHmu/OVLrqaIVT5LIj6CMCb7zpIPvOP
         h5SFjTQyVPVch6CP0tWVRijt4oqP6IYQVp7MaswmjOVVblRnvxiV6JRHUt6v1M/jJs
         s5I4x5DvnMq58Va9lS0bWwZ13+meCMgtMnA8IJUuZrwD63jv6eFiklttiS1bEyXttE
         n5nLhuiM524i0FtNBBazC5hsFCC+24hI5zY4nE2zvmyLHc8oD1Ep8nf0j9WsgAy0WG
         EHk/jSJooETiQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH RFC 4.9 3/5] arm64: reduce el2_setup branching
Date:   Fri,  7 Jan 2022 12:43:33 -0700
Message-Id: <20220107194335.3090066-4-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107194335.3090066-1-nathan@kernel.org>
References: <20220107194335.3090066-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 3ad47d055aa88d9f4189253f5b5c485f4c4626b2 upstream.

The early el2_setup code is a little convoluted, with two branches where
one would do. This makes the code more painful to read than is
necessary.

We can remove a branch and simplify the logic by moving the early return
in the booted-at-EL1 case earlier in the function. This separates it
from all the setup logic that only makes sense for EL2.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm64/kernel/head.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 387542383662..b15abc6ae4af 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -489,13 +489,8 @@ ENTRY(el2_setup)
 	msr	SPsel, #1			// We want to use SP_EL{1,2}
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
-	b.ne	1f
-	mrs	x0, sctlr_el2
-CPU_BE(	orr	x0, x0, #(1 << 25)	)	// Set the EE bit for EL2
-CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
-	msr	sctlr_el2, x0
-	b	2f
-1:	mrs	x0, sctlr_el1
+	b.eq	1f
+	mrs	x0, sctlr_el1
 CPU_BE(	orr	x0, x0, #(3 << 24)	)	// Set the EE and E0E bits for EL1
 CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
 	msr	sctlr_el1, x0
@@ -503,7 +498,11 @@ CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
 	isb
 	ret
 
-2:
+1:	mrs	x0, sctlr_el2
+CPU_BE(	orr	x0, x0, #(1 << 25)	)	// Set the EE bit for EL2
+CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
+	msr	sctlr_el2, x0
+
 #ifdef CONFIG_ARM64_VHE
 	/*
 	 * Check for VHE being present. For the rest of the EL2 setup,
-- 
2.34.1

