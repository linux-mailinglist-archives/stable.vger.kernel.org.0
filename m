Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F51B5499
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfIQRvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:51:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47083 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfIQRvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 13:51:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so2378503pgm.13
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=arc0Q3//8NiGztCishs5Ian0XaU+QKrsL3I7zsZs3HI=;
        b=C1SGu4Z9wn3/SidESbKaPc9/so+NbfhWdmhudo1z7/dvSNZsjs/01bFMTazMDHZx8k
         xmig8u8v+Kq9OLln0kvBesOdhSPZrFCFFV3eqkBeFX6h9b8ydFX/FCuaTDTZhfca2vW6
         paqVXLmPQD9oS9njOuHha1ykKrdS7XrWz2Tma4zwsmLZX7ekBBd6qcJbp7IwEN9t2c8r
         IW0nFO8TqbQxv11TMQJRYhSIMQNRBLs5kQ7rj1OETQJB6/kbEKm537R785PgShWbVx69
         l2qIP9vfhSk7FXBOKamQapu9bzzSZds/USIPngDOllinkXdM1V9kzcdNAX3eCWzw3SGD
         824Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=arc0Q3//8NiGztCishs5Ian0XaU+QKrsL3I7zsZs3HI=;
        b=MkklfUxAeKdt+U9UQvFHWGB9Xb1nQxzYz8v4IPigzH3Sb0UyG6C48gm1sbRBnZwwXc
         MUT1PZYNUOcN9fwQn1MNc6lWuARu9Gx64dKkIN8XoV1ZS65tFjSnkXDhD21pcSVeoXBl
         xTje0jf+Pz02KZlRR+L96QqhDvnWN0MU8sbuqWqmPUUFgkS+IVSiTmyIGZXhIeyUl0ws
         p6Qepdscuv2Z6DG8chAlDJwXUDU+PpGrZkwbh+S0gOiuG6fJ95qxOVr99f+xkwSveIBJ
         W1Z0ilANQw59Ew0i825sP+GuyMjRxAFT5umWZOQlameC3AakfGDMfKJGPhaf/TyJkNJa
         fz3w==
X-Gm-Message-State: APjAAAXwBlt5AGyubI9//v6O1pNpb4kCZP58QZxEoi034f1RYqWIEqUm
        ekakFL/b4OwVpScUYe1GeCA=
X-Google-Smtp-Source: APXvYqx21Iqp6XLCjswc5VV2O1jafFLvq+IEdCTeBHMIVU7lUlR3X5S5YALsRq3siVl2K60Ra7rWfw==
X-Received: by 2002:a62:788b:: with SMTP id t133mr5568345pfc.218.1568742700286;
        Tue, 17 Sep 2019 10:51:40 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id y80sm3353310pfc.30.2019.09.17.10.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:51:39 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Wed, 18 Sep 2019 02:50:48 +0900
Message-Id: <20190917175048.12895-1-ikegami.t@gmail.com>
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
index c8fa5906bdf9..ed3e640eb03a
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

