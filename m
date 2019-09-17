Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7EB549B
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfIQRwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:52:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46100 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfIQRwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 13:52:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so2379223pgm.13
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3xoBbv73tKSb35chuDrteuMuwVgmL1EzbHL+TVxu3jQ=;
        b=Q9xyCHQJH1qy1vs1PCxRWSI66qtGbBnvVQwOdEF6n5JUvIuk/rwRf5ZdocSugS/Nut
         5X+z02U1efaJxSjOUauiF40qW7bALSnqnImhYRGvh7aoRSI8uVzs0J5VM434qrmB7Y2C
         QV60jCVj8aI1XPKSCpNBPOxdxxjLvaOEI48O+miqVlJnm9307YZSIzbPX/jIC1KIO2WT
         rDaaqpp6hwDfjB6LQgi7FYJLsLI7QnOC+bn71mztR66I3KGhFFUjRTqtT9T6GN8YpHdJ
         9oAUuPWZPL3KAcr0oJmDxu+ZOyjPWGkJb1kBbxAblugrzdg6wNmZHsWF+wlEPjOVKe2Z
         CjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3xoBbv73tKSb35chuDrteuMuwVgmL1EzbHL+TVxu3jQ=;
        b=F2VMaCN7ZkjeZb6GNeU1kDtBEs7c+2F8uw9bv7fZFE4i7lcjrWST0iX/qjV3tCI6dS
         N5qI1NCbVvK5CENqHY401E/QPjqL8QuhtWt9KAvmyyH0B1lhT6AdkucREYt9U90nvcbz
         EBQaWH3bSUYuvzgGHWcOAhZHmAynmPXfXYiTol/SuE6DdaiHQeaU64vHvEBNK2zYwQnZ
         WgwEUrqgjrkOq+Mk8Tv/E7EvitS5QhteiLKJnn5lJXVM0IXYAvn9evlisb4w0PHGRwu+
         jSMbAzxH9R8aj7Dyp9bdMk1JRcA3drxnJb0NGhaMZwrLm60fb1MRyI4LsFkTDOV70HmM
         GkGg==
X-Gm-Message-State: APjAAAW+MM01CmwZg6C79Urpd5Yizvu0n+I1wDTMTmsn/nonF0LoY6JL
        ZLOh0kpy3ihLHcAkkVwypH8=
X-Google-Smtp-Source: APXvYqzaCxaVPRz71zRicfCrWHia/Xp7uKyeMWb7VDV58mEXRUOmgs0fpQ3oD48fri5n9LvCES90GA==
X-Received: by 2002:a63:4423:: with SMTP id r35mr36954pga.235.1568742734496;
        Tue, 17 Sep 2019 10:52:14 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id r187sm4634283pfc.105.2019.09.17.10.52.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:52:14 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.19.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Wed, 18 Sep 2019 02:52:05 +0900
Message-Id: <20190917175205.16391-1-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As reported by the OpenWRT team, write requests sometimes fail on some
platforms.
Currently to check the state chip_ready() is used correctly as described by
the flash memory S29GL256P11TFI01 datasheet.
Also chip_good() is used to check if the write is succeeded and it was
implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
checking").
But actually the write failure is caused on some platforms and also it can
be fixed by using chip_good() to check the state and retry instead.
Also it seems that it is caused after repeated about 1,000 times to retry
the write one word with the reset command.
By using chip_good() to check the state to be done it can be reduced the
retry with reset.
It is depended on the actual flash chip behavior so the root cause is
unknown.

Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org
Reported-by: Fabio Bettoni <fbettoni@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
[vigneshr@ti.com: Fix a checkpatch warning]
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)
 mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
old mode 100644
new mode 100755
index 72428b6bfc47..ba44ea6d497e
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1627,29 +1627,35 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			continue;
 		}
 
-		if (time_after(jiffies, timeo) && !chip_ready(map, adr)){
+		/*
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
+		 */
+		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
+			ret = -EIO;
 			break;
 		}
 
-		if (chip_ready(map, adr))
+		if (chip_good(map, adr, datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
 		UDELAY(map, chip, adr, 1);
 	}
+
 	/* Did we succeed? */
-	if (!chip_good(map, adr, datum)) {
+	if (ret) {
 		/* reset on all failures. */
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
 
-		if (++retry_cnt <= MAX_RETRIES)
+		if (++retry_cnt <= MAX_RETRIES) {
+			ret = 0;
 			goto retry;
-
-		ret = -EIO;
+		}
 	}
 	xip_enable(map, chip, adr);
  op_done:
-- 
2.11.0

