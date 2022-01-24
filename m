Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6EF4992B5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351577AbiAXUYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:24:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiAXUVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:21:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70510B8122F;
        Mon, 24 Jan 2022 20:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E68CC340E5;
        Mon, 24 Jan 2022 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055698;
        bh=KNvtoKF6VVt8mSBOua0hkFg/xqtySZDdSDEM4nWncgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjqgI/PlweB++3Iih7BF53Z467uoYj2E+wL1fXY3FK3RzV58WVyhrUnokQEANgmoL
         jGeMRu72nZSc6Dw/V7hPVosPSQpupMS4p9w844ToSaFDDkyQZhBbPdE58eCA0IaQMZ
         KP2PbtuXGGpBiq/plcyz+pKmMBZZ5vF8BzWwrxds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/846] drm/amd/display: Fix bug in debugfs crc_win_update entry
Date:   Mon, 24 Jan 2022 19:35:36 +0100
Message-Id: <20220124184108.479174958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 4bef85d4c9491415b7931407b07f24841c1e0390 ]

[Why]
crc_rd_wrk shouldn't be null in crc_win_update_set(). Current programming
logic is inconsistent in crc_win_update_set().

[How]
Initially, return if crc_rd_wrk is NULL. Later on, we can use member of
crc_rd_wrk safely.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 9a65df193108 ("drm/amd/display: Use PSP TA to read out crc")

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index de9ec5ddb6c72..e94ddd5e7b638 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -2908,10 +2908,13 @@ static int crc_win_update_set(void *data, u64 val)
 	struct amdgpu_device *adev = drm_to_adev(new_crtc->dev);
 	struct crc_rd_work *crc_rd_wrk = adev->dm.crc_rd_wrk;
 
+	if (!crc_rd_wrk)
+		return 0;
+
 	if (val) {
 		spin_lock_irq(&adev_to_drm(adev)->event_lock);
 		spin_lock_irq(&crc_rd_wrk->crc_rd_work_lock);
-		if (crc_rd_wrk && crc_rd_wrk->crtc) {
+		if (crc_rd_wrk->crtc) {
 			old_crtc = crc_rd_wrk->crtc;
 			old_acrtc = to_amdgpu_crtc(old_crtc);
 		}
-- 
2.34.1



