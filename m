Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37515937BF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbiHOS5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244952AbiHOS4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5171AE4D;
        Mon, 15 Aug 2022 11:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78857B81062;
        Mon, 15 Aug 2022 18:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E8C433D6;
        Mon, 15 Aug 2022 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588252;
        bh=b+UBN1FBQ7qTYL/22sOwtFW1DR36fOVK9mF/Wjsb7gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBdqQ+gQtBQT3HybY5xrbcPTUclTR6KbwruzxkhMfl7giOmzMZYoJwTp+PYHfU90w
         E6b++PLtZiW72hX2mdM9WltTBZx+Yylxkfx+3/kNmR7RiLXXwEEPCdDcTKrnhazNKL
         Hz0IA8wwRB0y1EX+0Wb02ofIuwngA7/zQje5Gxeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/779] media: hantro: Simplify postprocessor
Date:   Mon, 15 Aug 2022 19:59:47 +0200
Message-Id: <20220815180351.922425700@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 53a3e71095c572333ceea30762565dbedec951ca ]

Add a 'postprocessed' boolean property to struct hantro_fmt
to signal that a format is produced by the post-processor.
This will allow to introduce the G2 post-processor in a simple way.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro.h          | 2 ++
 drivers/staging/media/hantro/hantro_postproc.c | 8 +-------
 drivers/staging/media/hantro/imx8m_vpu_hw.c    | 1 +
 drivers/staging/media/hantro/rockchip_vpu_hw.c | 1 +
 drivers/staging/media/hantro/sama5d4_vdec_hw.c | 1 +
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro.h b/drivers/staging/media/hantro/hantro.h
index c2e2dca38628..88792c863edc 100644
--- a/drivers/staging/media/hantro/hantro.h
+++ b/drivers/staging/media/hantro/hantro.h
@@ -262,6 +262,7 @@ struct hantro_ctx {
  * @max_depth:	Maximum depth, for bitstream formats
  * @enc_fmt:	Format identifier for encoder registers.
  * @frmsize:	Supported range of frame sizes (only for bitstream formats).
+ * @postprocessed: Indicates if this format needs the post-processor.
  */
 struct hantro_fmt {
 	char *name;
@@ -271,6 +272,7 @@ struct hantro_fmt {
 	int max_depth;
 	enum hantro_enc_fmt enc_fmt;
 	struct v4l2_frmsize_stepwise frmsize;
+	bool postprocessed;
 };
 
 struct hantro_reg {
diff --git a/drivers/staging/media/hantro/hantro_postproc.c b/drivers/staging/media/hantro/hantro_postproc.c
index 07842152003f..46434c97317b 100644
--- a/drivers/staging/media/hantro/hantro_postproc.c
+++ b/drivers/staging/media/hantro/hantro_postproc.c
@@ -53,15 +53,9 @@ const struct hantro_postproc_regs hantro_g1_postproc_regs = {
 bool hantro_needs_postproc(const struct hantro_ctx *ctx,
 			   const struct hantro_fmt *fmt)
 {
-	struct hantro_dev *vpu = ctx->dev;
-
 	if (ctx->is_encoder)
 		return false;
-
-	if (!vpu->variant->postproc_fmts)
-		return false;
-
-	return fmt->fourcc != V4L2_PIX_FMT_NV12;
+	return fmt->postprocessed;
 }
 
 void hantro_postproc_enable(struct hantro_ctx *ctx)
diff --git a/drivers/staging/media/hantro/imx8m_vpu_hw.c b/drivers/staging/media/hantro/imx8m_vpu_hw.c
index ea919bfb9891..b692b74b0914 100644
--- a/drivers/staging/media/hantro/imx8m_vpu_hw.c
+++ b/drivers/staging/media/hantro/imx8m_vpu_hw.c
@@ -82,6 +82,7 @@ static const struct hantro_fmt imx8m_vpu_postproc_fmts[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_YUYV,
 		.codec_mode = HANTRO_MODE_NONE,
+		.postprocessed = true,
 	},
 };
 
diff --git a/drivers/staging/media/hantro/rockchip_vpu_hw.c b/drivers/staging/media/hantro/rockchip_vpu_hw.c
index 0c22039162a0..543dc4a5486c 100644
--- a/drivers/staging/media/hantro/rockchip_vpu_hw.c
+++ b/drivers/staging/media/hantro/rockchip_vpu_hw.c
@@ -62,6 +62,7 @@ static const struct hantro_fmt rockchip_vpu1_postproc_fmts[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_YUYV,
 		.codec_mode = HANTRO_MODE_NONE,
+		.postprocessed = true,
 	},
 };
 
diff --git a/drivers/staging/media/hantro/sama5d4_vdec_hw.c b/drivers/staging/media/hantro/sama5d4_vdec_hw.c
index 9c3b8cd0b239..99432008b241 100644
--- a/drivers/staging/media/hantro/sama5d4_vdec_hw.c
+++ b/drivers/staging/media/hantro/sama5d4_vdec_hw.c
@@ -15,6 +15,7 @@ static const struct hantro_fmt sama5d4_vdec_postproc_fmts[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_YUYV,
 		.codec_mode = HANTRO_MODE_NONE,
+		.postprocessed = true,
 	},
 };
 
-- 
2.35.1



