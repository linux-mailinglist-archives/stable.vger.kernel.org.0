Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2DBB1ED9
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfIMNNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389319AbfIMNNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:25 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA58208C0;
        Fri, 13 Sep 2019 13:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380404;
        bh=O/eJkoX0EluawxXyzZ/kpihm0tQRxYaP8Km5fqzNr9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnVtaaLsQswW2ykvm+EdbgmndcAWqVFVoDQ+5RAT3C/zNCZ+ZvRrAxA51k23UKBFs
         m1Ipx0ctkb6E+10jp9SdsTGiYOmd0af9+wTWq8sCTeAZ0J+26UVRym4MlLObQlF2z0
         n9zMkxB6PjzM6r8gkk+750BtRe4kuwW2z3vlVecY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/190] ARM: davinci: da8xx: define gpio interrupts as separate resources
Date:   Fri, 13 Sep 2019 14:05:09 +0100
Message-Id: <20190913130604.087293545@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58a0afbf4c99ac355df16773af835b919b9432ee ]

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
 arch/arm/mach-davinci/devices-da8xx.c | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 3c42bf9fa0618..708931b470909 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -704,6 +704,46 @@ static struct resource da8xx_gpio_resources[] = {
 	},
 	{ /* interrupt */
 		.start	= IRQ_DA8XX_GPIO0,
+		.end	= IRQ_DA8XX_GPIO0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO1,
+		.end	= IRQ_DA8XX_GPIO1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO2,
+		.end	= IRQ_DA8XX_GPIO2,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO3,
+		.end	= IRQ_DA8XX_GPIO3,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO4,
+		.end	= IRQ_DA8XX_GPIO4,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO5,
+		.end	= IRQ_DA8XX_GPIO5,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO6,
+		.end	= IRQ_DA8XX_GPIO6,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO7,
+		.end	= IRQ_DA8XX_GPIO7,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= IRQ_DA8XX_GPIO8,
 		.end	= IRQ_DA8XX_GPIO8,
 		.flags	= IORESOURCE_IRQ,
 	},
-- 
2.20.1



