Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F34C210E49
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgGAPCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 11:02:32 -0400
Received: from first.geanix.com ([116.203.34.67]:51100 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731490AbgGAPCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 11:02:31 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 07B4022432FD;
        Wed,  1 Jul 2020 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1593615421; bh=z31N8AQ+S2BawxjT54NpNGz2lpgKvwpwj8HFL25Hyik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jWDZPSTIjigw3f7alub+NkuuRQWxLpO9FliyrUjwjCDLL+YRShqUlG6TQwqhz5a8N
         qbN16ft9CqWbb9clIefgiPFkB0Mx3OXZ0rVY2qRVVWNHPdo/ezwFG3SG67wHySEOYh
         cVNYWeDSED9eDs6ppd2bLG5Nh7+PUrJEmkvnEJVIENhNQIpBrQxAWLRb5+N5K3QreX
         oMtpzsiWdMl5gd0qTbXi7N59Cz5gWNEpDFiOfifdAb4OGD54OO+adEKhB6uiKhqF5v
         8jSA8S1pPCYVVCw2JiLCZ0Lx7OCHB0CgLOT++/KZq0zJ2a2qAVNLfYLkhG7QLhLuQ2
         7PBAS7bC9Mqlg==
From:   Esben Haabendal <esben@geanix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] uio_pdrv_genirq: Remove warning when irq is not specified
Date:   Wed,  1 Jul 2020 16:56:57 +0200
Message-Id: <20200701145659.3978-2-esben@geanix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701145659.3978-1-esben@geanix.com>
References: <20200701145659.3978-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since e3a3c3a20555 ("UIO: fix uio_pdrv_genirq with device tree but no
interrupt"), the uio_pdrv_genirq has supported use without interrupt,
so the change in 7723f4c5ecdb ("driver core: platform: Add an error
message to") added false warnings for those cases.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Cc: stable@vger.kernel.org
---
 drivers/uio/uio_pdrv_genirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index ae319ef3a832..1d69dd49c6d2 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -159,7 +159,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 
 	if (!uioinfo->irq) {
-		ret = platform_get_irq(pdev, 0);
+		ret = platform_get_irq_optional(pdev, 0);
 		uioinfo->irq = ret;
 		if (ret == -ENXIO && pdev->dev.of_node)
 			uioinfo->irq = UIO_IRQ_NONE;
-- 
2.4.11

