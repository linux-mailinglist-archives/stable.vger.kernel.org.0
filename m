Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B759148A602
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 04:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiAKDCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 22:02:03 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:53616 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235331AbiAKDCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 22:02:03 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowABnbloR89xhYiBmBQ--.33851S2;
        Tue, 11 Jan 2022 11:01:37 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     damien.lemoal@opensource.wdc.com, David.Laight@ACULAB.COM,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Naohiro.Aota@wdc.com
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v3] ide: Check for null pointer after calling devm_ioremap
Date:   Tue, 11 Jan 2022 11:01:31 +0800
Message-Id: <20220111030131.525049-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABnbloR89xhYiBmBQ--.33851S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw47AF1fZry5Gw1UKr15Arb_yoW8Aw4rpF
        4SgFWSvrWDWr1UK3WxAr18ZFyUu3ZrJa4FgFyYvw4kZ3s0qr18JrWaqFWIqr9rJrW3CayY
        v3W2yr4kuFZ8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYnYwUU
        UUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In linux-stable-5.15.13, this file has been removed and combined
to `drivers/ata/pata_platform.c` without this bug.
But in the older LTS kernels, like 5.10.90, this bug still exists.
As the possible failure of the devres_alloc(), the devm_ioremap() and
devm_ioport_map() may return NULL pointer.
And then, the 'base' and 'alt_base' are used in plat_ide_setup_ports().
Therefore, it should be better to add the check in order to avoid the
dereference of the NULL pointer.
Actually, it introduced the bug from commit 8cb1f567f4c0
("ide: Platform IDE driver") and we can know from the commit message
that it tended to be similar to the `drivers/ata/pata_platform.c`.
But actually, even the first time pata_platform was built,
commit a20c9e820864 ("[PATCH] ata: Generic platform_device libata driver"),
there was no the bug, as there was a check after the ioremap().
So possibly the bug was caused by ide itself.

Fixes: 8cb1f567f4c0 ("ide: Platform IDE driver")
Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog

v1 -> v2

* Change 1. Correct the fixes tag and commit message.

v2 -> v3

* Change 1. Correct the code.
---
 drivers/ide/ide_platform.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index 91639fd6c276..5500c5afb3ca 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -85,6 +85,10 @@ static int plat_ide_probe(struct platform_device *pdev)
 		alt_base = devm_ioport_map(&pdev->dev,
 			res_alt->start, resource_size(res_alt));
 	}
+	if (!base || !alt_base) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
-- 
2.25.1

