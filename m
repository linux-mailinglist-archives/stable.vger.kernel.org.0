Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86A6BACA2
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 04:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404340AbfIWCdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 22:33:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40566 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbfIWCdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 22:33:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so5852932pll.7
        for <stable@vger.kernel.org>; Sun, 22 Sep 2019 19:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xoixj4WcbUR0QNe9dzuhd7SQ9clDGmTGtv+vABF9xr0=;
        b=RIPSxSGSGr8c2+Ai8oYcf6JV+2cV2Sba4bfL27UX/yYxkBma4CYhLdhEo8OgS3miLy
         OcKQzqumi8HPqvbe/rIZbshBtKk8chNvXrCUGDsv/X1xzi1LQZQY2eqmHxhN4hIi2o6j
         K64eB2+ALesrLwfUa3jB5Ew18maNMSo04BzvdEjc6wDlYrdpthFkqbTCejoPz2W2IxKp
         VaXeJRcVbsTjNsit+8AEvt1YJSQzE7tYWjKAt9F8bhmQ6I8PoMLj4ABar4Kt90CprtoV
         JUc6/+vtZ9eeytCYvJl5ZlTO817z/Xym8iBJUk8kL6/Qkmiav5naJwuWzFXtSt+s2o1X
         Am7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xoixj4WcbUR0QNe9dzuhd7SQ9clDGmTGtv+vABF9xr0=;
        b=jHkOjfND16vYbTJevSq2Rk9EdF7fIeGSpskERD56cphL0TSFOShsky0hZXx/3uexBb
         MyHKAU2fhm4GEHCkcPW8VwrWUdy0OwnCuNU+joF44kfQGghclcbl0iyYecggQLrLhGgP
         VdhGfhxWa/EfwJbKfdtD8ncBg81xRQ3f4TRTW3CK8hgAY3SZbfjgT+VHUQNDy43zUJGg
         Mrx+e2VZDGkiImhVKJZ+aOUN2FpzwQCKZT7f60TPqDZTC8kljlIVIA04u/xiY2p4k6aR
         0mj9lCQBxJOii1NA44S0C/FjjzevpePfJ8RZe1c/FHMfmcZb7ArdPdsQa8rWyWhS+zOt
         KPTQ==
X-Gm-Message-State: APjAAAWH1a3BId+DGrmlbVsIbCUr1vL+Ic78tFAqvFpDqGFrj24+GcCS
        bFnYv2UrNXjNTNJIJiYqMtx++khu
X-Google-Smtp-Source: APXvYqwA99vWR8wgnVNyo/j9SHbrLddwoCS/EfgFAC/OkckQuCpN7vOzu9zoj5wCWsl9vKXz0OKKHQ==
X-Received: by 2002:a17:902:a615:: with SMTP id u21mr28547709plq.4.1569205983038;
        Sun, 22 Sep 2019 19:33:03 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id o195sm13517299pfg.21.2019.09.22.19.33.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 19:33:02 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 23 Sep 2019 11:32:51 +0900
Message-Id: <20190923023251.20180-1-ikegami.t@gmail.com>
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
index c8fa5906bdf9..ed3e640eb03a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1628,29 +1628,35 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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

