Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61C02ACD14
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgKJD4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:56:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387520AbgKJD4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547E820731;
        Tue, 10 Nov 2020 03:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980573;
        bh=6U9xVuBFhCt5nqfNxn//sTWcz874C1yrKV6OPWBMONY=;
        h=From:To:Cc:Subject:Date:From;
        b=SOGw6hWXx9VAOV92hg+3g6PW/IintHzRcLeynA6CJ6nTlAe+XqkdQzFhqxqZTXT+p
         SF4uIa9eWtQt7BoAsAfSafy+28RpdiUyM30YJ34kYvp91MKYV+TtbnEcR21zv2Jjml
         4z7bN0Mu8LpxcVVpAO6C39EiQ8nw/5WWucTPASlE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Pavel Andrianov <andrianov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/14] usb: gadget: goku_udc: fix potential crashes in probe
Date:   Mon,  9 Nov 2020 22:55:57 -0500
Message-Id: <20201110035611.424867-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8433c22900dcb..0ed0d03651329 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1772,6 +1772,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	pci_set_drvdata(pdev, dev);
 	spin_lock_init(&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &goku_ops;
@@ -1805,7 +1806,6 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	dev->regs = (struct goku_udc_regs __iomem *) base;
 
-	pci_set_drvdata(pdev, dev);
 	INFO(dev, "%s\n", driver_desc);
 	INFO(dev, "version: " DRIVER_VERSION " %s\n", dmastr());
 	INFO(dev, "irq %d, pci mem %p\n", pdev->irq, base);
-- 
2.27.0

