Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC57657876
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiL1OvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiL1Our (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4AE1209F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA6376154C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD1C433D2;
        Wed, 28 Dec 2022 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239040;
        bh=n1/L6LZp8E2IryGAR9z/ZRShETgQoWQB3m7j8dYLsAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JesSLHS1stcxxmyBw3H+vqVgsRDr3aD80QNbwHElAj2j37C9VQsRo/5RPRkd0fmUl
         mxn4nFq122g49ZA/h7s0Ys0BhW6U0e+4jwnj+lP1khlUxxQj/CHLXL5rbfaixro5Lk
         IKZSpjnSaJbFINAFmc+wMj5QiP6TqG/4F4QEKawA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/731] genirq/irqdesc: Dont try to remove non-existing sysfs files
Date:   Wed, 28 Dec 2022 15:33:32 +0100
Message-Id: <20221228144259.593844858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9049e1ca41983ab773d7ea244bee86d7835ec9f5 ]

Fault injection tests trigger warnings like this:

  kernfs: can not remove 'chip_name', no directory
  WARNING: CPU: 0 PID: 253 at fs/kernfs/dir.c:1616 kernfs_remove_by_name_ns+0xce/0xe0
  RIP: 0010:kernfs_remove_by_name_ns+0xce/0xe0
  Call Trace:
   <TASK>
   remove_files.isra.1+0x3f/0xb0
   sysfs_remove_group+0x68/0xe0
   sysfs_remove_groups+0x41/0x70
   __kobject_del+0x45/0xc0
   kobject_del+0x29/0x40
   free_desc+0x42/0x70
   irq_free_descs+0x5e/0x90

The reason is that the interrupt descriptor sysfs handling does not roll
back on a failing kobject_add() during allocation. If the descriptor is
freed later on, kobject_del() is invoked with a not added kobject resulting
in the above warnings.

A proper rollback in case of a kobject_add() failure would be the straight
forward solution. But this is not possible due to the way how interrupt
descriptor sysfs handling works.

Interrupt descriptors are allocated before sysfs becomes available. So the
sysfs files for the early allocated descriptors are added later in the boot
process. At this point there can be nothing useful done about a failing
kobject_add(). For consistency the interrupt descriptor allocation always
treats kobject_add() failures as non-critical and just emits a warning.

To solve this problem, keep track in the interrupt descriptor whether
kobject_add() was successful or not and make the invocation of
kobject_del() conditional on that.

[ tglx: Massage changelog, comments and use a state bit. ]

Fixes: ecb3f394c5db ("genirq: Expose interrupt information through sysfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20221128151612.1786122-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/internals.h |  2 ++
 kernel/irq/irqdesc.c   | 15 +++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index e58342ace11f..f1d83a8b4417 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -52,6 +52,7 @@ enum {
  * IRQS_PENDING			- irq is pending and replayed later
  * IRQS_SUSPENDED		- irq is suspended
  * IRQS_NMI			- irq line is used to deliver NMIs
+ * IRQS_SYSFS			- descriptor has been added to sysfs
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -64,6 +65,7 @@ enum {
 	IRQS_SUSPENDED		= 0x00000800,
 	IRQS_TIMINGS		= 0x00001000,
 	IRQS_NMI		= 0x00002000,
+	IRQS_SYSFS		= 0x00004000,
 };
 
 #include "debug.h"
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 21b3ac2a29d2..7a45fd593245 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -288,22 +288,25 @@ static void irq_sysfs_add(int irq, struct irq_desc *desc)
 	if (irq_kobj_base) {
 		/*
 		 * Continue even in case of failure as this is nothing
-		 * crucial.
+		 * crucial and failures in the late irq_sysfs_init()
+		 * cannot be rolled back.
 		 */
 		if (kobject_add(&desc->kobj, irq_kobj_base, "%d", irq))
 			pr_warn("Failed to add kobject for irq %d\n", irq);
+		else
+			desc->istate |= IRQS_SYSFS;
 	}
 }
 
 static void irq_sysfs_del(struct irq_desc *desc)
 {
 	/*
-	 * If irq_sysfs_init() has not yet been invoked (early boot), then
-	 * irq_kobj_base is NULL and the descriptor was never added.
-	 * kobject_del() complains about a object with no parent, so make
-	 * it conditional.
+	 * Only invoke kobject_del() when kobject_add() was successfully
+	 * invoked for the descriptor. This covers both early boot, where
+	 * sysfs is not initialized yet, and the case of a failed
+	 * kobject_add() invocation.
 	 */
-	if (irq_kobj_base)
+	if (desc->istate & IRQS_SYSFS)
 		kobject_del(&desc->kobj);
 }
 
-- 
2.35.1



