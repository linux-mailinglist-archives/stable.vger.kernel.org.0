Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D694A29B6F2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798440AbgJ0P16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798141AbgJ0PZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4150C20657;
        Tue, 27 Oct 2020 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812349;
        bh=J4REINZOHT+mo5UJ7vS/fqY36s16U5xGSnBqpbisXW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jg9ivsXWgfUzfrTw++w93caaPLlql7FKKq/LYOGFAhZH25C4e3rkyN06VQXOnRZvJ
         JkvRXXmslWmwoUIOJfBGvYFn9H8o6OHvSmX2rtf55me2aOmnefjJL5V07/GsgT3w/L
         HoF2yqS5luIQUKTQkWBlQmbMbSONNsAEBhd/kDYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Jay Fang <f.fangjian@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 148/757] spi: dw-pci: free previously allocated IRQs if desc->setup() fails
Date:   Tue, 27 Oct 2020 14:46:38 +0100
Message-Id: <20201027135457.547501014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Fang <f.fangjian@huawei.com>

[ Upstream commit 9599f341889c87e56bb944659c32490d05e2532f ]

Free previously allocated IRQs when return an error code of desc->setup()
which is not always successful. And simplify the code by adding a goto
label.

Fixes: 8f5c285f3ef5 ("SPI: designware: pci: Switch over to MSI interrupts")
CC: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/1600132969-53037-1-git-send-email-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-pci.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
index 2ea73809ca345..271839a8add0e 100644
--- a/drivers/spi/spi-dw-pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -127,18 +127,16 @@ static int spi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (desc->setup) {
 			ret = desc->setup(dws);
 			if (ret)
-				return ret;
+				goto err_free_irq_vectors;
 		}
 	} else {
-		pci_free_irq_vectors(pdev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_free_irq_vectors;
 	}
 
 	ret = dw_spi_add_host(&pdev->dev, dws);
-	if (ret) {
-		pci_free_irq_vectors(pdev);
-		return ret;
-	}
+	if (ret)
+		goto err_free_irq_vectors;
 
 	/* PCI hook and SPI hook use the same drv data */
 	pci_set_drvdata(pdev, dws);
@@ -152,6 +150,10 @@ static int spi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pm_runtime_allow(&pdev->dev);
 
 	return 0;
+
+err_free_irq_vectors:
+	pci_free_irq_vectors(pdev);
+	return ret;
 }
 
 static void spi_pci_remove(struct pci_dev *pdev)
-- 
2.25.1



