Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E2B54A2
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfIQRyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:54:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32915 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfIQRyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 13:54:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so2614231pfl.0
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WPG/wS1hlThmAskZmosz1ji9mhqI+gG9h0TvZkbfmio=;
        b=RL5AWXGfndm1ddkzAoWs/c1AXuEXvSX6MbZjn4WhZrA1v/2dGI0oSqIsDA0jpoI99y
         dxfvZ0galgUbfWSTUCpbtnGt19kp7n22ynEZPZmn03fKWBYApRIH+B8xHg/H+Qh26nzC
         MQstXH5rq3IPE3CAd/KvZVYi3EVmYJArg9SHOA+JNqRCLJYfVp3jImjxdO/9enT4kr/X
         7QpavGrNvyx0r5yx3KtQTX5ZfAEleMg4TBi1l4n9gRe3fDEt5LE8X0oMavJOi2mQwOFh
         PWY9eM0mRPRE5+vAGISRgf7yglheYpUnRRjm3nBvQOjpYkYWRpZq9r2leP/2InU0xG3Q
         tk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WPG/wS1hlThmAskZmosz1ji9mhqI+gG9h0TvZkbfmio=;
        b=CA9Pt8GokYzZz2MrDHFyt8hZ4Rpu9Vh1POkYkcZNOEIuPMyYOqDSQpSVkX6dxDqn0q
         /f6UMMxq5hezyXA/cV/D3igJb4YeEQZ02oSOXSeWeiIN5MPv1dNDTJJGNuphhtbRCf9Z
         hrbqp0VNhnvpVsB3Xz1a9EW1DaKhAaM8RTEuHPuah5vvVr3GD45gAm8PVIABXrZgO/nl
         QEE2zqF0UMSHoORSiWZ32P19eg/oDCPC7m6u1Z3LOTIKOEZU9r+N0wtU8TmbLtomVT5d
         7MNEvzByQrSndUEkdrUOs1HppNMG+UijgbRVauyq/Thk/wbSEvOZJpigheKs5Up1zmcX
         2gQw==
X-Gm-Message-State: APjAAAXcra79jq6HG7BJJAEMZjd1IzmEnr+hUsZHvOS42LdkG49+pbHC
        J6yvDvZzK8SRiGZpb7CFyTEsbzyXW4o=
X-Google-Smtp-Source: APXvYqxqSxM+3xex9bcZPVFmep7rU9hsR1I9Kl5QR0ZoZg0XATeUEci0PksW/ZI/hn435InVGabuLA==
X-Received: by 2002:a63:5549:: with SMTP id f9mr72061pgm.346.1568742856933;
        Tue, 17 Sep 2019 10:54:16 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id 37sm5512357pgv.32.2019.09.17.10.54.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:54:16 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH for 4.14.y] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Wed, 18 Sep 2019 02:54:10 +0900
Message-Id: <20190917175410.19564-1-ikegami.t@gmail.com>
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
index af3d207c9cc4..e773dc6fdd3c
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

