Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943AC26B5E8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgIOXxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgIOObi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54AEB22287;
        Tue, 15 Sep 2020 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179813;
        bh=MJw2ypF69EdDVFzN7tH09hnsrI31ouSIOYaRN26+0OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpSDhDNxRrdyHEIpWnpSvGKw8wU3pe6gmT8KgymQ/icDAl0HHCbdK0I2Zk8n0Grs1
         h9TCErtCptKA8slQu61F/8lBt6hBsrZgYCXLWzF1ji3syi5TwvCHiiuT6VT1nyxCD0
         6pgkq4TV98TK7Y2CtRa2kO9CxpNk3IzScgpZOELA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 099/132] regulator: plug of_node leak in regulator_register()s error path
Date:   Tue, 15 Sep 2020 16:13:21 +0200
Message-Id: <20200915140649.110637858@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit d3c731564e09b6c2ebefcd1344743a91a237d6dc upstream.

By calling device_initialize() earlier and noting that kfree(NULL) is
ok, we can save a bit of code in error handling and plug of_node leak.
Fixed commit already did part of the work.

Fixes: 9177514ce349 ("regulator: fix memory leak on error path of regulator_register()")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/f5035b1b4d40745e66bacd571bbbb5e4644d21a1.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5065,6 +5065,7 @@ regulator_register(const struct regulato
 		ret = -ENOMEM;
 		goto rinse;
 	}
+	device_initialize(&rdev->dev);
 
 	/*
 	 * Duplicate the config so the driver could override it after
@@ -5072,9 +5073,8 @@ regulator_register(const struct regulato
 	 */
 	config = kmemdup(cfg, sizeof(*cfg), GFP_KERNEL);
 	if (config == NULL) {
-		kfree(rdev);
 		ret = -ENOMEM;
-		goto rinse;
+		goto clean;
 	}
 
 	init_data = regulator_of_get_init_data(dev, regulator_desc, config,
@@ -5086,10 +5086,8 @@ regulator_register(const struct regulato
 	 * from a gpio extender or something else.
 	 */
 	if (PTR_ERR(init_data) == -EPROBE_DEFER) {
-		kfree(config);
-		kfree(rdev);
 		ret = -EPROBE_DEFER;
-		goto rinse;
+		goto clean;
 	}
 
 	/*
@@ -5142,7 +5140,6 @@ regulator_register(const struct regulato
 	}
 
 	/* register with sysfs */
-	device_initialize(&rdev->dev);
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
@@ -5220,13 +5217,11 @@ wash:
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
 	mutex_unlock(&regulator_list_mutex);
-	put_device(&rdev->dev);
-	rdev = NULL;
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
-	kfree(rdev);
 	kfree(config);
+	put_device(&rdev->dev);
 rinse:
 	if (dangling_cfg_gpiod)
 		gpiod_put(cfg->ena_gpiod);


