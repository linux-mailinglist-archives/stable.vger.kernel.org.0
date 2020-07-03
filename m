Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078BC213BA2
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 16:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgGCON7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 10:13:59 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:41954 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgGCON7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 10:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1593785635; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=MHr/Vx6AifBNxeaJEpwnQzcfqb7ip8S1SAY5xrrDCAQ=;
        b=lNirvIktMvxLeah53ukETpEpZYUmjzjAPoKeb28ku1EYbtKYo994W+14qxyIB9RQESR3OV
        11yzVhd+OIK1XbGwdXS2o4E0C0SVrrG+Hp8Rh6BOu8k2qXU4fDF1kJoqTuYC01NjfHQWOY
        h7gOKmmmxlvKuW28uoM6n5XF3cInT/A=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] drm/dbi: Fix SPI Type 1 (9-bit) transfer
Date:   Fri,  3 Jul 2020 16:13:41 +0200
Message-Id: <20200703141341.1266263-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function mipi_dbi_spi1_transfer() will transfer its payload as 9-bit
data, the 9th (MSB) bit being the data/command bit. In order to do that,
it unpacks the 8-bit values into 16-bit values, then sets the 9th bit if
the byte corresponds to data, clears it otherwise. The 7 MSB are
padding. The array of now 16-bit values is then passed to the SPI core
for transfer.

This function was broken since its introduction, as the length of the
SPI transfer was set to the payload size before its conversion, but the
payload doubled in size due to the 8-bit -> 16-bit conversion.

Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/drm_mipi_dbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index bb27c82757f1..bf7888ad9ad4 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -923,7 +923,7 @@ static int mipi_dbi_spi1_transfer(struct mipi_dbi *dbi, int dc,
 			}
 		}
 
-		tr.len = chunk;
+		tr.len = chunk * 2;
 		len -= chunk;
 
 		ret = spi_sync(spi, &m);
-- 
2.27.0

