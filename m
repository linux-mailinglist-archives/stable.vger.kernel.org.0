Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBCF246AEB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387720AbgHQPoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgHQPox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:44:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2578E20760;
        Mon, 17 Aug 2020 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679092;
        bh=6LmQh1e/NqQGj+89BAr9m4CJNhDun1U7OdbG+iIs+F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCpjSdask3j1fEVRsynAT/3RqHCz5QMDMEC7f+eAEOUJ2kHMY9fozKjYWK5tArVUQ
         NkPdhNX8smORJENcq1ga8E70HDu1x+q1lSJMys9PgFjG2tkuVLpj+9oWkawKqUrejI
         wS0ABZ/ikZadYv5QQd1Jv6LHuQ37DXije10Stbb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/393] drm/tilcdc: fix leak & null ref in panel_connector_get_modes
Date:   Mon, 17 Aug 2020 17:11:53 +0200
Message-Id: <20200817143822.688249282@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit 3f9c1c872cc97875ddc8d63bc9fe6ee13652b933 ]

If videomode_from_timings() returns true, the mode allocated with
drm_mode_create will be leaked.

Also, the return value of drm_mode_create() is never checked, and thus
could cause NULL deref.

Fix these two issues.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200429104234.18910-1-tomi.valkeinen@ti.com
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 5584e656b8575..8c4fd1aa4c2db 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -143,12 +143,16 @@ static int panel_connector_get_modes(struct drm_connector *connector)
 	int i;
 
 	for (i = 0; i < timings->num_timings; i++) {
-		struct drm_display_mode *mode = drm_mode_create(dev);
+		struct drm_display_mode *mode;
 		struct videomode vm;
 
 		if (videomode_from_timings(timings, &vm, i))
 			break;
 
+		mode = drm_mode_create(dev);
+		if (!mode)
+			break;
+
 		drm_display_mode_from_videomode(&vm, mode);
 
 		mode->type = DRM_MODE_TYPE_DRIVER;
-- 
2.25.1



