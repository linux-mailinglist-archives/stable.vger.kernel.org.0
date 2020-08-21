Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE58524DD61
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHURQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgHUQQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22DAF22B4B;
        Fri, 21 Aug 2020 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026591;
        bh=gyOlkQURNkZvXeZvqUwTJ18Ftp1jHejsTw6kRIdH8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVVFh1PmwSNkntZbhTjEXfqEiQERt4VDuI3BsOoJ+0inVEf4aGG8rojBynbHbwmMO
         d0DAsNEVFWcxKps0rvytkd5ltMlFpSUnCpADmy6CO9ZvBJUOPMWsS8L2++F1CovNc8
         6Y8tXZjLfC8R4acbuEBHwauGB8iNHwDEreY8BCq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, kjlu@umn.edu, wu000273@umn.edu,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Enrico Weigelt <info@metux.net>,
        "Andrew F. Davis" <afd@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 36/61] omapfb: fix multiple reference count leaks due to pm_runtime_get_sync
Date:   Fri, 21 Aug 2020 12:15:20 -0400
Message-Id: <20200821161545.347622-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 78c2ce9bde70be5be7e3615a2ae7024ed8173087 ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
reference count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu
Cc: wu000273@umn.edu
Cc: Allison Randal <allison@lohutok.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Enrico Weigelt <info@metux.net>
cc: "Andrew F. Davis" <afd@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200614030528.128064-1-pakki001@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c | 7 +++++--
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c   | 7 +++++--
 drivers/video/fbdev/omap2/omapfb/dss/dss.c   | 7 +++++--
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c | 5 +++--
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c | 5 +++--
 drivers/video/fbdev/omap2/omapfb/dss/venc.c  | 7 +++++--
 6 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
index ce37da85cc458..5d7daec9b1e72 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
@@ -520,8 +520,11 @@ int dispc_runtime_get(void)
 	DSSDBG("dispc_runtime_get\n");
 
 	r = pm_runtime_get_sync(&dispc.pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&dispc.pdev->dev);
+		return r;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(dispc_runtime_get);
 
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index d620376216e1d..6f9c25fec9946 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -1137,8 +1137,11 @@ static int dsi_runtime_get(struct platform_device *dsidev)
 	DSSDBG("dsi_runtime_get\n");
 
 	r = pm_runtime_get_sync(&dsi->pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&dsi->pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 static void dsi_runtime_put(struct platform_device *dsidev)
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
index bfc5c4c5a26ad..a6b1c1598040d 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
@@ -768,8 +768,11 @@ int dss_runtime_get(void)
 	DSSDBG("dss_runtime_get\n");
 
 	r = pm_runtime_get_sync(&dss.pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&dss.pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 void dss_runtime_put(void)
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c
index 7060ae56c062c..4804aab342981 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c
@@ -39,9 +39,10 @@ static int hdmi_runtime_get(void)
 	DSSDBG("hdmi_runtime_get\n");
 
 	r = pm_runtime_get_sync(&hdmi.pdev->dev);
-	WARN_ON(r < 0);
-	if (r < 0)
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&hdmi.pdev->dev);
 		return r;
+	}
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c b/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c
index ac49531e47327..a06b6f1355bdb 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c
@@ -43,9 +43,10 @@ static int hdmi_runtime_get(void)
 	DSSDBG("hdmi_runtime_get\n");
 
 	r = pm_runtime_get_sync(&hdmi.pdev->dev);
-	WARN_ON(r < 0);
-	if (r < 0)
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&hdmi.pdev->dev);
 		return r;
+	}
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/venc.c b/drivers/video/fbdev/omap2/omapfb/dss/venc.c
index f81e2a46366dd..3717dac3dcc83 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/venc.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/venc.c
@@ -391,8 +391,11 @@ static int venc_runtime_get(void)
 	DSSDBG("venc_runtime_get\n");
 
 	r = pm_runtime_get_sync(&venc.pdev->dev);
-	WARN_ON(r < 0);
-	return r < 0 ? r : 0;
+	if (WARN_ON(r < 0)) {
+		pm_runtime_put_sync(&venc.pdev->dev);
+		return r;
+	}
+	return 0;
 }
 
 static void venc_runtime_put(void)
-- 
2.25.1

