Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2C412C475
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfL2R3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbfL2R3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:29:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B37220722;
        Sun, 29 Dec 2019 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640593;
        bh=FoAkvQ84Aqr7ov3qxU+UYFel2j4aZ8kOa2zDHZChO/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xITgH2RjjCPOHwbVSaYDgQlyhUREQ/FNu1CoD1KMYO8I2Tb3jpbi636fnlilXV1RL
         YioMeZTgwPkgGd7luyL3F7yx/WLQDvYzhRPZwVOyzivqB1z13peBgVuW1TqoP37Dp8
         MEVZIgLm7J54fGBm8gfxYqaUOITOnwDhx0hMgGCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        linux-mips@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/219] MIPS: syscall: Emit Loongson3 sync workarounds within asm
Date:   Sun, 29 Dec 2019 18:17:42 +0100
Message-Id: <20191229162515.892321194@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/mips/kernel/syscall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 69c17b549fd3..10990434bf94 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -37,6 +37,7 @@
 #include <asm/signal.h>
 #include <asm/sim.h>
 #include <asm/shmparam.h>
+#include <asm/sync.h>
 #include <asm/sysmips.h>
 #include <asm/switch_to.h>
 
@@ -135,6 +136,7 @@ static inline int mips_atomic_set(unsigned long addr, unsigned long new)
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 		"	li	%[err], 0				\n"
 		"1:							\n"
+		"	" __SYNC(full, loongson3_war) "			\n"
 		user_ll("%[old]", "(%[addr])")
 		"	move	%[tmp], %[new]				\n"
 		"2:							\n"
-- 
2.20.1



