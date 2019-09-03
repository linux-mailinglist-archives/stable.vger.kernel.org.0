Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D371A6E6C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbfICQ0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbfICQ0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9CE238CE;
        Tue,  3 Sep 2019 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527969;
        bh=plF5iuZgX7U6b2kvIKYefoXXR8ZqV0zxgADx6/YTaiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+1fxh70DB5RQCDnPXpQNRhOoPkrOXgQ7o6VYb4tUD8qDYKLIs6C+9mr8Mv1T68YM
         LnEQr1l4RUIAINnL6ATv91zEAwrhxB9oPZX2vYDejU/VrEBAgQpYkiwytx5N3jzRmA
         0T7BCopGOpms6t4R496kzttBnEJBLhlDE2E0iBCk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 029/167] ARM: davinci: dm644x: define gpio interrupts as separate resources
Date:   Tue,  3 Sep 2019 12:23:01 -0400
Message-Id: <20190903162519.7136-29-sashal@kernel.org>
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

[ Upstream commit adcf60ce14c8250761af9de907eb6c7d096c26d3 ]

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
 arch/arm/mach-davinci/dm644x.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 0720da7809a69..de1ec6dc01e94 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -492,6 +492,26 @@ static struct resource dm644_gpio_resources[] = {
 	},
 	{	/* interrupt */
 		.start	= IRQ_GPIOBNK0,
+		.end	= IRQ_GPIOBNK0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_GPIOBNK1,
+		.end	= IRQ_GPIOBNK1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_GPIOBNK2,
+		.end	= IRQ_GPIOBNK2,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_GPIOBNK3,
+		.end	= IRQ_GPIOBNK3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_GPIOBNK4,
 		.end	= IRQ_GPIOBNK4,
 		.flags	= IORESOURCE_IRQ,
 	},
-- 
2.20.1

