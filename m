Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0058744091
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbfFMQHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731304AbfFMIpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5392173C;
        Thu, 13 Jun 2019 08:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415533;
        bh=sSYbn8TpRkDbnMKW/pslPsGm6fozgk7nH3JxDJUHq00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwF7pwFXQBuJLu8q5YBCxvD7SNUTsIUpajBgklSHd0BFl0HNdeh1Es5SwMqZ7rdcZ
         A8zL2aJdLUJrUWwKNaQOwLdoC+YzJ1B4xwdgc0ppZMWUeu0f4SsUNAjywwAkCYLfw7
         KTayfA6KizB3nxIxJN376ygEEB4J7Mw3C6xchMX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Matt Redfearn <matt.redfearn@thinci.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 034/155] drm/bridge: adv7511: Fix low refresh rate selection
Date:   Thu, 13 Jun 2019 10:32:26 +0200
Message-Id: <20190613075654.942680737@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ec2ca71e1323..c532e9c9e491 100644
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



