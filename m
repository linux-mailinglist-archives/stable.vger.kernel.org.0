Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDD91A0B90
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgDGK0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgDGK0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1F420644;
        Tue,  7 Apr 2020 10:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255202;
        bh=h2kS5Qz/xwausVLpxQPYmK+Zqwh3u5tCcA85lqQVuNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSJMjtvfpKJKFP9Glmi4p5PCHp39F8W0g/paXkIaWBR+9CnqDnLmArXlayRuR5Ogj
         YF9k5WGdg/CRqU0CojUYg7ILmZCAx46yEFfgnOL6FZZGbOq543eb6ZcKLrQyIejVlb
         hixBCufh8y7hNN3gdW/RtZfYpN2C4Orlp+UIKW3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.6 24/29] extcon: axp288: Add wakeup support
Date:   Tue,  7 Apr 2020 12:22:21 +0200
Message-Id: <20200407101455.026177621@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 9c94553099efb2ba873cbdddfd416a8a09d0e5f1 upstream.

On devices with an AXP288, we need to wakeup from suspend when a charger
is plugged in, so that we can do charger-type detection and so that the
axp288-charger driver, which listens for our extcon events, can configure
the input-current-limit accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-axp288.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -443,9 +443,40 @@ static int axp288_extcon_probe(struct pl
 	/* Start charger cable type detection */
 	axp288_extcon_enable(info);
 
+	device_init_wakeup(dev, true);
+	platform_set_drvdata(pdev, info);
+
+	return 0;
+}
+
+static int __maybe_unused axp288_extcon_suspend(struct device *dev)
+{
+	struct axp288_extcon_info *info = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(info->irq[VBUS_RISING_IRQ]);
+
 	return 0;
 }
 
+static int __maybe_unused axp288_extcon_resume(struct device *dev)
+{
+	struct axp288_extcon_info *info = dev_get_drvdata(dev);
+
+	/*
+	 * Wakeup when a charger is connected to do charger-type
+	 * connection and generate an extcon event which makes the
+	 * axp288 charger driver set the input current limit.
+	 */
+	if (device_may_wakeup(dev))
+		disable_irq_wake(info->irq[VBUS_RISING_IRQ]);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(axp288_extcon_pm_ops, axp288_extcon_suspend,
+			 axp288_extcon_resume);
+
 static const struct platform_device_id axp288_extcon_table[] = {
 	{ .name = "axp288_extcon" },
 	{},
@@ -457,6 +488,7 @@ static struct platform_driver axp288_ext
 	.id_table = axp288_extcon_table,
 	.driver = {
 		.name = "axp288_extcon",
+		.pm = &axp288_extcon_pm_ops,
 	},
 };
 


