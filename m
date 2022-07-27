Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A0A582E24
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbiG0RIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiG0RHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A791E3CA;
        Wed, 27 Jul 2022 09:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F6B4B821A6;
        Wed, 27 Jul 2022 16:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7426BC433D6;
        Wed, 27 Jul 2022 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940012;
        bh=+h+gwRdGWwGx5T79uwU2v5LX43yylfttSA57ZGp5D9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amaD8GjqMhQXKVxa0WssXNb0Gru+crOHDoTfscdGcw0ut0PC8MUSRj73uMpJA5Yba
         oqL0fGKko+yC0/+AlTkXYueORkVlOSrkGHm3jplzfNpmsb9bV5qVwydkusbI6/F0/T
         MzMMq4Sv02Nri2h2rqPqWTWihI8NQVdjp+ewfh9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/201] drm/amd/display: Fork thread to offload work of hpd_rx_irq
Date:   Wed, 27 Jul 2022 18:09:08 +0200
Message-Id: <20220727161028.712609252@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 8e794421bc981586d0af4e959ec76d668c793a55 ]

[Why]
Currently, we will try to get dm.dc_lock in handle_hpd_rx_irq() when
link lost happened, which is risky and could cause deadlock.
e.g. If we are under procedure to enable MST streams and then monitor
happens to toggle short hpd to notify link lost, then
handle_hpd_rx_irq() will get blocked due to stream enabling flow has
dc_lock. However, under MST, enabling streams involves communication
with remote sinks which need to use handle_hpd_rx_irq() to handle
sideband messages. Thus, we have deadlock here.

[How]
Target is to have handle_hpd_rx_irq() finished as soon as possilble.
Hence we can react to interrupt quickly. Besides, we should avoid to
grabe dm.dc_lock within handle_hpd_rx_irq() to avoid deadlock situation.

Firstly, revert patches which introduced to use dm.dc_lock in
handle_hpd_rx_irq():

* commit ("drm/amd/display: NULL pointer error during ")

* commit ("drm/amd/display: Only one display lights up while using MST")

* commit ("drm/amd/display: take dc_lock in short pulse handler only")

Instead, create work to handle irq events which needs dm.dc_lock.
Besides:

* Create struct hpd_rx_irq_offload_work_queue for each link to handle
  its short hpd events

* Avoid to handle link lost/ automated test if the link is disconnected

* Defer dc_lock needed works in dc_link_handle_hpd_rx_irq(). This
  function should just handle simple stuff for us (e.g. DPCD R/W).
  However, deferred works should still be handled by the order that
  dc_link_handle_hpd_rx_irq() used to be.

* Change function name dm_handle_hpd_rx_irq() to
  dm_handle_mst_sideband_msg() to be more specific

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 203 ++++++++++++++----
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  49 ++++-
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  |   9 +-
 drivers/gpu/drm/amd/display/dc/dc_link.h      |   6 +-
 4 files changed, 219 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 19048f0d83a4..ce647302a1ec 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1236,6 +1236,83 @@ static void vblank_control_worker(struct work_struct *work)
 }
 
 #endif
