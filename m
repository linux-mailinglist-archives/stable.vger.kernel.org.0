Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12530BA94F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436815AbfIVTNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394779AbfIVS5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47BB208C2;
        Sun, 22 Sep 2019 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178627;
        bh=4aQFDbSQL+d9zrO7he+q/JybfPW4JziCkkso1/CsaKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPnCrPQ69Hg5xcz5Kpx8pW+IGJromkA7Xv3FnZUczxxdy/KpM1tnmkjEg7u6raf+V
         JBvc52q8YuhSNEOE70VFmUSFFUetL2zyKvSRPPbzxXZQOqOsXLtk/tZvI0DmKUAic2
         BqFwKy2wQGG/4Xu1Id3QWUL6LV2wo1fQtR51PKWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahzo <Ahzo@tutanota.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 124/128] drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)
Date:   Sun, 22 Sep 2019 14:54:14 -0400
Message-Id: <20190922185418.2158-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahzo <Ahzo@tutanota.com>

[ Upstream commit f659bb6dae58c113805f92822e4c16ddd3156b79 ]

This fixes screen corruption/flickering on 75 Hz displays.

v2: make print statement debug only (Alex)

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=102646
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Ahzo <Ahzo@tutanota.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index b52ccab428a9e..c7c505095402d 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -4052,6 +4052,11 @@ static int smu7_program_display_gap(struct pp_hwmgr *hwmgr)
 
 	data->frame_time_x2 = frame_time_in_us * 2 / 100;
 
+	if (data->frame_time_x2 < 280) {
+		pr_debug("%s: enforce minimal VBITimeout: %d -> 280\n", __func__, data->frame_time_x2);
+		data->frame_time_x2 = 280;
+	}
+
 	display_gap2 = pre_vbi_time_in_us * (ref_clock / 100);
 
 	cgs_write_ind_register(hwmgr->device, CGS_IND_REG__SMC, ixCG_DISPLAY_GAP_CNTL2, display_gap2);
-- 
2.20.1

