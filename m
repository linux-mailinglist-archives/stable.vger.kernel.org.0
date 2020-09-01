Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE88C259430
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgIAPgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbgIAPgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:36:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BAF521534;
        Tue,  1 Sep 2020 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974592;
        bh=qRCS/QLC3FWuoJNnuz3TG5j7m7cgkYxFjClqQS7j5IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkQ4njnyu9tYj6Km+LFze49xs8qH5/qcQzkAksWxTAL47ooBMWXDLp/MBg5P/oVfx
         oegWLE6yVAUZoYkwbGtnmRRP/EvztVp1+rfCBeFiPxz5IJCuee3+zVd11K0lBsSbX7
         +YK59we5Nj+fdQYu8tD1T0HDVGI2LHbLe5t1ois0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 007/255] drm/amdgpu: fix RAS memory leak in error case
Date:   Tue,  1 Sep 2020 17:07:43 +0200
Message-Id: <20200901151001.160468656@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 5e91160ac0b5cfbbaeb62cbff8b069262095f744 ]

RAS context memory needs to freed in failure case.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 50fe08bf2f727..20a7d75b2eb88 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1914,9 +1914,8 @@ int amdgpu_ras_init(struct amdgpu_device *adev)
 	amdgpu_ras_check_supported(adev, &con->hw_supported,
 			&con->supported);
 	if (!con->hw_supported) {
-		amdgpu_ras_set_context(adev, NULL);
-		kfree(con);
-		return 0;
+		r = 0;
+		goto err_out;
 	}
 
 	con->features = 0;
@@ -1927,29 +1926,31 @@ int amdgpu_ras_init(struct amdgpu_device *adev)
 	if (adev->nbio.funcs->init_ras_controller_interrupt) {
 		r = adev->nbio.funcs->init_ras_controller_interrupt(adev);
 		if (r)
-			return r;
+			goto err_out;
 	}
 
 	if (adev->nbio.funcs->init_ras_err_event_athub_interrupt) {
 		r = adev->nbio.funcs->init_ras_err_event_athub_interrupt(adev);
 		if (r)
-			return r;
+			goto err_out;
 	}
 
 	amdgpu_ras_mask &= AMDGPU_RAS_BLOCK_MASK;
 
-	if (amdgpu_ras_fs_init(adev))
-		goto fs_out;
+	if (amdgpu_ras_fs_init(adev)) {
+		r = -EINVAL;
+		goto err_out;
+	}
 
 	dev_info(adev->dev, "RAS INFO: ras initialized successfully, "
 			"hardware ability[%x] ras_mask[%x]\n",
 			con->hw_supported, con->supported);
 	return 0;
-fs_out:
+err_out:
 	amdgpu_ras_set_context(adev, NULL);
 	kfree(con);
 
-	return -EINVAL;
+	return r;
 }
 
 /* helper function to handle common stuff in ip late init phase */
-- 
2.25.1



