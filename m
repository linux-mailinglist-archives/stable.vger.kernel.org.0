Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D5238A416
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhETKAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhETJ5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0C2613AE;
        Thu, 20 May 2021 09:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503478;
        bh=U6sti/vTkvS38BdljLHSF5iL//TmOPR5G5sRrW9yB7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYkBs7J2Rb7GKZEDKr4SKIfBAD0NPKjuX/o25ygnEA7hT3C1JhNQyGK1NZgcudRxa
         9ToYYd7IuUwTVtEC5gFo1I8T7JE6e+MbaZ5PXNXuguVCZrhO16ObD3gAN6wvKsyT2I
         49zBBXvpziIoQwRFFmuJcd7usTrQmiCFL2mW6KWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/425] scsi: jazz_esp: Add IRQ check
Date:   Thu, 20 May 2021 11:20:08 +0200
Message-Id: <20210520092139.281738467@linuxfoundation.org>
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

[ Upstream commit 38fca15c29db6ed06e894ac194502633e2a7d1fb ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding the real
error code.  Stop calling request_irq() with the invalid IRQ #s.

Link: https://lore.kernel.org/r/594aa9ae-2215-49f6-f73c-33bd38989912@omprussia.ru
Fixes: 352e921f0dd4 ("[SCSI] jazz_esp: converted to use esp_core")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/jazz_esp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 6eb5ff3e2e61..7dfe4237e5e8 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -170,7 +170,9 @@ static int esp_jazz_probe(struct platform_device *dev)
 	if (!esp->command_block)
 		goto fail_unmap_regs;
 
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = err = platform_get_irq(dev, 0);
+	if (err < 0)
+		goto fail_unmap_command_block;
 	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp);
 	if (err < 0)
 		goto fail_unmap_command_block;
-- 
2.30.2



