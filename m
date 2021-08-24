Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5D43F67A1
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbhHXRgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241719AbhHXRdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F5F61875;
        Tue, 24 Aug 2021 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824786;
        bh=+MNKkykN4WGvxZJrqCETi17OlL0DcrMPBOxluCXjKaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFbFC9D41sbbxoZU0g8oMHNiiVG33UANGHomCFgIFEI4m7QtaFMzJMCQHeDc8zwQQ
         Xi/aoMIYpZKDTdxm8aMqrjubroYqIy4vN4MNoRv/S8g+vcbY3/wmyPfylpLSp9I14j
         NQJ0HBDh46yyu3UOuqnvMgLzWcBKAfLktZ03ljp0X9PdGtlLICeAGLG5R0fCVO5sw6
         IyjIzi7vzImkJ1Mmd8/HG5tzjS2EZCgshlIRsJ6VBAn0Jj7NPZyhHj+KMAPRKm5XP0
         bOt2wiH6iVo6VFlabnc/n1yxsTMO1ANlWEHGSMVdFBoq2HK1rJWmDE+qDUbctYf9VN
         rWjHoe4PevQag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Heyne <mheyne@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/43] xen/events: Fix race in set_evtchn_to_irq
Date:   Tue, 24 Aug 2021 13:05:40 -0400
Message-Id: <20210824170614.710813-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Heyne <mheyne@amazon.de>

[ Upstream commit 88ca2521bd5b4e8b83743c01a2d4cb09325b51e9 ]

There is a TOCTOU issue in set_evtchn_to_irq. Rows in the evtchn_to_irq
mapping are lazily allocated in this function. The check whether the row
is already present and the row initialization is not synchronized. Two
threads can at the same time allocate a new row for evtchn_to_irq and
add the irq mapping to the their newly allocated row. One thread will
overwrite what the other has set for evtchn_to_irq[row] and therefore
the irq mapping is lost. This will trigger a BUG_ON later in
bind_evtchn_to_cpu:

  INFO: pci 0000:1a:15.4: [1d0f:8061] type 00 class 0x010802
  INFO: nvme 0000:1a:12.1: enabling device (0000 -> 0002)
  INFO: nvme nvme77: 1/0/0 default/read/poll queues
  CRIT: kernel BUG at drivers/xen/events/events_base.c:427!
  WARN: invalid opcode: 0000 [#1] SMP NOPTI
  WARN: Workqueue: nvme-reset-wq nvme_reset_work [nvme]
  WARN: RIP: e030:bind_evtchn_to_cpu+0xc2/0xd0
  WARN: Call Trace:
  WARN:  set_affinity_irq+0x121/0x150
  WARN:  irq_do_set_affinity+0x37/0xe0
  WARN:  irq_setup_affinity+0xf6/0x170
  WARN:  irq_startup+0x64/0xe0
  WARN:  __setup_irq+0x69e/0x740
  WARN:  ? request_threaded_irq+0xad/0x160
  WARN:  request_threaded_irq+0xf5/0x160
  WARN:  ? nvme_timeout+0x2f0/0x2f0 [nvme]
  WARN:  pci_request_irq+0xa9/0xf0
  WARN:  ? pci_alloc_irq_vectors_affinity+0xbb/0x130
  WARN:  queue_request_irq+0x4c/0x70 [nvme]
  WARN:  nvme_reset_work+0x82d/0x1550 [nvme]
  WARN:  ? check_preempt_wakeup+0x14f/0x230
  WARN:  ? check_preempt_curr+0x29/0x80
  WARN:  ? nvme_irq_check+0x30/0x30 [nvme]
  WARN:  process_one_work+0x18e/0x3c0
  WARN:  worker_thread+0x30/0x3a0
  WARN:  ? process_one_work+0x3c0/0x3c0
  WARN:  kthread+0x113/0x130
  WARN:  ? kthread_park+0x90/0x90
  WARN:  ret_from_fork+0x3a/0x50

This patch sets evtchn_to_irq rows via a cmpxchg operation so that they
will be set only once. The row is now cleared before writing it to
evtchn_to_irq in order to not create a race once the row is visible for
other threads.

While at it, do not require the page to be zeroed, because it will be
overwritten with -1's in clear_evtchn_to_irq_row anyway.

Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Fixes: d0b075ffeede ("xen/events: Refactor evtchn_to_irq array to be dynamically allocated")
Link: https://lore.kernel.org/r/20210812130930.127134-1-mheyne@amazon.de
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c6e6b7470cbf..fbb6a4701ea3 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -134,12 +134,12 @@ static void disable_dynirq(struct irq_data *data);
 
 static DEFINE_PER_CPU(unsigned int, irq_epoch);
 
-static void clear_evtchn_to_irq_row(unsigned row)
+static void clear_evtchn_to_irq_row(int *evtchn_row)
 {
 	unsigned col;
 
 	for (col = 0; col < EVTCHN_PER_ROW; col++)
-		WRITE_ONCE(evtchn_to_irq[row][col], -1);
+		WRITE_ONCE(evtchn_row[col], -1);
 }
 
 static void clear_evtchn_to_irq_all(void)
@@ -149,7 +149,7 @@ static void clear_evtchn_to_irq_all(void)
 	for (row = 0; row < EVTCHN_ROW(xen_evtchn_max_channels()); row++) {
 		if (evtchn_to_irq[row] == NULL)
 			continue;
-		clear_evtchn_to_irq_row(row);
+		clear_evtchn_to_irq_row(evtchn_to_irq[row]);
 	}
 }
 
@@ -157,6 +157,7 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 {
 	unsigned row;
 	unsigned col;
+	int *evtchn_row;
 
 	if (evtchn >= xen_evtchn_max_channels())
 		return -EINVAL;
@@ -169,11 +170,18 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 		if (irq == -1)
 			return 0;
 
-		evtchn_to_irq[row] = (int *)get_zeroed_page(GFP_KERNEL);
-		if (evtchn_to_irq[row] == NULL)
+		evtchn_row = (int *) __get_free_pages(GFP_KERNEL, 0);
+		if (evtchn_row == NULL)
 			return -ENOMEM;
 
-		clear_evtchn_to_irq_row(row);
+		clear_evtchn_to_irq_row(evtchn_row);
+
+		/*
+		 * We've prepared an empty row for the mapping. If a different
+		 * thread was faster inserting it, we can drop ours.
+		 */
+		if (cmpxchg(&evtchn_to_irq[row], NULL, evtchn_row) != NULL)
+			free_page((unsigned long) evtchn_row);
 	}
 
 	WRITE_ONCE(evtchn_to_irq[row][col], irq);
-- 
2.30.2

