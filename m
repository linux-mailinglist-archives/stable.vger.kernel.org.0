Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046CC1D8574
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgERRzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbgERRzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7303E20715;
        Mon, 18 May 2020 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824504;
        bh=ESOYWcCGu4d7CtEt3/MpT+J1apvIHKiIcZD5hwqrtRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icrwPkoUYtW1fr+fNZdjmG5ZMRClseiYPjvbYDaaTmADqGSBnE06Uzn1ZiZZAMR3c
         A/qKkWo+NtqobObaAo/EZGUXW6fq9D+7p0/QDt91fNOj3N+sNSVg+TNgXbLz5rYRnk
         w0J/L/chUgPdFDwceJQJiqOVeaRZQyb6yTRgD2Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/147] gpio: pca953x: Fix pca953x_gpio_set_config
Date:   Mon, 18 May 2020 19:35:28 +0200
Message-Id: <20200518173513.867666840@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit dc87f6dd058a648cd2a35e4aa04592dccdc9f0c2 ]

pca953x_gpio_set_config is setup to support pull-up/down
bias.  Currently the driver uses a variable called 'config' to
determine which options to use.  Unfortunately, this is incorrect.

This patch uses function pinconf_to_config_param(config), which
converts this 'config' parameter back to pinconfig to determine
which option to use.

Fixes: 15add06841a3 ("gpio: pca953x: add ->set_config implementation")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index de5d1383f28da..3edc1762803ac 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -528,7 +528,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 {
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
 
-	switch (config) {
+	switch (pinconf_to_config_param(config)) {
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 		return pca953x_gpio_set_pull_up_down(chip, offset, config);
-- 
2.20.1



