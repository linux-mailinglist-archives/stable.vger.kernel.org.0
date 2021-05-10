Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E353378744
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhEJLOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhEJLHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5395961943;
        Mon, 10 May 2021 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644340;
        bh=afdQf9/aM8BWPCZOv3p4IUfP0aOisSy9AmlRKgNsLOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06yFqEqDjlLv3BV5xsXq5Y7D5seOFxg++Eu4PSwJdAnRKDjNigKWJXeVSOZlPWTBM
         53XJzTE9JhPOEtgsXyV6pjxIOn18K3PZ4q6cUX3UWISTVBN9kqDkoet1e0SuWjjOTc
         szkKgD1qs6ice8Jv558jsO8H1fQgAbG0yf1AQEi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 5.12 035/384] scsi: qla2xxx: Reserve extra IRQ vectors
Date:   Mon, 10 May 2021 12:17:04 +0200
Message-Id: <20210510102016.028114971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit f02d4086a8f36a0e1aaebf559b54cf24a177a486 upstream.

Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of
CPUs") lowers the number of allocated MSI-X vectors to the number of CPUs.

That breaks vector allocation assumptions in qla83xx_iospace_config(),
qla24xx_enable_msix() and qla2x00_iospace_config(). Either of the functions
computes maximum number of qpairs as:

  ha->max_qpairs = ha->msix_count - 1 (MB interrupt) - 1 (default
                   response queue) - 1 (ATIO, in dual or pure target mode)

max_qpairs is set to zero in case of two CPUs and initiator mode. The
number is then used to allocate ha->queue_pair_map inside
qla2x00_alloc_queues(). No allocation happens and ha->queue_pair_map is
left NULL but the driver thinks there are queue pairs available.

qla2xxx_queuecommand() tries to find a qpair in the map and crashes:

  if (ha->mqenable) {
          uint32_t tag;
          uint16_t hwq;
          struct qla_qpair *qpair = NULL;

          tag = blk_mq_unique_tag(cmd->request);
          hwq = blk_mq_unique_tag_to_hwq(tag);
          qpair = ha->queue_pair_map[hwq]; # <- HERE

          if (qpair)
                  return qla2xxx_mqueuecommand(host, cmd, qpair);
  }

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 72 Comm: kworker/u4:3 Tainted: G        W         5.10.0-rc1+ #25
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
  Workqueue: scsi_wq_7 fc_scsi_scan_rport [scsi_transport_fc]
  RIP: 0010:qla2xxx_queuecommand+0x16b/0x3f0 [qla2xxx]
  Call Trace:
   scsi_queue_rq+0x58c/0xa60
   blk_mq_dispatch_rq_list+0x2b7/0x6f0
   ? __sbitmap_get_word+0x2a/0x80
   __blk_mq_sched_dispatch_requests+0xb8/0x170
   blk_mq_sched_dispatch_requests+0x2b/0x50
   __blk_mq_run_hw_queue+0x49/0xb0
   __blk_mq_delay_run_hw_queue+0xfb/0x150
   blk_mq_sched_insert_request+0xbe/0x110
   blk_execute_rq+0x45/0x70
   __scsi_execute+0x10e/0x250
   scsi_probe_and_add_lun+0x228/0xda0
   __scsi_scan_target+0xf4/0x620
   ? __pm_runtime_resume+0x4f/0x70
   scsi_scan_target+0x100/0x110
   fc_scsi_scan_rport+0xa1/0xb0 [scsi_transport_fc]
   process_one_work+0x1ea/0x3b0
   worker_thread+0x28/0x3b0
   ? process_one_work+0x3b0/0x3b0
   kthread+0x112/0x130
   ? kthread_park+0x80/0x80
   ret_from_fork+0x22/0x30

The driver should allocate enough vectors to provide every CPU it's own HW
queue and still handle reserved (MB, RSP, ATIO) interrupts.

The change fixes the crash on dual core VM and prevents unbalanced QP
allocation where nr_hw_queues is two less than the number of CPUs.

Link: https://lore.kernel.org/r/20210412165740.39318-1-r.bolshakov@yadro.com
Fixes: a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of CPUs")
Cc: Daniel Wagner <daniel.wagner@suse.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Aleksandr Volkov <a.y.volkov@yadro.com>
Reported-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4005,11 +4005,11 @@ qla24xx_enable_msix(struct qla_hw_data *
 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
 		/* user wants to control IRQ setting for target mode */
 		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)num_online_cpus()),
+		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
 		    PCI_IRQ_MSIX);
 	} else
 		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)num_online_cpus()),
+		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
 		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
 		    &desc);
 


