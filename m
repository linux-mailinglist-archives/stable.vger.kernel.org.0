Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F18489269
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbiAJHm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242199AbiAJHkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:40:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D17C0225AD;
        Sun,  9 Jan 2022 23:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A970B81212;
        Mon, 10 Jan 2022 07:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760A1C36AE9;
        Mon, 10 Jan 2022 07:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800058;
        bh=ibkJuuo+6RsBx6kxBDga/mXyaKtd8xHoan+9CR99NQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aU7lFUtPAToustICwXCQyYz/xYTFXj56XcvNe0QZ4ALP3TRGqKGdlCInyl5n0mRAI
         aw/Khqz2gw4yP27Xmjdcrq77xpLpugIAlFMWz0T42PY48inP7ixyoHVkacN/s/IzZc
         9k6wAB8K9BSWGTTlKoUiQEjcn272asVXrdM8cwbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/72] drm/amdgpu: put SMU into proper state on runpm suspending for BOCO capable platform
Date:   Mon, 10 Jan 2022 08:23:40 +0100
Message-Id: <20220110071823.695439426@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 7be3be2b027c12e84833b3dc9597d3bb7e4c5464 ]

By setting mp1_state as PP_MP1_STATE_UNLOAD, MP1 will do some proper cleanups and
put itself into a state ready for PNP. That can workaround some random resuming
failure observed on BOCO capable platforms.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 9dfd9d70812cb..41677f99c67b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1606,12 +1606,27 @@ static int amdgpu_pmops_runtime_suspend(struct device *dev)
 	if (amdgpu_device_supports_px(drm_dev))
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 
+	/*
+	 * By setting mp1_state as PP_MP1_STATE_UNLOAD, MP1 will do some
+	 * proper cleanups and put itself into a state ready for PNP. That
+	 * can address some random resuming failure observed on BOCO capable
+	 * platforms.
+	 * TODO: this may be also needed for PX capable platform.
+	 */
+	if (amdgpu_device_supports_boco(drm_dev))
+		adev->mp1_state = PP_MP1_STATE_UNLOAD;
+
 	ret = amdgpu_device_suspend(drm_dev, false);
 	if (ret) {
 		adev->in_runpm = false;
+		if (amdgpu_device_supports_boco(drm_dev))
+			adev->mp1_state = PP_MP1_STATE_NONE;
 		return ret;
 	}
 
+	if (amdgpu_device_supports_boco(drm_dev))
+		adev->mp1_state = PP_MP1_STATE_NONE;
+
 	if (amdgpu_device_supports_px(drm_dev)) {
 		/* Only need to handle PCI state in the driver for ATPX
 		 * PCI core handles it for _PR3.
-- 
2.34.1



