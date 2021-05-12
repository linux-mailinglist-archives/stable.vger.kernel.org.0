Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4966537CDF3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245399AbhELQ7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243925AbhELQmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A745F61C4D;
        Wed, 12 May 2021 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835707;
        bh=5IUdzg3mU8Qx4DC/vAHUfwIBiPaBeLagFUwYjLkCvaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aC3BHIodrdx0EpdBdWUm2NyGdlHPj8OYyM+02QaxqhpUfSWEhUghIygV4Z8eekmGf
         OXoerr7Bt2ZirosvByynlwI6pOSnGhX8C9PPoLpYL+JDnNo7P9cPX4qglFYEd7ZbQ5
         FfQ/3S2NjcRIb/yTVFyAKUWu+0lfaCBuAKVJVypU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 417/677] scsi: jazz_esp: Add IRQ check
Date:   Wed, 12 May 2021 16:47:43 +0200
Message-Id: <20210512144851.194130626@linuxfoundation.org>
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
index f0ed6863cc70..60a88a95a8e2 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -143,7 +143,9 @@ static int esp_jazz_probe(struct platform_device *dev)
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



