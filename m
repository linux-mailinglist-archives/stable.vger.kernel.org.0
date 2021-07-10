Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2FE3C2D6B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhGJCWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232838AbhGJCWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC18613EB;
        Sat, 10 Jul 2021 02:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883564;
        bh=kkzpB9mHtqsTDc8yH38cr0ZSYOzrQ8stVA5/0TR9GAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8sOlP1CUkMI4+1aiOYKardLXNHxFqXc1aQb8CijYedy/uXj4MEt9+9B0Y9bCMyPc
         30j/qHEthC/itO3lEuJt95JRp2rL8P59l1RNIHENvvmr8D6Wxsl+1Ip9WyhWGDTtuR
         tkleF4X3PoWSYgowU74/pbPwSkpritRM3+MMGiV0f729wC0rn/FCpeZ0uYSBC07W7O
         k8CX5Ra//OGrKnvUWQnm0Kh9MzjvqaA0N0hquJAJjZcZh7rvbXf1hlsRC7acx41/Vd
         0L1nlmhz/a+HHYZZGn+oZhxXkkfNwHiMtjogSy80qTVNd0hgZLeiYkoQNPKWCvONv7
         +DKoeDUvTsDUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 071/114] gpio: zynq: Check return value of irq_get_irq_data
Date:   Fri,  9 Jul 2021 22:17:05 -0400
Message-Id: <20210710021748.3167666-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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

