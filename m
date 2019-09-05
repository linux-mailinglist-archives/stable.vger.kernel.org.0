Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4CBAA85C
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbfIEQSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37716 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388595AbfIEQST (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so1686795pgp.4
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oVyIDYAYI+VGDpI/lL7N1eH8i3MwtZKf3xtD/r8Rq24=;
        b=RxDSo4U5spH1guQJnwpIC/IDoB9wBeRnVHNJlU6ZkPdlDZGnci2vz8qQzeVqj6sHk8
         OIEP3Aw69I/XCmA2b4iKpZz7pSTX9yIxzmguy6LxNFNRQtOD1hZHZx50CRC8PIff6+Jn
         /PplH+b2d5ldVWpeCS9ka4uiFItzl73R1+KOe4NeD4/11/kYAn/1IySNj9Bit9gvqtaq
         BVSsW9xsV/zkaN+MU/3pg6WNWNHQQdNWpTw8n5BgEs56iSr3vf+9eqggw+5lcrUcaiuI
         sjZLImwlXI8C+gUp7XbIVlhEkMi75jmc05IAcQed1JPfpUYfVzvU+urgBPc0BaBeFAqr
         CjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oVyIDYAYI+VGDpI/lL7N1eH8i3MwtZKf3xtD/r8Rq24=;
        b=skhM1nsJADgSgVZCOta95VNf4Z3VCBBvtt8d1qB8slRCYGuqEBu5iEtWzFSqyRxDHb
         dwbabSTr9XWF/VO1aVjiZg0PgUMNlemBvnwElpSXO+b2S6bJ6supPJR/ZmJb7e4Us1wJ
         zMLrsJdnXyl9SW8JRMylYX14sQp9cPW/MVo4pwYZCdqwVClLBpoT8RuL+qLL8kVGD7uQ
         EGUAugSs0jKOicWjkmqGj/yGDecGLRPCluy3j+X1Ggx5r/CoWk4aNgR/Gv/4nlaZZLzt
         x1PDgbsggnWwWJDQJeAZxUPWJBLvvEbQIW5Nz5dhJMB1fjoxveN5r3sxHPu7/5soa8dF
         Chgg==
X-Gm-Message-State: APjAAAX0S5lA92J1LJ55UdEGQRxHWQPwg4d++AsmI5y6rhvJsTxaQIrR
        FcbfdU3B7NCmYPTH5E9d/bn5QUn9Hok=
X-Google-Smtp-Source: APXvYqzhTRlr7lMleWMm7PihRHJXTyTnHKtYgBmHBckAchkD+HJXwuNJjzGA3Uqro4QttUg4ocqrjA==
X-Received: by 2002:a63:ea14:: with SMTP id c20mr3836155pgi.185.1567700298006;
        Thu, 05 Sep 2019 09:18:18 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:17 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 14/18] ASoC: davinci-mcasp: Handle return value of devm_kasprintf
Date:   Thu,  5 Sep 2019 10:17:55 -0600
Message-Id: <20190905161759.28036-15-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

commit 0c8b794c4a10aaf7ac0d4a49be2b2638e2038adb upstream

devm_kasprintf() can fail here and we must check its return value.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/davinci/davinci-mcasp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 0480ec4c8035..af6cd8b874f5 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1894,6 +1894,10 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (irq >= 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_common",
 					  dev_name(&pdev->dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						davinci_mcasp_common_irq_handler,
 						IRQF_ONESHOT | IRQF_SHARED,
@@ -1911,6 +1915,10 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (irq >= 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_rx",
 					  dev_name(&pdev->dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						davinci_mcasp_rx_irq_handler,
 						IRQF_ONESHOT, irq_name, mcasp);
@@ -1926,6 +1934,10 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (irq >= 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_tx",
 					  dev_name(&pdev->dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						davinci_mcasp_tx_irq_handler,
 						IRQF_ONESHOT, irq_name, mcasp);
-- 
2.17.1

