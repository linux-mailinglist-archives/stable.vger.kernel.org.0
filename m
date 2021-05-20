Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0597A38A92B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhETK6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237399AbhETK4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 891B561CEB;
        Thu, 20 May 2021 10:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504904;
        bh=FJx9plFRkCLtY+h32Yo0G9TZRxeVfAmOVNZCVF8I4iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZA8dWGT7oKVpO5wcB9bwriJVfL4xjz9uRji494DZOSiNcbI5Nl5A4wUEFLGwsP0d
         uNbXOKJak9LmeYCuJuxyMaKkKAkoVAvrsVauicscwdMG8eisJhZ71+DPS8Q4I0lc6q
         FBCnZTVpvuShTIO8GNA4YjNkrNS1xlOosRc8HglI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 133/240] scsi: sun3x_esp: Add IRQ check
Date:   Thu, 20 May 2021 11:22:05 +0200
Message-Id: <20210520092113.124822785@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 14b321380eb333c82853d7d612d0995f05f88fdc ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding the real
error code.  Stop calling request_irq() with the invalid IRQ #s.

Link: https://lore.kernel.org/r/363eb4c8-a3bf-4dc9-2a9e-90f349030a15@omprussia.ru
Fixes: 0bb67f181834 ("[SCSI] sun3x_esp: convert to esp_scsi")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sun3x_esp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index d50c5ed8f428..167ae2d29e47 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -233,7 +233,9 @@ static int esp_sun3x_probe(struct platform_device *dev)
 	if (!esp->command_block)
 		goto fail_unmap_regs_dma;
 
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = err = platform_get_irq(dev, 0);
+	if (err < 0)
+		goto fail_unmap_command_block;
 	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED,
 			  "SUN3X ESP", esp);
 	if (err < 0)
-- 
2.30.2



