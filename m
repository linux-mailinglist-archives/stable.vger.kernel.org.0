Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4D04BEEC
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFSQuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 12:50:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45522 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSQuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 12:50:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi6so33965plb.12
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7zVrBvcdPjl0GzZ78aZFm1r+u0O6iXAiVi+Gz//erUM=;
        b=NTqWxPbQx5p7gokqJ3PfnlPBkfJl9fLcnheWQ6duIzMhkmYO/rVPcYh9J8+eVJaB1L
         M0hjmXsTVMx+9KdVybYagyXkzKF3j4UMYC8NlvoAFMFUyjKnZI1OAT2kW4PWe1NIMxD5
         uCxUWhNdxfyStVlnK7gDjs04hSkOmRJ6MaZSP82yBk/LoH5WuxVW73Hct1IYRc6j4PlA
         /Cj1UR2KO2hbYZgl+oQgfLwfID+qHQ43jyxfhGK+B9OzqWZlEUFh9iZI0cS1Tsl9A1Ia
         rfr1Zyfm6DFk+heoFbvJef/NMNc4Tg0/K7iW9PUQ2zAalagsYAQNwNnCazup+4BT6bRs
         ZRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7zVrBvcdPjl0GzZ78aZFm1r+u0O6iXAiVi+Gz//erUM=;
        b=pSjkltVViylLccseTSd0Mv9djZ0mF+VMT7FPrN9tVPypXvkQHz70H2ZBDpsQUnJiba
         U3xqPRbSfA4FA+K8El7PQxkEqjR76CYWtq+iZSgUTfAkTQIlKmaZjAFpNPFC4KAJlHZe
         HFWkmTrhq2PRBFGGHPaKEY++tRLMYglLpRz8tVxUgwJmYpPVoRM734iCxOOCsiQYvdz/
         WvDomDhunKszgmCezQngxLyYKdOtNX0tPVow5eGT+EyTotkvEnqe3GsO38tXzvq+YTrt
         iCpwja+wGftEbT8K990FPJbEJzoRD0mjbyBFL1dsgmvnKC6kxaSjSKrAvgsByl7hz7Tu
         HyDg==
X-Gm-Message-State: APjAAAWpljAN4AH6dVZ7AFhg0YhngAOs768mqN2KsP3NltmO6Gn98Q6A
        Tn7Qhs+hvOx7IKvFvEqdyZs=
X-Google-Smtp-Source: APXvYqzTtFtSBdTaHs9jWn/R9CI9j35mgUJ5Xs3tsHfC8R2s/+Qmo5j6lwBxjOkxFf5s00ZrxECqiQ==
X-Received: by 2002:a17:902:7087:: with SMTP id z7mr8437698plk.184.1560963019683;
        Wed, 19 Jun 2019 09:50:19 -0700 (PDT)
Received: from localhost.localdomain (M106072039032.v4.enabler.ne.jp. [106.72.39.32])
        by smtp.gmail.com with ESMTPSA id j1sm21344894pfe.101.2019.06.19.09.50.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 09:50:19 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH v7 1/9] mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
Date:   Thu, 20 Jun 2019 01:49:53 +0900
Message-Id: <20190619165001.28410-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190619165001.28410-1-ikegami.t@gmail.com>
References: <20190619165001.28410-1-ikegami.t@gmail.com>
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

