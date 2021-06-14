Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12D93A5B52
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 03:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhFNB2L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 13 Jun 2021 21:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhFNB2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 21:28:11 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4965D60C3D;
        Mon, 14 Jun 2021 01:26:09 +0000 (UTC)
Date:   Sun, 13 Jun 2021 21:26:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mark-pk.tsai@mediatek.com, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip
 address in ftrace_bug()" failed to apply to 5.4-stable tree
Message-ID: <20210613212607.5d1de4f8@rorschach.local.home>
In-Reply-To: <1623585795198152@kroah.com>
References: <1623585795198152@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 13 Jun 2021 14:03:15 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 

The function probe_kernel_read() was renamed to
copy_from_kernel_nofault() somewhere between 5.4 and 5.10, and since
this patch uses copy_from_kernel_nofault(), it doesn't exist in those
earlier kernels. Here's a new version using the older name (and this
should work for 4.4 through 5.10)

-- Steve

From 6c14133d2d3f768e0a35128faac8aa6ed4815051 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 7 Jun 2021 21:39:08 -0400
Subject: [PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()

It was reported that a bug on arm64 caused a bad ip address to be used for
updating into a nop in ftrace_init(), but the error path (rightfully)
returned -EINVAL and not -EFAULT, as the bug caused more than one error to
occur. But because -EINVAL was returned, the ftrace_bug() tried to report
what was at the location of the ip address, and read it directly. This
caused the machine to panic, as the ip was not pointing to a valid memory
address.

Instead, read the ip address with copy_from_kernel_nofault() to safely
access the memory, and if it faults, report that the address faulted,
otherwise report what was in that location.

Link: https://lore.kernel.org/lkml/20210607032329.28671-1-mark-pk.tsai@mediatek.com/

Cc: stable@vger.kernel.org
Fixes: 05736a427f7e1 ("ftrace: warn on failure to disable mcount callers")
Reported-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-test.git/kernel/trace/ftrace.c
===================================================================
--- linux-test.git.orig/kernel/trace/ftrace.c
+++ linux-test.git/kernel/trace/ftrace.c
@@ -1953,12 +1953,18 @@ static int ftrace_hash_ipmodify_update(s
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
 {
+	char ins[MCOUNT_INSN_SIZE];
 	int i;
 
+	if (probe_kernel_read(ins, p, MCOUNT_INSN_SIZE)) {
+		printk(KERN_CONT "%s[FAULT] %px\n", fmt, p);
+		return;
+	}
+
 	printk(KERN_CONT "%s", fmt);
 
 	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+		printk(KERN_CONT "%s%02x", i ? ":" : "", ins[i]);
 }
 
 enum ftrace_bug_type ftrace_bug_type;
