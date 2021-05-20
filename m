Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940EA38AB07
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbhETLUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240212AbhETLRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3BC61444;
        Thu, 20 May 2021 10:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505377;
        bh=3Gn753fkwrHl9WOyOxVbJ+VolEhzTSTT82586210nyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJX4sShVJyvrdgmEnCHyQ/PM73rkdS5ahe3vElgsif4Y/QuCnyO1DdrgvQUiY0Kfn
         hpQurrCbKsoBqPvaCma7PB3KXPo49HIPwaKr1lMcnAq1o/SCsWEm6wRIdd6Q3U9tQ/
         P6SMl+ziiOCiKZbyaHxSTvqLAQ5QlzbGgM9dqlqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 106/190] scsi: jazz_esp: Add IRQ check
Date:   Thu, 20 May 2021 11:22:50 +0200
Message-Id: <20210520092105.701621938@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 9aaa74e349cc..65f0dbfc3a45 100644
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



