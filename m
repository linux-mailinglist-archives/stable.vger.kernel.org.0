Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76274BACAF
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 04:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404882AbfIWCe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 22:34:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38122 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbfIWCe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 22:34:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so8196557pfe.5
        for <stable@vger.kernel.org>; Sun, 22 Sep 2019 19:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uUqRhL6WQ3qbg0PTyQYypbpaL7UfIqi63D3k5sB6pWs=;
        b=T1XA2rMEoe0wwjcs6Lw2R2slymbgzBQjfhy7tJ1/7KVjVWHsRmc0dZyzmXMlFesi2q
         5LM2BZMWphLKUzGlO6esTsOB0LUzCzFf61KGgWRleD/0Wnz39W0xgk3/LzV2na0By7EE
         q+hiWZ99QiGw1X2eauny+KIWg+wHmh6r1AD68xf1js8Oh/NcOr2qqoLdyqLDlGHFu1fp
         cnOeHl1UAFenGhUGvWrn2bknCE0Z6IrGzwggE45VY9umhK3egepZw/Ol3pehNUkwvgqd
         41yLNKQUTThLF9w6HkjQiI1xICUoefXTD5hLytPdNfRvA/7g2L2O/ggit4borgQjYJeX
         PeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uUqRhL6WQ3qbg0PTyQYypbpaL7UfIqi63D3k5sB6pWs=;
        b=f+kP3aCHwTxOmfGOrfwawt93oH1HbnxneBBACXbz3Ha6syiKonXQXDTZrt2J4tKt4J
         iHeHIdF7tJONjtH9sAojVWa/LaETDCe0yaX48O0jD0/HsMm2/Ya9aAJ65OvusdTWqKx8
         /oeraFnKITRilpZgyFVJ0VvmYr6iQGqswGUghEBmzd2ShAFaPZB7i3TztNpxQflGkzi+
         DL8hjkW8O/fKGyTiGXmsVY7xcikskpna4RNjRlXRRuJyuc8iynpgLDqFYkpQji66ton4
         mgw8M8LsdkzL6x6dz6wLIuu+DF6xzfDC+oty0d8DEasWsAMZI6xvp7u7Y0sGCEQlO/Xz
         YlqQ==
X-Gm-Message-State: APjAAAUN1wXCwtI67lKdw2Hi8O/UrKk0fbJH09sXz+bQrTdy46vVvRj5
        IPkUuUZGx5DTpVBzw0KALgI=
X-Google-Smtp-Source: APXvYqyT/C0ctGi44KRmNkrmYomsRYIuCcnaN9cQV4PewxSqAc/1BJv5NbBpjjcbXBkWtVYWoDORaA==
X-Received: by 2002:a63:e812:: with SMTP id s18mr26164581pgh.291.1569206067886;
        Sun, 22 Sep 2019 19:34:27 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id t12sm7596766pjq.18.2019.09.22.19.34.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 19:34:27 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.9.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 23 Sep 2019 11:34:21 +0900
Message-Id: <20190923023421.20328-1-ikegami.t@gmail.com>
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
index de35a2a362f9..8725e406a9eb 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1624,29 +1624,35 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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

