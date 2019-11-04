Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83629EEAB4
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfKDVD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDVDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:03:25 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCB9204FD;
        Mon,  4 Nov 2019 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572901404;
        bh=ScvQbq2CKzC40TGamFZm11Y2B74EFf3D2/9uv44FwJw=;
        h=Subject:To:From:Date:From;
        b=EOGkl6GuICG8k7aUHDHgazOvsMR7rhWg59iwf4q6SN80/pApcAuteYDEfUGw2sWAy
         QsT/DqfHLSaj6rsA6ufaLf3XPoveIaPIMUvd7z/kblq+GIyutpRfppuUzTylmdo5WI
         /6ojuoIGJbk9hyn+xlVUvpVqfEm6FkY5i7rN7qk4=
Subject: patch "coresight: etm4x: Fix input validation for sysfs." added to char-misc-testing
To:     mike.leach@linaro.org, gregkh@linuxfoundation.org,
        leo.yan@linaro.org, mathieu.poirier@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 22:03:09 +0100
Message-ID: <1572901389130186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: etm4x: Fix input validation for sysfs.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2fe6899e36aa174abefd017887f9cfe0cb60c43a Mon Sep 17 00:00:00 2001
From: Mike Leach <mike.leach@linaro.org>
Date: Mon, 4 Nov 2019 11:12:42 -0700
Subject: coresight: etm4x: Fix input validation for sysfs.

A number of issues are fixed relating to sysfs input validation:-

1) bb_ctrl_store() - incorrect compare of bit select field to absolute
value. Reworked per ETMv4 specification.
2) seq_event_store() - incorrect mask value - register has two
event values.
3) cyc_threshold_store() - must mask with max before checking min
otherwise wrapped values can set illegal value below min.
4) res_ctrl_store() - update to mask off all res0 bits.

Reviewed-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Fixes: a77de2637c9eb ("coresight: etm4x: moving sysFS entries to a dedicated file")
Cc: stable <stable@vger.kernel.org> # 4.9+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20191104181251.26732-6-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../coresight/coresight-etm4x-sysfs.c         | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index b6984be0c515..cc8156318018 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -652,10 +652,13 @@ static ssize_t cyc_threshold_store(struct device *dev,
 
 	if (kstrtoul(buf, 16, &val))
 		return -EINVAL;
+
+	/* mask off max threshold before checking min value */
+	val &= ETM_CYC_THRESHOLD_MASK;
 	if (val < drvdata->ccitmin)
 		return -EINVAL;
 
-	config->ccctlr = val & ETM_CYC_THRESHOLD_MASK;
+	config->ccctlr = val;
 	return size;
 }
 static DEVICE_ATTR_RW(cyc_threshold);
@@ -686,14 +689,16 @@ static ssize_t bb_ctrl_store(struct device *dev,
 		return -EINVAL;
 	if (!drvdata->nr_addr_cmp)
 		return -EINVAL;
+
 	/*
-	 * Bit[7:0] selects which address range comparator is used for
-	 * branch broadcast control.
+	 * Bit[8] controls include(1) / exclude(0), bits[0-7] select
+	 * individual range comparators. If include then at least 1
+	 * range must be selected.
 	 */
-	if (BMVAL(val, 0, 7) > drvdata->nr_addr_cmp)
+	if ((val & BIT(8)) && (BMVAL(val, 0, 7) == 0))
 		return -EINVAL;
 
-	config->bb_ctrl = val;
+	config->bb_ctrl = val & GENMASK(8, 0);
 	return size;
 }
 static DEVICE_ATTR_RW(bb_ctrl);
@@ -1324,8 +1329,8 @@ static ssize_t seq_event_store(struct device *dev,
 
 	spin_lock(&drvdata->spinlock);
 	idx = config->seq_idx;
-	/* RST, bits[7:0] */
-	config->seq_ctrl[idx] = val & 0xFF;
+	/* Seq control has two masks B[15:8] F[7:0] */
+	config->seq_ctrl[idx] = val & 0xFFFF;
 	spin_unlock(&drvdata->spinlock);
 	return size;
 }
@@ -1580,7 +1585,7 @@ static ssize_t res_ctrl_store(struct device *dev,
 	if (idx % 2 != 0)
 		/* PAIRINV, bit[21] */
 		val &= ~BIT(21);
-	config->res_ctrl[idx] = val;
+	config->res_ctrl[idx] = val & GENMASK(21, 0);
 	spin_unlock(&drvdata->spinlock);
 	return size;
 }
-- 
2.23.0


