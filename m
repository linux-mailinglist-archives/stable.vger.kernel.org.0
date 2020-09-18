Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F294526F248
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgIRC52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbgIRCGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220DE206BE;
        Fri, 18 Sep 2020 02:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394787;
        bh=soD9mfSC5yZAZGe0nPc7J0LkSN9i+t1bMSXV0n6QPQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/CBaejqwMsUM5XzM90vNGl0xVcGMKeZzJl1S9lKAjyps1hJYiApJn7R7Dbzfs9XR
         39hj5COngNJtC3gYc+AwnzJ0M13Wdr/ciSDX8MV02yZFegE2iN4Gx+VWb7bKXccxTa
         g4hQRtMs14m7kv4Y7ofAwNTfnaBueQav1XoeupVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 258/330] i2c: tegra: Restore pinmux on system resume
Date:   Thu, 17 Sep 2020 21:59:58 -0400
Message-Id: <20200918020110.2063155-258-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

