Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE5BCCA9
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391350AbfIXQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391096AbfIXQl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:41:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B7F820872;
        Tue, 24 Sep 2019 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343316;
        bh=yIdKmJ39DVVEUZj5hSgUPNeERFOvo1IIZg0ZVTBclWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5+N8u4SWOF4cpighVTgLGxgP1XVpZISmNS6Vj2DsvprIhkLGPdIb519Dc/vF6/1c
         /ehmmGOAZPMlE+Tiq/tsuIOMZBWFQ96GYcHusZ5b69WXEW1fv2BfdT54HnnkSANePF
         z5PxDQ7IRnQR6VBEnjAj+cnyNmzV2+pdfmG4S/B8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 07/87] drm/panel: simple: fix AUO g185han01 horizontal blanking
Date:   Tue, 24 Sep 2019 12:40:23 -0400
Message-Id: <20190924164144.25591-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit f8c6bfc612b56f02e1b8fae699dff12738aaf889 ]

The horizontal blanking periods are too short, as the values are
specified for a single LVDS channel. Since this panel is dual LVDS
they need to be doubled. With this change the panel reaches its
nominal vrefresh rate of 60Fps, instead of the 64Fps with the
current wrong blanking.

Philipp Zabel added:
The datasheet specifies 960 active clocks + 40/128/160 clocks blanking
on each of the two LVDS channels (min/typical/max), so doubled this is
now correct.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1562764060.23869.12.camel@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 5a93c4edf1e43..ee6900eb39069 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -724,9 +724,9 @@ static const struct panel_desc auo_g133han01 = {
 static const struct display_timing auo_g185han01_timings = {
 	.pixelclock = { 120000000, 144000000, 175000000 },
 	.hactive = { 1920, 1920, 1920 },
-	.hfront_porch = { 18, 60, 74 },
-	.hback_porch = { 12, 44, 54 },
-	.hsync_len = { 10, 24, 32 },
+	.hfront_porch = { 36, 120, 148 },
+	.hback_porch = { 24, 88, 108 },
+	.hsync_len = { 20, 48, 64 },
 	.vactive = { 1080, 1080, 1080 },
 	.vfront_porch = { 6, 10, 40 },
 	.vback_porch = { 2, 5, 20 },
-- 
2.20.1

