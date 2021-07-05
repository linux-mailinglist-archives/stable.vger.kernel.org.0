Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5991A3BBFA8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhGEPct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhGEPcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B714C61992;
        Mon,  5 Jul 2021 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498994;
        bh=SMypIDn/QlcJR33Og0VFeTr1hr+6S7cZNu+bYwTl6K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rY5FtgC66WXkAUiEdK5NRM2tbQCq24x9p6gxTsvPkzYEWGh2/BRry+nZ4Mtl/xu/z
         +p8teb6sXDumy88bByEwp7z8MzA+j+2hl9hi5A3+VRr6BNIFJ28wQL2gGwsFZdP8ow
         8jCNBemQQt0AWRNr1Zcqux2Ghr1Cc3ersZzmtvA+7coI8wt4mxWuzitjIZTgWEltKJ
         cZ1Io5slCvdyCSsijUnwhOOCZx65A8X/8HUpceOCF62BuULbSQh/BYI4ld9EQkoucs
         cKKrmQY08HMstrAOfAp5vWs7zFCaDUV9ZcsWsOiVL7A8KG/2cN+j23O8aWgvAPWTG4
         7pKdDu/YPOv0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 33/52] tools/power/x86/intel-speed-select: Fix uncore memory frequency display
Date:   Mon,  5 Jul 2021 11:28:54 -0400
Message-Id: <20210705152913.1521036-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 159f130f60f402273b235801d1fde3fc115c6795 ]

The uncore memory frequency value from the mailbox command
CONFIG_TDP_GET_MEM_FREQ needs to be scaled based on the platform for
display. There is no single constant multiplier.

This change introduces CPU model specific memory frequency multiplier.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 16 ++++++++++++++++
 tools/power/x86/intel-speed-select/isst-core.c   | 15 +++++++++++++++
 .../power/x86/intel-speed-select/isst-display.c  |  2 +-
 tools/power/x86/intel-speed-select/isst.h        |  2 ++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 582feb88eca3..3ff8d64369d7 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -106,6 +106,22 @@ int is_skx_based_platform(void)
 	return 0;
 }
 
+int is_spr_platform(void)
+{
+	if (cpu_model == 0x8F)
+		return 1;
+
+	return 0;
+}
+
+int is_icx_platform(void)
+{
+	if (cpu_model == 0x6A || cpu_model == 0x6C)
+		return 1;
+
+	return 0;
+}
+
 static int update_cpu_model(void)
 {
 	unsigned int ebx, ecx, edx;
diff --git a/tools/power/x86/intel-speed-select/isst-core.c b/tools/power/x86/intel-speed-select/isst-core.c
index 6a26d5769984..4431c8a0d40a 100644
--- a/tools/power/x86/intel-speed-select/isst-core.c
+++ b/tools/power/x86/intel-speed-select/isst-core.c
@@ -201,6 +201,7 @@ void isst_get_uncore_mem_freq(int cpu, int config_index,
 {
 	unsigned int resp;
 	int ret;
+
 	ret = isst_send_mbox_command(cpu, CONFIG_TDP, CONFIG_TDP_GET_MEM_FREQ,
 				     0, config_index, &resp);
 	if (ret) {
@@ -209,6 +210,20 @@ void isst_get_uncore_mem_freq(int cpu, int config_index,
 	}
 
 	ctdp_level->mem_freq = resp & GENMASK(7, 0);
+	if (is_spr_platform()) {
+		ctdp_level->mem_freq *= 200;
+	} else if (is_icx_platform()) {
+		if (ctdp_level->mem_freq < 7) {
+			ctdp_level->mem_freq = (12 - ctdp_level->mem_freq) * 133.33 * 2 * 10;
+			ctdp_level->mem_freq /= 10;
+			if (ctdp_level->mem_freq % 10 > 5)
+				ctdp_level->mem_freq++;
+		} else {
+			ctdp_level->mem_freq = 0;
+		}
+	} else {
+		ctdp_level->mem_freq = 0;
+	}
 	debug_printf(
 		"cpu:%d ctdp:%d CONFIG_TDP_GET_MEM_FREQ resp:%x uncore mem_freq:%d\n",
 		cpu, config_index, resp, ctdp_level->mem_freq);
diff --git a/tools/power/x86/intel-speed-select/isst-display.c b/tools/power/x86/intel-speed-select/isst-display.c
index 3bf1820c0da1..f97d8859ada7 100644
--- a/tools/power/x86/intel-speed-select/isst-display.c
+++ b/tools/power/x86/intel-speed-select/isst-display.c
@@ -446,7 +446,7 @@ void isst_ctdp_display_information(int cpu, FILE *outf, int tdp_level,
 		if (ctdp_level->mem_freq) {
 			snprintf(header, sizeof(header), "mem-frequency(MHz)");
 			snprintf(value, sizeof(value), "%d",
-				 ctdp_level->mem_freq * DISP_FREQ_MULTIPLIER);
+				 ctdp_level->mem_freq);
 			format_and_print(outf, level + 2, header, value);
 		}
 
diff --git a/tools/power/x86/intel-speed-select/isst.h b/tools/power/x86/intel-speed-select/isst.h
index 0cac6c54be87..1aa15d5ea57c 100644
--- a/tools/power/x86/intel-speed-select/isst.h
+++ b/tools/power/x86/intel-speed-select/isst.h
@@ -257,5 +257,7 @@ extern int get_cpufreq_base_freq(int cpu);
 extern int isst_read_pm_config(int cpu, int *cp_state, int *cp_cap);
 extern void isst_display_error_info_message(int error, char *msg, int arg_valid, int arg);
 extern int is_skx_based_platform(void);
+extern int is_spr_platform(void);
+extern int is_icx_platform(void);
 extern void isst_trl_display_information(int cpu, FILE *outf, unsigned long long trl);
 #endif
-- 
2.30.2

