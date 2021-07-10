Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5293C2F50
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhGJCbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhGJC3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A9861430;
        Sat, 10 Jul 2021 02:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883947;
        bh=kkzpB9mHtqsTDc8yH38cr0ZSYOzrQ8stVA5/0TR9GAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1Ky3r4KF8Qu3tISqr/sKNNEzZPzrSmi32ZHudi5tS1VZlJ06Pdib+XmqN+EwLhz9
         yEoZ+lZI/9JZg5VZEhVIFnJs+XINeHh8/W3JSC+m7qsjDLFDdbWgpwZ3biR4jiMn8+
         YoEiL6UoBzQf6KbQa5cBZzqcBTh4mU6qDknFLhrKcwhFAOVES+dkUWl2Cni/B2B3DI
         zIoYUrGleeafcya0rdNRQ1MwaARt2Rjyzepmht9qOqtlvi4OsdmLqDqyA+tljF/9mE
         km/ZrbojdvshIM5cKn54+pYdot5cuhTzujWSPW2XfvrKnJVk8ooAM5D93oN7fwpcGf
         LqOoCcp5qbj3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 60/93] gpio: zynq: Check return value of irq_get_irq_data
Date:   Fri,  9 Jul 2021 22:23:54 -0400
Message-Id: <20210710022428.3169839-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

