Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7692D59398B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243600AbiHOSo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243301AbiHOSno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3BF2F667;
        Mon, 15 Aug 2022 11:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F2AF60FA2;
        Mon, 15 Aug 2022 18:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69524C433C1;
        Mon, 15 Aug 2022 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588021;
        bh=o+CfgAyj9rPLk8ZM6G7S0zQl0iS1yoI3dsi9OirsY7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKoPm8gmfl015jRxmOoYPwPioT1GuPhRNtH402ldaMk4RsbXeHAzChBXCvrT4Xj3r
         fTUUekLYKxBIv6Zd8F1qAS+ayOoN3NK1AhrWchrlaeysR7EirQcdUmS4k0YWbN9AK4
         hFQTeAjJPIfHfCuDvqSldsGlZe4QNfKcvrspLKcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Shijie Qin <shijie.qin@nxp.com>,
        Zhou Peng <eagle.zhou@nxp.com>,
        Mirela Rabulea <mirela.rabulea@oss.nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/779] media: imx-jpeg: use NV12M to represent non contiguous NV12
Date:   Mon, 15 Aug 2022 19:58:35 +0200
Message-Id: <20220815180348.911162679@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 784a1883cff07e7510a81ad3041d6ec443d51944 ]

V4L2_PIX_FMT_NV12 requires num_planes equals to 1,
V4L2_PIX_FMT_NV12M requires num_planes equals to 2.
and mxc-jpeg supports 2 planes for nv12,
so we should use 4L2_PIX_FMT_NV12M instead of V4L2_PIX_FMT_NV12,
otherwise it will confuses gstreamer and prevent encoding and decoding.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Shijie Qin <shijie.qin@nxp.com>
Signed-off-by: Zhou Peng <eagle.zhou@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index bc66c09b807a..1ec60f54d5a1 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -96,7 +96,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 	},
 	{
 		.name		= "YUV420", /* 1st plane = Y, 2nd plane = UV */
-		.fourcc		= V4L2_PIX_FMT_NV12,
+		.fourcc		= V4L2_PIX_FMT_NV12M,
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
 		.nc		= 3,
 		.depth		= 12, /* 6 bytes (4Y + UV) for 4 pixels */
@@ -390,7 +390,7 @@ static enum mxc_jpeg_image_format mxc_jpeg_fourcc_to_imgfmt(u32 fourcc)
 		return MXC_JPEG_GRAY;
 	case V4L2_PIX_FMT_YUYV:
 		return MXC_JPEG_YUV422;
-	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV12M:
 		return MXC_JPEG_YUV420;
 	case V4L2_PIX_FMT_YUV24:
 		return MXC_JPEG_YUV444;
@@ -660,7 +660,7 @@ static int mxc_jpeg_fixup_sof(struct mxc_jpeg_sof *sof,
 	_bswap16(&sof->width);
 
 	switch (fourcc) {
-	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV12M:
 		sof->components_no = 3;
 		sof->comp[0].v = 0x2;
 		sof->comp[0].h = 0x2;
@@ -696,7 +696,7 @@ static int mxc_jpeg_fixup_sos(struct mxc_jpeg_sos *sos,
 	u8 *sof_u8 = (u8 *)sos;
 
 	switch (fourcc) {
-	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV12M:
 		sos->components_no = 3;
 		break;
 	case V4L2_PIX_FMT_YUYV:
@@ -1179,7 +1179,7 @@ static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q,
 		/* bytesperline unused for compressed formats */
 		q->bytesperline[0] = 0;
 		q->bytesperline[1] = 0;
-	} else if (q->fmt->fourcc == V4L2_PIX_FMT_NV12) {
+	} else if (q->fmt->fourcc == V4L2_PIX_FMT_NV12M) {
 		/* When the image format is planar the bytesperline value
 		 * applies to the first plane and is divided by the same factor
 		 * as the width field for the other planes
@@ -1211,7 +1211,7 @@ static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q)
 	} else {
 		q->sizeimage[0] = q->bytesperline[0] * q->h;
 		q->sizeimage[1] = 0;
-		if (q->fmt->fourcc == V4L2_PIX_FMT_NV12)
+		if (q->fmt->fourcc == V4L2_PIX_FMT_NV12M)
 			q->sizeimage[1] = q->sizeimage[0] / 2;
 	}
 }
-- 
2.35.1



