Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3235DCA63F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405032AbfJCQle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405045AbfJCQlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AEA620830;
        Thu,  3 Oct 2019 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120891;
        bh=0UFRwrVqMUuMsxtnEtdiDjvOApLR5fVd8zynEbyvw2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BB8nRSI7hAQVc/mXf0+/4RoP7yy0VTn5LczjK9SlO3jbcf8KTwOOe8Q8zJHbLHPg
         5n/n6dwLXivVT+sh2aImb1NEfhEGRbYU9mG89mV4ooc/gm9veDB0RbdOvphKqGOIj8
         a1sNdIQGdMkJAnYHtrsyGJM9/4HMlqBFNPiJVyU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 077/344] gpio: madera: Add support for Cirrus Logic CS47L92
Date:   Thu,  3 Oct 2019 17:50:42 +0200
Message-Id: <20191003154547.748478547@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 74d2d0e68701bcd53d2cf771dd3b3cb9f84bed5c ]

As the gpio is common to all madera codecs all that is needed
is to setup the correct number of GPIO pins for the CS47L92.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20190722090748.20807-4-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-madera.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-madera.c b/drivers/gpio/gpio-madera.c
index 19db5a500eb0d..be963113f6722 100644
--- a/drivers/gpio/gpio-madera.c
+++ b/drivers/gpio/gpio-madera.c
@@ -150,6 +150,11 @@ static int madera_gpio_probe(struct platform_device *pdev)
 	case CS47L91:
 		madera_gpio->gpio_chip.ngpio = CS47L90_NUM_GPIOS;
 		break;
+	case CS42L92:
+	case CS47L92:
+	case CS47L93:
+		madera_gpio->gpio_chip.ngpio = CS47L92_NUM_GPIOS;
+		break;
 	default:
 		dev_err(&pdev->dev, "Unknown chip variant %d\n", madera->type);
 		return -EINVAL;
-- 
2.20.1



