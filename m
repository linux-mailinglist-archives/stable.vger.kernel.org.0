Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB504657B9B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiL1PXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiL1PX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629BE13EB5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11A66155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A07C433D2;
        Wed, 28 Dec 2022 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241007;
        bh=fL+zxk+dzBvZ4uBwm7Cwthu8ZL9ceMTRrexOpCMIE7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ0NoZtFBekHCsiWRrG0n3FJbV2jqmR0ZepQGnm/MU2xXR6Mq0aXDSP3s79oFZGLB
         HTjnDQt3EnSm8h7FnpI2cbKJ5Ov3tKbD0nOGZ2InVP4KXQKtBvx5nVOTBEuK2q8h/9
         gV4nQgAwmNh2tQiMMehQMNex949GxP+2DDFiV2IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0229/1073] media: v4l2-ioctl.c: Unify YCbCr/YUV terms in format descriptions
Date:   Wed, 28 Dec 2022 15:30:17 +0100
Message-Id: <20221228144334.246450947@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 6a394d563dffb60c150d87dc6678994ef8028c53 ]

Format descriptions use YCbCr and YUV terms interchangeably. Let's unify
them so they all use YUV. While YCbCr is actually correct term here, YUV
is shorter and thus it also fixes too long description of P010 tiled
format.

Fixes: 3c8e19d3d3f9 ("media: Add P010 tiled format")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 34 ++++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e6fd355a2e92..de83714f0d40 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1347,23 +1347,23 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_YUV420:	descr = "Planar YUV 4:2:0"; break;
 	case V4L2_PIX_FMT_HI240:	descr = "8-bit Dithered RGB (BTTV)"; break;
 	case V4L2_PIX_FMT_M420:		descr = "YUV 4:2:0 (M420)"; break;
-	case V4L2_PIX_FMT_NV12:		descr = "Y/CbCr 4:2:0"; break;
-	case V4L2_PIX_FMT_NV21:		descr = "Y/CrCb 4:2:0"; break;
-	case V4L2_PIX_FMT_NV16:		descr = "Y/CbCr 4:2:2"; break;
-	case V4L2_PIX_FMT_NV61:		descr = "Y/CrCb 4:2:2"; break;
-	case V4L2_PIX_FMT_NV24:		descr = "Y/CbCr 4:4:4"; break;
-	case V4L2_PIX_FMT_NV42:		descr = "Y/CrCb 4:4:4"; break;
-	case V4L2_PIX_FMT_P010:		descr = "10-bit Y/CbCr 4:2:0"; break;
-	case V4L2_PIX_FMT_NV12_4L4:	descr = "Y/CbCr 4:2:0 (4x4 Linear)"; break;
-	case V4L2_PIX_FMT_NV12_16L16:	descr = "Y/CbCr 4:2:0 (16x16 Linear)"; break;
-	case V4L2_PIX_FMT_NV12_32L32:   descr = "Y/CbCr 4:2:0 (32x32 Linear)"; break;
-	case V4L2_PIX_FMT_P010_4L4:	descr = "10-bit Y/CbCr 4:2:0 (4x4 Linear)"; break;
-	case V4L2_PIX_FMT_NV12M:	descr = "Y/CbCr 4:2:0 (N-C)"; break;
-	case V4L2_PIX_FMT_NV21M:	descr = "Y/CrCb 4:2:0 (N-C)"; break;
-	case V4L2_PIX_FMT_NV16M:	descr = "Y/CbCr 4:2:2 (N-C)"; break;
-	case V4L2_PIX_FMT_NV61M:	descr = "Y/CrCb 4:2:2 (N-C)"; break;
-	case V4L2_PIX_FMT_NV12MT:	descr = "Y/CbCr 4:2:0 (64x32 MB, N-C)"; break;
-	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/CbCr 4:2:0 (16x16 MB, N-C)"; break;
+	case V4L2_PIX_FMT_NV12:		descr = "Y/UV 4:2:0"; break;
+	case V4L2_PIX_FMT_NV21:		descr = "Y/VU 4:2:0"; break;
+	case V4L2_PIX_FMT_NV16:		descr = "Y/UV 4:2:2"; break;
+	case V4L2_PIX_FMT_NV61:		descr = "Y/VU 4:2:2"; break;
+	case V4L2_PIX_FMT_NV24:		descr = "Y/UV 4:4:4"; break;
+	case V4L2_PIX_FMT_NV42:		descr = "Y/VU 4:4:4"; break;
+	case V4L2_PIX_FMT_P010:		descr = "10-bit Y/UV 4:2:0"; break;
+	case V4L2_PIX_FMT_NV12_4L4:	descr = "Y/UV 4:2:0 (4x4 Linear)"; break;
+	case V4L2_PIX_FMT_NV12_16L16:	descr = "Y/UV 4:2:0 (16x16 Linear)"; break;
+	case V4L2_PIX_FMT_NV12_32L32:   descr = "Y/UV 4:2:0 (32x32 Linear)"; break;
+	case V4L2_PIX_FMT_P010_4L4:	descr = "10-bit Y/UV 4:2:0 (4x4 Linear)"; break;
+	case V4L2_PIX_FMT_NV12M:	descr = "Y/UV 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV21M:	descr = "Y/VU 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV16M:	descr = "Y/UV 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV61M:	descr = "Y/VU 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT:	descr = "Y/UV 4:2:0 (64x32 MB, N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/UV 4:2:0 (16x16 MB, N-C)"; break;
 	case V4L2_PIX_FMT_YUV420M:	descr = "Planar YUV 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_YVU420M:	descr = "Planar YVU 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_YUV422M:	descr = "Planar YUV 4:2:2 (N-C)"; break;
-- 
2.35.1



