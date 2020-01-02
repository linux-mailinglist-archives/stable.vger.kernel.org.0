Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745D712EBAB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgABWLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgABWLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B6A021582;
        Thu,  2 Jan 2020 22:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003073;
        bh=g0rgOA3HoY9PhWlM0zSqCVb2bgoYbxFetloP04hzmgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVltsG54/iWOV/H/4M7tqaTXsNZFlt4U0R4gtjGZy4Za1rOuhJ2+cCg4/23xrpkmV
         8Uzg3bFSA8yNfxLnuFZgdzDYF2oqCmatrLuS5UBn/N3WwV4F6G4RwzR34BAECyE1/Z
         9wVM3i2fliyN+UUYytsP2QbDkLYti4sq01iMKQHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/191] Revert "MIPS: futex: Restore \n after sync instructions"
Date:   Thu,  2 Jan 2020 23:04:43 +0100
Message-Id: <20200102215830.043513213@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit dc9d0a75ce9af74612d6a4d052e4df2bddfe8ed4 which is
commit fd7710cb491f900eb63d2ce5aac0e682003e84e9 upstream.

This, and the follow-on patch, breaks the mips build so it needs to be
reverted.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/futex.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -33,7 +33,7 @@
 		"	.set	arch=r4000			\n"	\
 		"2:	sc	$1, %2				\n"	\
 		"	beqzl	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB) "			\n"	\
+		__stringify(__WEAK_LLSC_MB)				\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -63,7 +63,7 @@
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
 		"2:	"user_sc("$1", "%2")"			\n"	\
 		"	beqz	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB) "			\n"	\
+		__stringify(__WEAK_LLSC_MB)				\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -148,7 +148,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		"	.set	arch=r4000				\n"
 		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
-		__stringify(__WEAK_LLSC_MB) "				\n"
+		__stringify(__WEAK_LLSC_MB)
 		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"


