Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D87F487484
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 10:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346372AbiAGJMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 04:12:18 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:57514 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236305AbiAGJMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jan 2022 04:12:17 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowAB3fS3YA9hhOGtBBQ--.3160S2;
        Fri, 07 Jan 2022 17:11:52 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     damien.lemoal@opensource.wdc.com, davem@davemloft.net
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>, stable@vger.kernel.org
Subject: [PATCH v2] ide: Check for null pointer after calling devm_ioremap
Date:   Fri,  7 Jan 2022 17:11:51 +0800
Message-Id: <20220107091151.4057283-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAB3fS3YA9hhOGtBBQ--.3160S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw47AF1fZry5Gw1UKr15Arb_yoW8AFyfpF
        sagFWIvrZ8Wr1UK3W7Ar18ZFyUu3ZrJa4FgFyYvw4kZ3s0vr1rJrWagFWIqr9rJrW3Ca4a
        y3W2yr4kuFZ8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GFWl
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUIhFcUUUUU=
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
Cc: stable@vger.kernel.org#5.10.90
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog

v1 -> v2

* Change 1. Correct the fixes tag and commit message.
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
+	if (!base || !!alt_base) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
-- 
2.25.1

