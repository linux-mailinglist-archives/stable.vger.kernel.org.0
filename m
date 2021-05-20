Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57D138A6F0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbhETKcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237164AbhETK3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A298B60551;
        Thu, 20 May 2021 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504299;
        bh=EVw1yJLDoY2u+9KBb7oQsjBEFyKgubZGB4jVr4IBGjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ivtq9E3EVkiztKoDn3y2WVL6Sb+vRG8SXjcYFiBtk9O5wC8V+0qhTKHVWD7q5uGps
         vXfcHbdtul+Mql0hwXIMLBJTNz7d3FDp4jgtLtZoOpxOzEtiZAXJwRRo4k2bzoxGS6
         d8w47rSv/LCodhE2m/Uhf6tmC/I4UpHsHUdrH6rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 183/323] pata_arasan_cf: fix IRQ check
Date:   Thu, 20 May 2021 11:21:15 +0200
Message-Id: <20210520092126.382872080@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit c7e8f404d56b99c80990b19a402c3f640d74be05 ]

The driver's probe() method is written as if platform_get_irq() returns 0
on error, while actually it returns a negative error code (with all the
other values considered valid IRQs). Rewrite the driver's IRQ checking code
to pass the positive IRQ #s to ata_host_activate(), propagate upstream
-EPROBE_DEFER, and set up the driver to polling mode on (negative) errors
and IRQ0 (libata treats IRQ #0 as a polling mode anyway)...

Fixes: a480167b23ef ("pata_arasan_cf: Adding support for arasan compact flash host controller")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_arasan_cf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index b4d54771c9fe..623199fab8fe 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -819,12 +819,19 @@ static int arasan_cf_probe(struct platform_device *pdev)
 	else
 		quirk = CF_BROKEN_UDMA; /* as it is on spear1340 */
 
-	/* if irq is 0, support only PIO */
-	acdev->irq = platform_get_irq(pdev, 0);
-	if (acdev->irq)
+	/*
+	 * If there's an error getting IRQ (or we do get IRQ0),
+	 * support only PIO
+	 */
+	ret = platform_get_irq(pdev, 0);
+	if (ret > 0) {
+		acdev->irq = ret;
 		irq_handler = arasan_cf_interrupt;
-	else
+	} else	if (ret == -EPROBE_DEFER) {
+		return ret;
+	} else	{
 		quirk |= CF_BROKEN_MWDMA | CF_BROKEN_UDMA;
+	}
 
 	acdev->pbase = res->start;
 	acdev->vbase = devm_ioremap_nocache(&pdev->dev, res->start,
-- 
2.30.2



