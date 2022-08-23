Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D403459D66F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347980AbiHWJIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbiHWJHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:07:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E0861CF;
        Tue, 23 Aug 2022 01:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8113B81C57;
        Tue, 23 Aug 2022 08:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2347DC433B5;
        Tue, 23 Aug 2022 08:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243335;
        bh=HoReviJIiaDBHeMOZIQuLCNx7ec42U1K2fgXMEpQAJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2DlweHaW+6laPOoM5SRVZ4xH8IjS2KR4jVjN/UbHgk/6sez4XrxCeO5S8Y7DaVD+
         78tDeGJKbwQVJTRyaVQcTtbSFN7RWxHRPfmo19kl+f6IFnL+neZsMXFafF45FDNdmO
         dT0A7yQDX+tqYNI5smt2bwNDjGXNSbbXZS9cqa5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 245/365] drm/amdgpu: Avoid another list of reset devices
Date:   Tue, 23 Aug 2022 10:02:26 +0200
Message-Id: <20220823080128.470688262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 0a83bb35d8a6ff3d18c2772afe616780c23293a6 ]

A list of devices to be reset is already created in
amdgpu_device_gpu_recover function. Creating another list with the
same nodes is incorrect and not supported in list_head. Instead, pass
the device list as part of reset context.

Fixes: 9e08564727fc (drm/amdgpu: Refactor mode2 reset logic for v13.0.2)
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aldebaran.c     | 45 +++++++---------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h  |  1 +
 3 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aldebaran.c b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
index c6cc493a5486..2b97b8a96fb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
@@ -148,30 +148,22 @@ aldebaran_mode2_perform_reset(struct amdgpu_reset_control *reset_ctl,
 			      struct amdgpu_reset_context *reset_context)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)reset_ctl->handle;
+	struct list_head *reset_device_list = reset_context->reset_device_list;
 	struct amdgpu_device *tmp_adev = NULL;
-	struct list_head reset_device_list;
 	int r = 0;
 
 	dev_dbg(adev->dev, "aldebaran perform hw reset\n");
+
+	if (reset_device_list == NULL)
+		return -EINVAL;
+
 	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 2) &&
 	    reset_context->hive == NULL) {
 		/* Wrong context, return error */
 		return -EINVAL;
 	}
 
-	INIT_LIST_HEAD(&reset_device_list);
-	if (reset_context->hive) {
-		list_for_each_entry (tmp_adev,
-				     &reset_context->hive->device_list,
-				     gmc.xgmi.head)
-			list_add_tail(&tmp_adev->reset_list,
-				      &reset_device_list);
-	} else {
-		list_add_tail(&reset_context->reset_req_dev->reset_list,
-			      &reset_device_list);
-	}
-
-	list_for_each_entry (tmp_adev, &reset_device_list, reset_list) {
+	list_for_each_entry(tmp_adev, reset_device_list, reset_list) {
 		mutex_lock(&tmp_adev->reset_cntl->reset_lock);
 		tmp_adev->reset_cntl->active_reset = AMD_RESET_METHOD_MODE2;
 	}
@@ -179,7 +171,7 @@ aldebaran_mode2_perform_reset(struct amdgpu_reset_control *reset_ctl,
 	 * Mode2 reset doesn't need any sync between nodes in XGMI hive, instead launch
 	 * them together so that they can be completed asynchronously on multiple nodes
 	 */
-	list_for_each_entry (tmp_adev, &reset_device_list, reset_list) {
+	list_for_each_entry(tmp_adev, reset_device_list, reset_list) {
 		/* For XGMI run all resets in parallel to speed up the process */
 		if (tmp_adev->gmc.xgmi.num_physical_nodes > 1) {
 			if (!queue_work(system_unbound_wq,
@@ -197,7 +189,7 @@ aldebaran_mode2_perform_reset(struct amdgpu_reset_control *reset_ctl,
 
 	/* For XGMI wait for all resets to complete before proceed */
 	if (!r) {
-		list_for_each_entry (tmp_adev, &reset_device_list, reset_list) {
+		list_for_each_entry(tmp_adev, reset_device_list, reset_list) {
 			if (tmp_adev->gmc.xgmi.num_physical_nodes > 1) {
 				flush_work(&tmp_adev->reset_cntl->reset_work);
 				r = tmp_adev->asic_reset_res;
@@ -207,7 +199,7 @@ aldebaran_mode2_perform_reset(struct amdgpu_reset_control *reset_ctl,
 		}
 	}
 
-	list_for_each_entry (tmp_adev, &reset_device_list, reset_list) {
+	list_for_each_entry(tmp_adev, reset_device_list, reset_list) {
 		mutex_unlock(&tmp_adev->reset_cntl->reset_lock);
 		tmp_adev->reset_cntl->active_reset = AMD_RESET_METHOD_NONE;
 	}
@@ -339,10 +331,13 @@ static int
 aldebaran_mode2_restore_hwcontext(struct amdgpu_reset_control *reset_ctl,
 				  struct amdgpu_reset_context *reset_context)
 {
+	struct list_head *reset_device_list = reset_context->reset_device_list;
 	struct amdgpu_device *tmp_adev = NULL;
-	struct list_head reset_device_list;
 	int r;
 
+	if (reset_device_list == NULL)
+		return -EINVAL;
+
 	if (reset_context->reset_req_dev->ip_versions[MP1_HWIP][0] ==
 		    IP_VERSION(13, 0, 2) &&
 	    reset_context->hive == NULL) {
@@ -350,19 +345,7 @@ aldebaran_mode2_restore_hwcontext(struct amdgpu_reset_control *reset_ctl,
 		return -EINVAL;
 	}
 
-	INIT_LIST_HEAD(&reset_device_list);
-	if (reset_context->hive) {
-		list_for_each_entry (tmp_adev,
-				     &reset_context->hive->device_list,
-				     gmc.xgmi.head)
-			list_add_tail(&tmp_adev->reset_list,
-				      &reset_device_list);
-	} else {
-		list_add_tail(&reset_context->reset_req_dev->reset_list,
-			      &reset_device_list);
-	}
-
-	list_for_each_entry (tmp_adev, &reset_device_list, reset_list) {
+	list_for_each_entry(tmp_adev, reset_device_list, reset_list) {
 		dev_info(tmp_adev->dev,
 			 "GPU reset succeeded, trying to resume\n");
 		r = aldebaran_mode2_restore_ip(tmp_adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 58df107e3beb..3adebb63680e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4746,6 +4746,8 @@ int amdgpu_do_asic_reset(struct list_head *device_list_handle,
 	tmp_adev = list_first_entry(device_list_handle, struct amdgpu_device,
 				    reset_list);
 	amdgpu_reset_reg_dumps(tmp_adev);
+
+	reset_context->reset_device_list = device_list_handle;
 	r = amdgpu_reset_perform_reset(tmp_adev, reset_context);
 	/* If reset handler not implemented, continue; otherwise return */
 	if (r == -ENOSYS)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
index 1949dbe28a86..0c3ad85d84a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
@@ -37,6 +37,7 @@ struct amdgpu_reset_context {
 	struct amdgpu_device *reset_req_dev;
 	struct amdgpu_job *job;
 	struct amdgpu_hive_info *hive;
+	struct list_head *reset_device_list;
 	unsigned long flags;
 };
 
-- 
2.35.1