+
+static void dm_handle_hpd_rx_offload_work(struct work_struct *work)
+{
+	struct hpd_rx_irq_offload_work *offload_work;
+	struct amdgpu_dm_connector *aconnector;
+	struct dc_link *dc_link;
+	struct amdgpu_device *adev;
+	enum dc_connection_type new_connection_type = dc_connection_none;
+	unsigned long flags;
+
+	offload_work = container_of(work, struct hpd_rx_irq_offload_work, work);
+	aconnector = offload_work->offload_wq->aconnector;
+
+	if (!aconnector) {
+		DRM_ERROR("Can't retrieve aconnector in hpd_rx_irq_offload_work");
+		goto skip;
+	}
+
+	adev = drm_to_adev(aconnector->base.dev);
+	dc_link = aconnector->dc_link;
+
+	mutex_lock(&aconnector->hpd_lock);
+	if (!dc_link_detect_sink(dc_link, &new_connection_type))
+		DRM_ERROR("KMS: Failed to detect connector\n");
+	mutex_unlock(&aconnector->hpd_lock);
+
+	if (new_connection_type == dc_connection_none)
+		goto skip;
+
+	if (amdgpu_in_reset(adev))
+		goto skip;
+
+	mutex_lock(&adev->dm.dc_lock);
+	if (offload_work->data.bytes.device_service_irq.bits.AUTOMATED_TEST)
+		dc_link_dp_handle_automated_test(dc_link);
+	else if ((dc_link->connector_signal != SIGNAL_TYPE_EDP) &&
+			hpd_rx_irq_check_link_loss_status(dc_link, &offload_work->data) &&
+			dc_link_dp_allow_hpd_rx_irq(dc_link)) {
+		dc_link_dp_handle_link_loss(dc_link);
+		spin_lock_irqsave(&offload_work->offload_wq->offload_lock, flags);
+		offload_work->offload_wq->is_handling_link_loss = false;
+		spin_unlock_irqrestore(&offload_work->offload_wq->offload_lock, flags);
+	}
+	mutex_unlock(&adev->dm.dc_lock);
+
+skip:
+	kfree(offload_work);
+
+}
+
+static struct hpd_rx_irq_offload_work_queue *hpd_rx_irq_create_workqueue(struct dc *dc)
+{
+	int max_caps = dc->caps.max_links;
+	int i = 0;
+	struct hpd_rx_irq_offload_work_queue *hpd_rx_offload_wq = NULL;
+
+	hpd_rx_offload_wq = kcalloc(max_caps, sizeof(*hpd_rx_offload_wq), GFP_KERNEL);
+
+	if (!hpd_rx_offload_wq)
+		return NULL;
+
+
+	for (i = 0; i < max_caps; i++) {
+		hpd_rx_offload_wq[i].wq =
+				    create_singlethread_workqueue("amdgpu_dm_hpd_rx_offload_wq");
+
+		if (hpd_rx_offload_wq[i].wq == NULL) {
+			DRM_ERROR("create amdgpu_dm_hpd_rx_offload_wq fail!");
+			return NULL;
+		}
+
+		spin_lock_init(&hpd_rx_offload_wq[i].offload_lock);
+	}
+
+	return hpd_rx_offload_wq;
+}
+
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -1362,6 +1439,12 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	dc_hardware_init(adev->dm.dc);
 
+	adev->dm.hpd_rx_offload_wq = hpd_rx_irq_create_workqueue(adev->dm.dc);
+	if (!adev->dm.hpd_rx_offload_wq) {
+		DRM_ERROR("amdgpu: failed to create hpd rx offload workqueue.\n");
+		goto error;
+	}
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	if ((adev->flags & AMD_IS_APU) && (adev->asic_type >= CHIP_CARRIZO)) {
 		struct dc_phy_addr_space_config pa_config;
@@ -1541,6 +1624,18 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		adev->dm.freesync_module = NULL;
 	}
 
+	if (adev->dm.hpd_rx_offload_wq) {
+		for (i = 0; i < adev->dm.dc->caps.max_links; i++) {
+			if (adev->dm.hpd_rx_offload_wq[i].wq) {
+				destroy_workqueue(adev->dm.hpd_rx_offload_wq[i].wq);
+				adev->dm.hpd_rx_offload_wq[i].wq = NULL;
+			}
+		}
+
+		kfree(adev->dm.hpd_rx_offload_wq);
+		adev->dm.hpd_rx_offload_wq = NULL;
+	}
+
 	mutex_destroy(&adev->dm.audio_lock);
 	mutex_destroy(&adev->dm.dc_lock);
 
@@ -2160,6 +2255,16 @@ static enum dc_status amdgpu_dm_commit_zero_streams(struct dc *dc)
 	return res;
 }
 
+static void hpd_rx_irq_work_suspend(struct amdgpu_display_manager *dm)
+{
+	int i;
+
+	if (dm->hpd_rx_offload_wq) {
+		for (i = 0; i < dm->dc->caps.max_links; i++)
+			flush_workqueue(dm->hpd_rx_offload_wq[i].wq);
+	}
+}
+
 static int dm_suspend(void *handle)
 {
 	struct amdgpu_device *adev = handle;
@@ -2181,6 +2286,8 @@ static int dm_suspend(void *handle)
 
 		amdgpu_dm_irq_suspend(adev);
 
+		hpd_rx_irq_work_suspend(dm);
+
 		return ret;
 	}
 
@@ -2191,6 +2298,8 @@ static int dm_suspend(void *handle)
 
 	amdgpu_dm_irq_suspend(adev);
 
+	hpd_rx_irq_work_suspend(dm);
+
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;
@@ -2869,8 +2978,7 @@ static void handle_hpd_irq(void *param)
 
 }
 
-
-static void dm_handle_hpd_rx_irq(struct amdgpu_dm_connector *aconnector)
+static void dm_handle_mst_sideband_msg(struct amdgpu_dm_connector *aconnector)
 {
 	uint8_t esi[DP_PSR_ERROR_STATUS - DP_SINK_COUNT_ESI] = { 0 };
 	uint8_t dret;
@@ -2948,6 +3056,25 @@ static void dm_handle_hpd_rx_irq(struct amdgpu_dm_connector *aconnector)
 		DRM_DEBUG_DRIVER("Loop exceeded max iterations\n");
 }
 
