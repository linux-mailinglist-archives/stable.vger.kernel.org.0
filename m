Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B690635D8F7
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbhDMHf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:35:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:44694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231236AbhDMHf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 03:35:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9683AC6E;
        Tue, 13 Apr 2021 07:35:35 +0000 (UTC)
Date:   Tue, 13 Apr 2021 09:35:35 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, stable@vger.kernel.org,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
Message-ID: <20210413073535.2obrdtbl6lcdigxh@beryllium.lan>
References: <20210412165740.39318-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412165740.39318-1-r.bolshakov@yadro.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 07:57:40PM +0300, Roman Bolshakov wrote:
> Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number
> of CPUs") lowers the number of allocated MSI-X vectors to the number of
> CPUs.
> 
> That breaks vector allocation assumptions in qla83xx_iospace_config(),
> qla24xx_enable_msix() and qla2x00_iospace_config(). Either of the
> functions computes maximum number of qpairs as:
> 
>   ha->max_qpairs = ha->msix_count - 1 (MB interrupt) - 1 (default
>                    response queue) - 1 (ATIO, in dual or pure target mode)
> 
> max_qpairs is set to zero in case of two CPUs and initiator mode. The
> number is then used to allocate ha->queue_pair_map inside
> qla2x00_alloc_queues(). No allocation happens and ha->queue_pair_map is
> left NULL but the driver thinks there are queue pairs available.
> 
> qla2xxx_queuecommand() tries to find a qpair in the map and crashes:
> 
>   if (ha->mqenable) {
>           uint32_t tag;
>           uint16_t hwq;
>           struct qla_qpair *qpair = NULL;
> 
>           tag = blk_mq_unique_tag(cmd->request);
>           hwq = blk_mq_unique_tag_to_hwq(tag);
>           qpair = ha->queue_pair_map[hwq]; # <- HERE
> 
>           if (qpair)
>                   return qla2xxx_mqueuecommand(host, cmd, qpair);
>   }
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] SMP PTI
>   CPU: 0 PID: 72 Comm: kworker/u4:3 Tainted: G        W         5.10.0-rc1+ #25
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
>   Workqueue: scsi_wq_7 fc_scsi_scan_rport [scsi_transport_fc]
>   RIP: 0010:qla2xxx_queuecommand+0x16b/0x3f0 [qla2xxx]
>   Call Trace:
>    scsi_queue_rq+0x58c/0xa60
>    blk_mq_dispatch_rq_list+0x2b7/0x6f0
>    ? __sbitmap_get_word+0x2a/0x80
>    __blk_mq_sched_dispatch_requests+0xb8/0x170
>    blk_mq_sched_dispatch_requests+0x2b/0x50
>    __blk_mq_run_hw_queue+0x49/0xb0
>    __blk_mq_delay_run_hw_queue+0xfb/0x150
>    blk_mq_sched_insert_request+0xbe/0x110
>    blk_execute_rq+0x45/0x70
>    __scsi_execute+0x10e/0x250
>    scsi_probe_and_add_lun+0x228/0xda0
>    __scsi_scan_target+0xf4/0x620
>    ? __pm_runtime_resume+0x4f/0x70
>    scsi_scan_target+0x100/0x110
>    fc_scsi_scan_rport+0xa1/0xb0 [scsi_transport_fc]
>    process_one_work+0x1ea/0x3b0
>    worker_thread+0x28/0x3b0
>    ? process_one_work+0x3b0/0x3b0
>    kthread+0x112/0x130
>    ? kthread_park+0x80/0x80
>    ret_from_fork+0x22/0x30
> 
> The driver should allocate enough vectors to provide every CPU it's own HW
> queue and still handle reserved (MB, RSP, ATIO) interrupts.
> 
> The change fixes the crash on dual core VM and prevents unbalanced QP
> allocation where nr_hw_queues is two less than the number of CPUs.
> 
> Cc: Daniel Wagner <daniel.wagner@suse.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: stable@vger.kernel.org # 5.11+
> Fixes: a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of CPUs")
> Reported-by: Aleksandr Volkov <a.y.volkov@yadro.com>
> Reported-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>

Make sense to limit the _max_ numbers of requested IRQs to
num_online_cpus() + min_vecs.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
