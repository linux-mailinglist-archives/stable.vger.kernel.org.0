Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAC4890CE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiAJHZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:25:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35312 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbiAJHY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6BC56112C;
        Mon, 10 Jan 2022 07:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06ECC36AE9;
        Mon, 10 Jan 2022 07:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799495;
        bh=ebOknTUOflZSjPu9CtarS9vXMsesFQLswyJoZQraKfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oh6e3PiZKw142dBd2fr2752p0yuo5XuZHZmCHIPuf81csh42HrdWi1cspc+/vMUpG
         LU7kbEKV+7ySQec73CP8DRJJ4lYU3T3FntnRoGUmANOme0YBavuvCFtm/5rPhGb4J1
         ed6HsLbbB4jcVb2P3IRM3joFxdXUfls1tne881OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 13/21] arm64: reduce el2_setup branching
Date:   Mon, 10 Jan 2022 08:23:00 +0100
Message-Id: <20220110071813.246928726@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/head.S |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

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
@@ -503,7 +498,11 @@ CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clea
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


