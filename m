Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBF1A5022
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgDKMOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgDKMOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817BD20692;
        Sat, 11 Apr 2020 12:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607284;
        bh=FIQyZpGeWjGjICZFpF4bFafvr3BU4jUe3KlA1RozA18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBjzNiaSdhvyhLSNEyA9y8sFBUW7SOmNm3QZFfiPryKhNOkfydLc4yBZ9+Pp/dy4d
         8eYDIXbqujFdcMvH+eoN1m4+QxiJEpbvHPWvVefZntu6Ltd47AuWuChTkDsAn1MWlu
         q869xzlPZrslEKNtDIUanUvffkBUw1sTVBZVZIE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/54] tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks
Date:   Sat, 11 Apr 2020 14:08:53 +0200
Message-Id: <20200411115509.374022389@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 tools/power/x86/turbostat/turbostat.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -299,6 +299,10 @@ int *irqs_per_cpu;		/* indexed by cpu_nu
 
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


