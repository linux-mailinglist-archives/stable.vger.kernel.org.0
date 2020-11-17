Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227FB2B649E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgKQNdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732102AbgKQNdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8016621534;
        Tue, 17 Nov 2020 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620024;
        bh=m6KQATt8CWBhh1TON2YkRGTy8sd/B8BG6qA702T1i10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqDvzLMumrS8KOOgmWOEjfqj0Mn3BnvlxKXe+BPvle4wQA5sIQoLp3pVqLdrOHKly
         Yr6f68gI/ejnByv778rLMeY+j3DiXks5MyD68Q77ULEIiQuh7F8Nq4x7VKvDrbXxQN
         1janpmEB//PAaQYxeM6YKYsocBMTocggvS2dCwcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Andrianov <andrianov@ispras.ru>,
        Evgeny Novikov <novikov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 082/255] usb: gadget: goku_udc: fix potential crashes in probe
Date:   Tue, 17 Nov 2020 14:03:42 +0100
Message-Id: <20201117122142.947295240@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 0d66e04875c5aae876cf3d4f4be7978fa2b00523 ]

goku_probe() goes to error label "err" and invokes goku_remove()
in case of failures of pci_enable_device(), pci_resource_start()
and ioremap(). goku_remove() gets a device from
pci_get_drvdata(pdev) and works with it without any checks, in
particular it dereferences a corresponding pointer. But
goku_probe() did not set this device yet. So, one can expect
various crashes. The patch moves setting the device just after
allocation of memory for it.

Found by Linux Driver Verification project (linuxtesting.org).

Reported-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/goku_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index 25c1d6ab5adb4..3e1267d38774f 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1760,6 +1760,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	pci_set_drvdata(pdev, dev);
 	spin_lock_init(&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &goku_ops;
@@ -1793,7 +1794,6 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	dev->regs = (struct goku_udc_regs __iomem *) base;
 
-	pci_set_drvdata(pdev, dev);
 	INFO(dev, "%s\n", driver_desc);
 	INFO(dev, "version: " DRIVER_VERSION " %s\n", dmastr());
 	INFO(dev, "irq %d, pci mem %p\n", pdev->irq, base);
-- 
2.27.0



