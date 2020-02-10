Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60573157C7C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgBJMe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgBJMe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:34:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7928520661;
        Mon, 10 Feb 2020 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338096;
        bh=SpGnDWfPNKxbTyyVrQ0DcCY0igGGqg3viP6G02NqprA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3jTNemPZslNp7535XrPPBziOUUYD2b4ZBLnLYziNDD01OkYtf5NPAtI8o89eZExY
         ir0xNOEz9oU0IJ/5jAMW0kQzKM1Lj/S8AN1Dbs9wl2/afmEIarqR7+iM0gu13SVNob
         Lu+DpvrcwvUVtpFPzU00l2tovger0dYTPSF9maN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/195] Revert "drm/sun4i: dsi: Change the start delay calculation"
Date:   Mon, 10 Feb 2020 04:30:59 -0800
Message-Id: <20200210122305.918759931@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit a00d17e0a71ae2e4fdaac46e1c12785d3346c3f2 ]

This reverts commit da676c6aa6413d59ab0a80c97bbc273025e640b2.

The original commit adds a start parameter to the calculation of the
start delay according to some old BSP versions from Allwinner. However,
there're two ways to add this delay -- add it in DSI controller or add
it in the TCON. Add it in both controllers won't work.

The code before this commit is picked from new versions of BSP kernel,
which has a comment for the 1 that says "put start_delay to tcon". By
checking the sun4i_tcon0_mode_set_cpu() in sun4i_tcon driver, it has
already added this delay, so we shouldn't repeat to add the delay in DSI
controller, otherwise the timing won't match.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191001080253.6135-2-icenowy@aosc.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 97a0573cc5145..79eb11cd185d1 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -357,8 +357,7 @@ static void sun6i_dsi_inst_init(struct sun6i_dsi *dsi,
 static u16 sun6i_dsi_get_video_start_delay(struct sun6i_dsi *dsi,
 					   struct drm_display_mode *mode)
 {
-	u16 start = clamp(mode->vtotal - mode->vdisplay - 10, 8, 100);
-	u16 delay = mode->vtotal - (mode->vsync_end - mode->vdisplay) + start;
+	u16 delay = mode->vtotal - (mode->vsync_end - mode->vdisplay) + 1;
 
 	if (delay > mode->vtotal)
 		delay = delay % mode->vtotal;
-- 
2.20.1



