Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075A3394A82
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 07:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhE2FIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 01:08:54 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:44805 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhE2FIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 01:08:53 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 42330100D9407;
        Sat, 29 May 2021 07:07:14 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 12D5A1214F; Sat, 29 May 2021 07:07:14 +0200 (CEST)
Date:   Sat, 29 May 2021 07:07:14 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     axel.lin@ingics.com, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: spi-sh: Fix use-after-free on
 unbind" failed to apply to 4.4-stable tree
Message-ID: <20210529050714.GA21377@wunner.de>
References: <1609152602115140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609152602115140@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 11:50:02AM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the backport of e77df3eca12b to v4.4-stable.

-- >8 --
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:04 +0100
Subject: [PATCH] spi: spi-sh: Fix use-after-free on unbind

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
---
 drivers/spi/spi-sh.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
index 502501187c9e..f062ebb46e0e 100644
--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -451,7 +451,7 @@ static int spi_sh_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -469,16 +469,14 @@ static int spi_sh_probe(struct platform_device *pdev)
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
@@ -488,8 +486,7 @@ static int spi_sh_probe(struct platform_device *pdev)
 					dev_name(master->dev.parent));
 	if (ss->workqueue == NULL) {
 		dev_err(&pdev->dev, "create workqueue error\n");
-		ret = -EBUSY;
-		goto error1;
+		return -EBUSY;
 	}
 
 	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
@@ -516,9 +513,6 @@ static int spi_sh_probe(struct platform_device *pdev)
 	free_irq(irq, ss);
  error2:
 	destroy_workqueue(ss->workqueue);
- error1:
-	spi_master_put(master);
-
 	return ret;
 }
 
-- 
2.31.1

