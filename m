Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5852ACC64
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732944AbgKJDzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgKJDzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F11420897;
        Tue, 10 Nov 2020 03:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980503;
        bh=S/qVpmdo/I/WpqoRgF5iVIPW7eamJQGlkGVglSqUJfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lKr7w/aKFy4/lSYQ71YM71mSEHwdUNeIrU9gHp1Bjk4JANOlYKQzeUrBMjdKtsER
         ZzGNvt8vttuxx7UM/zbDciDyRAg7+dhsApxn10qcMOKt0WTnat0Ldqk5rQUZQ/kL4w
         +XFwcPW9VVTyMrmQ9+/B3wIglk2HFNMi2RKc7wDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 16/42] drm/amd/pm: do not use ixFEATURE_STATUS for checking smc running
Date:   Mon,  9 Nov 2020 22:54:14 -0500
Message-Id: <20201110035440.424258-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 786436b453001dafe81025389f96bf9dac1e9690 ]

This reverts commit f87812284172a9809820d10143b573d833cd3f75 ("drm/amdgpu:
Fix bug where DPM is not enabled after hibernate and resume").
It was intended to fix Hawaii S4(hibernation) issue but break S3. As
ixFEATURE_STATUS is filled with garbage data on resume which can be
only cleared by reloading smc firmware(but that will involve many
changes). So, we will revert this S4 fix and seek a new way.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Tested-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
index 0f4f27a89020d..42c8f8731a504 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -2725,10 +2725,7 @@ static int ci_initialize_mc_reg_table(struct pp_hwmgr *hwmgr)
 
 static bool ci_is_dpm_running(struct pp_hwmgr *hwmgr)
 {
-	return (1 == PHM_READ_INDIRECT_FIELD(hwmgr->device,
-					     CGS_IND_REG__SMC, FEATURE_STATUS,
-					     VOLTAGE_CONTROLLER_ON))
-		? true : false;
+	return ci_is_smc_ram_running(hwmgr);
 }
 
 static int ci_smu_init(struct pp_hwmgr *hwmgr)
-- 
2.27.0

