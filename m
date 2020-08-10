Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A4240D70
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHJTJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgHJTJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950BD2078D;
        Mon, 10 Aug 2020 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086541;
        bh=n4+rbEnu5fyOcSLZHKIsQ0tr72OZykSW/pXLx9Eq//Q=;
        h=From:To:Cc:Subject:Date:From;
        b=dQm01KV9A2ZGjb5PodPHXTZ1dLV+e4mfHDfVWWf52Ev9lj0RpWP+xR06hZ2qvvKSl
         FJZitIPfeCLMiPyzcqHbf7hfKEhcI6xujWU1YHZcNTA6jIsnIRTJgIsHeOU9lKIUUR
         gdKyfsrMs5GF8HTlbgPo2xb2W73JCvueY2NzOLE0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>, Jyri Sarha <jsarha@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 01/64] drm/tilcdc: fix leak & null ref in panel_connector_get_modes
Date:   Mon, 10 Aug 2020 15:07:56 -0400
Message-Id: <20200810190859.3793319-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 12823d60c4e89..4be53768f0146 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -139,12 +139,16 @@ static int panel_connector_get_modes(struct drm_connector *connector)
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

