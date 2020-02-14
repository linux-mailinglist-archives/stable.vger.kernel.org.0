Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FD515F279
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgBNPyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730994AbgBNPx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D47A824673;
        Fri, 14 Feb 2020 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695638;
        bh=3AKeUqw3th+3raqm8R0IJ/3uw095xNgT79Nx5tFCf0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTdN8frgYtV0VLg4WctAXP0k2SS/UQO8XWjDJtGdxLD9fSyrgKvVRMCBWhPiTBKDZ
         yTiHLQEfb2/nicYWtd3lSl4oqLnBHEOSP5mHdar0DA2S5NgVt9RenOJnNo/2MWvCX5
         4ydRXlu3q/4BN1cRueq9vXnA7rgmnKW91SXawsCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Monk Liu <Monk.Liu@amd.com>, Emily Deng <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 234/542] drm/amdgpu: fix double gpu_recovery for NV of SRIOV
Date:   Fri, 14 Feb 2020 10:43:46 -0500
Message-Id: <20200214154854.6746-234-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monk Liu <Monk.Liu@amd.com>

[ Upstream commit 1512d064f55bace6a8e32d65009c7ea112e76a31 ]

issues:
gpu_recover() is re-entered by the mailbox interrupt
handler mxgpu_nv.c

fix:
we need to bypass the gpu_recover() invoke in mailbox
interrupt as long as the timeout is not infinite (thus the TDR
will be triggered automatically after time out, no need to invoke
gpu_recover() through mailbox interrupt.

Signed-off-by: Monk Liu <Monk.Liu@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index 0d8767eb7a709..1c3a7d4bb65d2 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -269,7 +269,11 @@ static void xgpu_nv_mailbox_flr_work(struct work_struct *work)
 	}
 
 	/* Trigger recovery for world switch failure if no TDR */
-	if (amdgpu_device_should_recover_gpu(adev))
+	if (amdgpu_device_should_recover_gpu(adev)
+		&& (adev->sdma_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->gfx_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->compute_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->video_timeout == MAX_SCHEDULE_TIMEOUT))
 		amdgpu_device_gpu_recover(adev, NULL);
 }
 
-- 
2.20.1

