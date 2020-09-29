Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3915427C612
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgI2Ll3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbgI2LlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947E22065C;
        Tue, 29 Sep 2020 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379675;
        bh=soD9mfSC5yZAZGe0nPc7J0LkSN9i+t1bMSXV0n6QPQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEkWaJsntux2PF7+qInB5xfKzcQbHANVbtxkHRyeyg3vGuxk5efKX97AmQS4iUERM
         tJ/GsPuKvnK8S5VbtjR9S/6cRucyKOqfnn6WLWALWQ/2pa1me7IcCB5wAPtCx3t9m/
         1JMhbLBPCCnNzyij2TyTJw3ZXZwSQpIrcereZaZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/388] i2c: tegra: Restore pinmux on system resume
Date:   Tue, 29 Sep 2020 12:59:42 +0200
Message-Id: <20200929110022.632744646@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 44c99904cf61f945d02ac9976ab10dd5ccaea393 ]

Depending on the board design, the I2C controllers found on Tegra SoCs
may require pinmuxing in order to function. This is done as part of the
driver's runtime suspend/resume operations. However, the PM core does
not allow devices to go into runtime suspend during system sleep to
avoid potential races with the suspend/resume of their parents.

As a result of this, when Tegra SoCs resume from system suspend, their
I2C controllers may have lost the pinmux state in hardware, whereas the
pinctrl subsystem is not aware of this. To fix this, make sure that if
the I2C controller is not runtime suspended, the runtime suspend code is
still executed in order to disable the module clock (which we don't need
to be enabled during sleep) and set the pinmux to the idle state.

Conversely, make sure that the I2C controller is properly resumed when
waking up from sleep so that pinmux settings are properly restored.

This fixes a bug seen with DDC transactions to an HDMI monitor timing
out when resuming from system suspend.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 5ca72fb0b406c..db94e96aed77e 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1721,10 +1721,14 @@ static int tegra_i2c_remove(struct platform_device *pdev)
 static int __maybe_unused tegra_i2c_suspend(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
+	int err = 0;
 
 	i2c_mark_adapter_suspended(&i2c_dev->adapter);
 
-	return 0;
+	if (!pm_runtime_status_suspended(dev))
+		err = tegra_i2c_runtime_suspend(dev);
+
+	return err;
 }
 
 static int __maybe_unused tegra_i2c_resume(struct device *dev)
@@ -1732,6 +1736,10 @@ static int __maybe_unused tegra_i2c_resume(struct device *dev)
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 	int err;
 
+	/*
+	 * We need to ensure that clocks are enabled so that registers can be
+	 * restored in tegra_i2c_init().
+	 */
 	err = tegra_i2c_runtime_resume(dev);
 	if (err)
 		return err;
@@ -1740,9 +1748,16 @@ static int __maybe_unused tegra_i2c_resume(struct device *dev)
 	if (err)
 		return err;
 
-	err = tegra_i2c_runtime_suspend(dev);
-	if (err)
-		return err;
+	/*
+	 * In case we are runtime suspended, disable clocks again so that we
+	 * don't unbalance the clock reference counts during the next runtime
+	 * resume transition.
+	 */
+	if (pm_runtime_status_suspended(dev)) {
+		err = tegra_i2c_runtime_suspend(dev);
+		if (err)
+			return err;
+	}
 
 	i2c_mark_adapter_resumed(&i2c_dev->adapter);
 
-- 
2.25.1



