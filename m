Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF72191119
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCXNPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgCXNPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:15:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172CF20775;
        Tue, 24 Mar 2020 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055749;
        bh=kj8Aiz461xZA+wkG7vkjclbH830EtJcUQuSZSLkNXdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGB54KwenkNEeqj6UpQqNcowiQQeDJZTwaOAvYa+j82Z4wzaiXArxpENlUikoOvi2
         9H4ReZidaHBvMYaAFYps9sVpeRQjXRr5pCcMtizmLJwL6/6NhszdzWgADOPPnkR6Mh
         J9zFuVqyML114o7v/1Oxwnv4LTSNgAmd3WLFLWLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/102] drm/exynos: hdmi: dont leak enable HDMI_EN regulator if probe fails
Date:   Tue, 24 Mar 2020 14:10:09 +0100
Message-Id: <20200324130808.294391975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 3b6a9b19ab652efac7ad4c392add6f1235019568 ]

Move enabling and disabling HDMI_EN optional regulator to probe() function
to keep track on the regulator status. This fixes following warning if
probe() fails (for example when I2C DDC adapter cannot be yet gathered
due to the missing driver). This fixes following warning observed on
Arndale5250 board with multi_v7_defconfig:

[drm] Failed to get ddc i2c adapter by node
------------[ cut here ]------------
WARNING: CPU: 0 PID: 214 at drivers/regulator/core.c:2051 _regulator_put+0x16c/0x184
Modules linked in: ...
CPU: 0 PID: 214 Comm: systemd-udevd Not tainted 5.6.0-rc2-next-20200219-00040-g38af1dfafdbb #7570
Hardware name: Samsung Exynos (Flattened Device Tree)
[<c0312258>] (unwind_backtrace) from [<c030cc10>] (show_stack+0x10/0x14)
[<c030cc10>] (show_stack) from [<c0f0d3a0>] (dump_stack+0xcc/0xe0)
[<c0f0d3a0>] (dump_stack) from [<c0346a58>] (__warn+0xe0/0xf8)
[<c0346a58>] (__warn) from [<c0346b20>] (warn_slowpath_fmt+0xb0/0xb8)
[<c0346b20>] (warn_slowpath_fmt) from [<c0893f58>] (_regulator_put+0x16c/0x184)
[<c0893f58>] (_regulator_put) from [<c0893f8c>] (regulator_put+0x1c/0x2c)
[<c0893f8c>] (regulator_put) from [<c09b2664>] (release_nodes+0x17c/0x200)
[<c09b2664>] (release_nodes) from [<c09aebe8>] (really_probe+0x10c/0x350)
[<c09aebe8>] (really_probe) from [<c09aefa8>] (driver_probe_device+0x60/0x1a0)
[<c09aefa8>] (driver_probe_device) from [<c09af288>] (device_driver_attach+0x58/0x60)
[<c09af288>] (device_driver_attach) from [<c09af310>] (__driver_attach+0x80/0xbc)
[<c09af310>] (__driver_attach) from [<c09ace34>] (bus_for_each_dev+0x68/0xb4)
[<c09ace34>] (bus_for_each_dev) from [<c09ae00c>] (bus_add_driver+0x130/0x1e8)
[<c09ae00c>] (bus_add_driver) from [<c09afd98>] (driver_register+0x78/0x110)
[<c09afd98>] (driver_register) from [<bf139558>] (exynos_drm_init+0xe8/0x11c [exynosdrm])
[<bf139558>] (exynos_drm_init [exynosdrm]) from [<c0302fa8>] (do_one_initcall+0x50/0x220)
[<c0302fa8>] (do_one_initcall) from [<c03dc02c>] (do_init_module+0x60/0x210)
[<c03dc02c>] (do_init_module) from [<c03daf44>] (load_module+0x1c0c/0x2310)
[<c03daf44>] (load_module) from [<c03db85c>] (sys_finit_module+0xac/0xbc)
[<c03db85c>] (sys_finit_module) from [<c0301000>] (ret_fast_syscall+0x0/0x54)
Exception stack(0xecca3fa8 to 0xecca3ff0)
...
---[ end trace 276c91214635905c ]---

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 09aa73c0f2add..0073a2b3b80a2 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1802,18 +1802,10 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
 
 	hdata->reg_hdmi_en = devm_regulator_get_optional(dev, "hdmi-en");
 
-	if (PTR_ERR(hdata->reg_hdmi_en) != -ENODEV) {
+	if (PTR_ERR(hdata->reg_hdmi_en) != -ENODEV)
 		if (IS_ERR(hdata->reg_hdmi_en))
 			return PTR_ERR(hdata->reg_hdmi_en);
 
-		ret = regulator_enable(hdata->reg_hdmi_en);
-		if (ret) {
-			DRM_DEV_ERROR(dev,
-				      "failed to enable hdmi-en regulator\n");
-			return ret;
-		}
-	}
-
 	return hdmi_bridge_init(hdata);
 }
 
@@ -2020,6 +2012,15 @@ static int hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (!IS_ERR(hdata->reg_hdmi_en)) {
+		ret = regulator_enable(hdata->reg_hdmi_en);
+		if (ret) {
+			DRM_DEV_ERROR(dev,
+			      "failed to enable hdmi-en regulator\n");
+			goto err_hdmiphy;
+		}
+	}
+
 	pm_runtime_enable(dev);
 
 	audio_infoframe = &hdata->audio.infoframe;
@@ -2044,7 +2045,8 @@ static int hdmi_probe(struct platform_device *pdev)
 
 err_rpm_disable:
 	pm_runtime_disable(dev);
-
+	if (!IS_ERR(hdata->reg_hdmi_en))
+		regulator_disable(hdata->reg_hdmi_en);
 err_hdmiphy:
 	if (hdata->hdmiphy_port)
 		put_device(&hdata->hdmiphy_port->dev);
-- 
2.20.1



