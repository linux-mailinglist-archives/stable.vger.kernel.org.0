Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806D926CAE
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733283AbfEVTak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733279AbfEVTaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB85C204FD;
        Wed, 22 May 2019 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553439;
        bh=qtR83PQ7ruWBMdJdZYPRB1QbyflkCDjLydzMIArepxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBpps7nk2FsohHJ26MaKyhXZ2SbMB1YcEXEF4kjMYdhwbMEXxKR15hfhZWN+6d0oO
         vLzB3/emLt+aJeMemF+u70ZPxjHuLIZI4FTFGynKrf2VS/2nujOjjAdi8wsjCOv0Dz
         ihZhPvsYtozKHNDFy2KmN7HBJ6T2Plem8Hd0R2iM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 012/114] ARM: vdso: Remove dependency with the arch_timer driver internals
Date:   Wed, 22 May 2019 15:28:35 -0400
Message-Id: <20190522193017.26567-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 1f5b62f09f6b314c8d70b9de5182dae4de1f94da ]

The VDSO code uses the kernel helper that was originally designed
to abstract the access between 32 and 64bit systems. It worked so
far because this function is declared as 'inline'.

As we're about to revamp that part of the code, the VDSO would
break. Let's fix it by doing what should have been done from
the start, a proper system register access.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/cp15.h   | 2 ++
 arch/arm/vdso/vgettimeofday.c | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
index b74b174ac9fcd..b458e41227943 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -67,6 +67,8 @@
 #define BPIALL				__ACCESS_CP15(c7, 0, c5, 6)
 #define ICIALLU				__ACCESS_CP15(c7, 0, c5, 0)
 
+#define CNTVCT				__ACCESS_CP15_64(1, c14)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
diff --git a/arch/arm/vdso/vgettimeofday.c b/arch/arm/vdso/vgettimeofday.c
index 79214d5ff0970..3af02d2a0b7f2 100644
--- a/arch/arm/vdso/vgettimeofday.c
+++ b/arch/arm/vdso/vgettimeofday.c
@@ -18,9 +18,9 @@
 #include <linux/compiler.h>
 #include <linux/hrtimer.h>
 #include <linux/time.h>
-#include <asm/arch_timer.h>
 #include <asm/barrier.h>
 #include <asm/bug.h>
+#include <asm/cp15.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/vdso_datapage.h>
@@ -123,7 +123,8 @@ static notrace u64 get_ns(struct vdso_data *vdata)
 	u64 cycle_now;
 	u64 nsec;
 
-	cycle_now = arch_counter_get_cntvct();
+	isb();
+	cycle_now = read_sysreg(CNTVCT);
 
 	cycle_delta = (cycle_now - vdata->cs_cycle_last) & vdata->cs_mask;
 
-- 
2.20.1

