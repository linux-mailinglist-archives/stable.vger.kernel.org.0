Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC446FFD5
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbhLJLdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:33:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54570 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbhLJLdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:33:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0708FB827EE
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E90DC341CA;
        Fri, 10 Dec 2021 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639135781;
        bh=JTYdqQnSySNsWQzTLIevcFLC2z+2jv9Zrky3O2DtTXI=;
        h=Subject:To:Cc:From:Date:From;
        b=TM1zT6s31R+Jzufsvh1UfW5PQRMUW5lGdedhnLpc58797k+IgXscY7WAhmMqTyMaS
         JC4XQ5gaIGKVYduFjfzqJLw9yF/9rcA2vkph4WoaK+WWbXIaTxpDBFkBiPj3a3fgOd
         hzrx4ufVli01amJ1MeaDUxjD3DpU/busF/G71+Z8=
Subject: FAILED: patch "[PATCH] IB/hfi1: Insure use of smp_processor_id() is preempt disabled" failed to apply to 4.9-stable tree
To:     mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:29:26 +0100
Message-ID: <1639135766193244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6d57e24ce6cc3df8a8845e1b193e88a65d501b1 Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Date: Mon, 29 Nov 2021 14:19:58 -0500
Subject: [PATCH] IB/hfi1: Insure use of smp_processor_id() is preempt disabled

The following BUG has just surfaced with our 5.16 testing:

  BUG: using smp_processor_id() in preemptible [00000000] code: mpicheck/1581081
  caller is sdma_select_user_engine+0x72/0x210 [hfi1]
  CPU: 0 PID: 1581081 Comm: mpicheck Tainted: G S                5.16.0-rc1+ #1
  Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0016.033120161139 03/31/2016
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x42
   check_preemption_disabled+0xbf/0xe0
   sdma_select_user_engine+0x72/0x210 [hfi1]
   ? _raw_spin_unlock_irqrestore+0x1f/0x31
   ? hfi1_mmu_rb_insert+0x6b/0x200 [hfi1]
   hfi1_user_sdma_process_request+0xa02/0x1120 [hfi1]
   ? hfi1_write_iter+0xb8/0x200 [hfi1]
   hfi1_write_iter+0xb8/0x200 [hfi1]
   do_iter_readv_writev+0x163/0x1c0
   do_iter_write+0x80/0x1c0
   vfs_writev+0x88/0x1a0
   ? recalibrate_cpu_khz+0x10/0x10
   ? ktime_get+0x3e/0xa0
   ? __fget_files+0x66/0xa0
   do_writev+0x65/0x100
   do_syscall_64+0x3a/0x80

Fix this long standing bug by moving the smp_processor_id() to after the
rcu_read_lock().

The rcu_read_lock() implicitly disables preemption.

Link: https://lore.kernel.org/r/20211129191958.101968.87329.stgit@awfm-01.cornelisnetworks.com
Cc: stable@vger.kernel.org
Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 2b6c24b7b586..f07d328689d3 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -838,8 +838,8 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
 	if (current->nr_cpus_allowed != 1)
 		goto out;
 
-	cpu_id = smp_processor_id();
 	rcu_read_lock();
+	cpu_id = smp_processor_id();
 	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
 				     sdma_rht_params);
 

