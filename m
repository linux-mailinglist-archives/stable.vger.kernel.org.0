Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B5D635889
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbiKWJ7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbiKWJ6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:58:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CACE5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC12061B91
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD18BC433C1;
        Wed, 23 Nov 2022 09:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197156;
        bh=nwTYIszFR2D1cDmsmVWigrCJQ1xZTYGonN92I/EoYoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ldm8oVnx0ZSjUce/xzdSuPJEen/FZMadZ1VI8JiToDXW+vY0ZZ2nbtElNbSK8aWuT
         ZBHBhPc0MAPusc2THsiiGjBGDKSSyuJXyHPHuX6QPCYbzAXC2qeTcDwkuWbvMruCgO
         BIeX+8bT/qfS7MaHCyJTm3P2AlGsmw5SzDIa7+m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roman Li <Roman.Li@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 214/314] drm/amd/display: Fix invalid DPIA AUX reply causing system hang
Date:   Wed, 23 Nov 2022 09:50:59 +0100
Message-Id: <20221123084635.233993662@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 8d8494c3467d366eb0f7c8198dab80be8bdc47d2 upstream.

[Why]
Some DPIA AUX replies have incorrect data length from original request.
This could lead to overwriting of destination buffer if reply length is
larger, which could cause invalid access to stack since many destination
buffers are declared as local variables.

[How]
Check for invalid length from DPIA AUX replies and trigger a retry if
reply length is not the same as original request. A DRM_WARN() dmesg log
is also produced.

Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   20 ++++++++++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    6 ------
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -146,6 +146,14 @@ MODULE_FIRMWARE(FIRMWARE_NAVI12_DMCU);
 /* Number of bytes in PSP footer for firmware. */
 #define PSP_FOOTER_BYTES 0x100
 
+/*
+ * DMUB Async to Sync Mechanism Status
+ */
+#define DMUB_ASYNC_TO_SYNC_ACCESS_FAIL 1
+#define DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT 2
+#define DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS 3
+#define DMUB_ASYNC_TO_SYNC_ACCESS_INVALID 4
+
 /**
  * DOC: overview
  *
@@ -10149,6 +10157,8 @@ static int amdgpu_dm_set_dmub_async_sync
 			*operation_result = AUX_RET_ERROR_TIMEOUT;
 		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_FAIL) {
 			*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
+		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_INVALID) {
+			*operation_result = AUX_RET_ERROR_INVALID_REPLY;
 		} else {
 			*operation_result = AUX_RET_ERROR_UNKNOWN;
 		}
@@ -10196,6 +10206,16 @@ int amdgpu_dm_process_dmub_aux_transfer_
 			payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
 			if (!payload->write && adev->dm.dmub_notify->aux_reply.length &&
 			    payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK) {
+
+				if (payload->length != adev->dm.dmub_notify->aux_reply.length) {
+					DRM_WARN("invalid read from DPIA AUX %x(%d) got length %d!\n",
+							payload->address, payload->length,
+							adev->dm.dmub_notify->aux_reply.length);
+					return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux, ctx,
+							DMUB_ASYNC_TO_SYNC_ACCESS_INVALID,
+							(uint32_t *)operation_result);
+				}
+
 				memcpy(payload->data, adev->dm.dmub_notify->aux_reply.data,
 				       adev->dm.dmub_notify->aux_reply.length);
 			}
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -51,12 +51,6 @@
 #define AMDGPU_DMUB_NOTIFICATION_MAX 5
 
 /*
- * DMUB Async to Sync Mechanism Status
- */
-#define DMUB_ASYNC_TO_SYNC_ACCESS_FAIL 1
-#define DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT 2
-#define DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS 3
-/*
 #include "include/amdgpu_dal_power_if.h"
 #include "amdgpu_dm_irq.h"
 */


