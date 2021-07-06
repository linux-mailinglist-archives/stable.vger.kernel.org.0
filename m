Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047713BCBB7
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhGFLRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhGFLRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C281861C23;
        Tue,  6 Jul 2021 11:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570070;
        bh=fNfMGwQJKU7xCENjJix6Hk1CGW1bNKsCjIkjIHa08ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soq133w7u44iyNTKeNJzrhxOmzhswxmGAfVW5uuAzdpve1mLn7XnxGrC/VroiMlpF
         qPf/Pgq46bMcCh4wqHhbjN2xqyXTekcpmmv6GhVMkqwnXjTgLrl/yZMLLDYZFxddR3
         56VfcWTFnlyOMPVBHjMhcgHdCIBvdwNwqAJTN9JJWHNvoNdzdpj5VYLaVRT0cjYmCH
         FjbcLs7n3phpbmoito4IKb2RqbDyHKZ6fiD7FwiqY6B8BH+lh34KEOe0i7yOYhsuOR
         ZzfmBN8QR/mEgcxm+HvF+M07IEASZXnRuJpexS8Mtn/oagjUPUPnuE5vFYkKJOnOTh
         OAGdkCG2IT/og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <Roman.Li@amd.com>, Lang Yu <Lang.Yu@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 014/189] drm/amd/display: fix potential gpu reset deadlock
Date:   Tue,  6 Jul 2021 07:11:14 -0400
Message-Id: <20210706111409.2058071-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit cf8b92a75646735136053ce51107bfa8cfc23191 ]

[Why]
In gpu reset dc_lock acquired in dm_suspend().
Asynchronously handle_hpd_rx_irq can also be called
through amdgpu_dm_irq_suspend->flush_work, which also
tries to acquire dc_lock. That causes a deadlock.

[How]
Check if amdgpu executing reset before acquiring dc_lock.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Reviewed-by: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Acked-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 652cc1a0e450..875fd187463e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2726,13 +2726,15 @@ static void handle_hpd_rx_irq(void *param)
 		}
 	}
 
-	mutex_lock(&adev->dm.dc_lock);
+	if (!amdgpu_in_reset(adev))
+		mutex_lock(&adev->dm.dc_lock);
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
 #else
 	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
 #endif
-	mutex_unlock(&adev->dm.dc_lock);
+	if (!amdgpu_in_reset(adev))
+		mutex_unlock(&adev->dm.dc_lock);
 
 out:
 	if (result && !is_mst_root_connector) {
-- 
2.30.2

