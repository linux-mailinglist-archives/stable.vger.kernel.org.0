Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FC711D9B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfEBPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbfEBPb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E034521670;
        Thu,  2 May 2019 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811116;
        bh=ajV3JpXOrvSXip+WAVQ2R56F6sOHZ8UgqSRoshVk9yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZMMf5WYBg8NE+rFa/csdea13Qee4s/2lm6vKL+Dh7lmE555Qp0UaOqbQcPD6Ixif
         CyT04HqeQKMBwlkqXoEjUraPVZDi5koWBYiv/sAjwtyCT0DmDnb2KMQ1AkrN450lHh
         LWz2HTCvtQqW7OuU+pWp3dxmKomC6+sxxfTHmLqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chris Healy <cphealy@gmail.com>, linux-gpio@vger.kernel.org,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 081/101] gpio: of: Check for "spi-cs-high" in child instead of parent node
Date:   Thu,  2 May 2019 17:21:23 +0200
Message-Id: <20190502143345.297630995@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ce40277bf848391705011ba37eac2e377cbd9e6 ]

"spi-cs-high" is going to be specified in child node of an SPI
controller's representing attached SPI device, so change the code to
look for it there, instead of checking parent node.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 9470563f2506..f1ae28289a67 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -142,16 +142,16 @@ static void of_gpio_flags_quirks(struct device_node *np,
 				 * conflict and the "spi-cs-high" flag will
 				 * take precedence.
 				 */
-				if (of_property_read_bool(np, "spi-cs-high")) {
+				if (of_property_read_bool(child, "spi-cs-high")) {
 					if (*flags & OF_GPIO_ACTIVE_LOW) {
 						pr_warn("%s GPIO handle specifies active low - ignored\n",
-							of_node_full_name(np));
+							of_node_full_name(child));
 						*flags &= ~OF_GPIO_ACTIVE_LOW;
 					}
 				} else {
 					if (!(*flags & OF_GPIO_ACTIVE_LOW))
 						pr_info("%s enforce active low on chipselect handle\n",
-							of_node_full_name(np));
+							of_node_full_name(child));
 					*flags |= OF_GPIO_ACTIVE_LOW;
 				}
 				break;
-- 
2.19.1



