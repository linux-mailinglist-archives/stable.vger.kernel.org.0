Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CCB4124CE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350186AbhITSiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379309AbhITSgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98026331A;
        Mon, 20 Sep 2021 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158944;
        bh=66xlvQD0Gb9FNYNhXTZe5EXDwOjLwO5ScT1YPxrSOsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwJxpV9R3oJz2N4eZZhSsueHuRcEW3iPu975jrCOfnKaybvZfQL00ZknSDqV7VeIu
         fujsQdxgwhIKurcT9C/0XdixKx9RnjGsqiXuRaamD2Cr/Z5oDxb5umw+3pr1CIw0As
         1BpiwmjmS61NS/ylef6AP7JjpFQn2kAWYLchdv5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/122] gpio: mpc8xxx: Use devm_gpiochip_add_data() to simplify the code and avoid a leak
Date:   Mon, 20 Sep 2021 18:44:33 +0200
Message-Id: <20210920163919.100326398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index a4983c5d1f16..023b99bf098d 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -374,7 +374,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	    of_device_is_compatible(np, "fsl,ls1088a-gpio"))
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
 
-	ret = gpiochip_add_data(gc, mpc8xxx_gc);
+	ret = devm_gpiochip_add_data(&pdev->dev, gc, mpc8xxx_gc);
 	if (ret) {
 		pr_err("%pOF: GPIO chip registration failed with status %d\n",
 		       np, ret);
@@ -419,8 +419,6 @@ static int mpc8xxx_remove(struct platform_device *pdev)
 		irq_domain_remove(mpc8xxx_gc->irq);
 	}
 
-	gpiochip_remove(&mpc8xxx_gc->gc);
-
 	return 0;
 }
 
-- 
2.30.2



