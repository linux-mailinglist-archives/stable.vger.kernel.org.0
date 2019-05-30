Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860932EBC4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfE3DP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730545AbfE3DP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DCB2458C;
        Thu, 30 May 2019 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186157;
        bh=j5IrkmXoqipm6SS+hShpCMelEn2qPU/FEDpbZVsmWNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7npststurNcj6Mkm6U+Ln2UIa0GYpUZ7j6/0ktmoNl1CiHT/8Jhurbh8RittzTR2
         AgoGHgRZ15qlSgTr0c570wVq3TteEpZSA6bpqruo5cagwUl+hMriWIz0PqWx0M7m6j
         fO15k3F/DyV5G5WyPVTvy26W6R1QtKkqBKhVh7HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 345/346] drm/sun4i: dsi: Enforce boundaries on the start delay
Date:   Wed, 29 May 2019 20:06:58 -0700
Message-Id: <20190530030558.196706692@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit efa31801203ac2f5c6a82a28cb991c7163ee0f1d ]

The Allwinner BSP makes sure that we don't end up with a null start delay
or with a delay larger than vtotal.

The former condition is likely to happen now with the reworked start delay,
so make sure we enforce the same boundaries.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c9889cf5f7a3d101ef380905900b45a182596f56.1549896081.git-series.maxime.ripard@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 3de41de43127b..97a0573cc5145 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -358,8 +358,12 @@ static u16 sun6i_dsi_get_video_start_delay(struct sun6i_dsi *dsi,
 					   struct drm_display_mode *mode)
 {
 	u16 start = clamp(mode->vtotal - mode->vdisplay - 10, 8, 100);
+	u16 delay = mode->vtotal - (mode->vsync_end - mode->vdisplay) + start;
 
-	return mode->vtotal - (mode->vsync_end - mode->vdisplay) + start;
+	if (delay > mode->vtotal)
+		delay = delay % mode->vtotal;
+
+	return max_t(u16, delay, 1);
 }
 
 static void sun6i_dsi_setup_burst(struct sun6i_dsi *dsi,
-- 
2.20.1



