Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4728635954E
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 08:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhDIGSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 02:18:31 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:46364 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229498AbhDIGSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 02:18:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 05E8C412EE;
        Fri,  9 Apr 2021 06:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1617949095; x=
        1619763496; bh=E1rdHzqRAxVOToKn3pwobD/TFergpyDv0wx3i4KVc68=; b=Q
        It4+MOfGwE7TqV7205ljOMPEiSA6A9Rfy99SlvRrewzMy9Y9eGCLqu/dFb2RJ9HT
        L0MACAJjVq9ieYqQGhHrEVtosFipfJROyHExN+p5Jz5wogeJxloPmQs7GN1bqxkh
        RLNrVVZG/ra4BOSoI578547a6eDfdy2nQGj7qTmMF8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EJw90tPJgKAj; Fri,  9 Apr 2021 09:18:15 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9643B41280;
        Fri,  9 Apr 2021 09:18:14 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 9 Apr
 2021 09:18:14 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, <stable@vger.kernel.org>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: [PATCH] Revert "scsi: qla2xxx: Limit interrupt vectors to number of CPUs"
Date:   Fri, 9 Apr 2021 09:17:59 +0300
Message-ID: <20210409061759.42807-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number
of CPUs") lowers the number of allocated MSI-X vectors to the number of
CPUs.

That breaks vector allocation assumptions in qla83xx_iospace_config(),
qla24xx_enable_msix() and qla2x00_iospace_config(). Either of the
functions computes maximum number of qpairs as:

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

Unfortunately it's not enough to force single queue mode for systems
with small CPU count, the warning would be still produced:

  WARNING: CPU: 0 PID: 1039 at drivers/pci/msi.c:1323 pci_irq_get_affinity+0x36/0x80
  CPU: 0 PID: 1039 Comm: modprobe Not tainted 5.12.0-rc1+ #26
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
  RIP: 0010:pci_irq_get_affinity+0x36/0x80
  Call Trace:
   blk_mq_pci_map_queues+0x32/0xc0
   blk_mq_alloc_tag_set+0x131/0x310
   scsi_add_host_with_dma+0x79/0x2f0
   qla2x00_probe_one+0x1870/0x2410 [qla2xxx]
   local_pci_probe+0x3d/0x90
   ? pci_assign_irq+0x22/0xd0
   pci_device_probe+0xd5/0x170
   really_probe+0x1c5/0x3a0
   driver_probe_device+0x49/0xa0
   device_driver_attach+0x4a/0x50
   __driver_attach+0x67/0xb0
   ? device_driver_attach+0x50/0x50
   bus_for_each_dev+0x71/0xb0
   bus_add_driver+0x177/0x1f0
   ? 0xffffffffc02fa000
   driver_register+0x56/0xf0
   ? 0xffffffffc02fa000
   qla2x00_module_init+0x1a2/0x20a [qla2xxx]
   do_one_initcall+0x3f/0x1c0
   ? __cond_resched+0x10/0x40
   ? kmem_cache_alloc_trace+0x36/0x1a0
   do_init_module+0x56/0x1ed
   load_module+0x219e/0x2880
   ? __do_sys_finit_module+0x9c/0xe0
   __do_sys_finit_module+0x9c/0xe0
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f2d3adcf759

Also, former MSI-X allocation might be more performant - two more
nr_hw_queues, especially on the small and medium initiators. Therefore,
it's best to revert the offending commit.

Cc: Daniel Wagner <daniel.wagner@suse.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org # 5.11+
Fixes: a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of CPUs")
Reported-by: Aleksandr Volkov <a.y.volkov@yadro.com>
Reported-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 11d6e0db07fe..6641978dfecf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3998,12 +3998,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
 		/* user wants to control IRQ setting for target mode */
 		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)num_online_cpus()),
-		    PCI_IRQ_MSIX);
+		    ha->msix_count, PCI_IRQ_MSIX);
 	} else
 		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)num_online_cpus()),
-		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+		    ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
 		    &desc);
 
 	if (ret < 0) {
-- 
2.30.1

