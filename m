Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A267D593EE9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbiHOVKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347917AbiHOVHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E003E52E4A;
        Mon, 15 Aug 2022 12:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E09D60EF0;
        Mon, 15 Aug 2022 19:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835D3C433D6;
        Mon, 15 Aug 2022 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590995;
        bh=wZ6id2vo0jW3PMWz/YuKBr5MtvwyfWz2sT5AKcRRCd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5PmjCsQzI/Ar192Vq64An/zaEm0lD3Z0HHhp90FxpnfsWVnp7PoZUoDe286X3jkh
         Jgkb8lF3vaTeb/vVhzy8R9RZr2GRH1IwUxvcQAQbUwAxPp9hiLJWHdpNzZxXhLsRR4
         Fbjx2auCM5kQzP2DVmbG+mjak1djWnnVSliTYGv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0439/1095] media: amphion: sync buffer status with firmware during abort
Date:   Mon, 15 Aug 2022 19:57:18 +0200
Message-Id: <20220815180447.816781289@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 052a60189c13..dd7ea23902c0 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -63,6 +63,7 @@ struct vdec_t {
 	bool is_source_changed;
 	u32 source_change;
 	u32 drain;
+	bool aborting;
 };
 
 static const struct vpu_format vdec_formats[] = {
@@ -942,6 +943,9 @@ static int vdec_response_frame(struct vpu_inst *inst, struct vb2_v4l2_buffer *vb
 	if (inst->state != VPU_CODEC_STATE_ACTIVE)
 		return -EINVAL;
 
+	if (vdec->aborting)
+		return -EINVAL;
+
 	if (!vdec->req_frame_count)
 		return -EINVAL;
 
@@ -1051,6 +1055,8 @@ static void vdec_clear_slots(struct vpu_inst *inst)
 		vpu_buf = vdec->slots[i];
 		vbuf = &vpu_buf->m2m_buf.vb;
 
+		vpu_trace(inst->dev, "clear slot %d\n", i);
+		vdec_response_fs_release(inst, i, vpu_buf->tag);
 		vdec_recycle_buffer(inst, vbuf);
 		vdec->slots[i]->state = VPU_BUF_STATE_IDLE;
 		vdec->slots[i] = NULL;
@@ -1312,6 +1318,8 @@ static void vdec_abort(struct vpu_inst *inst)
 	int ret;
 
 	vpu_trace(inst->dev, "[%d] state = %d\n", inst->id, inst->state);
+
+	vdec->aborting = true;
 	vpu_iface_add_scode(inst, SCODE_PADDING_ABORT);
 	vdec->params.end_flag = 1;
 	vpu_iface_set_decode_params(inst, &vdec->params, 1);
@@ -1335,6 +1343,7 @@ static void vdec_abort(struct vpu_inst *inst)
 	vdec->decoded_frame_count = 0;
 	vdec->display_frame_count = 0;
 	vdec->sequence = 0;
+	vdec->aborting = false;
 }
 
 static void vdec_stop(struct vpu_inst *inst, bool free)
-- 
2.35.1



