Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187B0B54A3
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfIQRye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:54:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40259 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfIQRye (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 13:54:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so2588023pfb.7
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 10:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=onUVZCBtscC5yuxfoy+zsVbxl2PIwO0NVQMjTwxZqeg=;
        b=nfc3aLnN69+bt1y7/dIbf8WtiUmT8BJWb6cOUZfM2bUV+P8QZK+rf4wGlI2YtZ7IhQ
         cK0BLdUdjK/IsJ5hgiQSGju1p6RwgSJOKrHvlv4ycGYnOHAdXigp8fhCauhtEr9tZujS
         hSqIlp1a3iAgN0Ryxrhb4ta6H6UqSUEyZr/9uGHhFnnwHGwQf2GtpIHHJAzxHSLBE2Lw
         lv3oWObg1w8Skp/YyCwikjpPtWWgQFyFAVRuNNnKGefFxNfZ9lNB7JNcCwvSe5wjJViB
         D6b8UtUO1YQ+pTlrxMDkk5qEfzGqTCgNI+mp9TSSVsfohv0huMDTTnB6NmyK0PE1opeZ
         xGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=onUVZCBtscC5yuxfoy+zsVbxl2PIwO0NVQMjTwxZqeg=;
        b=ft5LxMPACWKVZ80QJsZFWUgNmBkzu/iyymoq7u7oVOpqg2By5t8B40z2rw1Fmg0T2e
         8FraBSyYtl5pN11XX84dfbfiZGffkK3RASp0YaZ/yzsZDB+voDShzWgqPD3jss8lpiLr
         f5fLjmLiCjASSBp4bEAyIkAF2shBHvzvWROfyEWWMAKUzHPJ5+OSwlJpPHHdTPL31qeK
         Jj0C/4/JRaH9WDrxyJnEu6Z90OUzLiaeIJhRFZm+60J89dG7ZtKkVA+GiuqE9KyOdpGQ
         m1d7SHYkFz90bLoBqP2ga1ex2aKDsjGgULCTeoqdRS/CueUlnqCxBxK31lBfIqv+KwRL
         c2sA==
X-Gm-Message-State: APjAAAW9u+6FgxLE16A6Jjr/sUhFmmNY9ECkxJDbSCobXR3IbHo2xvf7
        e8v1d7vK4plcT/8wtM0STGE=
X-Google-Smtp-Source: APXvYqzlYXc6UcokK2JRSKaWgD2ZROhMynTr0wgcSaUXVcWjEVFlHEcPokkxvP9YPg1EscUh8Aj16Q==
X-Received: by 2002:a63:4e44:: with SMTP id o4mr53303pgl.103.1568742873677;
        Tue, 17 Sep 2019 10:54:33 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id l124sm2841929pgl.54.2019.09.17.10.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:54:33 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.9.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Wed, 18 Sep 2019 02:54:25 +0900
Message-Id: <20190917175425.20141-1-ikegami.t@gmail.com>
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
index de35a2a362f9..8725e406a9eb
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

