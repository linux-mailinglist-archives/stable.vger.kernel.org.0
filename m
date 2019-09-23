Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD55BACB1
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 04:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404471AbfIWCen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 22:34:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37305 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbfIWCen (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 22:34:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id c17so7139409pgg.4
        for <stable@vger.kernel.org>; Sun, 22 Sep 2019 19:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mrHC8QGuZxOCxpQ1rrDbH0NR2xsFdEhMXsSzfS9GAKA=;
        b=dG5oRwwXRBLWqHzJYLw/IcltvwouTaQ9ymgAujUjvvWz7ciDj1Xpk1daQMRDANeguI
         K7fzzgOqi1aZUq8i2HiJFWUDejp3yRUX6pRYoqpECK9PLdFUUuxmowhsSEnTXN1Ahrpg
         j4O0ZKYdrNK0EeEW4Rn4eNjgwRGamruYqKNUrM/RHTwfn0bwpOyj2AlhiMsqxMi/9jAL
         CMT9+Dbp7eqHY9ePNs5B8pRdv0KXXHM7W7nbvOKIB1bosptGc4dUzxIkvu6DqnAywQuA
         dPJbBm/gnZTRNokHUfH+Nc/6i1DyA2/PTLYu7LvP3gKmEwTsraFt4axmEaYCwzWmnRQx
         +2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mrHC8QGuZxOCxpQ1rrDbH0NR2xsFdEhMXsSzfS9GAKA=;
        b=mNpjFcj6qGsRcjYaBPylOoDHcc0M6rBrpO9lp7UpWz5jTXebYQPrF3YAS5kvxXNd4s
         gOjedoDMWfu0UwhSNYqHQfLzb8ep8blVBYFb7z9jWeM5n1rO2IUfV49Q9zZMZuWuTUpl
         NZYgKgqy0gY7X3GKSZe91Tmjt+P+SzLBAr6uDdFO8CrbCZ+QX5fZDjLqis4P/fKiFwMR
         r8gTevuP/hDJKsWPfdvFhsU/VqosSAGU1Ss9szi4RE7j9uhSPjbI2G5mzs4kOI32MSjX
         RjW23vX5YkUFFLPTwZGSPsZ7kwjMdOn3GrTmGBVWks1uIVxSRSYTx04vwnJTqym2q5oj
         B7vg==
X-Gm-Message-State: APjAAAUiTf/uTxQCOl7jLK9QDl69mlVK79HvmTO2LpfB3UFBYw78H/hu
        gcuu9kco5WAxHuOUhhJqcqQ=
X-Google-Smtp-Source: APXvYqxTZfAhwf4Q/RvnFB3AfyFyk+Cy+6CCxJQPFBca8QHR3mOSLz8FMHjJfH5WUfo1Rdbz/vQt5Q==
X-Received: by 2002:a17:90a:220e:: with SMTP id c14mr17764702pje.6.1569206082602;
        Sun, 22 Sep 2019 19:34:42 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id f62sm10519515pfg.74.2019.09.22.19.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 19:34:42 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.4.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 23 Sep 2019 11:34:35 +0900
Message-Id: <20190923023435.20377-1-ikegami.t@gmail.com>
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

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index fb5a3052f144..7589d891b311 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1626,29 +1626,35 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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
 		map_write( map, CMD(0xF0), chip->start );
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

