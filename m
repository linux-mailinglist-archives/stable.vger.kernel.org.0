Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82014537C4F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiE3NbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiE3NaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FE7E00A;
        Mon, 30 May 2022 06:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E80DEB80B3A;
        Mon, 30 May 2022 13:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9FBC3411C;
        Mon, 30 May 2022 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917193;
        bh=MoPv6OhQx7EiRN060osT8VM3jcVMoppKxNbkWMOY8cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHxW4nzW41i3ZJL1N7wO889EQufIM6/2NZ6ZIfjVmucwOYysFwKzPKM3N0lorNv9J
         2G2L8AmfJ6UsUIy+sAShx9GJb9am4jE0Zhswh9+g2sB9n2fwJbk04VfXoGOn9jeDrX
         RUf3CODHbrJvAQH1AbMRIWZ39xPpi990CLH+1bYy8nb5+ZX9DvWkEXa/ivAUtuofq6
         ylaadzThCnAvGI0SiR4VvBzz/3vck37O1bIZLIMiS+8MlPZSvadJl/oj5husqo4Jei
         CACB3Cpa0SGFkj4MZsGZ4LwPsSYzhfX3KhZnzBzWLd/vXaG0kQ9gg4baCIOSjNe97A
         m1T7z84cJFnBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vikash Garodia <quic_vgarodia@quicinc.com>,
        Fritz Koenig <frkoenig@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 051/159] media: venus: do not queue internal buffers from previous sequence
Date:   Mon, 30 May 2022 09:22:36 -0400
Message-Id: <20220530132425.1929512-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikash Garodia <quic_vgarodia@quicinc.com>

[ Upstream commit 73664f107c0fafb59cd91e576b81c986adb74610 ]

During reconfig (DRC) event from firmware, it is not guaranteed that
all the DPB(internal) buffers would be released by the firmware. Some
buffers might be released gradually while processing frames from the
new sequence. These buffers now stay idle in the dpblist.
In subsequent call to queue the DPBs to firmware, these idle buffers
should not be queued. The fix identifies those buffers and free them.

Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Fritz Koenig <frkoenig@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 34 +++++++++++++++------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 0bca95d01650..fa01edd54c03 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -90,12 +90,28 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
 }
 EXPORT_SYMBOL_GPL(venus_helper_check_codec);
 
+static void free_dpb_buf(struct venus_inst *inst, struct intbuf *buf)
+{
+	ida_free(&inst->dpb_ids, buf->dpb_out_tag);
+
+	list_del_init(&buf->list);
+	dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
+		       buf->attrs);
+	kfree(buf);
+}
+
 int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 {
-	struct intbuf *buf;
+	struct intbuf *buf, *next;
+	unsigned int dpb_size = 0;
 	int ret = 0;
 
-	list_for_each_entry(buf, &inst->dpbbufs, list) {
+	if (inst->dpb_buftype == HFI_BUFFER_OUTPUT)
+		dpb_size = inst->output_buf_size;
+	else if (inst->dpb_buftype == HFI_BUFFER_OUTPUT2)
+		dpb_size = inst->output2_buf_size;
+
+	list_for_each_entry_safe(buf, next, &inst->dpbbufs, list) {
 		struct hfi_frame_data fdata;
 
 		memset(&fdata, 0, sizeof(fdata));
@@ -106,6 +122,12 @@ int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 		if (buf->owned_by == FIRMWARE)
 			continue;
 
+		/* free buffer from previous sequence which was released later */
+		if (dpb_size > buf->size) {
+			free_dpb_buf(inst, buf);
+			continue;
+		}
+
 		fdata.clnt_data = buf->dpb_out_tag;
 
 		ret = hfi_session_process_buf(inst, &fdata);
@@ -127,13 +149,7 @@ int venus_helper_free_dpb_bufs(struct venus_inst *inst)
 	list_for_each_entry_safe(buf, n, &inst->dpbbufs, list) {
 		if (buf->owned_by == FIRMWARE)
 			continue;
-
-		ida_free(&inst->dpb_ids, buf->dpb_out_tag);
-
-		list_del_init(&buf->list);
-		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
-			       buf->attrs);
-		kfree(buf);
+		free_dpb_buf(inst, buf);
 	}
 
 	if (list_empty(&inst->dpbbufs))
-- 
2.35.1

