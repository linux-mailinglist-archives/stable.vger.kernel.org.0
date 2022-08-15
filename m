Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B268D59473B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354343AbiHOXrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354904AbiHOXqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21963C2769;
        Mon, 15 Aug 2022 13:15:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41A3DB80EA9;
        Mon, 15 Aug 2022 20:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EA5C433D6;
        Mon, 15 Aug 2022 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594497;
        bh=8Hk5y3THfewdtbF9VTpJrfqNWBag9S8m1fnT5yd1cBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdJPcvda/DDAK13vq4I2T+0w4Qwy439Ia14AqfWR7cHaO97EIFQsCeux2mkaz54GI
         hka7GDl+vj9fKjDlqlW4Yl+6tTn17c7YaCyN4lK8pVu/SxVwsYfNOYbQS79WcHxkb5
         UhlSZjSu7euPFzsEXCCN1BnsABA3vE6Ws1erbelM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0466/1157] media: amphion: sync buffer status with firmware during abort
Date:   Mon, 15 Aug 2022 19:57:02 +0200
Message-Id: <20220815180458.241114228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit d8f1eb105eab7aab36323c6b488dda479d5bd2da ]

1. prevent to allocate buffer to firmware during abort
2. release buffer when clear the slots

Fixes: 6de8d628df6ef ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index a5bb997b000b..5e3b08d07abd 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -63,6 +63,7 @@ struct vdec_t {
 	bool is_source_changed;
 	u32 source_change;
 	u32 drain;
+	bool aborting;
 };
 
 static const struct vpu_format vdec_formats[] = {
@@ -948,6 +949,9 @@ static int vdec_response_frame(struct vpu_inst *inst, struct vb2_v4l2_buffer *vb
 	if (inst->state != VPU_CODEC_STATE_ACTIVE)
 		return -EINVAL;
 
+	if (vdec->aborting)
+		return -EINVAL;
+
 	if (!vdec->req_frame_count)
 		return -EINVAL;
 
@@ -1057,6 +1061,8 @@ static void vdec_clear_slots(struct vpu_inst *inst)
 		vpu_buf = vdec->slots[i];
 		vbuf = &vpu_buf->m2m_buf.vb;
 
+		vpu_trace(inst->dev, "clear slot %d\n", i);
+		vdec_response_fs_release(inst, i, vpu_buf->tag);
 		vdec_recycle_buffer(inst, vbuf);
 		vdec->slots[i]->state = VPU_BUF_STATE_IDLE;
 		vdec->slots[i] = NULL;
@@ -1318,6 +1324,8 @@ static void vdec_abort(struct vpu_inst *inst)
 	int ret;
 
 	vpu_trace(inst->dev, "[%d] state = %d\n", inst->id, inst->state);
+
+	vdec->aborting = true;
 	vpu_iface_add_scode(inst, SCODE_PADDING_ABORT);
 	vdec->params.end_flag = 1;
 	vpu_iface_set_decode_params(inst, &vdec->params, 1);
@@ -1341,6 +1349,7 @@ static void vdec_abort(struct vpu_inst *inst)
 	vdec->decoded_frame_count = 0;
 	vdec->display_frame_count = 0;
 	vdec->sequence = 0;
+	vdec->aborting = false;
 }
 
 static void vdec_stop(struct vpu_inst *inst, bool free)
-- 
2.35.1