+static void schedule_hpd_rx_offload_work(struct hpd_rx_irq_offload_work_queue *offload_wq,
+							union hpd_irq_data hpd_irq_data)
+{
+	struct hpd_rx_irq_offload_work *offload_work =
+				kzalloc(sizeof(*offload_work), GFP_KERNEL);
+
+	if (!offload_work) {
+		DRM_ERROR("Failed to allocate hpd_rx_irq_offload_work.\n");
+		return;
+	}
+
+	INIT_WORK(&offload_work->work, dm_handle_hpd_rx_offload_work);
+	offload_work->data = hpd_irq_data;
+	offload_work->offload_wq = offload_wq;
+
+	queue_work(offload_wq->wq, &offload_work->work);
+	DRM_DEBUG_KMS("queue work to handle hpd_rx offload work");
+}
+
 static void handle_hpd_rx_irq(void *param)
 {
 	struct amdgpu_dm_connector *aconnector = (struct amdgpu_dm_connector *)param;
@@ -2959,14 +3086,16 @@ static void handle_hpd_rx_irq(void *param)
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	union hpd_irq_data hpd_irq_data;
-	bool lock_flag = 0;
+	bool link_loss = false;
+	bool has_left_work = false;
+	int idx = aconnector->base.index;
+	struct hpd_rx_irq_offload_work_queue *offload_wq = &adev->dm.hpd_rx_offload_wq[idx];
 
 	memset(&hpd_irq_data, 0, sizeof(hpd_irq_data));
 
 	if (adev->dm.disable_hpd_irq)
 		return;
 
-
 	/*
 	 * TODO:Temporary add mutex to protect hpd interrupt not have a gpio
 	 * conflict, after implement i2c helper, this mutex should be
@@ -2974,43 +3103,41 @@ static void handle_hpd_rx_irq(void *param)
 	 */
 	mutex_lock(&aconnector->hpd_lock);
 
-	read_hpd_rx_irq_data(dc_link, &hpd_irq_data);
+	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data,
+						&link_loss, true, &has_left_work);
 
