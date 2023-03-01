Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2E6A7325
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCASNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjCASNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E42722
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928FEB810D2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09364C4339C;
        Wed,  1 Mar 2023 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694384;
        bh=UyE4sKSUMsJrrp3NWGbH3crkdho961pU+IqgYjZ0yrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6m/hyvvpvqIsPjNE5YOGlg032hQwnRJMph3NcWjOmCtBoPZnYlbHssQA6TaB5Np1
         ZjMz20qCizoN3DMgunst/KGVZNlt3E8PGEwpuvDSO5T0QYbMukn4p70UlzxWq9DvLP
         W/iUYpVTWmPn/HA+0Lo579wTh5PGA4sdmrerG2UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.1 29/42] drm/amd/display: Fix race condition in DPIA AUX transfer
Date:   Wed,  1 Mar 2023 19:08:50 +0100
Message-Id: <20230301180658.363778517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit ead08b95fa50f40618c72b93a849c4ae30c9cd50 upstream.

[Why]
This fix was intended for improving on coding style but in the process
uncovers a race condition, which explains why we are getting incorrect
length in DPIA AUX replies. Due to the call path of DPIA AUX going from
DC back to DM layer then again into DC and the added complexities on top
of current DC AUX implementation, a proper fix to rely on current dc_lock
to address the race condition is difficult without a major overhual
on how DPIA AUX is implemented.

[How]
- Add a mutex dpia_aux_lock to protect DPIA AUX transfers
- Remove DMUB_ASYNC_TO_SYNC_ACCESS_* codes and rely solely on
  aux_return_code_type for error reporting and handling
- Separate SET_CONFIG from DPIA AUX transfer because they have quiet
  different processing logic
- Remove unnecessary type casting to and from void * type

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |  147 ++++++--------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h         |   17 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   10 
 3 files changed, 89 insertions(+), 85 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -147,14 +147,6 @@ MODULE_FIRMWARE(FIRMWARE_NAVI12_DMCU);
 /* Number of bytes in PSP footer for firmware. */
 #define PSP_FOOTER_BYTES 0x100
 
-/*
- * DMUB Async to Sync Mechanism Status
- */
-#define DMUB_ASYNC_TO_SYNC_ACCESS_FAIL 1
-#define DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT 2
-#define DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS 3
-#define DMUB_ASYNC_TO_SYNC_ACCESS_INVALID 4
-
 /**
  * DOC: overview
  *
@@ -1456,6 +1448,7 @@ static int amdgpu_dm_init(struct amdgpu_
 	memset(&init_params, 0, sizeof(init_params));
 #endif
 
+	mutex_init(&adev->dm.dpia_aux_lock);
 	mutex_init(&adev->dm.dc_lock);
 	mutex_init(&adev->dm.audio_lock);
 	spin_lock_init(&adev->dm.vblank_lock);
@@ -1814,6 +1807,7 @@ static void amdgpu_dm_fini(struct amdgpu
 
 	mutex_destroy(&adev->dm.audio_lock);
 	mutex_destroy(&adev->dm.dc_lock);
+	mutex_destroy(&adev->dm.dpia_aux_lock);
 
 	return;
 }
@@ -10198,91 +10192,92 @@ uint32_t dm_read_reg_func(const struct d
 	return value;
 }
 
-static int amdgpu_dm_set_dmub_async_sync_status(bool is_cmd_aux,
-						struct dc_context *ctx,
-						uint8_t status_type,
-						uint32_t *operation_result)
+int amdgpu_dm_process_dmub_aux_transfer_sync(
+		struct dc_context *ctx,
+		unsigned int link_index,
+		struct aux_payload *payload,
+		enum aux_return_code_type *operation_result)
 {
 	struct amdgpu_device *adev = ctx->driver_context;
-	int return_status = -1;
 	struct dmub_notification *p_notify = adev->dm.dmub_notify;
+	int ret = -1;
 
-	if (is_cmd_aux) {
-		if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS) {
-			return_status = p_notify->aux_reply.length;
-			*operation_result = p_notify->result;
-		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT) {
-			*operation_result = AUX_RET_ERROR_TIMEOUT;
-		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_FAIL) {
-			*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
-		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_INVALID) {
-			*operation_result = AUX_RET_ERROR_INVALID_REPLY;
-		} else {
-			*operation_result = AUX_RET_ERROR_UNKNOWN;
+	mutex_lock(&adev->dm.dpia_aux_lock);
+	if (!dc_process_dmub_aux_transfer_async(ctx->dc, link_index, payload)) {
+		*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
+		goto out;
+ 	}
+
+	if (!wait_for_completion_timeout(&adev->dm.dmub_aux_transfer_done, 10 * HZ)) {
+		DRM_ERROR("wait_for_completion_timeout timeout!");
+		*operation_result = AUX_RET_ERROR_TIMEOUT;
+		goto out;
+	}
+
+	if (p_notify->result != AUX_RET_SUCCESS) {
+		/*
+		 * Transient states before tunneling is enabled could
+		 * lead to this error. We can ignore this for now.
+		 */
+		if (p_notify->result != AUX_RET_ERROR_PROTOCOL_ERROR) {
+			DRM_WARN("DPIA AUX failed on 0x%x(%d), error %d\n",
+					payload->address, payload->length,
+					p_notify->result);
 		}
