Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD67E491402
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiARCTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244343AbiARCTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:19:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AECC06173E;
        Mon, 17 Jan 2022 18:19:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B51612CD;
        Tue, 18 Jan 2022 02:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5466C36AF3;
        Tue, 18 Jan 2022 02:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472388;
        bh=FWew8kSA0PCwrUkOdUPtZ3rD8Vs0Xt6T0HP/cCKVwJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wzc3eJNLixafRolNgvkGXQstCaolP7toR98BMEa1/akRVgL56CE0D1++f5O4CjJIo
         vxrR2qY5qFp51hO3fnAI7VqU5f2DTaJhpq5A7ij0kt40ZYN5in7G/6wtXAbOxdsJIP
         Fp9K0M32bw0LnMsAGW9U3pemySll/DUzepaXHd2vBiXZpAsZl4yETFkxSKHm5XvFnp
         CrvssIEUYdeWXgrGYzj8V/DzFKNvyi9kJm5F7ltUo+MZAeSd7bYBlKhhaXu6HgW6QF
         mybztwKNe4fcS+x81UBmNGzc1hWo9nYW8GydR0F/YK3mwulioxrQyamrS3+WZi1TeC
         4eLoFeRy0hPkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>, jagan@amarulasolutions.com,
        thierry.reding@gmail.com, airlied@linux.ie, daniel@ffwll.ch,
        sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 004/217] drm/panel: Delete panel on mipi_dsi_attach() failure
Date:   Mon, 17 Jan 2022 21:16:07 -0500
Message-Id: <20220118021940.1942199-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 9bf7123bb07f98dc76acb5daa91248e6f95713cb ]

Many DSI panel drivers fail to clean up their panel references on
mipi_dsi_attach() failure, so we're leaving a dangling drm_panel
reference to freed memory. Clean that up on failure.

Noticed by inspection, after seeing similar problems on other drivers.
Therefore, I'm not marking Fixes/stable.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210923173336.3.If9e74fa9b1d6eaa9e0e5b95b2b957b992740251c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c    | 8 +++++++-
 drivers/gpu/drm/panel/panel-jdi-lt070me05000.c           | 8 +++++++-
 drivers/gpu/drm/panel/panel-novatek-nt36672a.c           | 8 +++++++-
 drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c     | 8 +++++++-
 drivers/gpu/drm/panel/panel-ronbo-rb070d30.c             | 8 +++++++-
 drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c | 1 +
 drivers/gpu/drm/panel/panel-samsung-sofef00.c            | 1 +
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c          | 8 +++++++-
 8 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c b/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
index 581661b506f81..f9c1f7bc8218c 100644
--- a/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
+++ b/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
@@ -227,7 +227,13 @@ static int feiyang_dsi_probe(struct mipi_dsi_device *dsi)
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->lanes = 4;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		drm_panel_remove(&ctx->panel);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int feiyang_dsi_remove(struct mipi_dsi_device *dsi)
diff --git a/drivers/gpu/drm/panel/panel-jdi-lt070me05000.c b/drivers/gpu/drm/panel/panel-jdi-lt070me05000.c
index 733010b5e4f53..3c86ad262d5e0 100644
--- a/drivers/gpu/drm/panel/panel-jdi-lt070me05000.c
+++ b/drivers/gpu/drm/panel/panel-jdi-lt070me05000.c
@@ -473,7 +473,13 @@ static int jdi_panel_probe(struct mipi_dsi_device *dsi)
 	if (ret < 0)
 		return ret;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		jdi_panel_del(jdi);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int jdi_panel_remove(struct mipi_dsi_device *dsi)
diff --git a/drivers/gpu/drm/panel/panel-novatek-nt36672a.c b/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
index 533cd3934b8b7..839b263fb3c0f 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
@@ -656,7 +656,13 @@ static int nt36672a_panel_probe(struct mipi_dsi_device *dsi)
 	if (err < 0)
 		return err;
 
-	return mipi_dsi_attach(dsi);
+	err = mipi_dsi_attach(dsi);
+	if (err < 0) {
+		drm_panel_remove(&pinfo->base);
+		return err;
+	}
+
+	return 0;
 }
 
 static int nt36672a_panel_remove(struct mipi_dsi_device *dsi)
diff --git a/drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c b/drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c
index 3c20beeb17819..3991f5d950af4 100644
--- a/drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c
+++ b/drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c
@@ -241,7 +241,13 @@ static int wuxga_nt_panel_probe(struct mipi_dsi_device *dsi)
 	if (ret < 0)
 		return ret;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		wuxga_nt_panel_del(wuxga_nt);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int wuxga_nt_panel_remove(struct mipi_dsi_device *dsi)
diff --git a/drivers/gpu/drm/panel/panel-ronbo-rb070d30.c b/drivers/gpu/drm/panel/panel-ronbo-rb070d30.c
index a3782830ae3c4..1fb579a574d9f 100644
--- a/drivers/gpu/drm/panel/panel-ronbo-rb070d30.c
+++ b/drivers/gpu/drm/panel/panel-ronbo-rb070d30.c
@@ -199,7 +199,13 @@ static int rb070d30_panel_dsi_probe(struct mipi_dsi_device *dsi)
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->lanes = 4;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		drm_panel_remove(&ctx->panel);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int rb070d30_panel_dsi_remove(struct mipi_dsi_device *dsi)
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c b/drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c
index ea63799ff2a1e..29fde3823212b 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c
@@ -247,6 +247,7 @@ static int s6e88a0_ams452ef01_probe(struct mipi_dsi_device *dsi)
 	ret = mipi_dsi_attach(dsi);
 	if (ret < 0) {
 		dev_err(dev, "Failed to attach to DSI host: %d\n", ret);
+		drm_panel_remove(&ctx->panel);
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/panel/panel-samsung-sofef00.c b/drivers/gpu/drm/panel/panel-samsung-sofef00.c
index 8cb1853574bb8..6d107e14fcc55 100644
--- a/drivers/gpu/drm/panel/panel-samsung-sofef00.c
+++ b/drivers/gpu/drm/panel/panel-samsung-sofef00.c
@@ -302,6 +302,7 @@ static int sofef00_panel_probe(struct mipi_dsi_device *dsi)
 	ret = mipi_dsi_attach(dsi);
 	if (ret < 0) {
 		dev_err(dev, "Failed to attach to DSI host: %d\n", ret);
+		drm_panel_remove(&ctx->panel);
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
index b937e24dac8e0..25829a0a8e801 100644
--- a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
+++ b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
@@ -296,7 +296,13 @@ static int sharp_nt_panel_probe(struct mipi_dsi_device *dsi)
 	if (ret < 0)
 		return ret;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		sharp_nt_panel_del(sharp_nt);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int sharp_nt_panel_remove(struct mipi_dsi_device *dsi)
-- 
2.34.1

