Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE2CAA57
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392712AbfJCRDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405023AbfJCQl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11092054F;
        Thu,  3 Oct 2019 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120889;
        bh=UGihAmaLW362vg11BnS10tyWxVR4P37dFjOZO5GGe6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg0nHQrVoJDWu1lBd5aZX8HHcffglLYLndGDNDF2btAg5XCE7EOuGU0lq+tAj10Ju
         eYcIopxwhFG7r0zFn6eGNUXjB7+lNlQnC9trMZmWlLGalcAgCaIJ5z4igCvPTPMqba
         UMPFUckRG3ruBKOYi6j+KCwd2bYEO6UAAfNLXO5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 076/344] gpio: madera: Add support for Cirrus Logic CS47L15
Date:   Thu,  3 Oct 2019 17:50:41 +0200
Message-Id: <20191003154547.647475518@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d06be8bc290aa255b9fd8602e60fb9f487aa0f48 ]

As the gpio is common to all madera codecs all that is needed
is to setup the correct number of GPIO pins for the CS47L15.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20190722090748.20807-3-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-madera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-madera.c b/drivers/gpio/gpio-madera.c
index 4dbc837d12155..19db5a500eb0d 100644
--- a/drivers/gpio/gpio-madera.c
+++ b/drivers/gpio/gpio-madera.c
@@ -136,6 +136,9 @@ static int madera_gpio_probe(struct platform_device *pdev)
 	madera_gpio->gpio_chip.parent = pdev->dev.parent;
 
 	switch (madera->type) {
+	case CS47L15:
+		madera_gpio->gpio_chip.ngpio = CS47L15_NUM_GPIOS;
+		break;
 	case CS47L35:
 		madera_gpio->gpio_chip.ngpio = CS47L35_NUM_GPIOS;
 		break;
-- 
2.20.1



