Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314031EAC7E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgFAShV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731596AbgFASPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF59D2065C;
        Mon,  1 Jun 2020 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035332;
        bh=xfgbRMaYu1U4oFDf4gWpQzShktC0BgPWQW1Ys9OQYtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAG61EyGf5AHRTyD0FGKeSXvkdAF8OiSH6ozrDj6oV245KJQTHyDD04V33+H5i3rh
         sZec7P8K9/ekiFqFqJKHbKvEEtVuTRi336bk3yexjJC8mBw1Is94sTEohpgEM95ii9
         ULbXq1teMkyz3/0NccNgyCiRWM1HX1rW3Epf/714=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 112/177] gpio: bcm-kona: Fix return value of bcm_kona_gpio_probe()
Date:   Mon,  1 Jun 2020 19:54:10 +0200
Message-Id: <20200601174057.951065819@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 98f7d1b15e87c84488b30ecc4ec753b0690b9dbf ]

Propagate the error code returned by devm_platform_ioremap_resource()
out of probe() instead of overwriting it.

Fixes: 72d8cb715477 ("drivers: gpio: bcm-kona: use devm_platform_ioremap_resource()")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
[Bartosz: tweaked the commit message]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index baee8c3f06ad..cf3687a7925f 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -625,7 +625,7 @@ static int bcm_kona_gpio_probe(struct platform_device *pdev)
 
 	kona_gpio->reg_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(kona_gpio->reg_base)) {
-		ret = -ENXIO;
+		ret = PTR_ERR(kona_gpio->reg_base);
 		goto err_irq_domain;
 	}
 
-- 
2.25.1



