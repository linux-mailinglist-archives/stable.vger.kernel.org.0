Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198D43C4C8B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbhGLHGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239988AbhGLHDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 223B561185;
        Mon, 12 Jul 2021 07:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073243;
        bh=zFz17kTz0q/RoXuxwTOaqF4XgovTxUeA4x4QhxkyBZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVbbmdJozsb+bLXom1fttQ5vliyiZ7wJI1JJk9ZOocXqRe4kJfeRl3adFtSxuEGS6
         USuChpX9KAMV/a/qneUTVp22scx8ZN00ysVewgbN3PhJ3SsVnDwDsYBxZqguvMUu4z
         0AtHJTpAABKuJSsnbgiXpsg0LuxSa+vSzfxmSEkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 176/700] media: imx-csi: Skip first few frames from a BT.656 source
Date:   Mon, 12 Jul 2021 08:04:19 +0200
Message-Id: <20210712060951.264770648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



