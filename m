Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E151CAFFF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgEHNW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgEHMin (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6EF624977;
        Fri,  8 May 2020 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941521;
        bh=M9gSkXQOztQYBL+rayQQa0EvYDh8PgCf9HEypXWE5fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GAiiLJlOwWx3Te+oYR1C5gKrWumuYAYeKzKPpFh9VLEY6Z2JwhLokBD5Qn+BrOBJ
         iCd1pzOCLuAro4ZbrT3U40s0mEonV11k+R6wyD2Rb7EnnLEqex5J/3vNjVyaOWXTZU
         5EFMPKj7kCvMfz476V4UjCCcLXhjOKxH4Ik1hVug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 027/312] MIPS: SMP: Update cpu_foreign_map on CPU disable
Date:   Fri,  8 May 2020 14:30:18 +0200
Message-Id: <20200508123126.393919988@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit 826e99be6ab5189dbfb096389016ffb8d20a683e upstream.

When a CPU is disabled via CPU hotplug, cpu_foreign_map is not updated.
This could result in cache management SMP calls being sent to offline
CPUs instead of online siblings in the same core.

Add a call to calculate_cpu_foreign_map() in the various MIPS cpu
disable callbacks after set_cpu_online(). All cases are updated for
consistency and to keep cpu_foreign_map strictly up to date, not just
those which may support hardware multithreading.

Fixes: cccf34e9411c ("MIPS: c-r4k: Fix cache flushing for MT cores")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Hongliang Tao <taohl@lemote.com>
Cc: Hua Yan <yanh@lemote.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13799/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/cavium-octeon/smp.c         |    1 +
 arch/mips/include/asm/smp.h           |    2 ++
 arch/mips/kernel/smp-bmips.c          |    1 +
 arch/mips/kernel/smp-cps.c            |    1 +
 arch/mips/kernel/smp.c                |    2 +-
 arch/mips/loongson64/loongson-3/smp.c |    1 +
 6 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -239,6 +239,7 @@ static int octeon_cpu_disable(void)
 		return -ENOTSUPP;
 
 	set_cpu_online(cpu, false);
+	calculate_cpu_foreign_map();
 	cpumask_clear_cpu(cpu, &cpu_callin_map);
 	octeon_fixup_irqs();
 
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -63,6 +63,8 @@ extern cpumask_t cpu_coherent_mask;
 
 extern void asmlinkage smp_bootstrap(void);
 
+extern void calculate_cpu_foreign_map(void);
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -362,6 +362,7 @@ static int bmips_cpu_disable(void)
 	pr_info("SMP: CPU%d is offline\n", cpu);
 
 	set_cpu_online(cpu, false);
+	calculate_cpu_foreign_map();
 	cpumask_clear_cpu(cpu, &cpu_callin_map);
 	clear_c0_status(IE_IRQ5);
 
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -338,6 +338,7 @@ static int cps_cpu_disable(void)
 	atomic_sub(1 << cpu_vpe_id(&current_cpu_data), &core_cfg->vpe_mask);
 	smp_mb__after_atomic();
 	set_cpu_online(cpu, false);
+	calculate_cpu_foreign_map();
 	cpumask_clear_cpu(cpu, &cpu_callin_map);
 
 	return 0;
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -118,7 +118,7 @@ static inline void set_cpu_core_map(int
  * Calculate a new cpu_foreign_map mask whenever a
  * new cpu appears or disappears.
  */
-static inline void calculate_cpu_foreign_map(void)
+void calculate_cpu_foreign_map(void)
 {
 	int i, k, core_present;
 	cpumask_t temp_foreign_map;
--- a/arch/mips/loongson64/loongson-3/smp.c
+++ b/arch/mips/loongson64/loongson-3/smp.c
@@ -417,6 +417,7 @@ static int loongson3_cpu_disable(void)
 		return -EBUSY;
 
 	set_cpu_online(cpu, false);
+	calculate_cpu_foreign_map();
 	cpumask_clear_cpu(cpu, &cpu_callin_map);
 	local_irq_save(flags);
 	fixup_irqs();


