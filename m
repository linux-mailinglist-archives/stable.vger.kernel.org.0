Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DB02E1572
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgLWCVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729456AbgLWCVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F69229C5;
        Wed, 23 Dec 2020 02:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690090;
        bh=sjsxwSsEpgt+R52matsY4bZqIscB9zmfputfgVf0/98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBdtIfY5I8wLgeqvf8ZCy9fuyY0MYtLvaBo/dfzAehAEhtiAqrPNEWeRopATyLpP4
         Xugzre6RSRCIuhuVux5YC+15pUINCikJqL5k7E+VScLC8uhi5Om5fBykiHTj+/+79Q
         X63t1/dsWvMFDV2VO2IYOt36T/kWQP8ScaPMo8xn04aOWeF+j14a9VPuuUeZMhI95X
         XkzT9WLthEKEqTRP09zbLwtg2KCmEE0UcgdFguT0gsw4KkStD1D4RY1nb/TOiPqCNg
         M+u3yXvmeTGaf3pqF1y6+n7O7mP77ziqszS8AMekWkphK+33KqH8RNutVfQ+D2baIB
         rtTUuaz0Pn2Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 21/87] drm/omap: Fix runtime PM imbalance on error
Date:   Tue, 22 Dec 2020 21:19:57 -0500
Message-Id: <20201223022103.2792705-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a5d704d33245b0799947a3008f9f376dba4d5c91 ]

pm_runtime_get_sync() increments the runtime PM usage counter
even when it returns an error code. However, users of its
direct wrappers in omapdrm assume that PM usage counter will
not change on error. Thus a pairing decrement is needed on
the error handling path for these wrappers to keep the counter
balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200822065743.13671-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dispc.c | 7 +++++--
 drivers/gpu/drm/omapdrm/dss/dsi.c   | 7 +++++--
 drivers/gpu/drm/omapdrm/dss/dss.c   | 7 +++++--
 drivers/gpu/drm/omapdrm/dss/hdmi4.c | 6 +++---
 drivers/gpu/drm/omapdrm/dss/hdmi5.c | 6 +++---
 drivers/gpu/drm/omapdrm/dss/venc.c  | 7 +++++--
 6 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index 84f274c4a4cbf..9dbe952872785 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -675,8 +675,11 @@ int dispc_runtime_get(struct dispc_device *dispc)
 	DSSDBG("dispc_runtime_get\n");
 
 	r = pm_runtime_get_sync(&dispc->pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(&dispc->pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 void dispc_runtime_put(struct dispc_device *dispc)
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index 8160954ebc257..80e8efcb8acf7 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1143,8 +1143,11 @@ static int dsi_runtime_get(struct dsi_data *dsi)
 	DSSDBG("dsi_runtime_get\n");
 
 	r = pm_runtime_get_sync(dsi->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(dsi->dev);
+		return r;
+	}
+	return 0;
 }
 
 static void dsi_runtime_put(struct dsi_data *dsi)
diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index 7e9e2f0644544..9db2454b25488 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -878,8 +878,11 @@ int dss_runtime_get(struct dss_device *dss)
 	DSSDBG("dss_runtime_get\n");
 
 	r = pm_runtime_get_sync(&dss->pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(&dss->pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 void dss_runtime_put(struct dss_device *dss)
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index 5879f45f6fc9b..38bdf50d39a58 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -52,10 +52,10 @@ static int hdmi_runtime_get(struct omap_hdmi *hdmi)
 	DSSDBG("hdmi_runtime_get\n");
 
 	r = pm_runtime_get_sync(&hdmi->pdev->dev);
-	WARN_ON(r < 0);
-	if (r < 0)
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(&hdmi->pdev->dev);
 		return r;
-
+	}
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi5.c b/drivers/gpu/drm/omapdrm/dss/hdmi5.c
index ae1a001d1b838..16f33aa5ad185 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi5.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi5.c
@@ -53,10 +53,10 @@ static int hdmi_runtime_get(struct omap_hdmi *hdmi)
 	DSSDBG("hdmi_runtime_get\n");
 
 	r = pm_runtime_get_sync(&hdmi->pdev->dev);
-	WARN_ON(r < 0);
-	if (r < 0)
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(&hdmi->pdev->dev);
 		return r;
-
+	}
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/omapdrm/dss/venc.c b/drivers/gpu/drm/omapdrm/dss/venc.c
index ac01907dcc345..9ef2942d938fd 100644
--- a/drivers/gpu/drm/omapdrm/dss/venc.c
+++ b/drivers/gpu/drm/omapdrm/dss/venc.c
@@ -438,8 +438,11 @@ static int venc_runtime_get(struct venc_device *venc)
 	DSSDBG("venc_runtime_get\n");
 
 	r = pm_runtime_get_sync(&venc->pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_noidle(&venc->pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 static void venc_runtime_put(struct venc_device *venc)
-- 
2.27.0

