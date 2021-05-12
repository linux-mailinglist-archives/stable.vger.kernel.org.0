Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7C37C569
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhELPkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhELPfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C576198B;
        Wed, 12 May 2021 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832654;
        bh=Ne5oA7d1Uhqff9qRZmUNN7hPZ4CMU6mywHgVFg+3m1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNsw2JJuaM19Jiq22+9E/wxm+ghKi+AShWSc5fd7QAC+DJPX0iVqcAKauiNMhDGps
         4lnDo2h1mPR/z5vWYTmoqYx5viO5gCY18PGdWPK4wtkZbk3bAVoPacH5TQFfUYuOeV
         y0L4wzwBzo4K/uvoX6yeoDfiF4vhebyRW/Lobgwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/530] scsi: sun3x_esp: Add IRQ check
Date:   Wed, 12 May 2021 16:47:23 +0200
Message-Id: <20210512144830.751260219@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 7de82f2c9757..d3489ac7ab28 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -206,7 +206,9 @@ static int esp_sun3x_probe(struct platform_device *dev)
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



