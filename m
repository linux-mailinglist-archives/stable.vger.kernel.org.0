Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAF93BB13A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhGDXLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232371AbhGDXKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7DC7613F7;
        Sun,  4 Jul 2021 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440055;
        bh=zFz17kTz0q/RoXuxwTOaqF4XgovTxUeA4x4QhxkyBZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9x+NT3k4FH1R1s61o+jt8XwqwUVoeERXvqrqxVBMILYmgnbglkSg+o9WpqmKxnnY
         BRNRO80I1bDCRKQqqjCrVKgN70uUZjz4Bh8g8222Yxj5mmmIbkL/h72ynhj49nJVn0
         gm0xZSQzUjd3cV+g21ife2ERPCPm+b2MtY8AuskZW2SrPU2oPnQkvdQChnyk9iYSbg
         neJM6C4A+kxs8o32GvPioRFpJUmOupWvVyHtgHoA5DkVxHq4h43+x5pNgJ6gwbe6nf
         97SWlHhjPB4CaOjPvt99hhWgn0YlfldsxNVW9ihV1hblWlCybTdrZ+MjYWMKhxvzGR
         SKrzbw8qJXMNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 59/80] media: imx-csi: Skip first few frames from a BT.656 source
Date:   Sun,  4 Jul 2021 19:05:55 -0400
Message-Id: <20210704230616.1489200-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit e198be37e52551bb863d07d2edc535d0932a3c4f ]

Some BT.656 sensors (e.g. ADV718x) transmit frames with unstable BT.656
sync codes after initial power on. This confuses the imx CSI,resulting
in vertical and/or horizontal sync issues. Skip the first 20 frames
to avoid the unstable sync codes.

[fabio: fixed checkpatch warning and increased the frame skipping to 20]

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index ef5add079774..7f4b967646d9 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -753,9 +753,10 @@ static int csi_setup(struct csi_priv *priv)
 
 static int csi_start(struct csi_priv *priv)
 {
-	struct v4l2_fract *output_fi;
+	struct v4l2_fract *input_fi, *output_fi;
 	int ret;
 
+	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 
 	/* start upstream */
@@ -764,6 +765,17 @@ static int csi_start(struct csi_priv *priv)
 	if (ret)
 		return ret;
 
+	/* Skip first few frames from a BT.656 source */
+	if (priv->upstream_ep.bus_type == V4L2_MBUS_BT656) {
+		u32 delay_usec, bad_frames = 20;
+
+		delay_usec = DIV_ROUND_UP_ULL((u64)USEC_PER_SEC *
+			input_fi->numerator * bad_frames,
+			input_fi->denominator);
+
+		usleep_range(delay_usec, delay_usec + 1000);
+	}
+
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		ret = csi_idmac_start(priv);
 		if (ret)
-- 
2.30.2

