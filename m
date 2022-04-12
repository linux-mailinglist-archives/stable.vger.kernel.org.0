Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36774FD8F0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344956AbiDLH7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358579AbiDLHlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DD5532E3;
        Tue, 12 Apr 2022 00:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1561B61708;
        Tue, 12 Apr 2022 07:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF80C385A1;
        Tue, 12 Apr 2022 07:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747899;
        bh=s/VkCHlAXjk7aA+uMA2YC/pT3rsyhNvVzzrg1lAIMno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqWbQBqA3uhZGYz4QQYY2BERC7hgGBLdg0zdgCijYUHEnWa6duyPULGOpn47CDW7b
         dIlK6WnETCSVr3pzHhJesC+Wcfi+tcpLQw/I5OdJtUshpqkVS57eRXpWY6SHKMIuLp
         3Pg8QYW/OBpCpRCp6AgaWlLj4+5o4GY+ydzl3f7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 247/343] drm/amd/display: Fix for dmub outbox notification enable
Date:   Tue, 12 Apr 2022 08:31:05 +0200
Message-Id: <20220412062958.457750663@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit ed7208706448953c6f15009cf139135776c15713 ]

[Why]
Currently driver enables dmub outbox notification before oubox ISR is
registered. During boot scenario, sometimes dmub issues hpd outbox
message before driver registers ISR and those messages are missed.

[How]
Enable dmub outbox notification after outbox ISR is registered. Also,
restructured outbox enable code to call from dm layer and renamed APIs.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 66 +++++++++++++++++--
 drivers/gpu/drm/amd/display/dc/dc.h           |  3 +
 .../gpu/drm/amd/display/dc/dce/dmub_outbox.c  | 25 +++----
 .../gpu/drm/amd/display/dc/dce/dmub_outbox.h  |  4 +-
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c |  4 --
 .../drm/amd/display/dc/dcn31/dcn31_hwseq.c    |  2 +-
 6 files changed, 80 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index ba1aa994db4b..62bc6ce88753 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -76,6 +76,8 @@
 
 #include "dc_trace.h"
 
+#include "dce/dmub_outbox.h"
+
 #define CTX \
 	dc->ctx
 
@@ -3707,13 +3709,23 @@ void dc_hardware_release(struct dc *dc)
 }
 #endif
 
-/**
- * dc_enable_dmub_notifications - Returns whether dmub notification can be enabled
- * @dc: dc structure
+/*
+ *****************************************************************************
+ * Function: dc_is_dmub_outbox_supported -
+ * 
+ * @brief 
+ *      Checks whether DMUB FW supports outbox notifications, if supported
+ *		DM should register outbox interrupt prior to actually enabling interrupts
+ *		via dc_enable_dmub_outbox
  *
- * Returns: True to enable dmub notifications, False otherwise
+ *  @param
+ *		[in] dc: dc structure
+ *
+ *  @return
+ *		True if DMUB FW supports outbox notifications, False otherwise
+ *****************************************************************************
  */
