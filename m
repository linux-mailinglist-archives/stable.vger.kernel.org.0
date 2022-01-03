Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608B94835DD
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiACRag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiACR3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78BAC061792;
        Mon,  3 Jan 2022 09:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93823B81042;
        Mon,  3 Jan 2022 17:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B925C36AFC;
        Mon,  3 Jan 2022 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230973;
        bh=cFOi+Lx49Jz2qSKIj75Qq6OD+sG4BvgvBkB5H0Skzcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNgQzBKtNOYCgcmiKVbjQ7Sx+SBabWOrDxm2Tx48AT6SgfRdKBDpKDfLVZQP2uusq
         9pEJEcyVfnlddu16oc57ILQoYhTYU8LtfxXBkJEDg//NReCcbfmX7sZzAWZOSff0tO
         Htx0Gf6fJc9Fyg0R+AicyFo6sl9J6WJ1ZL5JKyjc5TN5hnpVmvOZ+VB8VodT/ULCcI
         Y5o1t80oZEIBTQSpOzcNqM76JPraqh4p/u0AFTerfHenRaAnbXHBzIH/iozEJUyQKM
         +qD1f303P9O1pSYIY4V6/lY5XU9wp1S0Slu1dZcK/yX4ineaCnRW2keUvFMBgp4B/T
         7K7tAX7eLuDiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Hawking.Zhang@amd.com, ray.huang@amd.com,
        andrey.grodzovsky@amd.com, tzimmermann@suse.de,
        shaoyun.liu@amd.com, aurabindo.pillai@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 10/16] drm/amdgpu: always reset the asic in suspend (v2)
Date:   Mon,  3 Jan 2022 12:28:43 -0500
Message-Id: <20220103172849.1612731-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit daf8de0874ab5b74b38a38726fdd3d07ef98a7ee ]

If the platform suspend happens to fail and the power rail
is not turned off, the GPU will be in an unknown state on
resume, so reset the asic so that it will be in a known
good state on resume even if the platform suspend failed.

v2: handle s0ix

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index f18240f873878..ada083fbc052b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1498,7 +1498,10 @@ static int amdgpu_pmops_suspend(struct device *dev)
 	adev->in_s3 = true;
 	r = amdgpu_device_suspend(drm_dev, true);
 	adev->in_s3 = false;
-
+	if (r)
+		return r;
+	if (!adev->in_s0ix)
+		r = amdgpu_asic_reset(adev);
 	return r;
 }
 
-- 
2.34.1

