Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4AFA703B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfICQ0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730552AbfICQ0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 094A2238F7;
        Tue,  3 Sep 2019 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527968;
        bh=uMd4uvtbW1da0rDmTqsS1XFemtGN5vLwCY0w0LqKhqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wi7/rw8Im/TGo7uBIVHFmx0lnDkD+iVnjlAwEKJNSKOv9onF1AlDoE5H7hC29DsCl
         1d/tr9wJrAnCcJDZA+6KsbxEKlywzFEhJ0VL5aK/cTcw2pkiqx2C0KLLKOyx47YTEk
         6vX4dL+iiOOmFF3FFhxQ5dPSqHnuR5cOiPoQ1RkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 028/167] ARM: davinci: dm355: define gpio interrupts as separate resources
Date:   Tue,  3 Sep 2019 12:23:00 -0400
Message-Id: <20190903162519.7136-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 27db7baab640ea28d7994eda943fef170e347081 ]

Since commit eb3744a2dd01 ("gpio: davinci: Do not assume continuous
IRQ numbering") the davinci GPIO driver fails to probe if we boot
in legacy mode from any of the board files. Since the driver now
expects every interrupt to be defined as a separate resource, split
the definition of IRQ resources instead of having a single continuous
interrupt range.

Fixes: eb3744a2dd01 ("gpio: davinci: Do not assume continuous IRQ numbering")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/dm355.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 9f7d38d12c888..2b0f5d97ab7c1 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -548,6 +548,36 @@ static struct resource dm355_gpio_resources[] = {
 	},
 	{	/* interrupt */
 		.start	= IRQ_DM355_GPIOBNK0,
+		.end	= IRQ_DM355_GPIOBNK0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK1,
+		.end	= IRQ_DM355_GPIOBNK1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK2,
+		.end	= IRQ_DM355_GPIOBNK2,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK3,
+		.end	= IRQ_DM355_GPIOBNK3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK4,
+		.end	= IRQ_DM355_GPIOBNK4,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK5,
+		.end	= IRQ_DM355_GPIOBNK5,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM355_GPIOBNK6,
 		.end	= IRQ_DM355_GPIOBNK6,
 		.flags	= IORESOURCE_IRQ,
 	},
-- 
2.20.1

