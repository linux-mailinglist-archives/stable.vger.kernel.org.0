Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3ACB54D8
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfIQSD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:03:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46795 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfIQSD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 14:03:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so2586076pfg.13
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lck7mJNvhKtQlB0h0ewSM2EoFMfluPJ28+Anr3sILgs=;
        b=AXPOOXRiahRLh0n4wb+BMFwCNIu8a2q6yIEkwRKSlxWTJ/ipdJaGLAC/O9dbqLboLx
         rLeZrq4pbed/54OcZ2PU1K5Zo5H7RPgdt68jhVA7kjmfrP4A2662Uo7pGmXDsiERjegL
         a2EMqj0bmM5/Fa6ltItqE6VuijD4RoiXuyU1YNGwfhnCiVIlh82W/r//vZhXkhM5/bAN
         fKNnRcGimNdt6omp6PS8Pv8lXDHz0wGwwDB3qqhka5mYnFDrApxBZFsIiH+lp0XCOqPH
         t0bFUuX2SZpgdZfzeTw2fLhO8TmeP/hA/A9YL7a3I9FtDuZjYaEwWuzTui2rustwdaMB
         WZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lck7mJNvhKtQlB0h0ewSM2EoFMfluPJ28+Anr3sILgs=;
        b=Laif1Kw3otAZl2I8UksRP5lyqYxRDAxackazrLSbwhrLbc3hmT7QevKc3kPDCW29wh
         IAFScTiQMDCaNSK4BDZVyDEupcEwXQtu0spQEU7uiwYjKbrHlcpn/FW2Q+ZStyLSwgFa
         jvowLqnHidkVKrLxlI6SP937CDyE2XYEeXdHWj6/lwB9BcxByXtxtTFE4Fhiq9TAGH1I
         BrJuxAuKvH/sxxN+TKj+vCn460DEz3kO95OruS4SPg2I/HN4HKGG44x6GnWovYSYImlU
         XJCqbeQFqwJ8myCiQlkhCMmFIYj0IFediOlwfhevzpj3DNkuURSIiNYqCRdn7Jvbnrpz
         /07g==
X-Gm-Message-State: APjAAAUtdmWluPjwn3EgIb53wtqunpulUxDPjRlzs8yKs0J2sPNuGmZn
        nAm87jH9gCqpvg/wEXRB9xQ=
X-Google-Smtp-Source: APXvYqxRpV95thKlVBJdPEV34NQ17fE+SwXG9FMXOQQVSEzi3Cb6JKc8N7ErQlLnLae0y6mriszPWw==
X-Received: by 2002:a65:5188:: with SMTP id h8mr106707pgq.294.1568743408670;
        Tue, 17 Sep 2019 11:03:28 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id o9sm2505263pgv.19.2019.09.17.11.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 11:03:28 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.4.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Wed, 18 Sep 2019 02:54:52 +0900
Message-Id: <20190917175452.20891-1-ikegami.t@gmail.com>
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
index fb5a3052f144..7589d891b311
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

