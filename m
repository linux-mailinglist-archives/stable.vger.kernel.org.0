Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24171AC8C3
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgDPPLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441668AbgDPNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E037822246;
        Thu, 16 Apr 2020 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044992;
        bh=L9lth55zY+g3wY1fwvqUWhIhM+ZwE7TuD4VmdPiqPjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4cidiq0j/Smp7Pcq6BXCKWwUcVJJDU/QR/scz+kTiDdv+8tWYJrsGIUMO2E8gwuX
         dIgiuIRibqAdPiSUQxvrtU5bbxUkrqWCY7iiW/GDAZM99yR8FJybO31Eley17KdM51
         1AdvQryMDrCXd8adVzzl0nZNIGyF3ytE4ZyK1DXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuxian Dai <Yuxian.Dai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>, Kevin Wang <Kevin1.Wang@amd.com>
Subject: [PATCH 5.4 186/232] drm/amdgpu/powerplay: using the FCLK DPM table to set the MCLK
Date:   Thu, 16 Apr 2020 15:24:40 +0200
Message-Id: <20200416131338.376317121@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
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
@@ -184,6 +184,7 @@ static int renoir_print_clk_levels(struc
 	uint32_t cur_value = 0, value = 0, count = 0, min = 0, max = 0;
 	DpmClocks_t *clk_table = smu->smu_table.clocks_table;
 	SmuMetrics_t metrics;
+	bool cur_value_match_level = false;
 
 	if (!clk_table || clk_type >= SMU_CLK_COUNT)
 		return -EINVAL;
@@ -243,8 +244,13 @@ static int renoir_print_clk_levels(struc
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