-bool dc_enable_dmub_notifications(struct dc *dc)
+bool dc_is_dmub_outbox_supported(struct dc *dc)
 {
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	/* YELLOW_CARP B0 USB4 DPIA needs dmub notifications for interrupts */
@@ -3728,6 +3740,48 @@ bool dc_enable_dmub_notifications(struct dc *dc)
 
 /**
  * dc_process_dmub_aux_transfer_async - Submits aux command to dmub via inbox message
+ *  Function: dc_enable_dmub_notifications
+ *
+ *  @brief
+ *		Calls dc_is_dmub_outbox_supported to check if dmub fw supports outbox
+ *		notifications. All DMs shall switch to dc_is_dmub_outbox_supported.
+ *		This API shall be removed after switching.
+ *
+ *  @param
+ *		[in] dc: dc structure
+ *
+ *  @return
+ *		True if DMUB FW supports outbox notifications, False otherwise
+ *****************************************************************************
+ */
+bool dc_enable_dmub_notifications(struct dc *dc)
+{
+	return dc_is_dmub_outbox_supported(dc);
+}
+
+/**
+ *****************************************************************************
+ *  Function: dc_enable_dmub_outbox
+ *
+ *  @brief
+ *		Enables DMUB unsolicited notifications to x86 via outbox
+ *
+ *  @param
+ *		[in] dc: dc structure
+ *
+ *  @return
+ *		None
+ *****************************************************************************
+ */
+void dc_enable_dmub_outbox(struct dc *dc)
+{
+	struct dc_context *dc_ctx = dc->ctx;
+
+	dmub_enable_outbox_notification(dc_ctx->dmub_srv);
+}
+
+/**
+ *****************************************************************************
  *                                      Sets port index appropriately for legacy DDC
  * @dc: dc structure
  * @link_index: link index
@@ -3829,7 +3883,7 @@ uint8_t get_link_index_from_dpia_port_index(const struct dc *dc,
  *		[in] payload: aux payload
  *		[out] notify: set_config immediate reply
  *
- *	@return
+ *  @return
  *		True if successful, False if failure
  *****************************************************************************
  */
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index b51864890621..6a8c100a3688 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1448,8 +1448,11 @@ void dc_z10_restore(const struct dc *dc);
 void dc_z10_save_init(struct dc *dc);
 #endif
 
+bool dc_is_dmub_outbox_supported(struct dc *dc);
 bool dc_enable_dmub_notifications(struct dc *dc);
 
+void dc_enable_dmub_outbox(struct dc *dc);
+
 bool dc_process_dmub_aux_transfer_async(struct dc *dc,
 				uint32_t link_index,
 				struct aux_payload *payload);
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.c
index faad8555ddbb..fff1d07d865d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.c
@@ -22,20 +22,23 @@
  * Authors: AMD
  */
 
-#include "dmub_outbox.h"
+#include "dc.h"
 #include "dc_dmub_srv.h"
+#include "dmub_outbox.h"
 #include "dmub/inc/dmub_cmd.h"
 
-/**
- *  dmub_enable_outbox_notification - Sends inbox cmd to dmub to enable outbox1
- *                                    messages with interrupt. Dmub sends outbox1
- *                                    message and triggers outbox1 interrupt.
- * @dc: dc structure
+/*
+ *  Function: dmub_enable_outbox_notification
+ *
+ *  @brief
+ *		Sends inbox cmd to dmub for enabling outbox notifications to x86.
+ *
+ *  @param
+ *		[in] dmub_srv: dmub_srv structure
  */
-void dmub_enable_outbox_notification(struct dc *dc)
+void dmub_enable_outbox_notification(struct dc_dmub_srv *dmub_srv)
 {
 	union dmub_rb_cmd cmd;
-	struct dc_context *dc_ctx = dc->ctx;
 
 	memset(&cmd, 0x0, sizeof(cmd));
 	cmd.outbox1_enable.header.type = DMUB_CMD__OUTBOX1_ENABLE;
@@ -45,7 +48,7 @@ void dmub_enable_outbox_notification(struct dc *dc)
 		sizeof(cmd.outbox1_enable.header);
 	cmd.outbox1_enable.enable = true;
 
-	dc_dmub_srv_cmd_queue(dc_ctx->dmub_srv, &cmd);
-	dc_dmub_srv_cmd_execute(dc_ctx->dmub_srv);
-	dc_dmub_srv_wait_idle(dc_ctx->dmub_srv);
+	dc_dmub_srv_cmd_queue(dmub_srv, &cmd);
+	dc_dmub_srv_cmd_execute(dmub_srv);
+	dc_dmub_srv_wait_idle(dmub_srv);
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.h b/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.h
index 4e0aa0d1a2d5..58ceabb9d497 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.h
@@ -26,8 +26,8 @@
 #ifndef _DMUB_OUTBOX_H_
 #define _DMUB_OUTBOX_H_
 
-#include "dc.h"
+struct dc_dmub_srv;
 
-void dmub_enable_outbox_notification(struct dc *dc);
+void dmub_enable_outbox_notification(struct dc_dmub_srv *dmub_srv);
 
 #endif /* _DMUB_OUTBOX_H_ */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 530a72e3eefe..636e2d90ff93 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1500,10 +1500,6 @@ void dcn10_init_hw(struct dc *dc)
 				hws->funcs.dsc_pg_control(hws, res_pool->dscs[i]->inst, false);
 	}
 
-	/* Enable outbox notification feature of dmub */
-	if (dc->debug.enable_dmub_aux_for_legacy_ddc)
-		dmub_enable_outbox_notification(dc);
-
 	/* we want to turn off all dp displays before doing detection */
 	if (dc->config.power_down_display_on_boot)
 		dc_link_blank_all_dp_displays(dc);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 4206ce5bf9a9..1e156f398065 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -194,7 +194,7 @@ void dcn31_init_hw(struct dc *dc)
 
 	/* Enables outbox notifications for usb4 dpia */
 	if (dc->res_pool->usb4_dpia_count)
-		dmub_enable_outbox_notification(dc);
+		dmub_enable_outbox_notification(dc->ctx->dmub_srv);
 
 	/* we want to turn off all dp displays before doing detection */
 	if (dc->config.power_down_display_on_boot)
-- 
2.35.1



