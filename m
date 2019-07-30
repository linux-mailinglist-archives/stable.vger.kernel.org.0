Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA59D7A9AC
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbfG3NcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 09:32:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3251 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731038AbfG3NcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 09:32:07 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 66C0CBEC2A8FB601871B;
        Tue, 30 Jul 2019 21:32:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 30 Jul 2019 21:31:55 +0800
From:   John Garry <john.garry@huawei.com>
To:     <xuwei5@huawei.com>
CC:     <bhelgaas@google.com>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <olof@lixom.net>,
        <stable@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH v4 4/5] bus: hisi_lpc: Unregister logical PIO range to avoid potential use-after-free
Date:   Tue, 30 Jul 2019 21:29:55 +0800
Message-ID: <1564493396-92195-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1564493396-92195-1-git-send-email-john.garry@huawei.com>
References: <1564493396-92195-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If, after registering a logical PIO range, the driver probe later fails,
the logical PIO range memory will be released automatically.

This causes an issue, in that the logical PIO range is not unregistered
and the released range memory may be later referenced.

Fix by unregistering the logical PIO range.

And since we now unregister the logical PIO range for probe failure, avoid
the special ordering of setting logical PIO range ops, which was the
previous (poor) attempt at a safeguard against this.

Cc: stable@vger.kernel.org
Fixes: adf38bb0b595 ("HISI LPC: Support the LPC host on Hip06/Hip07 with DT bindings")
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/bus/hisi_lpc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/hisi_lpc.c b/drivers/bus/hisi_lpc.c
index 19d7b6ff2f17..6d301aafcad2 100644
--- a/drivers/bus/hisi_lpc.c
+++ b/drivers/bus/hisi_lpc.c
@@ -606,24 +606,25 @@ static int hisi_lpc_probe(struct platform_device *pdev)
 	range->fwnode = dev->fwnode;
 	range->flags = LOGIC_PIO_INDIRECT;
 	range->size = PIO_INDIRECT_SIZE;
+	range->hostdata = lpcdev;
+	range->ops = &hisi_lpc_ops;
+	lpcdev->io_host = range;
 
 	ret = logic_pio_register_range(range);
 	if (ret) {
 		dev_err(dev, "register IO range failed (%d)!\n", ret);
 		return ret;
 	}
-	lpcdev->io_host = range;
 
 	/* register the LPC host PIO resources */
 	if (acpi_device)
 		ret = hisi_lpc_acpi_probe(dev);
 	else
 		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	if (ret)
+	if (ret) {
+		logic_pio_unregister_range(range);
 		return ret;
-
-	lpcdev->io_host->hostdata = lpcdev;
-	lpcdev->io_host->ops = &hisi_lpc_ops;
+	}
 
 	io_end = lpcdev->io_host->io_start + lpcdev->io_host->size;
 	dev_info(dev, "registered range [%pa - %pa]\n",
-- 
2.17.1

