Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B63C5578
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhGLIK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353647AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F11461CFB;
        Mon, 12 Jul 2021 07:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076584;
        bh=ot23x9JGXST14cqDYE8faNQPo1m7ytDxJnm8xne/0rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXRJtgPhh9wOxFAT9++8/O7/gav2gNJZt5zQn/DFgpNcgiP2RchsTnCKn8mLlhrya
         pXew3DtWxyQsGIoZvBxvkHqYPzzhGDTQd/MZtXfpF3/PGp2NnyMfQ4ANVNXifqclKd
         njoplOjylvLRT77s0pbYUWNuLBjflaIG02lW0D88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 664/800] scsi: iscsi: Use system_unbound_wq for destroy_work
Date:   Mon, 12 Jul 2021 08:11:27 +0200
Message-Id: <20210712061037.570781069@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit b25b957d2db1585602c2c70fdf4261a5641fe6b7 ]

Use the system_unbound_wq for async session destruction. We don't need a
dedicated workqueue for async session destruction because:

 1. perf does not seem to be an issue since we only allow 1 active work.

 2. it does not have deps with other system works and we can run them in
    parallel with each other.

Link: https://lore.kernel.org/r/20210525181821.7617-6-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d134156d67f0..2eb77f69fe0c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -95,8 +95,6 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
-static struct workqueue_struct *iscsi_destroy_workq;
-
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -3724,7 +3722,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
-			queue_work(iscsi_destroy_workq, &session->destroy_work);
+			queue_work(system_unbound_wq, &session->destroy_work);
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
@@ -4820,18 +4818,8 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
-	iscsi_destroy_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_destroy");
-	if (!iscsi_destroy_workq) {
-		err = -ENOMEM;
-		goto destroy_wq;
-	}
-
 	return 0;
 
-destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4853,7 +4841,6 @@ unregister_transport_class:
 
 static void __exit iscsi_transport_exit(void)
 {
-	destroy_workqueue(iscsi_destroy_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
-- 
2.30.2



