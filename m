Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7DC2ACE38
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgKJDxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgKJDxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E82920897;
        Tue, 10 Nov 2020 03:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980409;
        bh=m6KQATt8CWBhh1TON2YkRGTy8sd/B8BG6qA702T1i10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF2opmLOH9GGS22suvlHvnymSxyv1VyeqQAgz5fflZ8DjLONTG9bUYp25YtQRZlop
         rrNm1niCoHgk9uFdJ8IQP+e2RDX1M0JYCAMueIUiql2uOdVwaiU47dWrh+6TvS2TSv
         GHN7cULjP9nI14dI2do6EkpF6MalE0Xr4DnHT7vk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Pavel Andrianov <andrianov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 07/55] usb: gadget: goku_udc: fix potential crashes in probe
Date:   Mon,  9 Nov 2020 22:52:30 -0500
Message-Id: <20201110035318.423757-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
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

