Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5669F2E67ED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgL1NG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730863AbgL1NGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63B922A84;
        Mon, 28 Dec 2020 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160760;
        bh=AGbZjThtdrTkvoPM+uTHatoHh9P2el0rwGqYVMnMn+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR8mKZQfr5v5z5YfGpLKPWUP5v9fQbxHjJxiQDWUQ/LU6T2sIFYOBrzoRKB1eM4OG
         whXa/r5uwyMYa4BZU9SggwGZgwWxrhBoGTfxkcEkZq112oSG/ig3dcLcs6EL3nDB7J
         0F2LaEmmTwlMhOU6OcFLqRbx5/QNz06cxvniS+Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 162/175] spi: spi-sh: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:15 +0100
Message-Id: <20201228124901.094894186@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit e77df3eca12be4b17f13cf9f215cff248c57d98f upstream.

spi_sh_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: 680c1305e259 ("spi/spi_sh: use spi_unregister_master instead of spi_master_put in remove path")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v3.0+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v3.0+
Cc: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/6d97628b536baf01d5e3e39db61108f84d44c8b2.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sh.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -450,7 +450,7 @@ static int spi_sh_probe(struct platform_
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -468,16 +468,14 @@ static int spi_sh_probe(struct platform_
 		break;
 	default:
 		dev_err(&pdev->dev, "No support width\n");
-		ret = -ENODEV;
-		goto error1;
+		return -ENODEV;
 	}
 	ss->irq = irq;
 	ss->master = master;
 	ss->addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (ss->addr == NULL) {
 		dev_err(&pdev->dev, "ioremap error.\n");
-		ret = -ENOMEM;
-		goto error1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&ss->queue);
 	spin_lock_init(&ss->lock);
@@ -487,7 +485,7 @@ static int spi_sh_probe(struct platform_
 	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request_irq error\n");
-		goto error1;
+		return ret;
 	}
 
 	master->num_chipselect = 2;
@@ -506,9 +504,6 @@ static int spi_sh_probe(struct platform_
 
  error3:
 	free_irq(irq, ss);
- error1:
-	spi_master_put(master);
-
 	return ret;
 }
 


