Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D22D657DB0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiL1Pp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiL1Ppx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF2025D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACD59B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABDAC433EF;
        Wed, 28 Dec 2022 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242349;
        bh=wqHBlWwDhEXSeeSSCMDc2kQD+kY2BGT9fPT2b3UzNNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx9TmLwxdQuK8N8LF1FD1P45eNAhuc1+51OhMIaqqgZrj4h6siyY/bYunzxjSXphv
         siAfcY5qRgujabCBX8VLq5JHhN9Z6JNax2VXofeGPnST3hDhnPrgRZqOkAX73EKJxw
         K2QCqcAjwrP2Lb2ksvc69G/0dFcvx2CIHozk/Jsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0394/1073] media: amphion: try to wakeup vpu core to avoid failure
Date:   Wed, 28 Dec 2022 15:33:02 +0100
Message-Id: <20221228144338.719585176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 082744433f7b96db7214a98202ed96f367684693 ]

firmware should be waked up by start or configure command,
but there is a very small chance that firmware failed to wakeup.
in such case, try to wakeup firmware again by sending a noop command

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu.h         |  1 +
 drivers/media/platform/amphion/vpu_cmds.c    | 39 ++++++++++++++++++--
 drivers/media/platform/amphion/vpu_malone.c  |  1 +
 drivers/media/platform/amphion/vpu_windsor.c |  1 +
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu.h b/drivers/media/platform/amphion/vpu.h
index beac0309ca8d..048c23c2bf4d 100644
--- a/drivers/media/platform/amphion/vpu.h
+++ b/drivers/media/platform/amphion/vpu.h
@@ -13,6 +13,7 @@
 #include <linux/mailbox_controller.h>
 #include <linux/kfifo.h>
 
+#define VPU_TIMEOUT_WAKEUP	msecs_to_jiffies(200)
 #define VPU_TIMEOUT		msecs_to_jiffies(1000)
 #define VPU_INST_NULL_ID	(-1L)
 #define VPU_MSG_BUFFER_SIZE	(8192)
diff --git a/drivers/media/platform/amphion/vpu_cmds.c b/drivers/media/platform/amphion/vpu_cmds.c
index f4d7ca78a621..fa581ba6bab2 100644
--- a/drivers/media/platform/amphion/vpu_cmds.c
+++ b/drivers/media/platform/amphion/vpu_cmds.c
@@ -269,7 +269,7 @@ static bool check_is_responsed(struct vpu_inst *inst, unsigned long key)
 	return flag;
 }
 
-static int sync_session_response(struct vpu_inst *inst, unsigned long key)
+static int sync_session_response(struct vpu_inst *inst, unsigned long key, long timeout, int try)
 {
 	struct vpu_core *core;
 
@@ -279,10 +279,12 @@ static int sync_session_response(struct vpu_inst *inst, unsigned long key)
 	core = inst->core;
 
 	call_void_vop(inst, wait_prepare);
-	wait_event_timeout(core->ack_wq, check_is_responsed(inst, key), VPU_TIMEOUT);
+	wait_event_timeout(core->ack_wq, check_is_responsed(inst, key), timeout);
 	call_void_vop(inst, wait_finish);
 
 	if (!check_is_responsed(inst, key)) {
+		if (try)
+			return -EINVAL;
 		dev_err(inst->dev, "[%d] sync session timeout\n", inst->id);
 		set_bit(inst->id, &core->hang_mask);
 		mutex_lock(&inst->core->cmd_lock);
@@ -294,6 +296,19 @@ static int sync_session_response(struct vpu_inst *inst, unsigned long key)
 	return 0;
 }
 
+static void vpu_core_keep_active(struct vpu_core *core)
+{
+	struct vpu_rpc_event pkt;
+
+	memset(&pkt, 0, sizeof(pkt));
+	vpu_iface_pack_cmd(core, &pkt, 0, VPU_CMD_ID_NOOP, NULL);
+
+	dev_dbg(core->dev, "try to wake up\n");
+	mutex_lock(&core->cmd_lock);
+	vpu_cmd_send(core, &pkt);
+	mutex_unlock(&core->cmd_lock);
+}
+
 static int vpu_session_send_cmd(struct vpu_inst *inst, u32 id, void *data)
 {
 	unsigned long key;
@@ -304,9 +319,25 @@ static int vpu_session_send_cmd(struct vpu_inst *inst, u32 id, void *data)
 		return -EINVAL;
 
 	ret = vpu_request_cmd(inst, id, data, &key, &sync);
-	if (!ret && sync)
-		ret = sync_session_response(inst, key);
+	if (ret)
+		goto exit;
+
+	/* workaround for a firmware issue,
+	 * firmware should be waked up by start or configure command,
+	 * but there is a very small change that firmware failed to wakeup.
+	 * in such case, try to wakeup firmware again by sending a noop command
+	 */
+	if (sync && (id == VPU_CMD_ID_CONFIGURE_CODEC || id == VPU_CMD_ID_START)) {
+		if (sync_session_response(inst, key, VPU_TIMEOUT_WAKEUP, 1))
+			vpu_core_keep_active(inst->core);
+		else
+			goto exit;
+	}
+
+	if (sync)
+		ret = sync_session_response(inst, key, VPU_TIMEOUT, 0);
 
+exit:
 	if (ret)
 		dev_err(inst->dev, "[%d] send cmd(0x%x) fail\n", inst->id, id);
 
diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index 51e0702f9ae1..9f2890730fd7 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -692,6 +692,7 @@ int vpu_malone_set_decode_params(struct vpu_shared_addr *shared,
 }
 
 static struct vpu_pair malone_cmds[] = {
+	{VPU_CMD_ID_NOOP, VID_API_CMD_NULL},
 	{VPU_CMD_ID_START, VID_API_CMD_START},
 	{VPU_CMD_ID_STOP, VID_API_CMD_STOP},
 	{VPU_CMD_ID_ABORT, VID_API_CMD_ABORT},
diff --git a/drivers/media/platform/amphion/vpu_windsor.c b/drivers/media/platform/amphion/vpu_windsor.c
index 1526af2ef9da..b93c8cfdee7f 100644
--- a/drivers/media/platform/amphion/vpu_windsor.c
+++ b/drivers/media/platform/amphion/vpu_windsor.c
@@ -658,6 +658,7 @@ int vpu_windsor_get_stream_buffer_size(struct vpu_shared_addr *shared)
 }
 
 static struct vpu_pair windsor_cmds[] = {
+	{VPU_CMD_ID_NOOP, GTB_ENC_CMD_NOOP},
 	{VPU_CMD_ID_CONFIGURE_CODEC, GTB_ENC_CMD_CONFIGURE_CODEC},
 	{VPU_CMD_ID_START, GTB_ENC_CMD_STREAM_START},
 	{VPU_CMD_ID_STOP, GTB_ENC_CMD_STREAM_STOP},
-- 
2.35.1



