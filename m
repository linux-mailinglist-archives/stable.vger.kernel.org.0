Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A413F51
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEEMJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 08:09:04 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:36692 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbfEEMJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 08:09:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TQw9-DK_1557058141;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0TQw9-DK_1557058141)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 05 May 2019 20:09:01 +0800
Subject: Re: [PATCH v4 RESEND] fs/writeback: use rcu_barrier() to wait for
 inflight wb switches going into workqueue when umount
To:     Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org
Cc:     tj@kernel.org, stable@kernel.org, stable@vger.kernel.org
References: <20190429024108.54150-1-jiufei.xue@linux.alibaba.com>
 <20190430103201.9C2D92080C@mail.kernel.org>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <499a7630-551e-70a1-7a4f-c5848030461d@linux.alibaba.com>
Date:   Sun, 5 May 2019 20:09:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430103201.9C2D92080C@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/4/30 下午6:32, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all.
> 
> The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114, v4.9.171, v4.4.179, v3.18.139.
> 
> v5.0.10: Build OK!
> v4.19.37: Build OK!
> v4.14.114: Build OK!
> v4.9.171: Failed to apply! Possible dependencies:
>     113c60970cf4 ("x86/intel_rdt: Add Haswell feature discovery")
>     2264d9c74dda ("x86/intel_rdt: Build structures for each resource based on cache topology")
>     3ee7e8697d58 ("bdi: Fix another oops in wb_workfn()")
>     4f341a5e4844 ("x86/intel_rdt: Add scheduler hook")
>     5318ce7d4686 ("bdi: Shutdown writeback on all cgwbs in cgwb_bdi_destroy()")
>     5b825c3af1d8 ("sched/headers: Prepare to remove <linux/cred.h> inclusion from <linux/sched.h>")
>     5dd43ce2f69d ("sched/wait: Split out the wait_bit*() APIs from <linux/wait.h> into <linux/wait_bit.h>")
>     5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
>     60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
>     60ec2440c63d ("x86/intel_rdt: Add schemata file")
>     6b2bb7265f0b ("sched/wait: Introduce wait_var_event()")
>     78e99b4a2b9a ("x86/intel_rdt: Add CONFIG, Makefile, and basic initialization")
>     7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches")
>     8236b0ae31c8 ("bdi: wake up concurrent wb_shutdown() callers.")
>     c1c7c3f9d6bb ("x86/intel_rdt: Pick up L3/L2 RDT parameters from CPUID")
> 
> v4.4.179: Failed to apply! Possible dependencies:
>     0007bccc3cfd ("x86: Replace RDRAND forced-reseed with simple sanity check")
>     113c60970cf4 ("x86/intel_rdt: Add Haswell feature discovery")
>     1b74dde7c47c ("x86/cpu: Convert printk(KERN_<LEVEL> ...) to pr_<level>(...)")
>     27f6d22b037b ("perf/x86: Move perf_event.h to its new home")
>     39b0332a2158 ("perf/x86: Move perf_event_amd.c ........... => x86/events/amd/core.c")
>     3ee7e8697d58 ("bdi: Fix another oops in wb_workfn()")
>     4f341a5e4844 ("x86/intel_rdt: Add scheduler hook")
>     5318ce7d4686 ("bdi: Shutdown writeback on all cgwbs in cgwb_bdi_destroy()")
>     5b825c3af1d8 ("sched/headers: Prepare to remove <linux/cred.h> inclusion from <linux/sched.h>")
>     5dd43ce2f69d ("sched/wait: Split out the wait_bit*() APIs from <linux/wait.h> into <linux/wait_bit.h>")
>     6b2bb7265f0b ("sched/wait: Introduce wait_var_event()")
>     724697648eec ("perf/x86: Use INST_RETIRED.PREC_DIST for cycles: ppp")
>     7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches")
>     8236b0ae31c8 ("bdi: wake up concurrent wb_shutdown() callers.")
>     fa9cbf320e99 ("perf/x86: Move perf_event.c ............... => x86/events/core.c")
> 
> v3.18.139: Failed to apply! Possible dependencies:
>     0ae45f63d4ef ("vfs: add support for a lazytime mount option")
>     4452226ea276 ("writeback: move backing_dev_info->state into bdi_writeback")
>     52ebea749aae ("writeback: make backing_dev_info host cgroup-specific bdi_writebacks")
>     66114cad64bf ("writeback: separate out include/linux/backing-dev-defs.h")
>     682aa8e1a6a1 ("writeback: implement unlocked_inode_to_wb transaction and use it for stat updates")
>     87e1d789bf55 ("writeback: implement [locked_]inode_to_wb_and_lock_list()")
>     a3816ab0e8fe ("fs: Convert show_fdinfo functions to void")
>     b16b1deb553a ("writeback: make writeback_control track the inode being written back")
>     b4caecd48005 ("fs: introduce f_op->mmap_capabilities for nommu mmap support")
>     bafc0dba1e20 ("buffer, writeback: make __block_write_full_page() honor cgroup writeback")
> 
> 
> How should we proceed with this patch?
> 
> --

I am sorry that I forgot to mention that the patch should be applied to stable
since v4.4.

v4.4.179 and v4.9.171 depend on the commit 7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches"). 
On these two versions we can just inc isw_nr_in_flight before return.

The patch is pasted below.

--- linux-4.4.179.orig/fs/fs-writeback.c.orig	2019-05-05 19:56:29.993961267 +0800
+++ linux-4.4.179/fs/fs-writeback.c	2019-05-05 19:39:55.880336751 +0800
@@ -502,8 +502,6 @@ static void inode_switch_wbs(struct inod
 	ihold(inode);
 	isw->inode = inode;
 
-	atomic_inc(&isw_nr_in_flight);
-
 	/*
 	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
 	 * the RCU protected stat update paths to grab the mapping's
@@ -511,6 +509,9 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+
+	atomic_inc(&isw_nr_in_flight);
+
 	return;
 
 out_free:
@@ -880,7 +881,11 @@ restart:
 void cgroup_writeback_umount(void)
 {
 	if (atomic_read(&isw_nr_in_flight)) {
-		synchronize_rcu();
+		/*
+		 * Use rcu_barrier() to wait for all pending callbacks to
+		 * ensure that all in-flight wb switches are in the workqueue.
+		 */
+		rcu_barrier();
 		flush_workqueue(isw_wq);
 	}
 }


Thanks,
Jiufei


> Thanks,
> Sasha
> 
