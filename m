Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56141472650
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbhLMJuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:50:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39910 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhLMJsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:48:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35444CE0AE2;
        Mon, 13 Dec 2021 09:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B56C00446;
        Mon, 13 Dec 2021 09:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388895;
        bh=ABDbxUGi36Vw+IJJjd+uvmNcwBpa6OJuHgGlHRCWDy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qrs86tYToErFa8cD5fPRx3k6cmB8vIDY7cKAheoJ5M6qVWTduHiyQjWpHLO7sL9BQ
         /UM4RgvzIdD1aG9eh68E6CVsxq52+EvnxT7XHEoygrcWYYSJRUJ9PfnLQIYQIuIPrT
         +SNVhXWNjkr8LJPwSvtva3dQHotvxuQ6iOb7LRIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 014/132] IB/hfi1: Insure use of smp_processor_id() is preempt disabled
Date:   Mon, 13 Dec 2021 10:29:15 +0100
Message-Id: <20211213092939.564555995@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit b6d57e24ce6cc3df8a8845e1b193e88a65d501b1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -880,8 +880,8 @@ struct sdma_engine *sdma_select_user_eng
 	if (current->nr_cpus_allowed != 1)
 		goto out;
 
-	cpu_id = smp_processor_id();
 	rcu_read_lock();
+	cpu_id = smp_processor_id();
 	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
 				     sdma_rht_params);
 