-	} else {
-		if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS) {
-			return_status = 0;
-			*operation_result = p_notify->sc_status;
-		} else {
-			*operation_result = SET_CONFIG_UNKNOWN_ERROR;
+		*operation_result = AUX_RET_ERROR_INVALID_REPLY;
+		goto out;
+	}
+
+
+	payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
+	if (!payload->write && p_notify->aux_reply.length &&
+			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK)) {
+
+		if (payload->length != p_notify->aux_reply.length) {
+			DRM_WARN("invalid read length %d from DPIA AUX 0x%x(%d)!\n",
+				p_notify->aux_reply.length,
+					payload->address, payload->length);
+			*operation_result = AUX_RET_ERROR_INVALID_REPLY;
+			goto out;
 		}
+
+		memcpy(payload->data, p_notify->aux_reply.data,
+				p_notify->aux_reply.length);
 	}
 
-	return return_status;
+	/* success */
+	ret = p_notify->aux_reply.length;
+	*operation_result = p_notify->result;
+out:
+	mutex_unlock(&adev->dm.dpia_aux_lock);
+	return ret;
 }
 
-int amdgpu_dm_process_dmub_aux_transfer_sync(bool is_cmd_aux, struct dc_context *ctx,
-	unsigned int link_index, void *cmd_payload, void *operation_result)
+int amdgpu_dm_process_dmub_set_config_sync(
+		struct dc_context *ctx,
+		unsigned int link_index,
+		struct set_config_cmd_payload *payload,
+		enum set_config_status *operation_result)
 {
 	struct amdgpu_device *adev = ctx->driver_context;
-	int ret = 0;
+	bool is_cmd_complete;
+	int ret;
 
-	if (is_cmd_aux) {
-		dc_process_dmub_aux_transfer_async(ctx->dc,
-			link_index, (struct aux_payload *)cmd_payload);
-	} else if (dc_process_dmub_set_config_async(ctx->dc, link_index,
-					(struct set_config_cmd_payload *)cmd_payload,
-					adev->dm.dmub_notify)) {
-		return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux,
-					ctx, DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS,
-					(uint32_t *)operation_result);
-	}
+	mutex_lock(&adev->dm.dpia_aux_lock);
+	is_cmd_complete = dc_process_dmub_set_config_async(ctx->dc,
+			link_index, payload, adev->dm.dmub_notify);
 
