Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232E3157AE7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBJN0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgBJMgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:47 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EAAA20733;
        Mon, 10 Feb 2020 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338206;
        bh=54VNu45w/vLNKLZ2cxJsWNJgFLn0bNvrtrd9wtIlbaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CA3LfErgIASlYX3Cz5Ufr3LcMEnD/OztakzX4rpmQs/SK5sQMXdA1g3PyWzz4REa8
         ApP57dLLTKJDoZE4nr7ljIbkOg49jeGYaaWKXI39rp5zgkdDX4SKHv1NinS/FepgNM
         SU8aiunlzrYXQOpN3XOVH/S2zVf9T1DeEOkb51CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 026/309] tracing/kprobes: Have uname use __get_str() in print_fmt
Date:   Mon, 10 Feb 2020 04:29:42 -0800
Message-Id: <20200210122408.499910156@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 20279420ae3a8ef4c5d9fedc360a2c37a1dbdf1b upstream.

Thomas Richter reported:

> Test case 66 'Use vfs_getname probe to get syscall args filenames'
> is broken on s390, but works on x86. The test case fails with:
>
>  [root@m35lp76 perf]# perf test -F 66
>  66: Use vfs_getname probe to get syscall args filenames
>            :Recording open file:
>  [ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.004 MB /tmp/__perf_test.perf.data.TCdYj\
> 	 (20 samples) ]
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
> 	  vfs_getname/format
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -876,7 +876,8 @@ static int __set_print_fmt(struct trace_
 	for (i = 0; i < tp->nr_args; i++) {
 		parg = tp->args + i;
 		if (parg->count) {
-			if (strcmp(parg->type->name, "string") == 0)
+			if ((strcmp(parg->type->name, "string") == 0) ||
+			    (strcmp(parg->type->name, "ustring") == 0))
 				fmt = ", __get_str(%s[%d])";
 			else
 				fmt = ", REC->%s[%d]";
@@ -884,7 +885,8 @@ static int __set_print_fmt(struct trace_
 				pos += snprintf(buf + pos, LEN_OR_ZERO,
 						fmt, parg->name, j);
 		} else {
-			if (strcmp(parg->type->name, "string") == 0)
+			if ((strcmp(parg->type->name, "string") == 0) ||
+			    (strcmp(parg->type->name, "ustring") == 0))
 				fmt = ", __get_str(%s)";
 			else
 				fmt = ", REC->%s";


