Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E185537C924
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhELQPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235131AbhELQIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC234619A8;
        Wed, 12 May 2021 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833947;
        bh=aeyliFnMX8FRphcdwB9MWrJ0v4MexZ4IASV8eDF7pDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV00o3I5AbVwb5AyWY//woDuOIrKmDEuGEEio90/scUo97+1JuJ2kM8CMNeCK5Kjn
         mj1Tco8VmvDX+EtiGOVmlDyPivQaLgnuPnKXeYR87y8dJ7wvzqfw5UVYiyCQc9tm6G
         F5bZGSZk1f8KG3t3/8QPTAnbARMoQfUoFzE9ALvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Almeida <daniel.almeida@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 350/601] media: rkvdec: Do not require all controls to be present in every request
Date:   Wed, 12 May 2021 16:47:07 +0200
Message-Id: <20210512144839.321181088@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Almeida <daniel.almeida@collabora.com>

[ Upstream commit 54676d5f5630b79f7b00c7c43882a58c1815aaf9 ]

According to the v4l2 api, it is allowed to skip
setting a control if its contents haven't changed for performance
reasons: userspace should only update the controls that changed from
last frame rather then updating them all. Still some ancient code
that checks for mandatory controls has been left in this driver.

Remove it.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 48 +--------------------------
 drivers/staging/media/rkvdec/rkvdec.h |  1 -
 2 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index aa4f8c287618..b1507f29fcc5 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -55,16 +55,13 @@ static const struct v4l2_ctrl_ops rkvdec_ctrl_ops = {
 
 static const struct rkvdec_ctrl_desc rkvdec_h264_ctrl_descs[] = {
 	{
-		.mandatory = true,
 		.cfg.id = V4L2_CID_STATELESS_H264_DECODE_PARAMS,
 	},
 	{
-		.mandatory = true,
 		.cfg.id = V4L2_CID_STATELESS_H264_SPS,
 		.cfg.ops = &rkvdec_ctrl_ops,
 	},
 	{
-		.mandatory = true,
 		.cfg.id = V4L2_CID_STATELESS_H264_PPS,
 	},
 	{
@@ -585,25 +582,7 @@ static const struct vb2_ops rkvdec_queue_ops = {
 
 static int rkvdec_request_validate(struct media_request *req)
 {
-	struct media_request_object *obj;
-	const struct rkvdec_ctrls *ctrls;
-	struct v4l2_ctrl_handler *hdl;
-	struct rkvdec_ctx *ctx = NULL;
-	unsigned int count, i;
-	int ret;
-
-	list_for_each_entry(obj, &req->objects, list) {
-		if (vb2_request_object_is_buffer(obj)) {
-			struct vb2_buffer *vb;
-
-			vb = container_of(obj, struct vb2_buffer, req_obj);
-			ctx = vb2_get_drv_priv(vb->vb2_queue);
-			break;
-		}
-	}
-
-	if (!ctx)
-		return -EINVAL;
+	unsigned int count;
 
 	count = vb2_request_buffer_cnt(req);
 	if (!count)
@@ -611,31 +590,6 @@ static int rkvdec_request_validate(struct media_request *req)
 	else if (count > 1)
 		return -EINVAL;
 
-	hdl = v4l2_ctrl_request_hdl_find(req, &ctx->ctrl_hdl);
-	if (!hdl)
-		return -ENOENT;
-
-	ret = 0;
-	ctrls = ctx->coded_fmt_desc->ctrls;
-	for (i = 0; ctrls && i < ctrls->num_ctrls; i++) {
-		u32 id = ctrls->ctrls[i].cfg.id;
-		struct v4l2_ctrl *ctrl;
-
-		if (!ctrls->ctrls[i].mandatory)
-			continue;
-
-		ctrl = v4l2_ctrl_request_hdl_ctrl_find(hdl, id);
-		if (!ctrl) {
-			ret = -ENOENT;
-			break;
-		}
-	}
-
-	v4l2_ctrl_request_hdl_put(hdl);
-
-	if (ret)
-		return ret;
-
 	return vb2_request_validate(req);
 }
 
diff --git a/drivers/staging/media/rkvdec/rkvdec.h b/drivers/staging/media/rkvdec/rkvdec.h
index 77a137cca88e..52ac3874c5e5 100644
--- a/drivers/staging/media/rkvdec/rkvdec.h
+++ b/drivers/staging/media/rkvdec/rkvdec.h
@@ -25,7 +25,6 @@
 struct rkvdec_ctx;
 
 struct rkvdec_ctrl_desc {
-	u32 mandatory : 1;
 	struct v4l2_ctrl_config cfg;
 };
 
-- 
2.30.2



