Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4252EBD7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfE3DQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730659AbfE3DQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3ADC245BB;
        Thu, 30 May 2019 03:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186182;
        bh=sIuyJJEtx+15ZALMzPbnzzQZkzP6gGkMSQ1h1QW2OSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+vIgfF5u5N+Y5U3PlvV8mv8TyM+oLNawrJRJlMcD2NjRumlsJjjxGHroSRp73SC9
         8yI9lpiz6GblyR+j3FvEhwhkrBFub+cVAikRzOuXCUbkvBuS/O1yx/eTU1JJ4oPlpP
         AhhvekDgocPxnkD1zPQHQFpU/9Tbu6a/QO+zuhTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/276] IB/hfi1: Fix WQ_MEM_RECLAIM warning
Date:   Wed, 29 May 2019 20:03:25 -0700
Message-Id: <20190530030527.688201988@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4c4b1996b5db688e2dcb8242b0a3bf7b1e845e42 ]

The work_item cancels that occur when a QP is destroyed can elicit the
following trace:

 workqueue: WQ_MEM_RECLAIM ipoib_wq:ipoib_cm_tx_reap [ib_ipoib] is flushing !WQ_MEM_RECLAIM hfi0_0:_hfi1_do_send [hfi1]
 WARNING: CPU: 7 PID: 1403 at kernel/workqueue.c:2486 check_flush_dependency+0xb1/0x100
 Call Trace:
  __flush_work.isra.29+0x8c/0x1a0
  ? __switch_to_asm+0x40/0x70
  __cancel_work_timer+0x103/0x190
  ? schedule+0x32/0x80
  iowait_cancel_work+0x15/0x30 [hfi1]
  rvt_reset_qp+0x1f8/0x3e0 [rdmavt]
  rvt_destroy_qp+0x65/0x1f0 [rdmavt]
  ? _cond_resched+0x15/0x30
  ib_destroy_qp+0xe9/0x230 [ib_core]
  ipoib_cm_tx_reap+0x21c/0x560 [ib_ipoib]
  process_one_work+0x171/0x370
  worker_thread+0x49/0x3f0
  kthread+0xf8/0x130
  ? max_active_store+0x80/0x80
  ? kthread_bind+0x10/0x10
  ret_from_fork+0x35/0x40

Since QP destruction frees memory, hfi1_wq should have the WQ_MEM_RECLAIM.

The hfi1_wq does not allocate memory with GFP_KERNEL or otherwise become
entangled with memory reclaim, so this flag is appropriate.

Fixes: 0a226edd203f ("staging/rdma/hfi1: Use parallel workqueue for SDMA engines")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index da786eb18558d..368f4f08b6866 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -798,7 +798,8 @@ static int create_workqueues(struct hfi1_devdata *dd)
 			ppd->hfi1_wq =
 				alloc_workqueue(
 				    "hfi%d_%d",
-				    WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
+				    WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE |
+				    WQ_MEM_RECLAIM,
 				    HFI1_MAX_ACTIVE_WORKQUEUE_ENTRIES,
 				    dd->unit, pidx);
 			if (!ppd->hfi1_wq)
-- 
2.20.1



