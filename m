Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1716AA705C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfICQio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbfICQ0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAB723878;
        Tue,  3 Sep 2019 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527967;
        bh=gfewWwdTDbQBqIu+m0JTmdBAjfkqtQxUhmsOgkQ5d00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmzVuzfXthnhDFtwU7w3Zu7235ip/2lpBgujsuM0z6Bt2tRS1Xu4vNu1xlbXHprbs
         AQO/veaPlriHRbHezFLjChzHf5Lb8yXpb8IWIRwz5QcdCXU+fmP2dj/T076L854+LK
         A+Ip3clo08JpaoCxCX1I55f12YXmqqpCo/UUBCos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 027/167] ARM: davinci: dm646x: define gpio interrupts as separate resources
Date:   Tue,  3 Sep 2019 12:22:59 -0400
Message-Id: <20190903162519.7136-27-sashal@kernel.org>
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

[ Upstream commit 2c9c83491f30afbce25796e185cd4d5e36080e31 ]

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
 arch/arm/mach-davinci/dm646x.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 6bd2ed069d0d7..d9b93e2806d22 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -442,6 +442,16 @@ static struct resource dm646x_gpio_resources[] = {
 	},
 	{	/* interrupt */
 		.start	= IRQ_DM646X_GPIOBNK0,
+		.end	= IRQ_DM646X_GPIOBNK0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM646X_GPIOBNK1,
+		.end	= IRQ_DM646X_GPIOBNK1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DM646X_GPIOBNK2,
 		.end	= IRQ_DM646X_GPIOBNK2,
 		.flags	= IORESOURCE_IRQ,
 	},
-- 
2.20.1

