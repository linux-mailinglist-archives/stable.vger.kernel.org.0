Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D179178BA5
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgCDHpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 02:45:02 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:57513 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728486AbgCDHpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 02:45:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04396;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Trd8PmO_1583307885;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Trd8PmO_1583307885)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 Mar 2020 15:44:52 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH] efi: Make efi_rts_work accessible to efi page fault handler
Date:   Wed,  4 Mar 2020 15:44:44 +0800
Message-Id: <20200304074444.7849-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

[ Upstream commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 ]

After the kernel has booted, if any accesses by firmware causes a page
fault, the efi page fault handler would freeze efi_rts_wq and schedules
a new process. To do this, the efi page fault handler needs
efi_rts_work. Hence, make it accessible.

There will be no race conditions in accessing this structure, because
all the calls to efi runtime services are already serialized.

[ Wen: This patch also fixes a memory corruption:
       #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)\
       ({                                                             \
        struct efi_runtime_work efi_rts_work;                           \
       …
        init_completion(&efi_rts_work.efi_rts_comp);                    \
        INIT_WORK(&efi_rts_work.work, efi_call_rts);                    \
       …

       efi_rts_work is on the stack, registering it to workqueue will cause
       the following error:

       ODEBUG: object (____ptrval____) is on stack (____ptrval____),
       but NOT annotated.
       ------------[ cut here ]------------
       WARNING: CPU: 6 PID: 1 at lib/debugobjects.c:368
       __debug_object_init+0x218/0x538
       Modules linked in:
       CPU: 6 PID: 1 Comm: swapper/0 Tainted: G        W         4.19.91 #19
       …
       Call trace:
       __debug_object_init+0x218/0x538
       debug_object_init+0x20/0x28
       __init_work+0x34/0x58
       virt_efi_get_time.part.5+0x6c/0x12c
       virt_efi_get_time+0x4c/0x58
       efi_read_time+0x40/0x9c
       __rtc_read_time+0x50/0x118
       rtc_read_time+0x60/0x1f0
       rtc_hctosys+0x74/0x124
       do_one_initcall+0xac/0x3d4
       kernel_init_freeable+0x49c/0x59c
       kernel_init+0x18/0x110 ]

Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 3eb420e70d87 (“efi: Use a work queue to invoke EFI Runtime Services”)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Caspar Zhang <caspar@linux.alibaba.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
---
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
 include/linux/efi.h                     | 36 +++++++++++++++++
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b0aeffd4e269..92e519d58618 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -45,39 +45,7 @@
 #define __efi_call_virt(f, args...) \
 	__efi_call_virt_pointer(efi.systab->runtime, f, args)
 
-/* efi_runtime_service() function identifiers */
-enum efi_rts_ids {
-	GET_TIME,
-	SET_TIME,
-	GET_WAKEUP_TIME,
-	SET_WAKEUP_TIME,
-	GET_VARIABLE,
-	GET_NEXT_VARIABLE,
-	SET_VARIABLE,
-	QUERY_VARIABLE_INFO,
-	GET_NEXT_HIGH_MONO_COUNT,
-	UPDATE_CAPSULE,
-	QUERY_CAPSULE_CAPS,
-};
-
-/*
- * efi_runtime_work:	Details of EFI Runtime Service work
- * @arg<1-5>:		EFI Runtime Service function arguments
- * @status:		Status of executing EFI Runtime Service
- * @efi_rts_id:		EFI Runtime Service function identifier
- * @efi_rts_comp:	Struct used for handling completions
- */
-struct efi_runtime_work {
-	void *arg1;
-	void *arg2;
-	void *arg3;
-	void *arg4;
-	void *arg5;
-	efi_status_t status;
-	struct work_struct work;
-	enum efi_rts_ids efi_rts_id;
-	struct completion efi_rts_comp;
-};
+struct efi_runtime_work efi_rts_work;
 
 /*
  * efi_queue_work:	Queue efi_runtime_service() and wait until it's done
@@ -91,7 +59,6 @@ struct efi_runtime_work {
  */
 #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)		\
 ({									\
-	struct efi_runtime_work efi_rts_work;				\
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
@@ -191,18 +158,16 @@ extern struct semaphore __efi_uv_runtime_lock __alias(efi_runtime_lock);
  */
 static void efi_call_rts(struct work_struct *work)
 {
-	struct efi_runtime_work *efi_rts_work;
 	void *arg1, *arg2, *arg3, *arg4, *arg5;
 	efi_status_t status = EFI_NOT_FOUND;
 
-	efi_rts_work = container_of(work, struct efi_runtime_work, work);
-	arg1 = efi_rts_work->arg1;
-	arg2 = efi_rts_work->arg2;
-	arg3 = efi_rts_work->arg3;
-	arg4 = efi_rts_work->arg4;
-	arg5 = efi_rts_work->arg5;
+	arg1 = efi_rts_work.arg1;
+	arg2 = efi_rts_work.arg2;
+	arg3 = efi_rts_work.arg3;
+	arg4 = efi_rts_work.arg4;
+	arg5 = efi_rts_work.arg5;
 
-	switch (efi_rts_work->efi_rts_id) {
+	switch (efi_rts_work.efi_rts_id) {
 	case GET_TIME:
 		status = efi_call_virt(get_time, (efi_time_t *)arg1,
 				       (efi_time_cap_t *)arg2);
@@ -260,8 +225,8 @@ static void efi_call_rts(struct work_struct *work)
 		 */
 		pr_err("Requested executing invalid EFI Runtime Service.\n");
 	}
-	efi_rts_work->status = status;
-	complete(&efi_rts_work->efi_rts_comp);
+	efi_rts_work.status = status;
+	complete(&efi_rts_work.efi_rts_comp);
 }
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc3391796c0b..6797811bf1e6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1664,6 +1664,42 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+/* efi_runtime_service() function identifiers */
+enum efi_rts_ids {
+	GET_TIME,
+	SET_TIME,
+	GET_WAKEUP_TIME,
+	SET_WAKEUP_TIME,
+	GET_VARIABLE,
+	GET_NEXT_VARIABLE,
+	SET_VARIABLE,
+	QUERY_VARIABLE_INFO,
+	GET_NEXT_HIGH_MONO_COUNT,
+	UPDATE_CAPSULE,
+	QUERY_CAPSULE_CAPS,
+};
+
+/*
+ * efi_runtime_work:	Details of EFI Runtime Service work
+ * @arg<1-5>:		EFI Runtime Service function arguments
+ * @status:		Status of executing EFI Runtime Service
+ * @efi_rts_id:		EFI Runtime Service function identifier
+ * @efi_rts_comp:	Struct used for handling completions
+ */
+struct efi_runtime_work {
+	void *arg1;
+	void *arg2;
+	void *arg3;
+	void *arg4;
+	void *arg5;
+	efi_status_t status;
+	struct work_struct work;
+	enum efi_rts_ids efi_rts_id;
+	struct completion efi_rts_comp;
+};
+
+extern struct efi_runtime_work efi_rts_work;
+
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
-- 
2.23.0

