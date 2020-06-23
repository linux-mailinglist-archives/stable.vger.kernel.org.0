Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21CC2062AD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbgFWVGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391191AbgFWUfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:35:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0CD92080C;
        Tue, 23 Jun 2020 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944548;
        bh=VIgcKFJfZUxNL2vbTVk81GcTZ32sCX90KI6LnC7d7OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4nqnCQqZ1SWxWQm+5PTDOSte70qnAIrBkJ9f3udYTqdZhJp8xFM7XNDcZCPJ/lyN
         WThSbR4KH+BSJsStsurzGbNJw69mnJlDgwoWo0DxMF9YKCWXPnJf4wOl6sL3vCQqjO
         sYJhDc241OU8M48nWLCKpOIftaELAC5gZRjNQin4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/206] backlight: lp855x: Ensure regulators are disabled on probe failure
Date:   Tue, 23 Jun 2020 21:55:36 +0200
Message-Id: <20200623195317.350184050@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit d8207c155a7c6015eb7f43739baa7dfb1fa638af ]

If probing the LP885x backlight fails after the regulators have been
enabled, then the following warning is seen when releasing the
regulators ...

 WARNING: CPU: 1 PID: 289 at drivers/regulator/core.c:2051 _regulator_put.part.28+0x158/0x160
 Modules linked in: tegra_xudc lp855x_bl(+) host1x pwm_tegra ip_tables x_tables ipv6 nf_defrag_ipv6
 CPU: 1 PID: 289 Comm: systemd-udevd Not tainted 5.6.0-rc2-next-20200224 #1
 Hardware name: NVIDIA Jetson TX1 Developer Kit (DT)

 ...

 Call trace:
  _regulator_put.part.28+0x158/0x160
  regulator_put+0x34/0x50
  devm_regulator_release+0x10/0x18
  release_nodes+0x12c/0x230
  devres_release_all+0x34/0x50
  really_probe+0x1c0/0x370
  driver_probe_device+0x58/0x100
  device_driver_attach+0x6c/0x78
  __driver_attach+0xb0/0xf0
  bus_for_each_dev+0x68/0xc8
  driver_attach+0x20/0x28
  bus_add_driver+0x160/0x1f0
  driver_register+0x60/0x110
  i2c_register_driver+0x40/0x80
  lp855x_driver_init+0x20/0x1000 [lp855x_bl]
  do_one_initcall+0x58/0x1a0
  do_init_module+0x54/0x1d0
  load_module+0x1d80/0x21c8
  __do_sys_finit_module+0xe8/0x100
  __arm64_sys_finit_module+0x18/0x20
  el0_svc_common.constprop.3+0xb0/0x168
  do_el0_svc+0x20/0x98
  el0_sync_handler+0xf4/0x1b0
  el0_sync+0x140/0x180

Fix this by ensuring that the regulators are disabled, if enabled, on
probe failure.

Finally, ensure that the vddio regulator is disabled in the driver
remove handler.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lp855x_bl.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 73612485ed07e..bd43d8cff389c 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -460,7 +460,7 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		ret = regulator_enable(lp->enable);
 		if (ret < 0) {
 			dev_err(lp->dev, "failed to enable vddio: %d\n", ret);
-			return ret;
+			goto disable_supply;
 		}
 
 		/*
@@ -475,24 +475,34 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	ret = lp855x_configure(lp);
 	if (ret) {
 		dev_err(lp->dev, "device config err: %d", ret);
-		return ret;
+		goto disable_vddio;
 	}
 
 	ret = lp855x_backlight_register(lp);
 	if (ret) {
 		dev_err(lp->dev,
 			"failed to register backlight. err: %d\n", ret);
-		return ret;
+		goto disable_vddio;
 	}
 
 	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
 	if (ret) {
 		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
-		return ret;
+		goto disable_vddio;
 	}
 
 	backlight_update_status(lp->bl);
+
 	return 0;
+
+disable_vddio:
+	if (lp->enable)
+		regulator_disable(lp->enable);
+disable_supply:
+	if (lp->supply)
+		regulator_disable(lp->supply);
+
+	return ret;
 }
 
 static int lp855x_remove(struct i2c_client *cl)
@@ -501,6 +511,8 @@ static int lp855x_remove(struct i2c_client *cl)
 
 	lp->bl->props.brightness = 0;
 	backlight_update_status(lp->bl);
+	if (lp->enable)
+		regulator_disable(lp->enable);
 	if (lp->supply)
 		regulator_disable(lp->supply);
 	sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
-- 
2.25.1



