Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719ECBACA4
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 04:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404383AbfIWCdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 22:33:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37096 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbfIWCdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 22:33:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so8200270pfo.4
        for <stable@vger.kernel.org>; Sun, 22 Sep 2019 19:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L0CPgCufl3kk7hZTqN/fh/41VjDv8bX2l/BiIIFM92U=;
        b=k6TfXXWAJvRs1psBuPG1jMNUkik0szqKx/RocEFaswy2giB3LFcf4QugLXSmJLpBXD
         P4xlqNBqjO31tkqY2Npm2qH6lI/cVNw1NR7axGvWUQOHWP5XpvSbZEZu9a4+RqxEZpqV
         M9ht42Vi7WgBIdwKefDR5OztOQ/ehVxGGtRskxD6Bg6PmMUQAbEOCo+CLq/sWvnWwXJ9
         IUsgrfGKS1LYl28kNYrFFa3VLlUDYGNUQ6DOGP7pl8oouPbgABgT0VkECbvg9a49apyU
         PwmUgG0P3hf1QJSptFfsBeFeUQZJKqcROVaeunNxFiM+pkhDDT3BZaIaDHa8D0bdzeQM
         uwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L0CPgCufl3kk7hZTqN/fh/41VjDv8bX2l/BiIIFM92U=;
        b=GglzDz6/RzRM+T1D2iaHwVlMmcCihYr5dNH6e2VG0jTMHCmsQqbC97TSQQHcAUk4/2
         7U+hfRPgRSxKtI5cyl/1mGwoIdrICY8fvew7jkCMQPgtY8LII5HAXDqQ3uyMqV7s7ebJ
         aOlUgzQbLzRc0lY+ugDQlYYLITrUy2vC6e89ibTIU9DkUxwQhSzdWC1ebXuM1buZEt/P
         8bT9LMC+DdTx5WKUzNLBOb+SDjiF3lcoNeScmvwxvMBKz2LQVVpGJhzaDOvhTO+YvuMw
         4ar7/7q8OosJUn/WJLJ8Nc29BEcYkhqyy73bJUV0ngCCiQr14ist9mNTS+EWbBQK9AAA
         W+BA==
X-Gm-Message-State: APjAAAWIRdz7tBkESpkQpinTJoLMSocS6Nyb1/YSYapvj9Xt825BxoRb
        oF8xUCG8rYgm37qEZMgu0dE=
X-Google-Smtp-Source: APXvYqy8JAFETTITBduEzj1zkSULkQzQoDOhOpNX2B3aJRWsyOz1XgaMD9qnrpqwQaEhI8O+TuHVSg==
X-Received: by 2002:a17:90a:7f89:: with SMTP id m9mr15098423pjl.30.1569206013055;
        Sun, 22 Sep 2019 19:33:33 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id i126sm10010566pfc.29.2019.09.22.19.33.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 19:33:32 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.19.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 23 Sep 2019 11:33:26 +0900
Message-Id: <20190923023326.20230-1-ikegami.t@gmail.com>
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
index 72428b6bfc47..ba44ea6d497e 100644
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

