Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F3C4BE268
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350794AbiBUJjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351004AbiBUJgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807B66466;
        Mon, 21 Feb 2022 01:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 819CD60C1D;
        Mon, 21 Feb 2022 09:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6616BC340F4;
        Mon, 21 Feb 2022 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434905;
        bh=TmLejLW9mEBO5G5fDzZMrMFnVitxe+SOqkA4tEbNZvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=am24mhg72B43Dq1iePI9lk+W9mc2sqpb6RZBftEhntzgn1oskgn6uqjwER7+rzeDI
         +mgQ+5emcrjZRLcAQ39Vmiy2UuUhmG18CvTU/NTMbXS/AYfp/i7r18N0D0dJdGEvA9
         MDmYWcblCLXS+kcUvGuBYTXQKCk/hlUAPa6ZGa78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <Charlene.Liu@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/196] drm/amd/display: fix yellow carp wm clamping
Date:   Mon, 21 Feb 2022 09:50:04 +0100
Message-Id: <20220221084936.697751684@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 60fdf98a774eee244a4e00c34a9e7729b61d0f44 ]

Fix clamping to match register field size

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn31/dcn31_hubbub.c   | 61 ++++++++++---------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
index 90c73a1cb9861..5e3bcaf12cac4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -138,8 +138,11 @@ static uint32_t convert_and_clamp(
 	ret_val = wm_ns * refclk_mhz;
 	ret_val /= 1000;
 
-	if (ret_val > clamp_value)
+	if (ret_val > clamp_value) {
+		/* clamping WMs is abnormal, unexpected and may lead to underflow*/
+		ASSERT(0);
 		ret_val = clamp_value;
+	}
 
 	return ret_val;
 }
@@ -159,7 +162,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->a.urgent_ns > hubbub2->watermarks.a.urgent_ns) {
 		hubbub2->watermarks.a.urgent_ns = watermarks->a.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->a.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_A, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_A, prog_wm_value);
 
@@ -193,7 +196,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->a.urgent_latency_ns > hubbub2->watermarks.a.urgent_latency_ns) {
 		hubbub2->watermarks.a.urgent_latency_ns = watermarks->a.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->a.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_A, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_A, prog_wm_value);
 	} else if (watermarks->a.urgent_latency_ns < hubbub2->watermarks.a.urgent_latency_ns)
@@ -203,7 +206,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->b.urgent_ns > hubbub2->watermarks.b.urgent_ns) {
 		hubbub2->watermarks.b.urgent_ns = watermarks->b.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->b.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_B, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_B, prog_wm_value);
 
@@ -237,7 +240,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->b.urgent_latency_ns > hubbub2->watermarks.b.urgent_latency_ns) {
 		hubbub2->watermarks.b.urgent_latency_ns = watermarks->b.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->b.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_B, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_B, prog_wm_value);
 	} else if (watermarks->b.urgent_latency_ns < hubbub2->watermarks.b.urgent_latency_ns)
@@ -247,7 +250,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->c.urgent_ns > hubbub2->watermarks.c.urgent_ns) {
 		hubbub2->watermarks.c.urgent_ns = watermarks->c.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->c.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_C, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_C, prog_wm_value);
 
@@ -281,7 +284,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->c.urgent_latency_ns > hubbub2->watermarks.c.urgent_latency_ns) {
 		hubbub2->watermarks.c.urgent_latency_ns = watermarks->c.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->c.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_C, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_C, prog_wm_value);
 	} else if (watermarks->c.urgent_latency_ns < hubbub2->watermarks.c.urgent_latency_ns)
@@ -291,7 +294,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->d.urgent_ns > hubbub2->watermarks.d.urgent_ns) {
 		hubbub2->watermarks.d.urgent_ns = watermarks->d.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->d.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_D, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_D, prog_wm_value);
 
@@ -325,7 +328,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->d.urgent_latency_ns > hubbub2->watermarks.d.urgent_latency_ns) {
 		hubbub2->watermarks.d.urgent_latency_ns = watermarks->d.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->d.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_D, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_D, prog_wm_value);
 	} else if (watermarks->d.urgent_latency_ns < hubbub2->watermarks.d.urgent_latency_ns)
@@ -351,7 +354,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_A calculated =%d\n"
@@ -367,7 +370,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_A calculated =%d\n"
@@ -383,7 +386,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_A calculated =%d\n"
@@ -399,7 +402,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_A calculated =%d\n"
@@ -416,7 +419,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_B calculated =%d\n"
@@ -432,7 +435,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_B calculated =%d\n"
@@ -448,7 +451,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_B calculated =%d\n"
@@ -464,7 +467,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_B calculated =%d\n"
@@ -481,7 +484,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_C calculated =%d\n"
@@ -497,7 +500,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_C calculated =%d\n"
@@ -513,7 +516,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_C calculated =%d\n"
@@ -529,7 +532,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_C calculated =%d\n"
@@ -546,7 +549,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_D calculated =%d\n"
@@ -562,7 +565,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_D calculated =%d\n"
@@ -578,7 +581,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_D calculated =%d\n"
@@ -594,7 +597,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_D calculated =%d\n"
@@ -625,7 +628,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->a.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_A calculated =%d\n"
@@ -642,7 +645,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->b.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_B calculated =%d\n"
@@ -659,7 +662,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->c.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_C calculated =%d\n"
@@ -676,7 +679,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->d.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_D calculated =%d\n"
-- 
2.34.1



