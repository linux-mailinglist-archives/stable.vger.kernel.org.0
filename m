Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13F1328FC7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242462AbhCAT6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhCATor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19CD46519B;
        Mon,  1 Mar 2021 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618693;
        bh=e0D/MCCFCmYYeI5pbSDk5j7pZRuKlZF+nY4kUP7iCYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4NKx4tx+6exDD7lKbE5DzOfW4feH/CsmCgSfpZFCmtgKGo4yHnVLvIzrVhlcaohT
         NqpnMkuq9dxfYhtWVgjYwFTwa9a6qzyg1CacHD5OeTK4beJmBCEzhsGriRJiDSAJKk
         k2w86thXmDpvA9EzAOfmOy6oJQytafQ+QuvgYcXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/663] drm/amdgpu: toggle on DF Cstate after finishing xgmi injection
Date:   Mon,  1 Mar 2021 17:07:10 +0100
Message-Id: <20210301161150.781505150@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit fe2d9f5abf19f2b3688b3b8da4e42f8d07886847 ]

Fixes: 5c23e9e05e42 ("drm/amdgpu: Update RAS XGMI error inject sequence")
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 82cd8e55595af..eb22a190c2423 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -844,7 +844,7 @@ static int amdgpu_ras_error_inject_xgmi(struct amdgpu_device *adev,
 	if (amdgpu_dpm_allow_xgmi_power_down(adev, true))
 		dev_warn(adev->dev, "Failed to allow XGMI power down");
 
-	if (amdgpu_dpm_set_df_cstate(adev, DF_CSTATE_DISALLOW))
+	if (amdgpu_dpm_set_df_cstate(adev, DF_CSTATE_ALLOW))
 		dev_warn(adev->dev, "Failed to allow df cstate");
 
 	return ret;
-- 
2.27.0



