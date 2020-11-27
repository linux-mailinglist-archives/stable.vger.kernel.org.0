Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF92C6651
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgK0NHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:07:49 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8604 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbgK0NHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 08:07:48 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjFK15ZP9zLtjd;
        Fri, 27 Nov 2020 21:07:17 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 21:07:36 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <tudor.ambarus@microchip.com>, <tpoynor@mvista.com>,
        <tglx@linutronix.de>, <vwool@ru.mvista.com>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wangle6@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when CONFIG_MTD_XIP=y
Date:   Fri, 27 Nov 2020 21:07:31 +0800
Message-ID: <20201127130731.99270-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CONFIG_MTD_XIP=y, local_irq_disable() is called in xip_disable().
To avoid sleep in interrupt context, we need to call local_irq_enable()
before schedule().

The problem call stack is as follows:
bug1:
	do_write_oneword_retry()
		xip_disable()
			local_irq_disable()
		do_write_oneword_once()
			schedule()
bug2:
	do_write_buffer()
		xip_disable()
			local_irq_disable()
		do_write_buffer_wait()
			schedule()
bug3:
	do_erase_chip()
		xip_disable()
			local_irq_disable()
		schedule()
bug4:
	do_erase_oneblock()
		xip_disable()
			local_irq_disable()
		schedule()

Fixes: 02b15e343aee ("[MTD] XIP for AMD CFI flash.")
Cc: stable@vger.kernel.org # v2.6.13
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a1f3e1031c3d..12c3776f093a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1682,7 +1682,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_enable();
 			schedule();
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_disable();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ / 2); /* FIXME */
 			mutex_lock(&chip->mutex);
@@ -1962,7 +1966,11 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_enable();
 			schedule();
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_disable();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ / 2); /* FIXME */
 			mutex_lock(&chip->mutex);
@@ -2461,7 +2469,11 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_enable();
 			schedule();
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_disable();
 			remove_wait_queue(&chip->wq, &wait);
 			mutex_lock(&chip->mutex);
 			continue;
@@ -2560,7 +2572,11 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_enable();
 			schedule();
+			if (IS_ENABLED(CONFIG_MTD_XIP))
+				local_irq_disable();
 			remove_wait_queue(&chip->wq, &wait);
 			mutex_lock(&chip->mutex);
 			continue;
-- 
2.27.0

