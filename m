Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1837D2E2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242071AbhELSO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241618AbhELSIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E10C61622;
        Wed, 12 May 2021 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842696;
        bh=GoRF33lxi4Sv6gTiTfm+CXnbmD2PPLK6dO2vDYEaNyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRMe3tjPI3ij3U47HgNTU0rljYmlKPBNqdbUm7aTdfyo9ysulaZfJ+XUCdcJt8qad
         LdrmWhG85vOQB5TcH5f4FS2Cr2wnML1dX+4jv1FaAMZLzVudtuyxfYowahmq2s/L0L
         pozA/ZbEo0uSi5lzCXinVXt9yNosudAF7x8QZCez3wWynGHPYq2vNXigCshKnXlSIY
         djtePqsR7MHdW2KWu+dkQVD6vDNKMlXSLhodD4sqPrNcc8kfFATnfL5teyspPtZQ2V
         zCJ3FWnZY/LoGcI2C4/vdCJwW2yTMM5Llf1xee1LQkCuxHpCHPrB7X4fSJ3HTzMmAc
         7K4TpR5N/9juw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "louis.wang" <liang26812@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/18] ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()
Date:   Wed, 12 May 2021 14:04:34 -0400
Message-Id: <20210512180450.665586-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180450.665586-1-sashal@kernel.org>
References: <20210512180450.665586-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "louis.wang" <liang26812@gmail.com>

[ Upstream commit 8252ca87c7a2111502ee13994956f8c309faad7f ]

Enabling function_graph tracer on ARM causes kernel panic, because the
function graph tracer updates the "return address" of a function in order
to insert a trace callback on function exit, it saves the function's
original return address in a return trace stack, but cpu_suspend() may not
return through the normal return path.

cpu_suspend() will resume directly via the cpu_resume path, but the return
trace stack has been set-up by the subfunctions of cpu_suspend(), which
makes the "return address" inconsistent with cpu_suspend().

This patch refers to Commit de818bd4522c40ea02a81b387d2fa86f989c9623
("arm64: kernel: pause/unpause function graph tracer in cpu_suspend()"),

fixes the issue by pausing/resuming the function graph tracer on the thread
executing cpu_suspend(), so that the function graph tracer state is kept
consistent across functions that enter power down states and never return
by effectively disabling graph tracer while they are executing.

Signed-off-by: louis.wang <liang26812@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/suspend.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
index d08099269e35..e126386fb78a 100644
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/ftrace.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
@@ -26,6 +27,13 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	if (!idmap_pgd)
 		return -EINVAL;
 
+	/*
+	 * Function graph tracer state gets incosistent when the kernel
+	 * calls functions that never return (aka suspend finishers) hence
+	 * disable graph tracing during their execution.
+	 */
+	pause_graph_tracing();
+
 	/*
 	 * Provide a temporary page table with an identity mapping for
 	 * the MMU-enable code, required for resuming.  On successful
@@ -33,6 +41,9 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * back to the correct page tables.
 	 */
 	ret = __cpu_suspend(arg, fn, __mpidr);
+
+	unpause_graph_tracing();
+
 	if (ret == 0) {
 		cpu_switch_mm(mm->pgd, mm);
 		local_flush_bp_all();
@@ -46,7 +57,13 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 {
 	u32 __mpidr = cpu_logical_map(smp_processor_id());
-	return __cpu_suspend(arg, fn, __mpidr);
+	int ret;
+
+	pause_graph_tracing();
+	ret = __cpu_suspend(arg, fn, __mpidr);
+	unpause_graph_tracing();
+
+	return ret;
 }
 #define	idmap_pgd	NULL
 #endif
-- 
2.30.2

