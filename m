Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8B2ACE2C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbgKJEHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732067AbgKJDxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C206C20829;
        Tue, 10 Nov 2020 03:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980425;
        bh=6XlyFZ9oASdXq6WPisknSIGYAu6qFcFe0nHE8uxr0dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujoAF98i8+lb7/XdnhYzTzuVtAkqyRZx3gzhspnb4LFOYEYM0cgWsg9FVgJJH4bB/
         TbzoGDQgynXLh+mem+AhNL+m9XXrXFXK5WwQZECNhtmyFbz3qebwavXU/in6Ec9MOT
         eCfKl40t1K3qEOleS2O1agUpywfsq7XDAviX1/J0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 19/55] drm/amd/pm: correct the baco reset sequence for CI ASICs
Date:   Mon,  9 Nov 2020 22:52:42 -0500
Message-Id: <20201110035318.423757-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit c108725ef589af462be6b957f63c7925e38213eb ]

Correct some registers bitmasks and add mmBIOS_SCRATCH_7
reset.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Tested-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c b/drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c
index 3be40114e63d2..45f608838f6eb 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c
@@ -142,12 +142,12 @@ static const struct baco_cmd_entry exit_baco_tbl[] =
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_BCLK_OFF_MASK,           BACO_CNTL__BACO_BCLK_OFF__SHIFT, 0, 0x00 },
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_POWER_OFF_MASK,          BACO_CNTL__BACO_POWER_OFF__SHIFT, 0, 0x00 },
 	{ CMD_DELAY_MS, 0, 0, 0, 20, 0 },
-	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__PWRGOOD_BF_MASK, 0, 0xffffffff, 0x20 },
+	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__PWRGOOD_BF_MASK, 0, 0xffffffff, 0x200 },
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_ISO_DIS_MASK, BACO_CNTL__BACO_ISO_DIS__SHIFT, 0, 0x01 },
-	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__PWRGOOD_MASK, 0, 5, 0x1c },
+	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__PWRGOOD_MASK, 0, 5, 0x1c00 },
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_ANA_ISO_DIS_MASK, BACO_CNTL__BACO_ANA_ISO_DIS__SHIFT, 0, 0x01 },
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_RESET_EN_MASK, BACO_CNTL__BACO_RESET_EN__SHIFT, 0, 0x00 },
-	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__RCU_BIF_CONFIG_DONE_MASK, 0, 5, 0x10 },
+	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__RCU_BIF_CONFIG_DONE_MASK, 0, 5, 0x100 },
 	{ CMD_READMODIFYWRITE, mmBACO_CNTL, BACO_CNTL__BACO_EN_MASK, BACO_CNTL__BACO_EN__SHIFT, 0, 0x00 },
 	{ CMD_WAITFOR, mmBACO_CNTL, BACO_CNTL__BACO_MODE_MASK, 0, 0xffffffff, 0x00 }
 };
@@ -155,6 +155,7 @@ static const struct baco_cmd_entry exit_baco_tbl[] =
 static const struct baco_cmd_entry clean_baco_tbl[] =
 {
 	{ CMD_WRITE, mmBIOS_SCRATCH_6, 0, 0, 0, 0 },
+	{ CMD_WRITE, mmBIOS_SCRATCH_7, 0, 0, 0, 0 },
 	{ CMD_WRITE, mmCP_PFP_UCODE_ADDR, 0, 0, 0, 0 }
 };
 
-- 
2.27.0

