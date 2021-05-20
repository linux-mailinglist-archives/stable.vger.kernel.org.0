Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2D838A3FF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhETKAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235181AbhETJ5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A636139A;
        Thu, 20 May 2021 09:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503482;
        bh=cDsNEF8pfcgYPEdhQPiH+XfrzDWIabER0r31WivNClA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7mODigDpwNR/KkD8ZmhRrNvVIWxq4edOv6TI23JyG6lS8AAcPmEstQQc4lxYWlJP
         ZaImxwnp1SHF5BRUshsMcoy+uDsOf7m1qpPYeOJjy8SUFukd13k5WlSSZ/VT3SAXHT
         XJLo+fbj33ilYl96luF9vll9WcX5G0+XBog8QgL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 241/425] scsi: sni_53c710: Add IRQ check
Date:   Thu, 20 May 2021 11:20:10 +0200
Message-Id: <20210520092139.344583448@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 1160d61bc51e87e509cfaf9da50a0060f67b6de4 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #s), causing it to fail with -EINVAL (overridden by -ENODEV
further below).  Stop calling request_irq() with the invalid IRQ #s.

Link: https://lore.kernel.org/r/8f4b8fa5-8251-b977-70a1-9099bcb4bb17@omprussia.ru
Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sni_53c710.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 3102a75984d3..aed91afb79b6 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -71,6 +71,7 @@ static int snirm710_probe(struct platform_device *dev)
 	struct NCR_700_Host_Parameters *hostdata;
 	struct Scsi_Host *host;
 	struct  resource *res;
+	int rc;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -96,7 +97,9 @@ static int snirm710_probe(struct platform_device *dev)
 		goto out_kfree;
 	host->this_id = 7;
 	host->base = base;
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = rc = platform_get_irq(dev, 0);
+	if (rc < 0)
+		goto out_put_host;
 	if(request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "snirm710", host)) {
 		printk(KERN_ERR "snirm710: request_irq failed!\n");
 		goto out_put_host;
-- 
2.30.2



