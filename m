Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B768D310E11
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBEPFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233070AbhBEPCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF5976508E;
        Fri,  5 Feb 2021 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534422;
        bh=uU8GzEoI26MawmMmTxJY79nXqStuQdKpJNSWPkntov4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFGZiTNZuZsJaJdN3FiJRBPTcpEsU0sT4ht0pwCei8tfGH10DjjbmtkpUTAZvKmvi
         i3mb2JPBRzwI2l8Lh+Ndzes4+afSq1zbNdfVZiKKmfsvmTK/xAqKoxsyozJH3J+QL8
         7U48r1GPqXcnSRYxbojMST4FZs47wJbZtFApkCkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/17] scsi: ibmvfc: Set default timeout to avoid crash during migration
Date:   Fri,  5 Feb 2021 15:08:07 +0100
Message-Id: <20210205140650.348317315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit 764907293edc1af7ac857389af9dc858944f53dc ]

While testing live partition mobility, we have observed occasional crashes
of the Linux partition. What we've seen is that during the live migration,
for specific configurations with large amounts of memory, slow network
links, and workloads that are changing memory a lot, the partition can end
up being suspended for 30 seconds or longer. This resulted in the following
scenario:

CPU 0                          CPU 1
-------------------------------  ----------------------------------
scsi_queue_rq                    migration_store
 -> blk_mq_start_request          -> rtas_ibm_suspend_me
  -> blk_add_timer                 -> on_each_cpu(rtas_percpu_suspend_me
              _______________________________________V
             |
             V
    -> IPI from CPU 1
     -> rtas_percpu_suspend_me
                                     -> __rtas_suspend_last_cpu

-- Linux partition suspended for > 30 seconds --
                                      -> for_each_online_cpu(cpu)
                                           plpar_hcall_norets(H_PROD
 -> scsi_dispatch_cmd
                                      -> scsi_times_out
                                       -> scsi_abort_command
                                        -> queue_delayed_work
  -> ibmvfc_queuecommand_lck
   -> ibmvfc_send_event
    -> ibmvfc_send_crq
     - returns H_CLOSED
   <- returns SCSI_MLQUEUE_HOST_BUSY
-> __blk_mq_requeue_request

                                      -> scmd_eh_abort_handler
                                       -> scsi_try_to_abort_cmd
                                         - returns SUCCESS
                                       -> scsi_queue_insert

Normally, the SCMD_STATE_COMPLETE bit would protect against the command
completion and the timeout, but that doesn't work here, since we don't
check that at all in the SCSI_MLQUEUE_HOST_BUSY path.

In this case we end up calling scsi_queue_insert on a request that has
already been queued, or possibly even freed, and we crash.

The patch below simply increases the default I/O timeout to avoid this race
condition. This is also the timeout value that nearly all IBM SAN storage
recommends setting as the default value.

Link: https://lore.kernel.org/r/1610463998-19791-1-git-send-email-brking@linux.vnet.ibm.com
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 090ab377f65e5..50078a199fea0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2890,8 +2890,10 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (sdev->type == TYPE_DISK)
+	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
+		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return 0;
 }
-- 
2.27.0



