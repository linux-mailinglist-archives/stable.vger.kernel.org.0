Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B8194CF8
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgCZX1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgCZXYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E5492077D;
        Thu, 26 Mar 2020 23:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265085;
        bh=WWPBWH6R7vqAyfkKB/N+fKzsFhjvBeypNxeA9gpyPj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oh2RZPL4T1tk78dyNGAGoaeV9dV0BPCBBew4f9lXwinYNSOjv0po6l9udntf4fZVG
         /cA4pOh5RcSDYCxyqd9LUQ6+cnimg2FzLy8VY+nA9Sq81i9QM+xyskkAbrDakueARj
         P2b2PDJV42yfl6M8TOXaQRrktGKtmTbEoYW+8OOM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Len Brown <len.brown@intel.com>, Sasha Levin <sashal@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/19] tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks
Date:   Thu, 26 Mar 2020 19:24:24 -0400
Message-Id: <20200326232431.7816-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
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
index 78507cd479bb4..17e82eaf5c4f4 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -304,6 +304,10 @@ int *irqs_per_cpu;		/* indexed by cpu_num */
 
 void setup_all_buffers(void);
 
+char *sys_lpi_file;
+char *sys_lpi_file_sysfs = "/sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us";
+char *sys_lpi_file_debugfs = "/sys/kernel/debug/pmc_core/slp_s0_residency_usec";
+
 int cpu_is_not_present(int cpu)
 {
 	return !CPU_ISSET_S(cpu, cpu_present_setsize, cpu_present_set);
@@ -2916,8 +2920,6 @@ int snapshot_gfx_mhz(void)
  *
  * record snapshot of
  * /sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us
- *
- * return 1 if config change requires a restart, else return 0
  */
 int snapshot_cpu_lpi_us(void)
 {
@@ -2941,17 +2943,14 @@ int snapshot_cpu_lpi_us(void)
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
 	if (retval != 1) {
@@ -4907,10 +4906,16 @@ void process_cpuid()
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

