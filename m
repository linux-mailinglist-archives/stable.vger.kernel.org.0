Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641CF17FA54
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgCJNCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgCJNCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C432468D;
        Tue, 10 Mar 2020 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845353;
        bh=u1tL22Oa8Lt3kR4tVCpS9TqfnburU/QugzCbNdKVgIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvvCMq7W91hJjJpDq3wcXF2waw0SFMOCdh5doLUdcTot8dhKjjni8p66G3apjfVBd
         JCAcJmL06Q6MuEmtt/ekGj8YOMBjaNP/f9NDS62HU8YynDs7vcfahc1+hnHe3iT6Y7
         8Pn5f4B9hIr8IAZ5S+lgzOvfVyw3h8eldGJcZPkE=
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
Subject: [PATCH 5.5 151/189] phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling
Date:   Tue, 10 Mar 2020 13:39:48 +0100
Message-Id: <20200310123655.153465134@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
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
@@ -243,10 +243,24 @@ static irqreturn_t phy_mdm6600_wakeirq_t
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


