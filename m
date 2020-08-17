Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8424779C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404068AbgHQTuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgHQPTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:19:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F6D720748;
        Mon, 17 Aug 2020 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677556;
        bh=2q+FXrg/9QdRjh2msUUDlUOpPof9RzO6120MvHd8tJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PINgS7J2dbXGJ0DFbG56XpiX9wwGtSFKTW5Ko4P7GlWXe0Ec6AJ3axSUG82S2p8nc
         bkBQ8wo+uUcVt5qXYu9R+KODzhg++mke/xhH7JiEjm3YlJj6seeUc9Q3x4DIDmAxbd
         Q6vzQY8vh1OpaLwalx2j5jj+0eWBMH1mPiBW0kK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giovanni Gherdovich <ggherdovich@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 009/464] x86, sched: check for counters overflow in frequency invariant accounting
Date:   Mon, 17 Aug 2020 17:09:22 +0200
Message-Id: <20200817143834.199060300@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Gherdovich <ggherdovich@suse.cz>

[ Upstream commit e2b0d619b400ae326f954a018a1d65d736c237c5 ]

The product mcnt * arch_max_freq_ratio can overflows u64.

For context, a large value for arch_max_freq_ratio would be 5000,
corresponding to a turbo_freq/base_freq ratio of 5 (normally it's more like
1500-2000). A large increment frequency for the MPERF counter would be 5GHz
(the base clock of all CPUs on the market today is less than that). With
these figures, a CPU would need to go without a scheduler tick for around 8
days for the u64 overflow to happen. It is unlikely, but the check is
warranted.

Under similar conditions, the difference acnt of two consecutive APERF
readings can overflow as well.

In these circumstances is appropriate to disable frequency invariant
accounting: the feature relies on measures of the clock frequency done at
every scheduler tick, which need to be "fresh" to be at all meaningful.

A note on i386: prior to version 5.1, the GCC compiler didn't have the
builtin function __builtin_mul_overflow. In these GCC versions the macro
check_mul_overflow needs __udivdi3() to do (u64)a/b, which the kernel
doesn't provide. For this reason this change fails to build on i386 if
GCC<5.1, and we protect the entire frequency invariant code behind
CONFIG_X86_64 (special thanks to "kbuild test robot" <lkp@intel.com>).

Fixes: 1567c3e3467c ("x86, sched: Add support for frequency invariance")
Signed-off-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lkml.kernel.org/r/20200531182453.15254-2-ggherdovich@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/topology.h |  2 +-
 arch/x86/kernel/smpboot.c       | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 79d8d54963303..f4234575f3fdb 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -193,7 +193,7 @@ static inline void sched_clear_itmt_support(void)
 }
 #endif /* CONFIG_SCHED_MC_PRIO */
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_64)
 #include <asm/cpufeature.h>
 
 DECLARE_STATIC_KEY_FALSE(arch_scale_freq_key);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ffbd9a3d78d84..18d292fc466cb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -56,6 +56,7 @@
 #include <linux/cpuidle.h>
 #include <linux/numa.h>
 #include <linux/pgtable.h>
+#include <linux/overflow.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -1777,6 +1778,7 @@ void native_play_dead(void)
 
 #endif
 
+#ifdef CONFIG_X86_64
 /*
  * APERF/MPERF frequency ratio computation.
  *
@@ -2048,11 +2050,19 @@ static void init_freq_invariance(bool secondary)
 	}
 }
 
+static void disable_freq_invariance_workfn(struct work_struct *work)
+{
+	static_branch_disable(&arch_scale_freq_key);
+}
+
+static DECLARE_WORK(disable_freq_invariance_work,
+		    disable_freq_invariance_workfn);
+
 DEFINE_PER_CPU(unsigned long, arch_freq_scale) = SCHED_CAPACITY_SCALE;
 
 void arch_scale_freq_tick(void)
 {
-	u64 freq_scale;
+	u64 freq_scale = SCHED_CAPACITY_SCALE;
 	u64 aperf, mperf;
 	u64 acnt, mcnt;
 
@@ -2064,19 +2074,32 @@ void arch_scale_freq_tick(void)
 
 	acnt = aperf - this_cpu_read(arch_prev_aperf);
 	mcnt = mperf - this_cpu_read(arch_prev_mperf);
-	if (!mcnt)
-		return;
 
 	this_cpu_write(arch_prev_aperf, aperf);
 	this_cpu_write(arch_prev_mperf, mperf);
 
-	acnt <<= 2*SCHED_CAPACITY_SHIFT;
-	mcnt *= arch_max_freq_ratio;
+	if (check_shl_overflow(acnt, 2*SCHED_CAPACITY_SHIFT, &acnt))
+		goto error;
+
+	if (check_mul_overflow(mcnt, arch_max_freq_ratio, &mcnt) || !mcnt)
+		goto error;
 
 	freq_scale = div64_u64(acnt, mcnt);
+	if (!freq_scale)
+		goto error;
 
 	if (freq_scale > SCHED_CAPACITY_SCALE)
 		freq_scale = SCHED_CAPACITY_SCALE;
 
 	this_cpu_write(arch_freq_scale, freq_scale);
+	return;
+
+error:
+	pr_warn("Scheduler frequency invariance went wobbly, disabling!\n");
+	schedule_work(&disable_freq_invariance_work);
+}
+#else
+static inline void init_freq_invariance(bool secondary)
+{
 }
+#endif /* CONFIG_X86_64 */
-- 
2.25.1



