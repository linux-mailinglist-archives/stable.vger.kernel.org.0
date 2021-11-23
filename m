Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6545A210
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhKWL62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236683AbhKWL62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:58:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C1260F26;
        Tue, 23 Nov 2021 11:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637668520;
        bh=Gq6GjGaTV7VT2mO0IDr1Q4YU3HWBYhWzL2JYX+NGpaA=;
        h=Subject:To:Cc:From:Date:From;
        b=BQ4gguc0xIPC8vqMIrSJiRrMsz+YDA7rbT4MfJIVW2Ho1bXyBDBvj8w+bqVlqEaxL
         t/kBHTFrNTR7gDXuCy+GbIkIphSCv3zZGJU0G2X2FHxLGCNquBNKfVEzEUlIpjTMA9
         MBBPOD63/9Ni5HCgjgVHCu5W28pwlOtqCJkaAGSY=
Subject: FAILED: patch "[PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level print support for" failed to apply to 5.15-stable tree
To:     Perry.Yuan@amd.com, Ray.Huang@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:55:17 +0100
Message-ID: <16376685172321@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3dac776e349a214c07fb2b0e5973947b0aade4f6 Mon Sep 17 00:00:00 2001
From: Perry Yuan <Perry.Yuan@amd.com>
Date: Thu, 28 Oct 2021 06:05:42 -0400
Subject: [PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level print support for
 APUs

add support that allow the userspace tool like RGP to get the GFX clock
value at runtime, the fix follow the old way to show the min/current/max
clocks level for compatible consideration.

=== Test ===
$ cat /sys/class/drm/card0/device/pp_dpm_sclk
0: 200Mhz *
1: 1100Mhz
2: 1600Mhz

then run stress test on one APU system.
$ cat /sys/class/drm/card0/device/pp_dpm_sclk
0: 200Mhz
1: 1040Mhz *
2: 1600Mhz

The current GFXCLK value is updated at runtime.

BugLink: https://gitlab.freedesktop.org/mesa/mesa/-/issues/5260
Reviewed-by: Huang Ray <Ray.Huang@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
index cbc3f99e8573..2238ee19c222 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
@@ -309,6 +309,7 @@ static int cyan_skillfish_print_clk_levels(struct smu_context *smu,
 {
 	int ret = 0, size = 0;
 	uint32_t cur_value = 0;
+	int i;
 
 	smu_cmn_get_sysfs_buf(&buf, &size);
 
@@ -334,8 +335,6 @@ static int cyan_skillfish_print_clk_levels(struct smu_context *smu,
 		size += sysfs_emit_at(buf, size, "VDDC: %7umV  %10umV\n",
 						CYAN_SKILLFISH_VDDC_MIN, CYAN_SKILLFISH_VDDC_MAX);
 		break;
-	case SMU_GFXCLK:
-	case SMU_SCLK:
 	case SMU_FCLK:
 	case SMU_MCLK:
 	case SMU_SOCCLK:
@@ -346,6 +345,25 @@ static int cyan_skillfish_print_clk_levels(struct smu_context *smu,
 			return ret;
 		size += sysfs_emit_at(buf, size, "0: %uMhz *\n", cur_value);
 		break;
+	case SMU_SCLK:
+	case SMU_GFXCLK:
+		ret = cyan_skillfish_get_current_clk_freq(smu, clk_type, &cur_value);
+		if (ret)
+			return ret;
+		if (cur_value  == CYAN_SKILLFISH_SCLK_MAX)
+			i = 2;
+		else if (cur_value == CYAN_SKILLFISH_SCLK_MIN)
+			i = 0;
+		else
+			i = 1;
+		size += sysfs_emit_at(buf, size, "0: %uMhz %s\n", CYAN_SKILLFISH_SCLK_MIN,
+				i == 0 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "1: %uMhz %s\n",
+				i == 1 ? cur_value : cyan_skillfish_sclk_default,
+				i == 1 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "2: %uMhz %s\n", CYAN_SKILLFISH_SCLK_MAX,
+				i == 2 ? "*" : "");
+		break;
 	default:
 		dev_warn(smu->adev->dev, "Unsupported clock type\n");
 		return ret;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index 421f38e8dada..c02ed65ffa38 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -683,6 +683,7 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 	int i, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	bool cur_value_match_level = false;
+	uint32_t min, max;
 
 	memset(&metrics, 0, sizeof(metrics));
 
@@ -743,6 +744,13 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 		if (ret)
 			return ret;
 		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GetGfxclkFrequency, 0, &cur_value);
+		if (ret) {
+			return ret;
+		}
+		break;
 	default:
 		break;
 	}
@@ -768,6 +776,24 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 		if (!cur_value_match_level)
 			size += sysfs_emit_at(buf, size, "   %uMhz *\n", cur_value);
 		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		min = (smu->gfx_actual_hard_min_freq > 0) ? smu->gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq;
+		max = (smu->gfx_actual_soft_max_freq > 0) ? smu->gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq;
+		if (cur_value  == max)
+			i = 2;
+		else if (cur_value == min)
+			i = 0;
+		else
+			i = 1;
+		size += sysfs_emit_at(buf, size, "0: %uMhz %s\n", min,
+				i == 0 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "1: %uMhz %s\n",
+				i == 1 ? cur_value : VANGOGH_UMD_PSTATE_STANDARD_GFXCLK,
+				i == 1 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "2: %uMhz %s\n", max,
+				i == 2 ? "*" : "");
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index 8215bbf5ed7c..caf1775d48ef 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -697,6 +697,11 @@ static int yellow_carp_get_current_clk_freq(struct smu_context *smu,
 	case SMU_FCLK:
 		return smu_cmn_send_smc_msg_with_param(smu,
 				SMU_MSG_GetFclkFrequency, 0, value);
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		return smu_cmn_send_smc_msg_with_param(smu,
+				SMU_MSG_GetGfxclkFrequency, 0, value);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -967,6 +972,7 @@ static int yellow_carp_print_clk_levels(struct smu_context *smu,
 {
 	int i, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
+	uint32_t min, max;
 
 	smu_cmn_get_sysfs_buf(&buf, &size);
 
@@ -1005,6 +1011,27 @@ static int yellow_carp_print_clk_levels(struct smu_context *smu,
 					cur_value == value ? "*" : "");
 		}
 		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		ret = yellow_carp_get_current_clk_freq(smu, clk_type, &cur_value);
+		if (ret)
+			goto print_clk_out;
+		min = (smu->gfx_actual_hard_min_freq > 0) ? smu->gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq;
+		max = (smu->gfx_actual_soft_max_freq > 0) ? smu->gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq;
+		if (cur_value  == max)
+			i = 2;
+		else if (cur_value == min)
+			i = 0;
+		else
+			i = 1;
+		size += sysfs_emit_at(buf, size, "0: %uMhz %s\n", min,
+				i == 0 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "1: %uMhz %s\n",
+				i == 1 ? cur_value : YELLOW_CARP_UMD_PSTATE_GFXCLK,
+				i == 1 ? "*" : "");
+		size += sysfs_emit_at(buf, size, "2: %uMhz %s\n", max,
+				i == 2 ? "*" : "");
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
index b3ad8352c68a..a9205a8ea3ad 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
@@ -24,5 +24,6 @@
 #define __YELLOW_CARP_PPT_H__
 
 extern void yellow_carp_set_ppt_funcs(struct smu_context *smu);
+#define YELLOW_CARP_UMD_PSTATE_GFXCLK       1100
 
 #endif

