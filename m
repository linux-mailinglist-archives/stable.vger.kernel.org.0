Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D33194C78
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgCZXZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZXZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:25:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1031208FE;
        Thu, 26 Mar 2020 23:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265108;
        bh=2SnIw+qa73YvKL5CuWhDtXX7O/rmDnHV2j0BMtChfm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIHILtaEFfu45B4VCv4vEOsk4r95gJZM1U15r24xgtdumnedSIFSQK0Q4it7fzTzL
         20MhHY//1fxihAKiCaxO+SUDcSLT6CMjEnW2omLecl07WV+8NXJoISD2OIBXTLedsW
         0FkpMA6wpSVxXLVyT8zO6NltFokMNb6PjsLLOpLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Len Brown <len.brown@intel.com>, Sasha Levin <sashal@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/15] tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks
Date:   Thu, 26 Mar 2020 19:24:51 -0400
Message-Id: <20200326232455.8029-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232455.8029-1-sashal@kernel.org>
References: <20200326232455.8029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

[ Upstream commit 1f81c5efc020314b2db30d77efe228b7e117750d ]

Some Chromebook BIOS' do not export an ACPI LPIT, which is how
Linux finds the residency counter for CPU and SYSTEM low power states,
that is exports in /sys/devices/system/cpu/cpuidle/*residency_us

When these sysfs attributes are missing, check the debugfs attrubte
from the pmc_core driver, which accesses the same counter value.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fb665fdc722a4..2233cf722c692 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -299,6 +299,10 @@ int *irqs_per_cpu;		/* indexed by cpu_num */
 
 void setup_all_buffers(void);
 
+char *sys_lpi_file;
+char *sys_lpi_file_sysfs = "/sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us";
+char *sys_lpi_file_debugfs = "/sys/kernel/debug/pmc_core/slp_s0_residency_usec";
+
 int cpu_is_not_present(int cpu)
 {
 	return !CPU_ISSET_S(cpu, cpu_present_setsize, cpu_present_set);
@@ -2844,8 +2848,6 @@ int snapshot_gfx_mhz(void)
  *
  * record snapshot of
  * /sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us
- *
- * return 1 if config change requires a restart, else return 0
  */
 int snapshot_cpu_lpi_us(void)
 {
@@ -2865,17 +2867,14 @@ int snapshot_cpu_lpi_us(void)
 /*
  * snapshot_sys_lpi()
  *
- * record snapshot of
- * /sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us
- *
- * return 1 if config change requires a restart, else return 0
+ * record snapshot of sys_lpi_file
  */
 int snapshot_sys_lpi_us(void)
 {
 	FILE *fp;
 	int retval;
 
-	fp = fopen_or_die("/sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us", "r");
+	fp = fopen_or_die(sys_lpi_file, "r");
 
 	retval = fscanf(fp, "%lld", &cpuidle_cur_sys_lpi_us);
 	if (retval != 1)
@@ -4743,10 +4742,16 @@ void process_cpuid()
 	else
 		BIC_NOT_PRESENT(BIC_CPU_LPI);
 
-	if (!access("/sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us", R_OK))
+	if (!access(sys_lpi_file_sysfs, R_OK)) {
+		sys_lpi_file = sys_lpi_file_sysfs;
 		BIC_PRESENT(BIC_SYS_LPI);
-	else
+	} else if (!access(sys_lpi_file_debugfs, R_OK)) {
+		sys_lpi_file = sys_lpi_file_debugfs;
+		BIC_PRESENT(BIC_SYS_LPI);
+	} else {
+		sys_lpi_file_sysfs = NULL;
 		BIC_NOT_PRESENT(BIC_SYS_LPI);
+	}
 
 	if (!quiet)
 		decode_misc_feature_control();
-- 
2.20.1

