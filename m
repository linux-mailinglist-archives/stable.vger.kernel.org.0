Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31E3BB081
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhGDXIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhGDXIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 602F5613F9;
        Sun,  4 Jul 2021 23:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439945;
        bh=RYCFuk0gjAJbRTFBZJX1SMMBhtn4qiRdhnSjSELTouQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdsL5CwpkK+5Rk8GUHsfUhkt7tnlMsmDGQ+PfGx2KI2Fs4xJ5fU0k276q+VVdd7un
         80x4Srcq7ByQXvWkTGVI/WiXhnScK0oxfaOdOMtXqjWcqN2ueB0CCTXk26B8m2yQTv
         MC/3UStyKqfXmpTp0gSJUYgPWg0g6vMGg+gMfAVfdJ6ajrZcrZ5C1VXa56gAhgEawq
         Akiv1fFB4PwbqZ+t1UpuRDIxdBpQDAJJvil4dI1CCiCnEobQNy5BSU7L+vaWENLfHb
         fAU7Ibe4m3h/XrGJWkNIyLt8mvWWrbVUsNjuMK07ObMi6rX/572UG+JTnSKDxzPQr+
         u1SXhwTC1bsdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 62/85] media: imx-csi: Skip first few frames from a BT.656 source
Date:   Sun,  4 Jul 2021 19:03:57 -0400
Message-Id: <20210704230420.1488358-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index e3bfd635a89a..6a94fff49bf6 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -750,9 +750,10 @@ static int csi_setup(struct csi_priv *priv)
 
 static int csi_start(struct csi_priv *priv)
 {
-	struct v4l2_fract *output_fi;
+	struct v4l2_fract *input_fi, *output_fi;
 	int ret;
 
+	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 
 	/* start upstream */
@@ -761,6 +762,17 @@ static int csi_start(struct csi_priv *priv)
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

