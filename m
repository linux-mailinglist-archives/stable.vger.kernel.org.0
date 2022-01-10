Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A3D489174
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbiAJHcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:32:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbiAJHaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3693AB8120F;
        Mon, 10 Jan 2022 07:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E6C36AED;
        Mon, 10 Jan 2022 07:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799814;
        bh=1RZ0kPZl9KxI1zgPVbZnXcBRIz2Lcdn7bViV5huftKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sR2zWVG5fiwjnoLbIWAigwbYsZ1cVw12CmrSqSvAfZlfWtjiHehkaeUM2vy2h2pcx
         dVj+Kyttx0thH3OFYFwtQCG7be/6x2PvMd2OKg3NDBJcNdEw7ma7W4SibTUGMD5s2K
         vMOgp8hMgzvVp8wgx48tvTgzjVH2pAtntyIPUJr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 16/43] ftrace/samples: Add missing prototypes direct functions
Date:   Mon, 10 Jan 2022 08:23:13 +0100
Message-Id: <20220110071817.898213966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

commit 0daf5cb217a9ca8ae91b8f966ddae322699fb71d upstream.

There's another compilation fail (first here [1]) reported by kernel
test robot for W=1 clang build:

  >> samples/ftrace/ftrace-direct-multi-modify.c:7:6: warning: no previous
  prototype for function 'my_direct_func1' [-Wmissing-prototypes]
     void my_direct_func1(unsigned long ip)

Direct functions in ftrace direct sample modules need to have prototypes
defined. They are already global in order to be visible for the inline
assembly, so there's no problem.

The kernel test robot reported just error for ftrace-direct-multi-modify,
but I got same errors also for the rest of the modules touched by this patch.

[1] 67d4f6e3bf5d ftrace/samples: Add missing prototype for my_direct_func

Link: https://lkml.kernel.org/r/20211219135317.212430-1-jolsa@kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e1067a07cfbc ("ftrace/samples: Add module to test multi direct modify interface")
Fixes: ae0cc3b7e7f5 ("ftrace/samples: Add a sample module that implements modify_ftrace_direct()")
Fixes: 156473a0ff4f ("ftrace: Add another example of register_ftrace_direct() use case")
Fixes: b06457c83af6 ("ftrace: Add sample module that uses register_ftrace_direct()")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/ftrace/ftrace-direct-modify.c |    3 +++
 samples/ftrace/ftrace-direct-too.c    |    3 +++
 samples/ftrace/ftrace-direct.c        |    2 ++
 3 files changed, 8 insertions(+)

--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -3,6 +3,9 @@
 #include <linux/kthread.h>
 #include <linux/ftrace.h>
 
+extern void my_direct_func1(void);
+extern void my_direct_func2(void);
+
 void my_direct_func1(void)
 {
 	trace_printk("my direct func1\n");
--- a/samples/ftrace/ftrace-direct-too.c
+++ b/samples/ftrace/ftrace-direct-too.c
@@ -4,6 +4,9 @@
 #include <linux/mm.h> /* for handle_mm_fault() */
 #include <linux/ftrace.h>
 
+extern void my_direct_func(struct vm_area_struct *vma,
+			   unsigned long address, unsigned int flags);
+
 void my_direct_func(struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
--- a/samples/ftrace/ftrace-direct.c
+++ b/samples/ftrace/ftrace-direct.c
@@ -4,6 +4,8 @@
 #include <linux/sched.h> /* for wake_up_process() */
 #include <linux/ftrace.h>
 
+extern void my_direct_func(struct task_struct *p);
+
 void my_direct_func(struct task_struct *p)
 {
 	trace_printk("waking up %s-%d\n", p->comm, p->pid);


