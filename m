Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63B395B3C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhEaNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhEaNSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACDF60FE8;
        Mon, 31 May 2021 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467005;
        bh=7c7ggbdg1DmfoguliOKqb3OOSiKDswSpOre3T5b7NUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsC+gXPTgQcYeVHC8zlvz9q9pSvrGLRPfvzZZKYoAQQpTsNH34WZ9VFJjTLcmHIG6
         owtPq7lGmdt4zqY7LS7T5s372KG2TuPHAEKpsVb/f0b0rEa6Dn4b22grt/ftn1B72I
         lgNiHk/ewdq43RHqN1jKfMPn4hZSN8/6XdNwgqKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 21/54] spi: spi-sh: Fix use-after-free on unbind
Date:   Mon, 31 May 2021 15:13:47 +0200
Message-Id: <20210531130635.758172932@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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
[lukas: backport to v4.4.270]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sh.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -451,7 +451,7 @@ static int spi_sh_probe(struct platform_
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -469,16 +469,14 @@ static int spi_sh_probe(struct platform_
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
@@ -488,8 +486,7 @@ static int spi_sh_probe(struct platform_
 					dev_name(master->dev.parent));
 	if (ss->workqueue == NULL) {
 		dev_err(&pdev->dev, "create workqueue error\n");
-		ret = -EBUSY;
-		goto error1;
+		return -EBUSY;
 	}
 
 	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
@@ -516,9 +513,6 @@ static int spi_sh_probe(struct platform_
 	free_irq(irq, ss);
  error2:
 	destroy_workqueue(ss->workqueue);
- error1:
-	spi_master_put(master);
-
 	return ret;
 }
 


