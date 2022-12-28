Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE7F657B16
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiL1PSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiL1PR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A65313F1F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCE461554
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05A7C433D2;
        Wed, 28 Dec 2022 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240676;
        bh=Ep9axNm+95NhPhmqWzUR3+1g3g79x2VlYPQMtWm/ed4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+NyBt6VgAcIcrqpKe8DczTSu2N75VP3pKQHTEmM4MZwlvAvsK0h1UkXv3v6DZ3Sw
         rq/37vXlXh4AJobJAPDlT9CmtBGH1j+3q4IlF2avIdTw7BIlCo+l9b0T77qWihDBSd
         6wzK6kvXILkpvzpBWhtqghl/TPxm6RqavKIxNBGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0154/1146] genirq/irqdesc: Dont try to remove non-existing sysfs files
Date:   Wed, 28 Dec 2022 15:28:13 +0100
Message-Id: <20221228144334.341853605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index f09c60393e55..5fdc0b557579 100644
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
index a91f9001103c..fd0996274401 100644
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



