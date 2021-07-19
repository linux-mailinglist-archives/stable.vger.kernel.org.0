Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02A3CDE66
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244196AbhGSPCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245464AbhGSPAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B5361375;
        Mon, 19 Jul 2021 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709283;
        bh=G8bvSzLRujbRqkbfhjx5bUrxn6I8OpCpBpG6EjwdsnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUGxuEjVY3BKwMhbDHMXJhT5WZQcbfGSrO+5El7mJ2hZaorhgexxe5GJb2ndeXPrU
         k3/s6SsBNeHv2Pdgo4M+C0eDQC5g7p0JcpcvAkGXMyJolGTcDIk0CXFubgm2qiR0Sl
         MKJDmaKQfNZtxSONdgEb4cG5M2smr4GBJ9PtPmeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 320/421] tracing: Do not reference char * as a string in histograms
Date:   Mon, 19 Jul 2021 16:52:11 +0200
Message-Id: <20210719144957.400906218@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 704adfb5a9978462cd861f170201ae2b5e3d3a80 upstream.

The histogram logic was allowing events with char * pointers to be used as
normal strings. But it was easy to crash the kernel with:

 # echo 'hist:keys=filename' > events/syscalls/sys_enter_openat/trigger

And open some files, and boom!

 BUG: unable to handle page fault for address: 00007f2ced0c3280
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 1173fa067 P4D 1173fa067 PUD 1171b6067 PMD 1171dd067 PTE 0
 Oops: 0000 [#1] PREEMPT SMP
 CPU: 6 PID: 1810 Comm: cat Not tainted 5.13.0-rc5-test+ #61
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01
v03.03 07/14/2016
 RIP: 0010:strlen+0x0/0x20
 Code: f6 82 80 2a 0b a9 20 74 11 0f b6 50 01 48 83 c0 01 f6 82 80 2a 0b
a9 20 75 ef c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 <80> 3f 00 74
10 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3

 RSP: 0018:ffffbdbf81567b50 EFLAGS: 00010246
 RAX: 0000000000000003 RBX: ffff93815cdb3800 RCX: ffff9382401a22d0
 RDX: 0000000000000100 RSI: 0000000000000000 RDI: 00007f2ced0c3280
 RBP: 0000000000000100 R08: ffff9382409ff074 R09: ffffbdbf81567c98
 R10: ffff9382409ff074 R11: 0000000000000000 R12: ffff9382409ff074
 R13: 0000000000000001 R14: ffff93815a744f00 R15: 00007f2ced0c3280
 FS:  00007f2ced0f8580(0000) GS:ffff93825a800000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f2ced0c3280 CR3: 0000000107069005 CR4: 00000000001706e0
 Call Trace:
  event_hist_trigger+0x463/0x5f0
  ? find_held_lock+0x32/0x90
  ? sched_clock_cpu+0xe/0xd0
  ? lock_release+0x155/0x440
  ? kernel_init_free_pages+0x6d/0x90
  ? preempt_count_sub+0x9b/0xd0
  ? kernel_init_free_pages+0x6d/0x90
  ? get_page_from_freelist+0x12c4/0x1680
  ? __rb_reserve_next+0xe5/0x460
  ? ring_buffer_lock_reserve+0x12a/0x3f0
  event_triggers_call+0x52/0xe0
  ftrace_syscall_enter+0x264/0x2c0
  syscall_trace_enter.constprop.0+0x1ee/0x210
  do_syscall_64+0x1c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Where it triggered a fault on strlen(key) where key was the filename.

The reason is that filename is a char * to user space, and the histogram
code just blindly dereferenced it, with obvious bad results.

I originally tried to use strncpy_from_user/kernel_nofault() but found
that there's other places that its dereferenced and not worth the effort.

Just do not allow "char *" to act like strings.

Link: https://lkml.kernel.org/r/20210715000206.025df9d2@rorschach.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Tom Zanussi <zanussi@kernel.org>
Fixes: 79e577cbce4c4 ("tracing: Support string type key properly")
Fixes: 5967bd5c4239 ("tracing: Let filter_assign_type() detect FILTER_PTR_STRING")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2342,7 +2342,9 @@ static struct hist_field *create_hist_fi
 	if (WARN_ON_ONCE(!field))
 		goto out;
 
-	if (is_string_field(field)) {
+	/* Pointers to strings are just pointers and dangerous to dereference */
+	if (is_string_field(field) &&
+	    (field->filter_type != FILTER_PTR_STRING)) {
 		flags |= HIST_FIELD_FL_STRING;
 
 		hist_field->size = MAX_FILTER_STR_VAL;
@@ -4742,8 +4744,6 @@ static inline void add_to_key(char *comp
 		field = key_field->field;
 		if (field->filter_type == FILTER_DYN_STRING)
 			size = *(u32 *)(rec + field->offset) >> 16;
-		else if (field->filter_type == FILTER_PTR_STRING)
-			size = strlen(key);
 		else if (field->filter_type == FILTER_STATIC_STRING)
 			size = field->size;
 


