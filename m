Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C34BACA7
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 04:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404482AbfIWCeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 22:34:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35462 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbfIWCeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 22:34:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so8209821pfw.2
        for <stable@vger.kernel.org>; Sun, 22 Sep 2019 19:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=olfyRzbV8M+cZYIlrHmiKQMFSiGHjLyePCXwy/Ik6xI=;
        b=A7vN0mahL+iuOHpzHbGW4MXq1bsSSuAw8pWF+ah/HlvNRK9mWyQtxNUX0k+jZykDg2
         s/VPUxLUBcVJGE67k2UH1qgP1pyVFiEeQ/tZ5As7jfEvRag9FGwt0/RCvs69mhyzWJi3
         I5o8D4cW86dIY5cEATjk1xvnO6uuixF2jccioi19t2BuHSLa4BtyQ4DEPKfVEhmCOMHH
         q9PNTPCj8Or/wvPoAigQr229POnBohZLTMKR3+DaAVglVTwhlXzntyPIZEV5cZl/90pN
         T4M9CPghGm2amRXu18bX1h2DsiHwHvDe6kpyfxIdRVHewtG5l4LMuNzZ/gk0zAYmAI6v
         LyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=olfyRzbV8M+cZYIlrHmiKQMFSiGHjLyePCXwy/Ik6xI=;
        b=ff1Owns3YtGML/n41aSdTulLQUp9qoaQCh246sVEha74LhCo/XPh1FypxihRIeJRc1
         qx0FPhDB6qUuEHsFSxb7vUBSZ5IRmUJI35QQ0fodjb00kP9vxM0AFTjP5lWZcDg2Naya
         qN9Rk4xPnywKkcS0karC7vI65vIeZvuoKgp+tuQKcLXjTxO9kPO17Cevne1vRdcPWbJI
         sJYP9byfea/qoRBJ/U5AV4cVEGnI0KZd5TD5V867qWdT78f1MR5pvZtO2NNTm2YhnQ8w
         jWRHIsYGwuaE9RTXD8WIg+9dBXuVaIF2L5m/3BNf+KtRpJfFDMAhM5DfwOpQ2m4CKlXf
         lxRQ==
X-Gm-Message-State: APjAAAV7a4+T7MV1RDFaATyZ0LlMXld/gotTk/Cd6Dq6mb+E8Xr5cp8X
        PSKk6h5hwM78jggIS4sw7aM=
X-Google-Smtp-Source: APXvYqyZm+iC57DXxob5AOei7j/ZUAQTRFyi21kwj/khROFMBah9Chtg618Lzz6LLLc5+ax5cClYjw==
X-Received: by 2002:a63:1009:: with SMTP id f9mr4787691pgl.124.1569206044921;
        Sun, 22 Sep 2019 19:34:04 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id s7sm8697403pjr.23.2019.09.22.19.34.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 19:34:04 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.14.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 23 Sep 2019 11:33:58 +0900
Message-Id: <20190923023358.20279-1-ikegami.t@gmail.com>
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
index af3d207c9cc4..e773dc6fdd3c 100644
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

