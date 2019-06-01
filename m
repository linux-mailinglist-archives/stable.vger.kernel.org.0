Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF7131F35
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfFANSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbfFANSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52459229EB;
        Sat,  1 Jun 2019 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395102;
        bh=5MBpqwrTJ0qVeiOlno1YCQGiuPLSOLgY7w+6OCism3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDre4j91B4GHOkCREZRcnxkk5s9ZoCRH0HZRwo+O0ssxouaRPQoyjSjNjparlOEG2
         H2Sux4qP9OVt86hDdD4zTlmhWj0XPu0sobb8TWP1XFBU9EsJEBd5D5F2GmXn76qaSB
         AG6ipOqAzS7gfoGLkkpcbJ8oO4W2k+TMb/2REq58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Redfearn <matt.redfearn@thinci.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 033/186] drm/bridge: adv7511: Fix low refresh rate selection
Date:   Sat,  1 Jun 2019 09:14:09 -0400
Message-Id: <20190601131653.24205-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Redfearn <matt.redfearn@thinci.com>

[ Upstream commit 67793bd3b3948dc8c8384b6430e036a30a0ecb43 ]

The driver currently sets register 0xfb (Low Refresh Rate) based on the
value of mode->vrefresh. Firstly, this field is specified to be in Hz,
but the magic numbers used by the code are Hz * 1000. This essentially
leads to the low refresh rate always being set to 0x01, since the
vrefresh value will always be less than 24000. Fix the magic numbers to
be in Hz.
Secondly, according to the comment in drm_modes.h, the field is not
supposed to be used in a functional way anyway. Instead, use the helper
function drm_mode_vrefresh().

Fixes: 9c8af882bf12 ("drm: Add adv7511 encoder driver")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Matt Redfearn <matt.redfearn@thinci.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190424132210.26338-1-matt.redfearn@thinci.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index ec2ca71e13232..c532e9c9e491e 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -748,11 +748,11 @@ static void adv7511_mode_set(struct adv7511 *adv7511,
 			vsync_polarity = 1;
 	}
 
-	if (mode->vrefresh <= 24000)
+	if (drm_mode_vrefresh(mode) <= 24)
 		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_24HZ;
-	else if (mode->vrefresh <= 25000)
+	else if (drm_mode_vrefresh(mode) <= 25)
 		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_25HZ;
-	else if (mode->vrefresh <= 30000)
+	else if (drm_mode_vrefresh(mode) <= 30)
 		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_30HZ;
 	else
 		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_NONE;
-- 
2.20.1

