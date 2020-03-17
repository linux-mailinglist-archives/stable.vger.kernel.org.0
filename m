Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785A3188205
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCQK7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbgCQK7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA64D20658;
        Tue, 17 Mar 2020 10:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442741;
        bh=V8No3yAN41AjLTu/gckx2qJCiuMNEaqdAghJRc59eNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvjw/sCrVfC7I3OYfQQjgvBbkchMs7rXI7k9bwek1pSn4Vue0+PBph6YMxzDzataZ
         0nKdnztugbRJxEtzcPu8FZ3XFU2PTcK60F/eQzBiJ/mkoz2TgisAt7CAYYnzhB/4ES
         2GTavnQY5UMNLqVholJA7CNlFcHAo0svfSCk79fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>
Subject: [PATCH 4.19 64/89] efi: Make efi_rts_work accessible to efi page fault handler
Date:   Tue, 17 Mar 2020 11:55:13 +0100
Message-Id: <20200317103307.316400146@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 upstream.

After the kernel has booted, if any accesses by firmware causes a page
fault, the efi page fault handler would freeze efi_rts_wq and schedules
a new process. To do this, the efi page fault handler needs
efi_rts_work. Hence, make it accessible.

There will be no race conditions in accessing this structure, because
all the calls to efi runtime services are already serialized.

Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 3eb420e70d87 (“efi: Use a work queue to invoke EFI Runtime Services”)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Caspar Zhang <caspar@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/runtime-wrappers.c |   53 +++++---------------------------
 include/linux/efi.h                     |   36 +++++++++++++++++++++
 2 files changed, 45 insertions(+), 44 deletions(-)

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
@@ -191,18 +158,16 @@ extern struct semaphore __efi_uv_runtime
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
@@ -260,8 +225,8 @@ static void efi_call_rts(struct work_str
 		 */
 		pr_err("Requested executing invalid EFI Runtime Service.\n");
 	}
-	efi_rts_work->status = status;
-	complete(&efi_rts_work->efi_rts_comp);
+	efi_rts_work.status = status;
+	complete(&efi_rts_work.efi_rts_comp);
 }
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
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
 


