Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96562FA40A
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbhARLmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390646AbhARLk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A6422D37;
        Mon, 18 Jan 2021 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970035;
        bh=CDf+Uydz0u3RU73t8yBRAriPKvLCoAd4wCfyGvaiaMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpXK5Mm9BMGrEkJInlg0TE9jjScuf3YPBho/0l7Irt3aU9f2eJukpgb1ylCMPL01s
         LgCRGnA5M7Y2k/pavdsWUeXEFiwmKipvGDUcLxS35UzMfA7NznAekqdkz39+i5DXcq
         474+yx5QtOExyu80nYT++jM+VKkQgkJWpbSBh1cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Naveed Ashfaq <Naveed.Ashfaq@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>, Roman Li <roman.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Subject: [PATCH 5.10 010/152] Revert "drm/amd/display: Fixed Intermittent blue screen on OLED panel"
Date:   Mon, 18 Jan 2021 12:33:05 +0100
Message-Id: <20210118113353.262872323@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 4eec66c014e9a406d8d453de958f6791d05427e4 upstream.

commit a861736dae64 ("drm/amd/display: Fixed Intermittent blue screen on OLED panel")

causes power regression for many users. It seems that this change causes
the MCLK to get forced high; this creates a regression for many users
since their devices were not able to drop to a low state after this
change. For this reason, this reverts commit
a861736dae644a0d7abbca0c638ae6aad28feeb8.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1407
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Naveed Ashfaq <Naveed.Ashfaq@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Roman Li <roman.li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c |   11 +++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -2635,14 +2635,15 @@ static void dml20v2_DISPCLKDPPCLKDCFCLKD
 	}
 
 	if (mode_lib->vba.DRAMClockChangeSupportsVActive &&
-			mode_lib->vba.MinActiveDRAMClockChangeMargin > 60 &&
-			mode_lib->vba.PrefetchMode[mode_lib->vba.VoltageLevel][mode_lib->vba.maxMpcComb] == 0) {
+			mode_lib->vba.MinActiveDRAMClockChangeMargin > 60) {
 		mode_lib->vba.DRAMClockChangeWatermark += 25;
 
 		for (k = 0; k < mode_lib->vba.NumberOfActivePlanes; ++k) {
-			if (mode_lib->vba.DRAMClockChangeWatermark >
-			dml_max(mode_lib->vba.StutterEnterPlusExitWatermark, mode_lib->vba.UrgentWatermark))
-				mode_lib->vba.MinTTUVBlank[k] += 25;
+			if (mode_lib->vba.PrefetchMode[mode_lib->vba.VoltageLevel][mode_lib->vba.maxMpcComb] == 0) {
+				if (mode_lib->vba.DRAMClockChangeWatermark >
+				dml_max(mode_lib->vba.StutterEnterPlusExitWatermark, mode_lib->vba.UrgentWatermark))
+					mode_lib->vba.MinTTUVBlank[k] += 25;
+			}
 		}
 
 		mode_lib->vba.DRAMClockChangeSupport[0][0] = dm_dram_clock_change_vactive;


