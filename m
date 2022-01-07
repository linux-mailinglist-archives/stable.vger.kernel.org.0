Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41074876C8
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 12:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbiAGLuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 06:50:23 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:39206 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347228AbiAGLuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jan 2022 06:50:23 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowABXXp7pKNhhIsD4BQ--.39687S2;
        Fri, 07 Jan 2022 19:50:01 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     David.Laight@ACULAB.COM, damien.lemoal@opensource.wdc.com,
        davem@davemloft.net
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v3] ide: Check for null pointer after calling devm_ioremap
Date:   Fri,  7 Jan 2022 19:50:00 +0800
Message-Id: <20220107115000.4057454-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowABXXp7pKNhhIsD4BQ--.39687S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw47AF1fZry5Gw1UKr15Arb_yoW8Aw4UpF
        4SgFWSvrWDWr1UK3WxAr18ZFyUu3ZrJa4FgFyYvw4kZ3s0vr18JrWaqFWIqr9rJrW3CayY
        v3W7tr4kuFZ8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8KwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU589NDUUUU
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

v2 -> v3

* Change 1. Correct the fixes tag and commit message.
* Change 2. Correct the code.
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

