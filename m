Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5138A109
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhETJ16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231872AbhETJ1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A5BB613B9;
        Thu, 20 May 2021 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502746;
        bh=ZdzK8q4w+TKlcqaURXyQyLF5Sq2YRST6TcrOEl50yss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Spy+dysOVV4G1f5DJ8YYX5q2RyrGGAtakO3QBpX1pTM2egrzhC/x5XdEcamrqZm86
         TJ+7mM46+j6q1T5N4nPfRDi2jexqkXZxE5lIC1wNwCGY73W6y/bqonmYNUyvJpTYuS
         Zq2QVU0wGdO8x/MnhJ/CPJJYQwi6GCoKS+3B7ueg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "louis.wang" <liang26812@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 09/45] ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()
Date:   Thu, 20 May 2021 11:21:57 +0200
Message-Id: <20210520092053.822371348@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: louis.wang <liang26812@gmail.com>

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
index 24bd20564be7..43f0a3ebf390 100644
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/ftrace.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
@@ -25,6 +26,13 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
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
@@ -32,6 +40,9 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * back to the correct page tables.
 	 */
 	ret = __cpu_suspend(arg, fn, __mpidr);
+
+	unpause_graph_tracing();
+
 	if (ret == 0) {
 		cpu_switch_mm(mm->pgd, mm);
 		local_flush_bp_all();
@@ -45,7 +56,13 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
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



