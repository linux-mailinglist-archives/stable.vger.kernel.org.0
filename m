Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869051331B6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgAGVDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgAGVDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD9E20678;
        Tue,  7 Jan 2020 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431000;
        bh=K4NYESKiwg4FmH9bqr8bH3rKODsDuOWoDVc3uWFEGh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1HEVvXiP2ff1OFVtw+5C3rM9pd3DYMwL5R76VDwV2jmV+9B2EiQfkbgdqqevFJyE
         E4xbcHOfNCIDAanhFqbTrkci/0SsGi/nWu2WBKdDG6b0V71hsUK7Gji21axdzUg5wq
         b2X8aP34/aRTywRJbyMjRYkF9DZtXbEEdbbwB9HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/191] lib/ubsan: dont serialize UBSAN report
Date:   Tue,  7 Jan 2020 21:55:04 +0100
Message-Id: <20200107205342.838591199@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Grall <julien.grall@arm.com>

[ Upstream commit ce5c31db3645b649a31044a4d8b6057f6c723702 ]

At the moment, UBSAN report will be serialized using a spin_lock().  On
RT-systems, spinlocks are turned to rt_spin_lock and may sleep.  This
will result to the following splat if the undefined behavior is in a
context that can sleep:

  BUG: sleeping function called from invalid context at /src/linux/kernel/locking/rtmutex.c:968
  in_atomic(): 1, irqs_disabled(): 128, pid: 3447, name: make
  1 lock held by make/3447:
   #0: 000000009a966332 (&mm->mmap_sem){++++}, at: do_page_fault+0x140/0x4f8
  irq event stamp: 6284
  hardirqs last  enabled at (6283): [<ffff000011326520>] _raw_spin_unlock_irqrestore+0x90/0xa0
  hardirqs last disabled at (6284): [<ffff0000113262b0>] _raw_spin_lock_irqsave+0x30/0x78
  softirqs last  enabled at (2430): [<ffff000010088ef8>] fpsimd_restore_current_state+0x60/0xe8
  softirqs last disabled at (2427): [<ffff000010088ec0>] fpsimd_restore_current_state+0x28/0xe8
  Preemption disabled at:
  [<ffff000011324a4c>] rt_mutex_futex_unlock+0x4c/0xb0
  CPU: 3 PID: 3447 Comm: make Tainted: G        W         5.2.14-rt7-01890-ge6e057589653 #911
  Call trace:
    dump_backtrace+0x0/0x148
    show_stack+0x14/0x20
    dump_stack+0xbc/0x104
    ___might_sleep+0x154/0x210
    rt_spin_lock+0x68/0xa0
    ubsan_prologue+0x30/0x68
    handle_overflow+0x64/0xe0
    __ubsan_handle_add_overflow+0x10/0x18
    __lock_acquire+0x1c28/0x2a28
    lock_acquire+0xf0/0x370
    _raw_spin_lock_irqsave+0x58/0x78
    rt_mutex_futex_unlock+0x4c/0xb0
    rt_spin_unlock+0x28/0x70
    get_page_from_freelist+0x428/0x2b60
    __alloc_pages_nodemask+0x174/0x1708
    alloc_pages_vma+0x1ac/0x238
    __handle_mm_fault+0x4ac/0x10b0
    handle_mm_fault+0x1d8/0x3b0
    do_page_fault+0x1c8/0x4f8
    do_translation_fault+0xb8/0xe0
    do_mem_abort+0x3c/0x98
    el0_da+0x20/0x24

The spin_lock() will protect against multiple CPUs to output a report
together, I guess to prevent them from being interleaved.  However, they
can still interleave with other messages (and even splat from
__might_sleep).

So the lock usefulness seems pretty limited.  Rather than trying to
accomodate RT-system by switching to a raw_spin_lock(), the lock is now
completely dropped.

Link: http://lkml.kernel.org/r/20190920100835.14999-1-julien.grall@arm.com
Signed-off-by: Julien Grall <julien.grall@arm.com>
Reported-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ubsan.c | 64 +++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index 0c4681118fcd..f007a406f89c 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -140,25 +140,21 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 	}
 }
 
-static DEFINE_SPINLOCK(report_lock);
-
-static void ubsan_prologue(struct source_location *location,
-			unsigned long *flags)
+static void ubsan_prologue(struct source_location *location)
 {
 	current->in_ubsan++;
-	spin_lock_irqsave(&report_lock, *flags);
 
 	pr_err("========================================"
 		"========================================\n");
 	print_source_location("UBSAN: Undefined behaviour in", location);
 }
 
