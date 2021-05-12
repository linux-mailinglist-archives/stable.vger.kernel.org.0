Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF537CD76
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbhELQzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhELQmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81DDB61C55;
        Wed, 12 May 2021 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835712;
        bh=kO8yA48hgkT1m02kdDNcbKCu3jksJOCsmIXPoQt2D7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8R2zXzJAKOqDC6MhFCauXPLwIRqf/pURuA5tktPSQiVc4XX1kWd5kQan45xt+XO+
         TbkUau7S/svVBOlmG0DQALyKa/WSZc818jJli4k/OnMxuT4/GfYBTvuntSU8CjM0nE
         qeOwkWoHrWXymFDyC0pGg6+hEpjfumibLb9QuuHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 419/677] scsi: sni_53c710: Add IRQ check
Date:   Wed, 12 May 2021 16:47:45 +0200
Message-Id: <20210512144851.258390366@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 9e2e196bc202..97c6f81b1d2a 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -58,6 +58,7 @@ static int snirm710_probe(struct platform_device *dev)
 	struct NCR_700_Host_Parameters *hostdata;
 	struct Scsi_Host *host;
 	struct  resource *res;
+	int rc;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -83,7 +84,9 @@ static int snirm710_probe(struct platform_device *dev)
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



