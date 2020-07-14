Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688CA21FB29
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgGNS7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730705AbgGNS7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA8222507;
        Tue, 14 Jul 2020 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753160;
        bh=PPHhOefhquj0kG2S3xsqFhi0SGzY5jt59PIVciQXpo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcT4iwttNPusNriCM73YyTpv/TkvIDphEb919pj3gZ1DMiYwUsTfUHeooeYY7jB6a
         HD8yKwAVzBVbDfDzFMb9EKRPVBjqwed91L6CLAJHiugce/t4ZsgUn76BEwYykJa+zs
         +n8ih3ICHqFcp+F1QGvUW1NhqtNQ7kI4fpogbAgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 142/166] drm/amdgpu: add TMR destory function for psp
Date:   Tue, 14 Jul 2020 20:45:07 +0200
Message-Id: <20200714184122.623525965@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

commit c564b8601ae917086751d90f464d5f19d731ece7 upstream.

TMR is required to be destoried with GFX_CMD_ID_DESTROY_TMR while the
system goes to suspend. Otherwise, PSP may return the failure state
(0xFFFF007) on Gfx-2-PSP command GFX_CMD_ID_SETUP_TMR after do multiple
times suspend/resume.

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |   57 +++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -370,6 +370,52 @@ static int psp_tmr_load(struct psp_conte
 	return ret;
 }
 
+static void psp_prep_tmr_unload_cmd_buf(struct psp_context *psp,
+					struct psp_gfx_cmd_resp *cmd)
+{
+	if (amdgpu_sriov_vf(psp->adev))
+		cmd->cmd_id = GFX_CMD_ID_DESTROY_VMR;
+	else
+		cmd->cmd_id = GFX_CMD_ID_DESTROY_TMR;
+}
+
+static int psp_tmr_unload(struct psp_context *psp)
+{
+	int ret;
+	struct psp_gfx_cmd_resp *cmd;
+
+	cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	psp_prep_tmr_unload_cmd_buf(psp, cmd);
+	DRM_INFO("free PSP TMR buffer\n");
+
+	ret = psp_cmd_submit_buf(psp, NULL, cmd,
+				 psp->fence_buf_mc_addr);
+
+	kfree(cmd);
+
+	return ret;
+}
+
+static int psp_tmr_terminate(struct psp_context *psp)
+{
+	int ret;
+	void *tmr_buf;
+	void **pptr;
+
+	ret = psp_tmr_unload(psp);
+	if (ret)
+		return ret;
+
+	/* free TMR memory buffer */
+	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
+	amdgpu_bo_free_kernel(&psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+
+	return 0;
+}
+
 static void psp_prep_asd_load_cmd_buf(struct psp_gfx_cmd_resp *cmd,
 				uint64_t asd_mc, uint32_t size)
 {
@@ -1575,8 +1621,6 @@ static int psp_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-	void *tmr_buf;
-	void **pptr;
 
 	if (psp->adev->psp.ta_fw) {
 		psp_ras_terminate(psp);
@@ -1586,10 +1630,9 @@ static int psp_hw_fini(void *handle)
 
 	psp_asd_unload(psp);
 
+	psp_tmr_terminate(psp);
 	psp_ring_destroy(psp, PSP_RING_TYPE__KM);
 
-	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
-	amdgpu_bo_free_kernel(&psp->tmr_bo, &psp->tmr_mc_addr, pptr);
 	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
 			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
 	amdgpu_bo_free_kernel(&psp->fence_buf_bo,
@@ -1636,6 +1679,12 @@ static int psp_suspend(void *handle)
 		}
 	}
 
+	ret = psp_tmr_terminate(psp);
+	if (ret) {
+		DRM_ERROR("Falied to terminate tmr\n");
+		return ret;
+	}
+
 	ret = psp_ring_stop(psp, PSP_RING_TYPE__KM);
 	if (ret) {
 		DRM_ERROR("PSP ring stop failed\n");


