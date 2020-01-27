Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1011814A7BF
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 17:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgA0QEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 11:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0QEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 11:04:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16894206A2;
        Mon, 27 Jan 2020 16:04:51 +0000 (UTC)
Date:   Mon, 27 Jan 2020 11:04:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>
Subject: [GIT PULL][PATCH] tracing/kprobes: Have uname use __get_str() in
 print_fmt
Message-ID: <20200127110449.512c13a1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Linus,

[ This is not a merge window pull, I was waiting on a tested-by from
  the reporter ]

Kprobe events added "ustring" to distinguish reading strings
from kernel space or user space. But the creating of the event format
file only checks for "string" to display string formats. "ustring" must
also be handled.


Please pull the latest trace-v5.5-rc7 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-v5.5-rc7

Tag SHA1: 83993af56b45a4c0b34401ee5bdd96c94180d77d
Head SHA1: 20279420ae3a8ef4c5d9fedc360a2c37a1dbdf1b


Steven Rostedt (VMware) (1):
      tracing/kprobes: Have uname use __get_str() in print_fmt

----
 kernel/trace/trace_probe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
---------------------------
commit 20279420ae3a8ef4c5d9fedc360a2c37a1dbdf1b
Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
Date:   Fri Jan 24 10:07:42 2020 -0500

    tracing/kprobes: Have uname use __get_str() in print_fmt
    
    Thomas Richter reported:
    
    > Test case 66 'Use vfs_getname probe to get syscall args filenames'
    > is broken on s390, but works on x86. The test case fails with:
    >
    >  [root@m35lp76 perf]# perf test -F 66
    >  66: Use vfs_getname probe to get syscall args filenames
    >            :Recording open file:
    >  [ perf record: Woken up 1 times to write data ]
    >  [ perf record: Captured and wrote 0.004 MB /tmp/__perf_test.perf.data.TCdYj\
    >        (20 samples) ]
    >  Looking at perf.data file for vfs_getname records for the file we touched:
    >   FAILED!
    >   [root@m35lp76 perf]#
    
    The root cause was the print_fmt of the kprobe event that referenced the
    "ustring"
    
    > Setting up the kprobe event using perf command:
    >
    >  # ./perf probe "vfs_getname=getname_flags:72 pathname=filename:ustring"
    >
    > generates this format file:
    >   [root@m35lp76 perf]# cat /sys/kernel/debug/tracing/events/probe/\
    >         vfs_getname/format
    >   name: vfs_getname
    >   ID: 1172
    >   format:
    >     field:unsigned short common_type; offset:0; size:2; signed:0;
    >     field:unsigned char common_flags; offset:2; size:1; signed:0;
    >     field:unsigned char common_preempt_count; offset:3; size:1; signed:0;
    >     field:int common_pid; offset:4; size:4; signed:1;
    >
    >     field:unsigned long __probe_ip; offset:8; size:8; signed:0;
    >     field:__data_loc char[] pathname; offset:16; size:4; signed:1;
    >
    >     print fmt: "(%lx) pathname=\"%s\"", REC->__probe_ip, REC->pathname
    
    Instead of using "__get_str(pathname)" it referenced it directly.
    
    Link: http://lkml.kernel.org/r/20200124100742.4050c15e@gandalf.local.home
    
    Cc: stable@vger.kernel.org
    Fixes: 88903c464321 ("tracing/probe: Add ustring type for user-space string")
    Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
    Reported-by: Thomas Richter <tmricht@linux.ibm.com>
    Tested-by: Thomas Richter <tmricht@linux.ibm.com>
    Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 9ae87be422f2..ab8b6436d53f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -876,7 +876,8 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 	for (i = 0; i < tp->nr_args; i++) {
 		parg = tp->args + i;
 		if (parg->count) {
-			if (strcmp(parg->type->name, "string") == 0)
+			if ((strcmp(parg->type->name, "string") == 0) ||
+			    (strcmp(parg->type->name, "ustring") == 0))
 				fmt = ", __get_str(%s[%d])";
 			else
 				fmt = ", REC->%s[%d]";
@@ -884,7 +885,8 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 				pos += snprintf(buf + pos, LEN_OR_ZERO,
 						fmt, parg->name, j);
 		} else {
-			if (strcmp(parg->type->name, "string") == 0)
+			if ((strcmp(parg->type->name, "string") == 0) ||
+			    (strcmp(parg->type->name, "ustring") == 0))
 				fmt = ", __get_str(%s)";
 			else
 				fmt = ", REC->%s";
