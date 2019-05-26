Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC32AA74
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 17:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEZPjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 May 2019 11:39:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40291 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfEZPjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 May 2019 11:39:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id g69so6051155plb.7
        for <stable@vger.kernel.org>; Sun, 26 May 2019 08:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uLQ3Werazxybbz57JZRnXyeiPAj1arCFDNXT9NkV8Cc=;
        b=sTuRXYpwE2LQ6HQG2nGZmYog7lvNBrU7zTrzxPUzOdMKHE+M0HQGTYwsZhSaciheSN
         Fv8cM6FjhnuT+QAabdFJ92COpX/96Ahn1ucea1ZoYPP46n5HB3mQFTczVaUmsH6o1tfc
         UHWg5XaUV6WWv3V/QqZ4s1xeJdmMZ+mNkFLFN5CZOu0+rU+wZPjlYVKk4Zbts3gvffJp
         Ctcl+zW5EFWPKYjehKtCSn/MWRw4KHoS4Lbp4RJJUbVhiDwSOBORvsY1r2BanpsdQ3hm
         U1sKfUAUwm3QYoV0/c51dw9AQnSwtRQVX1QCCkt/AwKsdZIvS5uGjqaKss9Z2jltm8hU
         oSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uLQ3Werazxybbz57JZRnXyeiPAj1arCFDNXT9NkV8Cc=;
        b=fV+4+kndZamxuhTx03ZkE8lJHu5DyUCLxDy+2OzhoWcbgEuAaNS7Ww6YVigC8mm2ot
         yK5VTChbT/h/SUfeWBQfYhfGpnPZS52gSRJZWb3hC4cxdWOp4Ohf8N1bzG5TqnywGZX9
         24Yju6zpDH9lXo7MRJv72ujL6dMkQmTRMzVYRI/iZeKEmVd+J0/nXqEvsEnATayLYoEL
         iizSMKtBAVkYM5AEbcN5TmjAbb4hJr0GPBi/xuxXHHevsof/bwGG1zQuY94FnhbF2rug
         KrjsY5ZGwt6hg44S7S7I78XmGWyXpeaH2MpIutTotDtpcINPTfCDGGroH0VG0vUP9lRH
         rrpA==
X-Gm-Message-State: APjAAAVgU0rB9rIUF6E7m+yqLnFTzAlH4uBch6gMiSsGxxw0ojto3/uY
        ksovqnNww0HJ9mNr/aapLp3j7H7t54E=
X-Google-Smtp-Source: APXvYqx4Pk4R53PvmzEUZtUMfn88IMbs+vEOVjLSu5V8TeA2M9z0usEYAgGkELnXUka+jMMXNJ08lQ==
X-Received: by 2002:a17:902:728a:: with SMTP id d10mr19605179pll.90.1558885162442;
        Sun, 26 May 2019 08:39:22 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id o2sm863129pgm.51.2019.05.26.08.39.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 08:39:21 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH v6 01/11] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Mon, 27 May 2019 00:38:54 +0900
Message-Id: <20190526153904.28871-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190526153904.28871-1-ikegami.t@gmail.com>
References: <20190526153904.28871-1-ikegami.t@gmail.com>
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

Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Co-Developed-by: Hauke Mehrtens <hauke@hauke-m.de>
Co-Developed-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Reported-by: Fabio Bettoni <fbettoni@gmail.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org
---
Changes since v5:
- Rebased on top of Liu Jian's fixes in master.
- Change to follow Liu Jian's fixes in master for the write buffer.
- Change the email address of Tokunori Ikegami to ikegami.t@gmail.com.

Changes since v4:
- None.

Changes since v3:
- Update the commit message for the comments.
- Drop the addition of blanks lines around xip_enable().
- Delete unnecessary setting the ret variable to -EIO.
- Change the email address of Tokunori Ikegami to ikegami_to@yahoo.co.jp.

Changes since v2:
- Just update the commit message for the comment.

Changes since v1:
- Just update the commit message.

Background:
This is required for OpenWrt Project to result the flash write issue as
below patche.
<https://git.openwrt.org/?p=openwrt/openwrt.git;a=commitdiff;h=ddc11c3932c7b7b7df7d5fbd48f207e77619eaa7>

Also the original patch in OpenWRT is below.
<https://github.com/openwrt/openwrt/blob/v18.06.0/target/linux/ar71xx/patches-4.9/403-mtd_fix_cfi_cmdset_0002_status_check.patch>

The reason to use chip_good() is that just actually fix the issue.
And also in the past I had fixed the erase function also as same way by the
patch below.
  <https://patchwork.ozlabs.org/patch/922656/>
    Note: The reason for the patch for erase is same.

In my understanding the chip_ready() is just checked the value twice from
flash.
So I think that sometimes incorrect value is read twice and it is depended
on the flash device behavior but not sure..

So change to use chip_good() instead of chip_ready().

 drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)
 mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
old mode 100644
new mode 100755
index c8fa5906bdf9..348b54820e4c
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1628,29 +1628,35 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			continue;
 		}
 
-		if (time_after(jiffies, timeo) && !chip_ready(map, adr)){
+		/*
+		 * We check "time_after" and "!chip_good" before checking "chip_good" to avoid
+		 * the failure due to scheduling.
+		 */
+		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum)){
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

