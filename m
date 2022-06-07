Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B2754146D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358562AbiFGUSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376699AbiFGURD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543861CF933;
        Tue,  7 Jun 2022 11:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 853656147E;
        Tue,  7 Jun 2022 18:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA55C385A5;
        Tue,  7 Jun 2022 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626579;
        bh=YBEeIKFakKoI6TjeL91aCaKu6R+WbdsfFHaDsD3gaxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnGgMp0FVeYXV7NCEsZ7SuYRnJIv4AFeXS7VuKRKz9i85V4tSTiBv3wBItR6q+rKJ
         FoMVN8QuHR03CEPqva1tm/KX1OcZDncqL9T2DIGtYbNMCB9B8SkIxpuEpIYNSlAqwO
         jumGIxdSG6KA8bcJf5DDP0XEI/89/ND9EP0h6RUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Dong <yunfei.dong@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 388/772] media: mediatek: vcodec: Fix v4l2 compliance decoder cmd test fail
Date:   Tue,  7 Jun 2022 18:59:40 +0200
Message-Id: <20220607165000.446928187@linuxfoundation.org>
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

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 08a83828825cbf3bc2c9f582a4cd4da9f40c77d6 ]

Will return -EINVAL using standard framework api when test stateless
decoder with cmd VIDIOC_(TRY)DECODER_CMD. Disable them to adjust v4l2
compliance test for user driver(GStreamer/Chrome) won't use decoder cmd.

Fixes: 8cdc3794b2e3 ("media: mtk-vcodec: vdec: support stateless API")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c  | 13 +------------
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c  |  3 +++
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 2b334a8a81c6..f99771a038b0 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -47,14 +47,7 @@ static struct mtk_q_data *mtk_vdec_get_q_data(struct mtk_vcodec_ctx *ctx,
 static int vidioc_try_decoder_cmd(struct file *file, void *priv,
 				struct v4l2_decoder_cmd *cmd)
 {
-	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
-
-	/* Use M2M stateless helper if relevant */
-	if (ctx->dev->vdec_pdata->uses_stateless_api)
-		return v4l2_m2m_ioctl_stateless_try_decoder_cmd(file, priv,
-								cmd);
-	else
-		return v4l2_m2m_ioctl_try_decoder_cmd(file, priv, cmd);
+	return v4l2_m2m_ioctl_try_decoder_cmd(file, priv, cmd);
 }
 
 
@@ -69,10 +62,6 @@ static int vidioc_decoder_cmd(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	/* Use M2M stateless helper if relevant */
-	if (ctx->dev->vdec_pdata->uses_stateless_api)
-		return v4l2_m2m_ioctl_stateless_decoder_cmd(file, priv, cmd);
-
 	mtk_v4l2_debug(1, "decoder cmd=%u", cmd->cmd);
 	dst_vq = v4l2_m2m_get_vq(ctx->m2m_ctx,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
index 40c39e1e596b..4b5cbaf672ab 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -315,6 +315,9 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	}
 
 	if (dev->vdec_pdata->uses_stateless_api) {
+		v4l2_disable_ioctl(vfd_dec, VIDIOC_DECODER_CMD);
+		v4l2_disable_ioctl(vfd_dec, VIDIOC_TRY_DECODER_CMD);
+
 		dev->mdev_dec.dev = &pdev->dev;
 		strscpy(dev->mdev_dec.model, MTK_VCODEC_DEC_NAME,
 			sizeof(dev->mdev_dec.model));
-- 
2.35.1



