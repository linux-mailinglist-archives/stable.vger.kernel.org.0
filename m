Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB0657DFB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbiL1PtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiL1Ps6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ADE18398
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD89B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6D8C433D2;
        Wed, 28 Dec 2022 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242525;
        bh=g6uAbsg2/4nBl/Qb5jnuKJIGeIlTrVa/TjSijcSD0FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4bByUxKszDrS7IjoRHJQWgXdahr9DlqxvBiAhZuv8TCLsRUrmFfBVjxFD/EoEAdP
         ub23rcN8+Deoh6dV3Oup7RBj4PcJwauGRApfNvxGy+T7PROVmHdxZn0wtxaOCuIqQd
         1bgiiT5aYZorEMF/EGXrCIUxty9sPh0ugfPSt8hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0396/1073] media: amphion: lock and check m2m_ctx in event handler
Date:   Wed, 28 Dec 2022 15:33:04 +0100
Message-Id: <20221228144338.773250817@linuxfoundation.org>
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

[ Upstream commit 1ade3f3f16986cd7c6fce02feede957f03eb8a42 ]

driver needs to cancel vpu before releasing the vpu instance,
so call v4l2_m2m_ctx_release() first,
to handle the redundant event triggered after m2m_ctx is released.

lock and check m2m_ctx in the event handler.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_msgs.c | 2 ++
 drivers/media/platform/amphion/vpu_v4l2.c | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_msgs.c b/drivers/media/platform/amphion/vpu_msgs.c
index d8247f36d84b..92672a802b49 100644
--- a/drivers/media/platform/amphion/vpu_msgs.c
+++ b/drivers/media/platform/amphion/vpu_msgs.c
@@ -43,6 +43,7 @@ static void vpu_session_handle_mem_request(struct vpu_inst *inst, struct vpu_rpc
 		  req_data.ref_frame_num,
 		  req_data.act_buf_size,
 		  req_data.act_buf_num);
+	vpu_inst_lock(inst);
 	call_void_vop(inst, mem_request,
 		      req_data.enc_frame_size,
 		      req_data.enc_frame_num,
@@ -50,6 +51,7 @@ static void vpu_session_handle_mem_request(struct vpu_inst *inst, struct vpu_rpc
 		      req_data.ref_frame_num,
 		      req_data.act_buf_size,
 		      req_data.act_buf_num);
+	vpu_inst_unlock(inst);
 }
 
 static void vpu_session_handle_stop_done(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index a24e2d0e9542..590d1084e5a5 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -242,8 +242,12 @@ int vpu_process_capture_buffer(struct vpu_inst *inst)
 
 struct vb2_v4l2_buffer *vpu_next_src_buf(struct vpu_inst *inst)
 {
-	struct vb2_v4l2_buffer *src_buf = v4l2_m2m_next_src_buf(inst->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *src_buf = NULL;
 
+	if (!inst->fh.m2m_ctx)
+		return NULL;
+
+	src_buf = v4l2_m2m_next_src_buf(inst->fh.m2m_ctx);
 	if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
 		return NULL;
 
@@ -266,7 +270,7 @@ void vpu_skip_frame(struct vpu_inst *inst, int count)
 	enum vb2_buffer_state state;
 	int i = 0;
 
-	if (count <= 0)
+	if (count <= 0 || !inst->fh.m2m_ctx)
 		return;
 
 	while (i < count) {
-- 
2.35.1



