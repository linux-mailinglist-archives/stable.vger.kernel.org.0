Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D605A2EC2E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbfE3DSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731743AbfE3DSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D162479B;
        Thu, 30 May 2019 03:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186333;
        bh=Si3j1yTPqK5NevGyq/Mg/kLi2fvNusVTnF7ZPW0gFDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjhiLi5QHoKW2tUwDzfCvx1+J/jbRJahz7UJDT13GbCy/R24bJiD1KUhDrCJOPUGD
         wCrvDmmbQV2M5gR+h7ieZ4CfIX5cMwjLJ3qXd8o8pjcRdq4aXQSPKiegc+liKALuXU
         ZlDPwY8R4g3EF/HPgqs5sNL2bIPzhb92mXocVxRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/193] ARM: vdso: Remove dependency with the arch_timer driver internals
Date:   Wed, 29 May 2019 20:05:07 -0700
Message-Id: <20190530030456.907422213@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 07e27f212dc75..d2453e2d3f1f3 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -68,6 +68,8 @@
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



