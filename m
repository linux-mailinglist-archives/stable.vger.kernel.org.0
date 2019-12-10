Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C55119A38
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfLJVus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbfLJVIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556F72469A;
        Tue, 10 Dec 2019 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012096;
        bh=a4ZjSUbhdkUB9ysnpymNNPpDNmR+PGfGrZG2TExZ1qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAhLs+IGevoH2pHKCa1vH29t/zzvUySlh2gaKad49eQVpE1LfQ+nsR0qrJI1NAknR
         v1ES/HZv2GRsOLQ5ypP/xvAYQvf5r+agfBK5KP3WmVsoCcZC1N0MpZRN6zyZztvpf5
         UIY0qHekoGJrGGxV2It2oWxCaWy+/s7mDBJVVqME=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 072/350] MIPS: syscall: Emit Loongson3 sync workarounds within asm
Date:   Tue, 10 Dec 2019 16:02:57 -0500
Message-Id: <20191210210735.9077-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

[ Upstream commit e84957e6ae043bb83ad6ae7e949a1ce97b6bbfef ]

Generate the sync instructions required to workaround Loongson3 LL/SC
errata within inline asm blocks, which feels a little safer than doing
it from C where strictly speaking the compiler would be well within its
rights to insert a memory access between the separate asm statements we
previously had, containing sync & ll instructions respectively.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 3f16f38230310..c333e57886642 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -37,6 +37,7 @@
 #include <asm/signal.h>
 #include <asm/sim.h>
 #include <asm/shmparam.h>
+#include <asm/sync.h>
 #include <asm/sysmips.h>
 #include <asm/switch_to.h>
 
@@ -133,12 +134,12 @@ static inline int mips_atomic_set(unsigned long addr, unsigned long new)
 		  [efault] "i" (-EFAULT)
 		: "memory");
 	} else if (cpu_has_llsc) {
-		loongson_llsc_mb();
 		__asm__ __volatile__ (
 		"	.set	push					\n"
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 		"	li	%[err], 0				\n"
 		"1:							\n"
+		"	" __SYNC(full, loongson3_war) "			\n"
 		user_ll("%[old]", "(%[addr])")
 		"	move	%[tmp], %[new]				\n"
 		"2:							\n"
-- 
2.20.1