-	ret = wait_for_completion_timeout(&adev->dm.dmub_aux_transfer_done, 10 * HZ);
-	if (ret == 0) {
+	if (is_cmd_complete || wait_for_completion_timeout(&adev->dm.dmub_aux_transfer_done, 10 * HZ)) {
+		ret = 0;
+		*operation_result = adev->dm.dmub_notify->sc_status;
+	} else {
 		DRM_ERROR("wait_for_completion_timeout timeout!");
-		return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux,
-				ctx, DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT,
-				(uint32_t *)operation_result);
-	}
-
-	if (is_cmd_aux) {
-		if (adev->dm.dmub_notify->result == AUX_RET_SUCCESS) {
-			struct aux_payload *payload = (struct aux_payload *)cmd_payload;
-
-			payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
-			if (!payload->write && adev->dm.dmub_notify->aux_reply.length &&
-			    payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK) {
-
-				if (payload->length != adev->dm.dmub_notify->aux_reply.length) {
-					DRM_WARN("invalid read from DPIA AUX %x(%d) got length %d!\n",
-							payload->address, payload->length,
-							adev->dm.dmub_notify->aux_reply.length);
-					return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux, ctx,
-							DMUB_ASYNC_TO_SYNC_ACCESS_INVALID,
-							(uint32_t *)operation_result);
-				}
-
-				memcpy(payload->data, adev->dm.dmub_notify->aux_reply.data,
-				       adev->dm.dmub_notify->aux_reply.length);
-			}
-		}
+		ret = -1;
+		*operation_result = SET_CONFIG_UNKNOWN_ERROR;
 	}
 
-	return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux,
-			ctx, DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS,
-			(uint32_t *)operation_result);
+	mutex_unlock(&adev->dm.dpia_aux_lock);
+	return ret;
 }
 
 /*
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -59,7 +59,9 @@
 #include "signal_types.h"
 #include "amdgpu_dm_crc.h"
 struct aux_payload;
+struct set_config_cmd_payload;
 enum aux_return_code_type;
+enum set_config_status;
 
 /* Forward declarations */
 struct amdgpu_device;
@@ -549,6 +551,13 @@ struct amdgpu_display_manager {
 	 * occurred on certain intel platform
 	 */
 	bool aux_hpd_discon_quirk;
+
+	/**
+	 * @dpia_aux_lock:
+	 *
+	 * Guards access to DPIA AUX
+	 */
+	struct mutex dpia_aux_lock;
 };
 
 enum dsc_clock_force_state {
@@ -792,9 +801,11 @@ void amdgpu_dm_update_connector_after_de
 
 extern const struct drm_encoder_helper_funcs amdgpu_dm_encoder_helper_funcs;
 
-int amdgpu_dm_process_dmub_aux_transfer_sync(bool is_cmd_aux,
-					struct dc_context *ctx, unsigned int link_index,
-					void *payload, void *operation_result);
+int amdgpu_dm_process_dmub_aux_transfer_sync(struct dc_context *ctx, unsigned int link_index,
+					struct aux_payload *payload, enum aux_return_code_type *operation_result);
+
+int amdgpu_dm_process_dmub_set_config_sync(struct dc_context *ctx, unsigned int link_index,
+					struct set_config_cmd_payload *payload, enum set_config_status *operation_result);
 
 bool check_seamless_boot_capability(struct amdgpu_device *adev);
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -844,9 +844,8 @@ int dm_helper_dmub_aux_transfer_sync(
 		struct aux_payload *payload,
 		enum aux_return_code_type *operation_result)
 {
-	return amdgpu_dm_process_dmub_aux_transfer_sync(true, ctx,
-			link->link_index, (void *)payload,
-			(void *)operation_result);
+	return amdgpu_dm_process_dmub_aux_transfer_sync(ctx, link->link_index, payload,
+			operation_result);
 }
 
 int dm_helpers_dmub_set_config_sync(struct dc_context *ctx,
@@ -854,9 +853,8 @@ int dm_helpers_dmub_set_config_sync(stru
 		struct set_config_cmd_payload *payload,
 		enum set_config_status *operation_result)
 {
-	return amdgpu_dm_process_dmub_aux_transfer_sync(false, ctx,
-			link->link_index, (void *)payload,
-			(void *)operation_result);
+	return amdgpu_dm_process_dmub_set_config_sync(ctx, link->link_index, payload,
+			operation_result);
 }
 
 void dm_set_dcn_clocks(struct dc_context *ctx, struct dc_clocks *clks)


