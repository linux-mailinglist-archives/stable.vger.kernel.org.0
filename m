Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007B835CF08
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 19:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243680AbhDLRAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 13:00:47 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44982 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245365AbhDLQ6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:58:14 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9847141325;
        Mon, 12 Apr 2021 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1618246673; x=
        1620061074; bh=/ecM41dJNzNDKtqkhrRYa4t8KFyoodeyuk49cZOd1LI=; b=i
        jeVIe3MvQo9q5zhhzgDl6sUxCCXeEt8Y6kkOoeVYpZBWkCfjQmhk8n8liLU2w72p
        FWQIx3ia33jkZAk2WIzTeBr552bfmHZKGgSe8Ggrf4TfbFBw6jfEc/2Or4fdC5wt
        nU8s3Z/uX2ZHkdpvG/Ybxx2JQ7kpfsvgUv9rswKmWc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MAjiHVnwl3uO; Mon, 12 Apr 2021 19:57:53 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9472B411F8;
        Mon, 12 Apr 2021 19:57:52 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 12
 Apr 2021 19:57:52 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux@yadro.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, <stable@vger.kernel.org>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
Date:   Mon, 12 Apr 2021 19:57:40 +0300
Message-ID: <20210412165740.39318-1-r.bolshakov@yadro.com>
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

The driver should allocate enough vectors to provide every CPU it's own HW
queue and still handle reserved (MB, RSP, ATIO) interrupts.

The change fixes the crash on dual core VM and prevents unbalanced QP
allocation where nr_hw_queues is two less than the number of CPUs.

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
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 11d6e0db07fe..6e8f737a4af3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3998,11 +3998,11 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
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
 
-- 
2.30.1

