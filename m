Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBB06DCE4
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfGSETI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387887AbfGSENR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1655321850;
        Fri, 19 Jul 2019 04:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509596;
        bh=GQ05ZiD1XF47UysruM1GHFihZ4IcyG9Em/YzAk21Fbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzXfEOXx1abiWIa+9pLZKfk67EdAdvpFaQsor+Ms/qS25n3sSTARpscIK4puwSFze
         cAdDEgahYUaD88cr9p8j736un1A0+L1vhMr7nZnlQsaNIcBLCNvcudIh7fSWV4eRcT
         eqNoivdgj77S2Fjmx8dsbPuEmR2noJHa/bCvd6U4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jyri Sarha <jsarha@ti.com>, Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 08/45] drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz
Date:   Fri, 19 Jul 2019 00:12:27 -0400
Message-Id: <20190719041304.18849-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jyri Sarha <jsarha@ti.com>

[ Upstream commit 8dbfc5b65023b67397aca28e8adb25c819f6398c ]

The pixel clock unit in the first two registers (0x00 and 0x01) of
sii9022 is 10kHz, not 1kHz as in struct drm_display_mode. Division by
10 fixes the issue.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1a2a8eae0b9d6333e7a5841026bf7fd65c9ccd09.1558964241.git.jsarha@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index 9126d0306ab5..51e2d03995a1 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -250,10 +250,11 @@ static void sii902x_bridge_mode_set(struct drm_bridge *bridge,
 	struct regmap *regmap = sii902x->regmap;
 	u8 buf[HDMI_INFOFRAME_SIZE(AVI)];
 	struct hdmi_avi_infoframe frame;
+	u16 pixel_clock_10kHz = adj->clock / 10;
 	int ret;
 
-	buf[0] = adj->clock;
-	buf[1] = adj->clock >> 8;
+	buf[0] = pixel_clock_10kHz & 0xff;
+	buf[1] = pixel_clock_10kHz >> 8;
 	buf[2] = adj->vrefresh;
 	buf[3] = 0x00;
 	buf[4] = adj->hdisplay;
-- 
2.20.1

