Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD47165657
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 05:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBTEju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 23:39:50 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:18566 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727469AbgBTEjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 23:39:49 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 19 Feb 2020 20:24:43 -0800
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 5AF16403A0;
        Wed, 19 Feb 2020 20:24:45 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>,
        <sharathg@vmware.com>, <srostedt@vmware.com>,
        <martin.petersen@oracle.com>, <hmadhani@marvell.com>,
        <mwilck@suse.com>, <allen.pais@oracle.com>
Subject: [PATCH v4.4.y] scsi: qla2xxx: fix a potential NULL pointer dereference
Date:   Thu, 20 Feb 2020 09:50:42 +0530
Message-ID: <1582172443-20029-2-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582172443-20029-1-git-send-email-akaher@vmware.com>
References: <1582172443-20029-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

commit 35a79a63517981a8aea395497c548776347deda8 upstream

alloc_workqueue is not checked for errors and as a result a potential
NULL dereference could occur.

Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
Signed-off-by: Allen Pais <allen.pais@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Ajay: Rewrote this patch for v4.4.y, as 4.4.y codebase is different from mainline]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c813c9b..00528db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -451,6 +451,12 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 		goto fail;
 	}
 	if (ql2xmultique_tag) {
+		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
+		if (unlikely(!ha->wq)) {
+			ql_log(ql_log_warn, vha, 0x01e0,
+			    "Failed to alloc workqueue.\n");
+			goto fail;
+		}
 		/* create a request queue for IO */
 		options |= BIT_7;
 		req = qla25xx_create_req_que(ha, options, 0, 0, -1,
@@ -458,9 +464,8 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 		if (!req) {
 			ql_log(ql_log_warn, vha, 0x00e0,
 			    "Failed to create request queue.\n");
-			goto fail;
+			goto fail2;
 		}
-		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
 		vha->req = ha->req_q_map[req];
 		options |= BIT_1;
 		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
@@ -468,7 +473,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 			if (!ret) {
 				ql_log(ql_log_warn, vha, 0x00e8,
 				    "Failed to create response queue.\n");
-				goto fail2;
+				goto fail3;
 			}
 		}
 		ha->flags.cpu_affinity_enabled = 1;
@@ -482,11 +487,13 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 		    ha->max_rsp_queues, ha->max_req_queues);
 	}
 	return 0;
-fail2:
+
+fail3:
 	qla25xx_delete_queues(vha);
-	destroy_workqueue(ha->wq);
-	ha->wq = NULL;
 	vha->req = ha->req_q_map[0];
+fail2:
+        destroy_workqueue(ha->wq);
+        ha->wq = NULL;
 fail:
 	ha->mqenable = 0;
 	kfree(ha->req_q_map);
-- 
2.7.4
