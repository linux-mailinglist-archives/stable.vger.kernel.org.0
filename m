Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD11AC360
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898383AbgDPNmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408486AbgDPNl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:41:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61612214D8;
        Thu, 16 Apr 2020 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044517;
        bh=hdTXoxkrdgeEsruKVakXS40NWxVwkDOQ6lkFtL1wn40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4Ih8qB3EikyqQNrndltDE/Xb75ZsKt//slsaSwHTy3nfAiVHL+ICamOfkzD1h+5l
         8hGDcasxmW0yWkGmIlGp4d9iv63q7/uLp32anEZQaw8KXf1adw1dgeOKYzI33OpY49
         968p1DLnQ9ozShXjTyfDsFyxFSpINjdKxzt5iWC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuxian Dai <Yuxian.Dai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>, Kevin Wang <Kevin1.Wang@amd.com>
Subject: [PATCH 5.5 210/257] drm/amdgpu/powerplay: using the FCLK DPM table to set the MCLK
Date:   Thu, 16 Apr 2020 15:24:21 +0200
Message-Id: <20200416131352.314278648@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuxian Dai <Yuxian.Dai@amd.com>

commit 022ac4c9c55be35a2d1f71019a931324c51b0dab upstream.

1.Using the FCLK DPM table to set the MCLK for DPM states consist of
three entities:
 FCLK
 UCLK
 MEMCLK
All these three clk change together, MEMCLK from FCLK, so use the fclk
frequency.
2.we should show the current working clock freqency from clock table metric

Signed-off-by: Yuxian Dai <Yuxian.Dai@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Kevin Wang <Kevin1.Wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c |    6 ++++++
 drivers/gpu/drm/amd/powerplay/renoir_ppt.h |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
@@ -181,6 +181,7 @@ static int renoir_print_clk_levels(struc
 	uint32_t cur_value = 0, value = 0, count = 0, min = 0, max = 0;
 	DpmClocks_t *clk_table = smu->smu_table.clocks_table;
 	SmuMetrics_t metrics;
+	bool cur_value_match_level = false;
 
 	if (!clk_table || clk_type >= SMU_CLK_COUNT)
 		return -EINVAL;
@@ -240,8 +241,13 @@ static int renoir_print_clk_levels(struc
 		GET_DPM_CUR_FREQ(clk_table, clk_type, i, value);
 		size += sprintf(buf + size, "%d: %uMhz %s\n", i, value,
 				cur_value == value ? "*" : "");
+		if (cur_value == value)
+			cur_value_match_level = true;
 	}
 
+	if (!cur_value_match_level)
+		size += sprintf(buf + size, "   %uMhz *\n", cur_value);
+
 	return size;
 }
 
--- a/drivers/gpu/drm/amd/powerplay/renoir_ppt.h
+++ b/drivers/gpu/drm/amd/powerplay/renoir_ppt.h
@@ -37,7 +37,7 @@ extern void renoir_set_ppt_funcs(struct
 			freq = table->SocClocks[dpm_level].Freq;	\
 			break;						\
 		case SMU_MCLK:						\
-			freq = table->MemClocks[dpm_level].Freq;	\
+			freq = table->FClocks[dpm_level].Freq;	\
 			break;						\
 		case SMU_DCEFCLK:					\
 			freq = table->DcfClocks[dpm_level].Freq;	\