-	if ((dc_link->cur_link_settings.lane_count != LANE_COUNT_UNKNOWN) ||
-		(dc_link->type == dc_connection_mst_branch)) {
-		if (hpd_irq_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY) {
-			result = true;
-			dm_handle_hpd_rx_irq(aconnector);
-			goto out;
-		} else if (hpd_irq_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
-			result = false;
-			dm_handle_hpd_rx_irq(aconnector);
+	if (!has_left_work)
+		goto out;
+
+	if (hpd_irq_data.bytes.device_service_irq.bits.AUTOMATED_TEST) {
+		schedule_hpd_rx_offload_work(offload_wq, hpd_irq_data);
+		goto out;
+	}
+
+	if (dc_link_dp_allow_hpd_rx_irq(dc_link)) {
+		if (hpd_irq_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY ||
+			hpd_irq_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
+			dm_handle_mst_sideband_msg(aconnector);
 			goto out;
 		}
-	}
 
-	/*
-	 * TODO: We need the lock to avoid touching DC state while it's being
-	 * modified during automated compliance testing, or when link loss
-	 * happens. While this should be split into subhandlers and proper
-	 * interfaces to avoid having to conditionally lock like this in the
-	 * outer layer, we need this workaround temporarily to allow MST
-	 * lightup in some scenarios to avoid timeout.
-	 */
-	if (!amdgpu_in_reset(adev) &&
-	    (hpd_rx_irq_check_link_loss_status(dc_link, &hpd_irq_data) ||
-	     hpd_irq_data.bytes.device_service_irq.bits.AUTOMATED_TEST)) {
-		mutex_lock(&adev->dm.dc_lock);
-		lock_flag = 1;
-	}
+		if (link_loss) {
+			bool skip = false;
 
-#ifdef CONFIG_DRM_AMD_DC_HDCP
-	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
-#else
-	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
-#endif
-	if (!amdgpu_in_reset(adev) && lock_flag)
-		mutex_unlock(&adev->dm.dc_lock);
+			spin_lock(&offload_wq->offload_lock);
+			skip = offload_wq->is_handling_link_loss;
+
+			if (!skip)
+				offload_wq->is_handling_link_loss = true;
+
+			spin_unlock(&offload_wq->offload_lock);
+
+			if (!skip)
+				schedule_hpd_rx_offload_work(offload_wq, hpd_irq_data);
+
+			goto out;
+		}
+	}
 
 out:
 	if (result && !is_mst_root_connector) {
@@ -3095,6 +3222,10 @@ static void register_hpd_handlers(struct amdgpu_device *adev)
 			amdgpu_dm_irq_register_interrupt(adev, &int_params,
 					handle_hpd_rx_irq,
 					(void *) aconnector);
+
+			if (adev->dm.hpd_rx_offload_wq)
+				adev->dm.hpd_rx_offload_wq[connector->index].aconnector =
+					aconnector;
 		}
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index da87ca77023d..cd059af033b4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -171,6 +171,48 @@ struct dal_allocation {
 	u64 gpu_addr;
 };
 
+/**
+ * struct hpd_rx_irq_offload_work_queue - Work queue to handle hpd_rx_irq
+ * offload work
+ */
+struct hpd_rx_irq_offload_work_queue {
+	/**
+	 * @wq: workqueue structure to queue offload work.
+	 */
+	struct workqueue_struct *wq;
+	/**
+	 * @offload_lock: To protect fields of offload work queue.
+	 */
+	spinlock_t offload_lock;
+	/**
+	 * @is_handling_link_loss: Used to prevent inserting link loss event when
+	 * we're handling link loss
+	 */
+	bool is_handling_link_loss;
+	/**
+	 * @aconnector: The aconnector that this work queue is attached to
+	 */
+	struct amdgpu_dm_connector *aconnector;
+};
+
+/**
+ * struct hpd_rx_irq_offload_work - hpd_rx_irq offload work structure
+ */
+struct hpd_rx_irq_offload_work {
+	/**
+	 * @work: offload work
+	 */
+	struct work_struct work;
+	/**
+	 * @data: reference irq data which is used while handling offload work
+	 */
+	union hpd_irq_data data;
+	/**
+	 * @offload_wq: offload work queue that this work is queued to
+	 */
+	struct hpd_rx_irq_offload_work_queue *offload_wq;
+};
+
 /**
  * struct amdgpu_display_manager - Central amdgpu display manager device
  *
@@ -461,7 +503,12 @@ struct amdgpu_display_manager {
 	 */
 	struct crc_rd_work *crc_rd_wrk;
 #endif
-
+	/**
+	 * @hpd_rx_offload_wq:
+	 *
+	 * Work queue to offload works of hpd_rx_irq
+	 */
+	struct hpd_rx_irq_offload_work_queue *hpd_rx_offload_wq;
 	/**
 	 * @mst_encoders:
 	 *
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 9b6111eb9ca4..6d5dc5ab3d8c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2075,7 +2075,7 @@ static struct dc_link_settings get_max_link_cap(struct dc_link *link)
 	return max_link_cap;
 }
 
-enum dc_status read_hpd_rx_irq_data(
+static enum dc_status read_hpd_rx_irq_data(
 	struct dc_link *link,
 	union hpd_irq_data *irq_data)
 {
@@ -3257,7 +3257,7 @@ void dc_link_dp_handle_link_loss(struct dc_link *link)
 	}
 }
 
-static bool handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss,
+bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss,
 							bool defer_handling, bool *has_left_work)
 {
 	union hpd_irq_data hpd_irq_dpcd_data = { { { {0} } } };
@@ -3379,11 +3379,6 @@ static bool handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_
 	return status;
 }
 
-bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss)
-{
-	return handle_hpd_rx_irq(link, out_hpd_irq_dpcd_data, out_link_loss, false, NULL);
-}
-
 /*query dpcd for version and mst cap addresses*/
 bool is_mst_supported(struct dc_link *link)
 {
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index 0efa2bc8639b..9b7c32f7fd86 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -296,7 +296,8 @@ enum dc_status dc_link_allocate_mst_payload(struct pipe_ctx *pipe_ctx);
  * false - no change in Downstream port status. No further action required
  * from DM. */
 bool dc_link_handle_hpd_rx_irq(struct dc_link *dc_link,
-		union hpd_irq_data *hpd_irq_dpcd_data, bool *out_link_loss);
+		union hpd_irq_data *hpd_irq_dpcd_data, bool *out_link_loss,
+		bool defer_handling, bool *has_left_work);
 
 /*
  * On eDP links this function call will stall until T12 has elapsed.
@@ -305,9 +306,6 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *dc_link,
  */
 bool dc_link_wait_for_t12(struct dc_link *link);
 
-enum dc_status read_hpd_rx_irq_data(
-	struct dc_link *link,
-	union hpd_irq_data *irq_data);
 void dc_link_dp_handle_automated_test(struct dc_link *link);
 void dc_link_dp_handle_link_loss(struct dc_link *link);
 bool dc_link_dp_allow_hpd_rx_irq(const struct dc_link *link);
-- 
2.35.1



