Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D43425053A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgHXRNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgHXQha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C447522EBD;
        Mon, 24 Aug 2020 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287017;
        bh=483GrcA7svNWzy8Q8L2xYtZFXyb1m8QzsUVZ+WM9R88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyjciXwax+KWDg1petEqZT6UfzCL4RL5HKzAqUP9idPqtmW6tldoXCo2cOk6zqB7N
         A3u3B3vZFeZtJtvNUwKJnXunqT3x2vDpxVmjt+ML6gWfHSrXKXIYYi4JxZdHTGSDM0
         umC2CLID7+Ejquq6jbdfgsPO5aMlPzEEZEooDp/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 17/54] drm/amd/powerplay: correct UVD/VCE PG state on custom pptable uploading
Date:   Mon, 24 Aug 2020 12:35:56 -0400
Message-Id: <20200824163634.606093-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 2c5b8080d810d98e3e59617680218499b17c84a1 ]

The UVD/VCE PG state is managed by UVD and VCE IP. It's error-prone to
assume the bootup state in SMU based on the dpm status.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
index f714d65de07e1..eeacd12caded1 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
@@ -1644,12 +1644,6 @@ static void vega20_init_powergate_state(struct pp_hwmgr *hwmgr)
 
 	data->uvd_power_gated = true;
 	data->vce_power_gated = true;
-
-	if (data->smu_features[GNLD_DPM_UVD].enabled)
-		data->uvd_power_gated = false;
-
-	if (data->smu_features[GNLD_DPM_VCE].enabled)
-		data->vce_power_gated = false;
 }
 
 static int vega20_enable_dpm_tasks(struct pp_hwmgr *hwmgr)
-- 
2.25.1

