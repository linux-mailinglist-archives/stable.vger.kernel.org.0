Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7680E7F35D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406766AbfHBJ4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406761AbfHBJ4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B953B2067D;
        Fri,  2 Aug 2019 09:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739800;
        bh=PcsQo1hXT6MNMUhxrEhQkhYoGRVZHbiC+jN1cSetfSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7VckPrmFJP85NiRtk/dQxRFazcqOtvt03Dd7+WjN4HMM3c+Mua+tXh43rHYU5E57
         yue+XTtmOKsRD0WOQhgIsKffp2LjORcc4jD+LgZnTR9ni/NB9trpFO5nWOascU37RE
         0oOCQk+xm14U/a3QeBky+E1Aa1SKo84aQpcmhAPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 32/32] scsi: core: Avoid that a kernel warning appears during system resume
Date:   Fri,  2 Aug 2019 11:40:06 +0200
Message-Id: <20190802092111.551503666@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 17605afaae825b0291f80c62a7f6565879edaa8a upstream.

Since scsi_device_quiesce() skips SCSI devices that have another state than
RUNNING, OFFLINE or TRANSPORT_OFFLINE, scsi_device_resume() should not
complain about SCSI devices that have been skipped. Hence this patch.  This
patch avoids that the following warning appears during resume:

WARNING: CPU: 3 PID: 1039 at blk_clear_pm_only+0x2a/0x30
CPU: 3 PID: 1039 Comm: kworker/u8:49 Not tainted 5.0.0+ #1
Hardware name: LENOVO 4180F42/4180F42, BIOS 83ET75WW (1.45 ) 05/10/2013
Workqueue: events_unbound async_run_entry_fn
RIP: 0010:blk_clear_pm_only+0x2a/0x30
Call Trace:
 ? scsi_device_resume+0x28/0x50
 ? scsi_dev_type_resume+0x2b/0x80
 ? async_run_entry_fn+0x2c/0xd0
 ? process_one_work+0x1f0/0x3f0
 ? worker_thread+0x28/0x3c0
 ? process_one_work+0x3f0/0x3f0
 ? kthread+0x10c/0x130
 ? __kthread_create_on_node+0x150/0x150
 ? ret_from_fork+0x1f/0x30

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Martin Steigerwald <martin@lichtvoll.de>
Cc: <stable@vger.kernel.org>
Reported-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Tested-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Fixes: 3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work reliably") # v4.15
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3102,8 +3102,10 @@ void scsi_device_resume(struct scsi_devi
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
-	sdev->quiesced_by = NULL;
-	blk_clear_pm_only(sdev->request_queue);
+	if (sdev->quiesced_by) {
+		sdev->quiesced_by = NULL;
+		blk_clear_pm_only(sdev->request_queue);
+	}
 	if (sdev->sdev_state == SDEV_QUIESCE)
 		scsi_device_set_state(sdev, SDEV_RUNNING);
 	mutex_unlock(&sdev->state_mutex);


