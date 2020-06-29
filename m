Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313C820E689
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404276AbgF2VsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B6A246A7;
        Mon, 29 Jun 2020 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444000;
        bh=CShSKxwEsr2YDNf3cAE90Nyu4luZdDoF3ZS0WckTXJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyrJM9uovylKDkjG7Gkz4nRXA2Az63YD2qtCSAVzkO+6MPGV5d54GRbs0Jk7qTSFH
         eB51k4qjHtCK7EP8KYwgWBqsIxF/trVamk6Q21CptamZ8V4c6kcxllUYwa4VKkjs03
         nh60rDv5ZSoKBmm05mndC0KEexWmt4SIos1ojLX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 105/265] x86/cpu: Move resctrl CPUID code to resctrl/
Date:   Mon, 29 Jun 2020 11:15:38 -0400
Message-Id: <20200629151818.2493727-106-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 0118ad82c2a64ebcf15d7565ed35361407efadfa ]

The function determining a platform's support and properties of cache
occupancy and memory bandwidth monitoring (properties of
X86_FEATURE_CQM_LLC) can be found among the common CPU code. After
the feature's properties is populated in the per-CPU data the resctrl
subsystem is the only consumer (via boot_cpu_data).

Move the function that obtains the CPU information used by resctrl to
the resctrl subsystem and rename it from init_cqm() to
resctrl_cpu_detect(). The function continues to be called from the
common CPU code. This move is done in preparation of the addition of some
vendor specific code.

No functional change.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/38433b99f9d16c8f4ee796f8cc42b871531fa203.1588715690.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/resctrl_sched.h |  3 +++
 arch/x86/kernel/cpu/common.c         | 27 ++-------------------------
 arch/x86/kernel/cpu/resctrl/core.c   | 24 ++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/resctrl_sched.h b/arch/x86/include/asm/resctrl_sched.h
index f6b7fe2833cc7..c8a27cbbdae29 100644
--- a/arch/x86/include/asm/resctrl_sched.h
+++ b/arch/x86/include/asm/resctrl_sched.h
@@ -84,9 +84,12 @@ static inline void resctrl_sched_in(void)
 		__resctrl_sched_in();
 }
 
+void resctrl_cpu_detect(struct cpuinfo_x86 *c);
+
 #else
 
 static inline void resctrl_sched_in(void) {}
+static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
 #endif /* CONFIG_X86_CPU_RESCTRL */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8293ee5149758..e2e4af685f9b4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -56,6 +56,7 @@
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
 #include <asm/uv/uv.h>
+#include <asm/resctrl_sched.h>
 
 #include "cpu.h"
 
@@ -854,30 +855,6 @@ static void init_speculation_control(struct cpuinfo_x86 *c)
 	}
 }
 
-static void init_cqm(struct cpuinfo_x86 *c)
-{
-	if (!cpu_has(c, X86_FEATURE_CQM_LLC)) {
-		c->x86_cache_max_rmid  = -1;
-		c->x86_cache_occ_scale = -1;
-		return;
-	}
-
-	/* will be overridden if occupancy monitoring exists */
-	c->x86_cache_max_rmid = cpuid_ebx(0xf);
-
-	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL)) {
-		u32 eax, ebx, ecx, edx;
-
-		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
-
-		c->x86_cache_max_rmid  = ecx;
-		c->x86_cache_occ_scale = ebx;
-	}
-}
-
 void get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
@@ -945,7 +922,7 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 
 	init_scattered_cpuid_features(c);
 	init_speculation_control(c);
-	init_cqm(c);
+	resctrl_cpu_detect(c);
 
 	/*
 	 * Clear/Set all flags overridden by options, after probe.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d8cc5223b7ce8..49599733fa94d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -958,6 +958,30 @@ static __init void rdt_init_res_defs(void)
 
 static enum cpuhp_state rdt_online;
 
+void resctrl_cpu_detect(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has(c, X86_FEATURE_CQM_LLC)) {
+		c->x86_cache_max_rmid  = -1;
+		c->x86_cache_occ_scale = -1;
+		return;
+	}
+
+	/* will be overridden if occupancy monitoring exists */
+	c->x86_cache_max_rmid = cpuid_ebx(0xf);
+
+	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
+	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
+	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL)) {
+		u32 eax, ebx, ecx, edx;
+
+		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
+		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
+
+		c->x86_cache_max_rmid  = ecx;
+		c->x86_cache_occ_scale = ebx;
+	}
+}
+
 static int __init resctrl_late_init(void)
 {
 	struct rdt_resource *r;
-- 
2.25.1

