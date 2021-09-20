Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8A6412652
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387250AbhITS4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384612AbhITSs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E986337D;
        Mon, 20 Sep 2021 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159248;
        bh=p+ZZn61JJA25b2nR8Jk9ZR27Knm7fkfpCZzlGmUg5Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEE69CA1VcJUfW6eGysmWUZwiVcsIbCcmX0NvgDzJIDAKS0RCrR3Hq/HMB4znY99X
         EsBMceE6CiMdCXYVp51niAPZgD+3udlasdcdOAHxb8wwPmFn9iRy04h9Dmli2W06D2
         HcHPzWiIH3IDDEKXA2f6HX/IzbDKqFOOO2Aea8U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 145/168] gpio: mpc8xxx: Use devm_gpiochip_add_data() to simplify the code and avoid a leak
Date:   Mon, 20 Sep 2021 18:44:43 +0200
Message-Id: <20210920163926.422367515@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 889a1b3f35db6ba5ba6a0c23a3a55594570b6a17 ]

If an error occurs after a 'gpiochip_add_data()' call it must be undone by
a corresponding 'gpiochip_remove()' as already done in the remove function.

To simplify the code a fix a leak in the error handling path of the probe,
use the managed version instead (i.e. 'devm_gpiochip_add_data()')

Fixes: 698b8eeaed72 ("gpio/mpc8xxx: change irq handler from chained to normal")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index fdb22c2e1085..d574e8cb6d7c 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -380,7 +380,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	    is_acpi_node(fwnode))
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
 
-	ret = gpiochip_add_data(gc, mpc8xxx_gc);
+	ret = devm_gpiochip_add_data(&pdev->dev, gc, mpc8xxx_gc);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"GPIO chip registration failed with status %d\n", ret);
@@ -429,8 +429,6 @@ static int mpc8xxx_remove(struct platform_device *pdev)
 		irq_domain_remove(mpc8xxx_gc->irq);
 	}
 
-	gpiochip_remove(&mpc8xxx_gc->gc);
-
 	return 0;
 }
 
-- 
2.30.2



