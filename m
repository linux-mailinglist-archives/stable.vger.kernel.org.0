Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8332F328F6C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhCATvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236793AbhCATmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:42:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D34F6501C;
        Mon,  1 Mar 2021 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618678;
        bh=RbsRnAjVjKH2hfuolaRNlatMWXPRUnHLsvtlKr+1y5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvnpaRxROFk5biJPQz2I7I5GRW/0v8G7k2MnNpZObwBD+LU7gFSgS1ah8mn8wX+nY
         oMv8qlxCtHAros56CkvxwE16uov0BCMWFEET0UdRlMxzmQMLfaxq+vqP9JFaXA2K52
         LuPNhDzkT28OrzOGVEqlQNqMo/QUgE3Im0419uaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/663] media: imx7: csi: Fix pad link validation
Date:   Mon,  1 Mar 2021 17:07:05 +0100
Message-Id: <20210301161150.544187438@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rmfrfs@gmail.com>

[ Upstream commit f5ffb81f51376eb5a12e8c4cb4871426c65bb2af ]

We can not make the assumption that the bound subdev is always a CSI
mux, in i.MX6UL/i.MX6ULL that is not the case. So, just get the entity
selected by source directly upstream from the CSI.

Fixes: 86e02d07871c ("media: imx5/6/7: csi: Mark a bound video mux as a CSI mux")
Reported-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
Tested-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 31e36168f9d0f..ac52b1daf9914 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -499,6 +499,7 @@ static int imx7_csi_pad_link_validate(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *sink_fmt)
 {
 	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
+	struct media_entity *src;
 	struct media_pad *pad;
 	int ret;
 
@@ -509,11 +510,21 @@ static int imx7_csi_pad_link_validate(struct v4l2_subdev *sd,
 	if (!csi->src_sd)
 		return -EPIPE;
 
+	src = &csi->src_sd->entity;
+
+	/*
+	 * if the source is neither a CSI MUX or CSI-2 get the one directly
+	 * upstream from this CSI
+	 */
+	if (src->function != MEDIA_ENT_F_VID_IF_BRIDGE &&
+	    src->function != MEDIA_ENT_F_VID_MUX)
+		src = &csi->sd.entity;
+
 	/*
-	 * find the entity that is selected by the CSI mux. This is needed
+	 * find the entity that is selected by the source. This is needed
 	 * to distinguish between a parallel or CSI-2 pipeline.
 	 */
-	pad = imx_media_pipeline_pad(&csi->src_sd->entity, 0, 0, true);
+	pad = imx_media_pipeline_pad(src, 0, 0, true);
 	if (!pad)
 		return -ENODEV;
 
-- 
2.27.0