-static void ubsan_epilogue(unsigned long *flags)
+static void ubsan_epilogue(void)
 {
 	dump_stack();
 	pr_err("========================================"
 		"========================================\n");
-	spin_unlock_irqrestore(&report_lock, *flags);
+
 	current->in_ubsan--;
 }
 
@@ -167,14 +163,13 @@ static void handle_overflow(struct overflow_data *data, void *lhs,
 {
 
 	struct type_descriptor *type = data->type;
-	unsigned long flags;
 	char lhs_val_str[VALUE_LENGTH];
 	char rhs_val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
@@ -186,7 +181,7 @@ static void handle_overflow(struct overflow_data *data, void *lhs,
 		rhs_val_str,
 		type->type_name);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 
 void __ubsan_handle_add_overflow(struct overflow_data *data,
@@ -214,20 +209,19 @@ EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
 void __ubsan_handle_negate_overflow(struct overflow_data *data,
 				void *old_val)
 {
-	unsigned long flags;
 	char old_val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
 
 	pr_err("negation of %s cannot be represented in type %s:\n",
 		old_val_str, data->type->type_name);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
 
@@ -235,13 +229,12 @@ EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
 void __ubsan_handle_divrem_overflow(struct overflow_data *data,
 				void *lhs, void *rhs)
 {
-	unsigned long flags;
 	char rhs_val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
 
@@ -251,58 +244,52 @@ void __ubsan_handle_divrem_overflow(struct overflow_data *data,
 	else
 		pr_err("division by zero\n");
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_divrem_overflow);
 
 static void handle_null_ptr_deref(struct type_mismatch_data_common *data)
 {
-	unsigned long flags;
-
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location, &flags);
+	ubsan_prologue(data->location);
 
 	pr_err("%s null pointer of type %s\n",
 		type_check_kinds[data->type_check_kind],
 		data->type->type_name);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 
 static void handle_misaligned_access(struct type_mismatch_data_common *data,
 				unsigned long ptr)
 {
-	unsigned long flags;
-
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location, &flags);
+	ubsan_prologue(data->location);
 
 	pr_err("%s misaligned address %p for type %s\n",
 		type_check_kinds[data->type_check_kind],
 		(void *)ptr, data->type->type_name);
 	pr_err("which requires %ld byte alignment\n", data->alignment);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 
 static void handle_object_size_mismatch(struct type_mismatch_data_common *data,
 					unsigned long ptr)
 {
-	unsigned long flags;
-
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location, &flags);
+	ubsan_prologue(data->location);
 	pr_err("%s address %p with insufficient space\n",
 		type_check_kinds[data->type_check_kind],
 		(void *) ptr);
 	pr_err("for an object of type %s\n", data->type->type_name);
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 
 static void ubsan_type_mismatch_common(struct type_mismatch_data_common *data,
@@ -351,25 +338,23 @@ EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
 void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
 {
-	unsigned long flags;
 	char index_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(index_str, sizeof(index_str), data->index_type, index);
 	pr_err("index %s is out of range for type %s\n", index_str,
 		data->array_type->type_name);
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
 
 void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 					void *lhs, void *rhs)
 {
-	unsigned long flags;
 	struct type_descriptor *rhs_type = data->rhs_type;
 	struct type_descriptor *lhs_type = data->lhs_type;
 	char rhs_str[VALUE_LENGTH];
@@ -379,7 +364,7 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 	if (suppress_report(&data->location))
 		goto out;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
 	val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
@@ -402,7 +387,7 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 			lhs_str, rhs_str,
 			lhs_type->type_name);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 out:
 	user_access_restore(ua_flags);
 }
@@ -411,11 +396,9 @@ EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
 void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
-	unsigned long flags;
-
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 	pr_err("calling __builtin_unreachable()\n");
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 	panic("can't return from __builtin_unreachable()");
 }
 EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
@@ -423,19 +406,18 @@ EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
 void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
 				void *val)
 {
-	unsigned long flags;
 	char val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(&data->location);
 
 	val_to_string(val_str, sizeof(val_str), data->type, val);
 
 	pr_err("load of value %s is not a valid value for type %s\n",
 		val_str, data->type->type_name);
 
-	ubsan_epilogue(&flags);
+	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_load_invalid_value);
-- 
2.20.1



