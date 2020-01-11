Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA234137E09
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgAKKER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbgAKKER (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:04:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E51820848;
        Sat, 11 Jan 2020 10:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737055;
        bh=fbvmo8+KlHIKYVvh0cnmPiWMpsqcNZRAXgK+EO7LOKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwmscnpoeTyzO+kPWdHNUuYynDhFsR7hBRy7JLBTN5Kq3tymIuE7IBwgziiUxIRTg
         v0fthjCcE66gKz+tpJnZ5DgHrZib6zGCKhYqhOAXTuQhBEgdnKVim+bLiCtOSwVy+b
         qJdVgg9uycNptkYYBFUmMMFAjoIMgVuDPpfAedF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 53/91] s390/smp: fix physical to logical CPU map for SMT
Date:   Sat, 11 Jan 2020 10:49:46 +0100
Message-Id: <20200111094904.876955444@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit 72a81ad9d6d62dcb79f7e8ad66ffd1c768b72026 ]

If an SMT capable system is not IPL'ed from the first CPU the setup of
the physical to logical CPU mapping is broken: the IPL core gets CPU
number 0, but then the next core gets CPU number 1. Correct would be
that all SMT threads of CPU 0 get the subsequent logical CPU numbers.

This is important since a lot of code (like e.g. the CPU topology
code) assumes that CPU maps are setup like this. If the mapping is
broken the system will not IPL due to broken topology masks:

[    1.716341] BUG: arch topology broken
[    1.716342]      the SMT domain not a subset of the MC domain
[    1.716343] BUG: arch topology broken
[    1.716344]      the MC domain not a subset of the BOOK domain

This scenario can usually not happen since LPARs are always IPL'ed
from CPU 0 and also re-IPL is intiated from CPU 0. However older
kernels did initiate re-IPL on an arbitrary CPU. If therefore a re-IPL
from an old kernel into a new kernel is initiated this may lead to
crash.

Fix this by setting up the physical to logical CPU mapping correctly.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/smp.c | 80 ++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index d52a94e9f57f..cba8e56cd63d 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -691,39 +691,67 @@ static struct sclp_core_info *smp_get_core_info(void)
 
 static int smp_add_present_cpu(int cpu);
 
-static int __smp_rescan_cpus(struct sclp_core_info *info, int sysfs_add)
+static int smp_add_core(struct sclp_core_entry *core, cpumask_t *avail,
+			bool configured, bool early)
 {
 	struct pcpu *pcpu;
-	cpumask_t avail;
-	int cpu, nr, i, j;
+	int cpu, nr, i;
 	u16 address;
 
 	nr = 0;
-	cpumask_xor(&avail, cpu_possible_mask, cpu_present_mask);
-	cpu = cpumask_first(&avail);
-	for (i = 0; (i < info->combined) && (cpu < nr_cpu_ids); i++) {
-		if (sclp.has_core_type && info->core[i].type != boot_core_type)
+	if (sclp.has_core_type && core->type != boot_core_type)
+		return nr;
+	cpu = cpumask_first(avail);
+	address = core->core_id << smp_cpu_mt_shift;
+	for (i = 0; (i <= smp_cpu_mtid) && (cpu < nr_cpu_ids); i++) {
+		if (pcpu_find_address(cpu_present_mask, address + i))
 			continue;
-		address = info->core[i].core_id << smp_cpu_mt_shift;
-		for (j = 0; j <= smp_cpu_mtid; j++) {
-			if (pcpu_find_address(cpu_present_mask, address + j))
-				continue;
-			pcpu = pcpu_devices + cpu;
-			pcpu->address = address + j;
-			pcpu->state =
-				(cpu >= info->configured*(smp_cpu_mtid + 1)) ?
-				CPU_STATE_STANDBY : CPU_STATE_CONFIGURED;
-			smp_cpu_set_polarization(cpu, POLARIZATION_UNKNOWN);
-			set_cpu_present(cpu, true);
-			if (sysfs_add && smp_add_present_cpu(cpu) != 0)
-				set_cpu_present(cpu, false);
-			else
-				nr++;
-			cpu = cpumask_next(cpu, &avail);
-			if (cpu >= nr_cpu_ids)
+		pcpu = pcpu_devices + cpu;
+		pcpu->address = address + i;
+		if (configured)
+			pcpu->state = CPU_STATE_CONFIGURED;
+		else
+			pcpu->state = CPU_STATE_STANDBY;
+		smp_cpu_set_polarization(cpu, POLARIZATION_UNKNOWN);
+		set_cpu_present(cpu, true);
+		if (!early && smp_add_present_cpu(cpu) != 0)
+			set_cpu_present(cpu, false);
+		else
+			nr++;
+		cpumask_clear_cpu(cpu, avail);
+		cpu = cpumask_next(cpu, avail);
+	}
+	return nr;
+}
+
+static int __smp_rescan_cpus(struct sclp_core_info *info, bool early)
+{
+	struct sclp_core_entry *core;
+	cpumask_t avail;
+	bool configured;
+	u16 core_id;
+	int nr, i;
+
+	nr = 0;
+	cpumask_xor(&avail, cpu_possible_mask, cpu_present_mask);
+	/*
+	 * Add IPL core first (which got logical CPU number 0) to make sure
+	 * that all SMT threads get subsequent logical CPU numbers.
+	 */
+	if (early) {
+		core_id = pcpu_devices[0].address >> smp_cpu_mt_shift;
+		for (i = 0; i < info->configured; i++) {
+			core = &info->core[i];
+			if (core->core_id == core_id) {
+				nr += smp_add_core(core, &avail, true, early);
 				break;
+			}
 		}
 	}
+	for (i = 0; i < info->combined; i++) {
+		configured = i < info->configured;
+		nr += smp_add_core(&info->core[i], &avail, configured, early);
+	}
 	return nr;
 }
 
@@ -771,7 +799,7 @@ static void __init smp_detect_cpus(void)
 
 	/* Add CPUs present at boot */
 	get_online_cpus();
-	__smp_rescan_cpus(info, 0);
+	__smp_rescan_cpus(info, true);
 	put_online_cpus();
 	kfree(info);
 }
@@ -1127,7 +1155,7 @@ int __ref smp_rescan_cpus(void)
 		return -ENOMEM;
 	get_online_cpus();
 	mutex_lock(&smp_cpu_state_mutex);
-	nr = __smp_rescan_cpus(info, 1);
+	nr = __smp_rescan_cpus(info, false);
 	mutex_unlock(&smp_cpu_state_mutex);
 	put_online_cpus();
 	kfree(info);
-- 
2.20.1



