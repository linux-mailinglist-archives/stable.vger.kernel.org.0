Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4317F2B645C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbgKQNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732980AbgKQNhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E7FA20870;
        Tue, 17 Nov 2020 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620261;
        bh=RYoJxuGsQ0hEKKi4IpBR0Qi7ppATwZ+UJbY48a3iQRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLru8/yijODtjS1+K73KG2n9esvdfXkuVmkKHvb5ciR6T86fHiy64zjArCc0lqZFw
         3TwXGV77Hcst1mXHAVveVc6NahriQNz29ch7mjfWIfUJsaAJcWaRwq95/ri4FN3ISv
         RwoA0FEo0UrLosEJJqW+EdQd05RyI2ke8swHkmuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Tao Ren <rentao.bupt@gmail.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 130/255] gpio: aspeed: fix ast2600 bank properties
Date:   Tue, 17 Nov 2020 14:04:30 +0100
Message-Id: <20201117122145.261584541@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 560b6ac37a87fcb78d580437e3e0bc2b6b5b0295 ]

GPIO_T is mapped to the most significant byte of input/output mask, and
the byte in "output" mask should be 0 because GPIO_T is input only. All
the other bits need to be 1 because GPIO_Q/R/S support both input and
output modes.

Fixes: ab4a85534c3e ("gpio: aspeed: Add in ast2600 details to Aspeed driver")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index e44d5de2a1201..b966f5e28ebff 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1114,6 +1114,7 @@ static const struct aspeed_gpio_config ast2500_config =
 
 static const struct aspeed_bank_props ast2600_bank_props[] = {
 	/*     input	  output   */
+	{4, 0xffffffff,  0x00ffffff}, /* Q/R/S/T */
 	{5, 0xffffffff,  0xffffff00}, /* U/V/W/X */
 	{6, 0x0000ffff,  0x0000ffff}, /* Y/Z */
 	{ },
-- 
2.27.0



