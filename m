Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46CE5D1E
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJZNRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbfJZNRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855AE2070B;
        Sat, 26 Oct 2019 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095839;
        bh=gulA3tNgyb2dUp3AmieLcpeoFl2ZtpI36NvZRc/TxS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juAJp1iajgIf9H7BQN9eg7L70fOtuTW3a34mHSqyoMMIdEXH3ATwrtXYEkXZYj+5t
         R0NFYfT1rOKKpAG8AEu2akyR09n1pBxbBhEQuBGbhtrElWicHbYrIHXRkGOf7mZldO
         WUJzdifJjR/SSXYvJRIPrEQAR7ocj3EvlYTnV/bA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Robert Strube <rstrube@gmail.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 39/99] drm/amdgpu/powerplay: fix typo in mvdd table setup
Date:   Sat, 26 Oct 2019 09:15:00 -0400
Message-Id: <20191026131600.2507-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 598c30dbcc9434706f29a085a8eba4730573bcc2 ]

Polaris and vegam use count for the value rather than
level.  This looks like a copy paste typo from when
the code was adapted from previous asics.

I'm not sure that the SMU actually uses this value, so
I don't know that it actually is a bug per se.

Bug: https://bugs.freedesktop.org/show_bug.cgi?id=108609
Reported-by: Robert Strube <rstrube@gmail.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c | 2 +-
 drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
index dc754447f0ddc..23c12018dbc18 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
@@ -655,7 +655,7 @@ static int polaris10_populate_smc_mvdd_table(struct pp_hwmgr *hwmgr,
 			count = SMU_MAX_SMIO_LEVELS;
 		for (level = 0; level < count; level++) {
 			table->SmioTable2.Pattern[level].Voltage =
-				PP_HOST_TO_SMC_US(data->mvdd_voltage_table.entries[count].value * VOLTAGE_SCALE);
+				PP_HOST_TO_SMC_US(data->mvdd_voltage_table.entries[level].value * VOLTAGE_SCALE);
 			/* Index into DpmTable.Smio. Drive bits from Smio entry to get this voltage level.*/
 			table->SmioTable2.Pattern[level].Smio =
 				(uint8_t) level;
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
index 7c960b07746fd..ae18fbcb26fb1 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
@@ -456,7 +456,7 @@ static int vegam_populate_smc_mvdd_table(struct pp_hwmgr *hwmgr,
 			count = SMU_MAX_SMIO_LEVELS;
 		for (level = 0; level < count; level++) {
 			table->SmioTable2.Pattern[level].Voltage = PP_HOST_TO_SMC_US(
-					data->mvdd_voltage_table.entries[count].value * VOLTAGE_SCALE);
+					data->mvdd_voltage_table.entries[level].value * VOLTAGE_SCALE);
 			/* Index into DpmTable.Smio. Drive bits from Smio entry to get this voltage level.*/
 			table->SmioTable2.Pattern[level].Smio =
 				(uint8_t) level;
-- 
2.20.1

