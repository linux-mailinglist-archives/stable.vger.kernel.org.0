Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBD750777
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbfFXKHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730282AbfFXKHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:14 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E78208E3;
        Mon, 24 Jun 2019 10:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370833;
        bh=vWC6Q7IEbHwHRpdDTrxRzY10mjdXVgXYXiYOU/cC72Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPX/+0EBAoqD5asMul8zkPKWKt+5P01m4dhdWBHpNt5recnkbS7pkpxWGWaob78Po
         pa37ETQUrV/IPgRQ1uGXRr2J+nI86KPjjevaKvDxF14j8OHhR3lN7lLIHJIWU1K5aF
         0JHKDEJA1az5w0RRJI4t8QjCdVyWsCyA+YYCK0gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.1 018/121] IB/hfi1: Correct tid qp rcd to match verbs context
Date:   Mon, 24 Jun 2019 17:55:50 +0800
Message-Id: <20190624092321.549583585@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit cc78076af14e1478c1a8fb18997674b5f8cbe3c8 upstream.

The qp priv rcd pointer doesn't match the context being used for verbs
causing issues when 9B and kdeth packets are processed by different
receive contexts and hence different CPUs.

When running on different CPUs the following panic can occur:

 WARNING: CPU: 3 PID: 2584 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0
 list_del corruption. prev->next should be ffff9a7ac31f7a30, but was ffff9a7c3bc89230
 CPU: 3 PID: 2584 Comm: z_wr_iss Kdump: loaded Tainted: P           OE  ------------   3.10.0-862.2.3.el7_lustre.x86_64 #1
 Call Trace:
  <IRQ>  [<ffffffffb7b0d78e>] dump_stack+0x19/0x1b
  [<ffffffffb74916d8>] __warn+0xd8/0x100
  [<ffffffffb749175f>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffffb7768671>] __list_del_entry+0xa1/0xd0
  [<ffffffffc0c7a945>] process_rcv_qp_work+0xb5/0x160 [hfi1]
  [<ffffffffc0c7bc2b>] handle_receive_interrupt_nodma_rtail+0x20b/0x2b0 [hfi1]
  [<ffffffffc0c70683>] receive_context_interrupt+0x23/0x40 [hfi1]
  [<ffffffffb7540a94>] __handle_irq_event_percpu+0x44/0x1c0
  [<ffffffffb7540c42>] handle_irq_event_percpu+0x32/0x80
  [<ffffffffb7540ccc>] handle_irq_event+0x3c/0x60
  [<ffffffffb7543a1f>] handle_edge_irq+0x7f/0x150
  [<ffffffffb742d504>] handle_irq+0xe4/0x1a0
  [<ffffffffb7b23f7d>] do_IRQ+0x4d/0xf0
  [<ffffffffb7b16362>] common_interrupt+0x162/0x162
  <EOI>  [<ffffffffb775a326>] ? memcpy+0x6/0x110
  [<ffffffffc109210d>] ? abd_copy_from_buf_off_cb+0x1d/0x30 [zfs]
  [<ffffffffc10920f0>] ? abd_copy_to_buf_off_cb+0x30/0x30 [zfs]
  [<ffffffffc1093257>] abd_iterate_func+0x97/0x120 [zfs]
  [<ffffffffc10934d9>] abd_copy_from_buf_off+0x39/0x60 [zfs]
  [<ffffffffc109b828>] arc_write_ready+0x178/0x300 [zfs]
  [<ffffffffb7b11032>] ? mutex_lock+0x12/0x2f
  [<ffffffffb7b11032>] ? mutex_lock+0x12/0x2f
  [<ffffffffc1164d05>] zio_ready+0x65/0x3d0 [zfs]
  [<ffffffffc04d725e>] ? tsd_get_by_thread+0x2e/0x50 [spl]
  [<ffffffffc04d1318>] ? taskq_member+0x18/0x30 [spl]
  [<ffffffffc115ef22>] zio_execute+0xa2/0x100 [zfs]
  [<ffffffffc04d1d2c>] taskq_thread+0x2ac/0x4f0 [spl]
  [<ffffffffb74cee80>] ? wake_up_state+0x20/0x20
  [<ffffffffc115ee80>] ? zio_taskq_member.isra.7.constprop.10+0x80/0x80 [zfs]
  [<ffffffffc04d1a80>] ? taskq_thread_spawn+0x60/0x60 [spl]
  [<ffffffffb74bae31>] kthread+0xd1/0xe0
  [<ffffffffb74bad60>] ? insert_kthread_work+0x40/0x40
  [<ffffffffb7b1f5f7>] ret_from_fork_nospec_begin+0x21/0x21
  [<ffffffffb74bad60>] ? insert_kthread_work+0x40/0x40

Fix by reading the map entry in the same manner as the hardware so that
the kdeth and verbs contexts match.

Cc: <stable@vger.kernel.org>
Fixes: 5190f052a365 ("IB/hfi1: Allow the driver to initialize QP priv struct")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/chip.c     |   13 +++++++++++++
 drivers/infiniband/hw/hfi1/chip.h     |    1 +
 drivers/infiniband/hw/hfi1/tid_rdma.c |    4 +---
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14028,6 +14028,19 @@ static void init_kdeth_qp(struct hfi1_de
 }
 
 /**
+ * hfi1_get_qp_map
+ * @dd: device data
+ * @idx: index to read
+ */
+u8 hfi1_get_qp_map(struct hfi1_devdata *dd, u8 idx)
+{
+	u64 reg = read_csr(dd, RCV_QP_MAP_TABLE + (idx / 8) * 8);
+
+	reg >>= (idx % 8) * 8;
+	return reg;
+}
+
+/**
  * init_qpmap_table
  * @dd - device data
  * @first_ctxt - first context
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1442,6 +1442,7 @@ void clear_all_interrupts(struct hfi1_de
 void remap_intr(struct hfi1_devdata *dd, int isrc, int msix_intr);
 void remap_sdma_interrupts(struct hfi1_devdata *dd, int engine, int msix_intr);
 void reset_interrupts(struct hfi1_devdata *dd);
+u8 hfi1_get_qp_map(struct hfi1_devdata *dd, u8 idx);
 
 /*
  * Interrupt source table.
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -305,9 +305,7 @@ static struct hfi1_ctxtdata *qp_to_rcd(s
 	if (qp->ibqp.qp_num == 0)
 		ctxt = 0;
 	else
-		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
-			(dd->n_krcv_queues - 1)) + 1;
-
+		ctxt = hfi1_get_qp_map(dd, qp->ibqp.qp_num >> dd->qos_shift);
 	return dd->rcd[ctxt];
 }
 


