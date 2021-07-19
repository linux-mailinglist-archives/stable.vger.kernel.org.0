Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585263CE4B5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbhGSPpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347126AbhGSPlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D5D61166;
        Mon, 19 Jul 2021 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711680;
        bh=kkzpB9mHtqsTDc8yH38cr0ZSYOzrQ8stVA5/0TR9GAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0A4GKi5rTaqacZCn1DHdkQ/ii7ssYjRiR9t1Eyp2dDC48zlA5LtJCxv9en2DxRj2T
         8utbzBdWSsHPJW8Q7jakTwFZVJ+NyOJNsih8UkSfLXfXZmu44wod2tnuXvMvO8MgJw
         312LqRBnJ+bFcyMh5Qpoi8et+MjeAmcambmzkEUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 093/292] gpio: zynq: Check return value of irq_get_irq_data
Date:   Mon, 19 Jul 2021 16:52:35 +0200
Message-Id: <20210719144945.567722837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit 35d7b72a632bc7afb15356f44005554af8697904 ]

In two different instances the return value of "irq_get_irq_data"
API was neither captured nor checked.
Fixed it by capturing the return value and then checking for any error.

Addresses-Coverity: "returned_null"
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index fb8684d70fe3..c288a7502de2 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -736,6 +736,11 @@ static int __maybe_unused zynq_gpio_suspend(struct device *dev)
 	struct zynq_gpio *gpio = dev_get_drvdata(dev);
 	struct irq_data *data = irq_get_irq_data(gpio->irq);
 
+	if (!data) {
+		dev_err(dev, "irq_get_irq_data() failed\n");
+		return -EINVAL;
+	}
+
 	if (!device_may_wakeup(dev))
 		disable_irq(gpio->irq);
 
@@ -753,6 +758,11 @@ static int __maybe_unused zynq_gpio_resume(struct device *dev)
 	struct irq_data *data = irq_get_irq_data(gpio->irq);
 	int ret;
 
+	if (!data) {
+		dev_err(dev, "irq_get_irq_data() failed\n");
+		return -EINVAL;
+	}
+
 	if (!device_may_wakeup(dev))
 		enable_irq(gpio->irq);
 
-- 
2.30.2



