Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A1590007
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiHKPhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbiHKPhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CA998C96;
        Thu, 11 Aug 2022 08:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9280F6162D;
        Thu, 11 Aug 2022 15:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E73C433C1;
        Thu, 11 Aug 2022 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232010;
        bh=4ESsXl8rexzcWZTYWvPGXzFYiesziOJPORgwOzpzmFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVnVLib9+PFYwX4EoDm51odEBQTOYyiAAD/xady8bY+JcqUTuA29mR+dJqxKTn0wA
         3flFytMw5KqiGe4uqD2v54BjbuMN98ud0INkA/YqGspSJ0wNNrgfzPymL0sxIvML2C
         YF2dQc09Z5azKHX7c1BDbfkZaApX0QLrW0d7GKdLLEzApObRI+hb/asJpioveCs7JO
         y7pWQzRtm1ezH6o7+fv4D8P0ho0exw7/lCxZhoZAnAW/1WsTRol9d9qb4Bw+BuNTSf
         jZt873V9nt4MTMSK5M+SxXop+QGAiA1vvAUdELaa3EnPLU7EZYwszbmo4l1mtZ0MtH
         KtAyAEMK+lehQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darren Powell <darren.powell@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, lijo.lazar@amd.com, Hawking.Zhang@amd.com,
        guchun.chen@amd.com, kevin1.wang@amd.com, lang.yu@amd.com,
        luben.tuikov@amd.com, Stanley.Yang@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 045/105] amdgpu/pm: Fix possible array out-of-bounds if SCLK levels != 2
Date:   Thu, 11 Aug 2022 11:27:29 -0400
Message-Id: <20220811152851.1520029-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darren Powell <darren.powell@amd.com>

[ Upstream commit ceb180361e3851007547c55035cd1de03f108f75 ]

 [v2]
simplified fix after Lijo's feedback
 removed clocks.num_levels from calculation of loop count
   removed unsafe accesses to shim table freq_values
 retained corner case output only min,now if
   clocks.num_levels == 1 && now > min

 [v1]
added a check to populate and use SCLK shim table freq_values only
   if using dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL or
                         AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM
removed clocks.num_levels from calculation of shim table size
removed unsafe accesses to shim table freq_values
   output gfx_table values if using other dpm levels
added check for freq_match when using freq_values for when now == min_clk

== Test ==
LOGFILE=aldebaran-sclk.test.log
AMDGPU_PCI_ADDR=`lspci -nn | grep "VGA\|Display" | cut -d " " -f 1`
AMDGPU_HWMON=`ls -la /sys/class/hwmon | grep $AMDGPU_PCI_ADDR | awk '{print $9}'`
HWMON_DIR=/sys/class/hwmon/${AMDGPU_HWMON}

lspci -nn | grep "VGA\|Display"  > $LOGFILE
FILES="pp_od_clk_voltage
pp_dpm_sclk"

for f in $FILES
do
  echo === $f === >> $LOGFILE
  cat $HWMON_DIR/device/$f >> $LOGFILE
done
cat $LOGFILE

Signed-off-by: Darren Powell <darren.powell@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/aldebaran_ppt.c    | 34 +++++++------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index fb130409309c..f6ff7942e1b7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -739,7 +739,7 @@ static int aldebaran_print_clk_levels(struct smu_context *smu,
 	struct smu_13_0_dpm_table *single_dpm_table;
 	struct smu_dpm_context *smu_dpm = &smu->smu_dpm;
 	struct smu_13_0_dpm_context *dpm_context = NULL;
-	uint32_t display_levels;
+	int display_levels;
 	uint32_t freq_values[3] = {0};
 	uint32_t min_clk, max_clk;
 
@@ -771,7 +771,7 @@ static int aldebaran_print_clk_levels(struct smu_context *smu,
 			return ret;
 		}
 
-		display_levels = clocks.num_levels;
+		display_levels = (clocks.num_levels == 1) ? 1 : 2;
 
 		min_clk = pstate_table->gfxclk_pstate.curr.min;
 		max_clk = pstate_table->gfxclk_pstate.curr.max;
@@ -781,30 +781,20 @@ static int aldebaran_print_clk_levels(struct smu_context *smu,
 
 		/* fine-grained dpm has only 2 levels */
 		if (now > min_clk && now < max_clk) {
-			display_levels = clocks.num_levels + 1;
+			display_levels++;
 			freq_values[2] = max_clk;
 			freq_values[1] = now;
 		}
 
-		/*
-		 * For DPM disabled case, there will be only one clock level.
-		 * And it's safe to assume that is always the current clock.
-		 */
-		if (display_levels == clocks.num_levels) {
-			for (i = 0; i < clocks.num_levels; i++)
-				size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n", i,
-					freq_values[i],
-					(clocks.num_levels == 1) ?
-						"*" :
-						(aldebaran_freqs_in_same_level(
-							 freq_values[i], now) ?
-							 "*" :
-							 ""));
-		} else {
-			for (i = 0; i < display_levels; i++)
-				size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n", i,
-						freq_values[i], i == 1 ? "*" : "");
-		}
+		for (i = 0; i < display_levels; i++)
+			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n", i,
+				freq_values[i],
+				(display_levels == 1) ?
+					"*" :
+					(aldebaran_freqs_in_same_level(
+						 freq_values[i], now) ?
+						 "*" :
+						 ""));
 
 		break;
 
-- 
2.35.1

