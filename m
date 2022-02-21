Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25D94BDBFA
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiBUIyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:54:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345597AbiBUIxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:53:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC83A20F57;
        Mon, 21 Feb 2022 00:52:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D005B80EB1;
        Mon, 21 Feb 2022 08:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C874C340EB;
        Mon, 21 Feb 2022 08:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433576;
        bh=eGRjD+jlNSWjTRgOOlQUWxE40XwEgQsiMXaxkZeyMvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NUkZfJlf5EEX440eptoZpCG+JHuA1Wc5B9rTOogDmBsKuWfSwi26X4l9reI5Bzmv
         JlySm/g6PSx6k08mdHOeC097n3XKA59+KwG7PK8UxsySM8LYRyyPjVRhoc8QnGqeQm
         NhjHQo0aj0Ak51jkFKzaJmlIZr/Q6l8ndCyV7+LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/45] Revert "module, async: async_synchronize_full() on module init iff async is used"
Date:   Mon, 21 Feb 2022 09:49:05 +0100
Message-Id: <20220221084910.928068930@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 67d6212afda218d564890d1674bab28e8612170f ]

This reverts commit 774a1221e862b343388347bac9b318767336b20b.

We need to finish all async code before the module init sequence is
done.  In the reverted commit the PF_USED_ASYNC flag was added to mark a
thread that called async_schedule().  Then the PF_USED_ASYNC flag was
used to determine whether or not async_synchronize_full() needs to be
invoked.  This works when modprobe thread is calling async_schedule(),
but it does not work if module dispatches init code to a worker thread
which then calls async_schedule().

For example, PCI driver probing is invoked from a worker thread based on
a node where device is attached:

	if (cpu < nr_cpu_ids)
		error = work_on_cpu(cpu, local_pci_probe, &ddi);
	else
		error = local_pci_probe(&ddi);

We end up in a situation where a worker thread gets the PF_USED_ASYNC
flag set instead of the modprobe thread.  As a result,
async_synchronize_full() is not invoked and modprobe completes without
waiting for the async code to finish.

The issue was discovered while loading the pm80xx driver:
(scsi_mod.scan=async)

modprobe pm80xx                      worker
...
  do_init_module()
  ...
    pci_call_probe()
      work_on_cpu(local_pci_probe)
                                     local_pci_probe()
                                       pm8001_pci_probe()
                                         scsi_scan_host()
                                           async_schedule()
                                           worker->flags |= PF_USED_ASYNC;
                                     ...
      < return from worker >
  ...
  if (current->flags & PF_USED_ASYNC) <--- false
  	async_synchronize_full();

Commit 21c3c5d28007 ("block: don't request module during elevator init")
fixed the deadlock issue which the reverted commit 774a1221e862
("module, async: async_synchronize_full() on module init iff async is
used") tried to fix.

Since commit 0fdff3ec6d87 ("async, kmod: warn on synchronous
request_module() from async workers") synchronous module loading from
async is not allowed.

Given that the original deadlock issue is fixed and it is no longer
allowed to call synchronous request_module() from async we can remove
PF_USED_ASYNC flag to make module init consistently invoke
async_synchronize_full() unless async module probe is requested.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Changyuan Lyu <changyuanl@google.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  1 -
 kernel/async.c        |  3 ---
 kernel/module.c       | 25 +++++--------------------
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 914cc8b180eda..63522a384f5aa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1346,7 +1346,6 @@ extern struct pid *cad_pid;
 #define PF_MEMALLOC		0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED	0x00001000	/* set_user() noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
-#define PF_USED_ASYNC		0x00004000	/* Used async_schedule*(), used by module init */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
diff --git a/kernel/async.c b/kernel/async.c
index a893d6170944f..4bf1b00a28d86 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -191,9 +191,6 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* mark that this task has queued an async job, used by module init */
-	current->flags |= PF_USED_ASYNC;
-
 	/* schedule for execution */
 	queue_work(system_unbound_wq, &entry->work);
 
diff --git a/kernel/module.c b/kernel/module.c
index e962096672636..8404b41be7c6f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3499,12 +3499,6 @@ static noinline int do_init_module(struct module *mod)
 	}
 	freeinit->module_init = mod->init_layout.base;
 
-	/*
-	 * We want to find out whether @mod uses async during init.  Clear
-	 * PF_USED_ASYNC.  async_schedule*() will set it.
-	 */
-	current->flags &= ~PF_USED_ASYNC;
-
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -3530,22 +3524,13 @@ static noinline int do_init_module(struct module *mod)
 
 	/*
 	 * We need to finish all async code before the module init sequence
-	 * is done.  This has potential to deadlock.  For example, a newly
-	 * detected block device can trigger request_module() of the
-	 * default iosched from async probing task.  Once userland helper
-	 * reaches here, async_synchronize_full() will wait on the async
-	 * task waiting on request_module() and deadlock.
-	 *
-	 * This deadlock is avoided by perfomring async_synchronize_full()
-	 * iff module init queued any async jobs.  This isn't a full
-	 * solution as it will deadlock the same if module loading from
-	 * async jobs nests more than once; however, due to the various
-	 * constraints, this hack seems to be the best option for now.
-	 * Please refer to the following thread for details.
+	 * is done. This has potential to deadlock if synchronous module
+	 * loading is requested from async (which is not allowed!).
 	 *
-	 * http://thread.gmane.org/gmane.linux.kernel/1420814
+	 * See commit 0fdff3ec6d87 ("async, kmod: warn on synchronous
+	 * request_module() from async workers") for more details.
 	 */
-	if (!mod->async_probe_requested && (current->flags & PF_USED_ASYNC))
+	if (!mod->async_probe_requested)
 		async_synchronize_full();
 
 	mutex_lock(&module_mutex);
-- 
2.34.1



