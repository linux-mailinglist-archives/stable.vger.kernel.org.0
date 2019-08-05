Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCE08253F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfHETDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:03:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45314 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHETDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:03:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so40187776pgp.12
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=605yGL6yEzP68D5/hqewP5GiyzS32TYrjnFMz+/3b1w=;
        b=RiD6DLpbvqbzKrxrBEOt01/rqLUSu7Us6JaoEFVjMahW3OF7L59XC3wObVNUXnMavO
         FvXaGl0SNyGOV3RMA9llCf5b9xJccrsThQ/8kSQmcvxo+zaWBkkkvO7xkHQSTGxnujQw
         7ulO+0VWmTZ0vxGXtBUeYAdEtvGn7ONzTt70d09BqZDYagu7RSBcQBUx/608orVO2gTX
         o/6Kh0HbiFbB7B60IKxkMC5qShL7XSFwcYbUCU095AlCN405m8qSVW4HVDd/yyyEiedX
         aPX+aNKzW/byDqaG2UVm4Oic6NEw9NE6O3cF6FybCsA2qv0DPl8OqwRWYEVAaZOWfcRN
         WRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=605yGL6yEzP68D5/hqewP5GiyzS32TYrjnFMz+/3b1w=;
        b=SfnYAAeC3HrHlrtIRqR80pp5JBuaMlRc7FPa+RTEdS5bjaPZwMvO2UsSr76oHH3n4W
         +/huy9KT+EY+HOJtcF1InrfD1yp4becWPi58bii3mXLjV5TGsTTJ7ufMuc0OHsRcnXoP
         sArfQ/EV8bMIT6Cg3m66xASofsDYjqMO4oDsQS99YKKF1S3AzVdl1bKWQZs2wDV/V4UV
         d0FZ5UQz3AkHDfQCPHjurIf3yWQD21LFe9uFlehXqhTm3J0BTQ/4xTR6DLWR/l+vD/3i
         1Fk6QQiGISoOHWs28rz6KSIS3/ZTg6uC+8zAJw5vRZ4sYSlHdue2ILUhCQ+jWORIOeqV
         741g==
X-Gm-Message-State: APjAAAVjXdp6/IJVsvD3ZR4/lT8mldCi656preyg7foH3rv9leFnq+lu
        Nacc/bnn8VFaMHtzlGHlZpE=
X-Google-Smtp-Source: APXvYqwrQIPe1BDuX4xFc0UMP7ax23aEKs97vQ7OOArKcHJ4q3GfCesHHCWpMlr5/29hcQIQkg4MZw==
X-Received: by 2002:a63:9d43:: with SMTP id i64mr21895683pgd.306.1565031823889;
        Mon, 05 Aug 2019 12:03:43 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id q198sm88045579pfq.155.2019.08.05.12.03.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:03:43 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH v8 1/9] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Tue,  6 Aug 2019 04:03:18 +0900
Message-Id: <20190805190326.28772-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190805190326.28772-1-ikegami.t@gmail.com>
References: <20190805190326.28772-1-ikegami.t@gmail.com>
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
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Reported-by: Fabio Bettoni <fbettoni@gmail.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org
---
Changes since v7:
Rebased on top of polling status register support in master.

Changes since v6:
- Change the tag of Hauke Mehrtens to Signed-off-by as confirmed with him.
- Removed the tag of Koen Vandeputte as confirmed with him.
- Address the ./scripts/checkpatch.pl issues.
- Fix to remain the file type as 100644.

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

 drivers/mtd/chips/cfi_cmdset_0002.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index f4da7bd552e9..19787a14350b 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1717,31 +1717,36 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			continue;
 		}
 
-		if (time_after(jiffies, timeo) &&
-		    !chip_ready(map, chip, adr)) {
+		/*
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
+		 */
+		if (time_after(jiffies, timeo) && !chip_good(map, chip, adr, datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
+			ret = -EIO;
 			break;
 		}
 
-		if (chip_ready(map, chip, adr))
+		if (chip_good(map, chip, adr, datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
 		UDELAY(map, chip, adr, 1);
 	}
+
 	/* Did we succeed? */
-	if (!chip_good(map, chip, adr, datum)) {
+	if (ret) {
 		/* reset on all failures. */
 		cfi_check_err_status(map, chip, adr);
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

