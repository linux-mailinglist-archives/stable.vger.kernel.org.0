Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933105E894B
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiIXHuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 03:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiIXHuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 03:50:03 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1919B1F9F2;
        Sat, 24 Sep 2022 00:50:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VQZNauz_1664005795;
Received: from localhost.localdomain(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VQZNauz_1664005795)
          by smtp.aliyun-inc.com;
          Sat, 24 Sep 2022 15:49:57 +0800
From:   Shuai Xue <xueshuai@linux.alibaba.com>
To:     rafael@kernel.org, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
        jarkko@kernel.org, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cuibixuan@linux.alibaba.com,
        baolin.wang@linux.alibaba.com, zhuo.song@linux.alibaba.com,
        xueshuai@linux.alibaba.com
Subject: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to avoid memory leak
Date:   Sat, 24 Sep 2022 15:49:53 +0800
Message-Id: <20220924074953.83064-1-xueshuai@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an error is detected as a result of user-space process accessing a
corrupt memory location, the CPU may take an abort. Then the platform
firmware reports kernel via NMI like notifications, e.g. NOTIFY_SEA,
NOTIFY_SOFTWARE_DELEGATED, etc.

For NMI like notifications, commit 7f17b4a121d0 ("ACPI: APEI: Kick the
memory_failure() queue for synchronous errors") keep track of whether
memory_failure() work was queued, and make task_work pending to flush out
the queue so that the work is processed before return to user-space.

The code use init_mm to check whether the error occurs in user space:

    if (current->mm != &init_mm)

The condition is always true, becase _nobody_ ever has "init_mm" as a real
VM any more.

In addition to abort, errors can also be signaled as asynchronous
exceptions, such as interrupt and SError. In such case, the interrupted
current process could be any kind of thread. When a kernel thread is
interrupted, the work ghes_kick_task_work deferred to task_work will never
be processed because entry_handler returns to call ret_to_kernel() instead
of ret_to_user(). Consequently, the estatus_node alloced from
ghes_estatus_pool in ghes_in_nmi_queue_one_entry() will not be freed.
After around 200 allocations in our platform, the ghes_estatus_pool will
run of memory and ghes_in_nmi_queue_one_entry() returns ENOMEM. As a
result, the event failed to be processed.

    sdei: event 805 on CPU 113 failed with error: -2

Finally, a lot of unhandled events may cause platform firmware to exceed
some threshold and reboot.

The condition should generally just do

    if (current->mm)

as described in active_mm.rst documentation.

Then if an asynchronous error is detected when a kernel thread is running,
(e.g. when detected by a background scrubber), do not add task_work to it
as the original patch intends to do.

Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
---
changes since v1:
- add description the side effect and give more details

 drivers/acpi/apei/ghes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d91ad378c00d..80ad530583c9 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -985,7 +985,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 				ghes_estatus_cache_add(generic, estatus);
 		}
 
-		if (task_work_pending && current->mm != &init_mm) {
+		if (task_work_pending && current->mm) {
 			estatus_node->task_work.func = ghes_kick_task_work;
 			estatus_node->task_work_cpu = smp_processor_id();
 			ret = task_work_add(current, &estatus_node->task_work,
-- 
2.20.1.12.g72788fdb

