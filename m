Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CE8541195
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbiFGTi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356412AbiFGTiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656AA52533;
        Tue,  7 Jun 2022 11:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D3B9B8233E;
        Tue,  7 Jun 2022 18:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FFFC36B0B;
        Tue,  7 Jun 2022 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625634;
        bh=MoPv6OhQx7EiRN060osT8VM3jcVMoppKxNbkWMOY8cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRe5hQMIIDh8QkBZhnGrcSWt0DLDxU7cvFWI0UD9+CAcl2D3j3mWalpsk0IuBjP5a
         e2VdVkr4VM+IEfKuUIV68EzHnUGj2zWXlEXbrmx+DqeYw7y9S8Ik0CZNynnCAtZhR5
         6lGcGsr4r82R4XTUK+m4n01zll5vWq04e2H/A4+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikash Garodia <quic_vgarodia@quicinc.com>,
        Fritz Koenig <frkoenig@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 089/772] media: venus: do not queue internal buffers from previous sequence
Date:   Tue,  7 Jun 2022 18:54:41 +0200
Message-Id: <20220607164951.668432150@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



