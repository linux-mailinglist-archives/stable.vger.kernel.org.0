Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D155B17FB90
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbgCJNPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731967AbgCJNPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C032468F;
        Tue, 10 Mar 2020 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846103;
        bh=K8Y8jh5uSqqUInp3L/Zt9bBTpRRZKPPFsxSSKmpoX2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8kAhxinDBBn1cddXHK4RMB7cbIq2H13NNDJ0Yeaj6QfmtkFiLB6Yf4hYywj11sHa
         /rqdH/+BVlfRa49ipNzV7KRP9/yBizhxN4m4fB5M3if1BODgdlXpHkTxxCi2cZu9pQ
         HC/imQq5UR5mzhWrNevkJfU+LXPVz/KFUSbR+crc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Partap <mpartap@gmx.net>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Michael Scott <hashcode0f@gmail.com>,
        NeKit <nekit1000@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 4.19 70/86] phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling
Date:   Tue, 10 Mar 2020 13:45:34 +0100
Message-Id: <20200310124534.553979393@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit be4e3c737eebd75815633f4b8fd766defaf0f1fc upstream.

We have an interrupt handler for the wake-up GPIO pin, but we're missing
the code to wake-up the system. This can cause timeouts receiving data
for the UART that shares the wake-up GPIO pin with the USB PHY.

All we need to do is just wake the system and kick the autosuspend
timeout to fix the issue.

Fixes: 5d1ebbda0318 ("phy: mapphone-mdm6600: Add USB PHY driver for MDM6600 on Droid 4")
Cc: Marcel Partap <mpartap@gmx.net>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Michael Scott <hashcode0f@gmail.com>
Cc: NeKit <nekit1000@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/motorola/phy-mapphone-mdm6600.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -224,10 +224,24 @@ static irqreturn_t phy_mdm6600_wakeirq_t
 {
 	struct phy_mdm6600 *ddata = data;
 	struct gpio_desc *mode_gpio1;
+	int error, wakeup;
 
 	mode_gpio1 = ddata->mode_gpios->desc[PHY_MDM6600_MODE1];
-	dev_dbg(ddata->dev, "OOB wake on mode_gpio1: %i\n",
-		gpiod_get_value(mode_gpio1));
+	wakeup = gpiod_get_value(mode_gpio1);
+	if (!wakeup)
+		return IRQ_NONE;
+
+	dev_dbg(ddata->dev, "OOB wake on mode_gpio1: %i\n", wakeup);
+	error = pm_runtime_get_sync(ddata->dev);
+	if (error < 0) {
+		pm_runtime_put_noidle(ddata->dev);
+
+		return IRQ_NONE;
+	}
+
+	/* Just wake-up and kick the autosuspend timer */
+	pm_runtime_mark_last_busy(ddata->dev);
+	pm_runtime_put_autosuspend(ddata->dev);
 
 	return IRQ_HANDLED;
 }


