Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D389E1D84E4
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbgERSAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbgERSAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3620A207C4;
        Mon, 18 May 2020 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824806;
        bh=1HxIOp0p+Tyli1jlTBaZAeRhrVgH4wr28E09u2yL/oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glmgJPq4Z6e835hHNHyJPstziocb3L4wbuIucfrjw1FZa705wetX7luG1N/vWV3GO
         B+vhNfmhmpu9/pNdmoPV3PwWgf3x3nioVrfeeYfvP43uCqFn/gY4vYHe/IJj74Jdlk
         q5Lz8j7uqJ7fugRcpt81/QtgcJ2SFLMw/HVONbTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 012/194] gpio: pca953x: Fix pca953x_gpio_set_config
Date:   Mon, 18 May 2020 19:35:02 +0200
Message-Id: <20200518173532.652633533@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
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
index 5638b4e5355f1..4269ea9a817e6 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -531,7 +531,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 {
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
 
-	switch (config) {
+	switch (pinconf_to_config_param(config)) {
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 		return pca953x_gpio_set_pull_up_down(chip, offset, config);
-- 
2.20.1



