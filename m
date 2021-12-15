Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAB1475EBB
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhLORYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbhLORXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB9C0613B4;
        Wed, 15 Dec 2021 09:23:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E02B8202A;
        Wed, 15 Dec 2021 17:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1932C36AE2;
        Wed, 15 Dec 2021 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589015;
        bh=fxnpeYtn5lzA1D9cDoDh9K8sHKNQ4nQR9xKxEguVNx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pEPb26jOKRDvdOlUslp8pIML6zY9BLLq3RlbIJuyyXQPXk3Tv21eUSb35FwkpVMA
         T4Yj/Cw40at7jJFoIDxZim0MvAYrmdUVgScukKfYh4s47sW8YygMMZGplKWDZvko2d
         VyPOMdPL5WTbfkzfrGpedgPmf0R2FsJZQ9BpawT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flora Cui <flora.cui@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/42] drm/amdgpu: cancel the correct hrtimer on exit
Date:   Wed, 15 Dec 2021 18:21:14 +0100
Message-Id: <20211215172027.784525540@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit 3e467e478ed3a9701bb588d648d6e0ccb82ced09 ]

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index ce982afeff913..ac9a8cd21c4b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -504,8 +504,8 @@ static int amdgpu_vkms_sw_fini(void *handle)
 	int i = 0;
 
 	for (i = 0; i < adev->mode_info.num_crtc; i++)
-		if (adev->mode_info.crtcs[i])
-			hrtimer_cancel(&adev->mode_info.crtcs[i]->vblank_timer);
+		if (adev->amdgpu_vkms_output[i].vblank_hrtimer.function)
+			hrtimer_cancel(&adev->amdgpu_vkms_output[i].vblank_hrtimer);
 
 	kfree(adev->mode_info.bios_hardcoded_edid);
 	kfree(adev->amdgpu_vkms_output);
-- 
2.33.0



