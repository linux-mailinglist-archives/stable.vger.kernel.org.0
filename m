Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDCE17198A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgB0Npp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgB0Npp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19BE720726;
        Thu, 27 Feb 2020 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811144;
        bh=7/ppde6gtQAayolTromL0dUdEI07aG1CC03+goNB0f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diH7Dz7PqfF5j1iyqr0NKB8PIspCb1PB68o0zoWsUltgI7sKHggofb+qZJ2Sy3pKm
         /oWZCwuoZOBBvo8dKjdHXzFW5d+6q8vjuXd+jJ9+pWBtxlOjgF6wD6uru9qdc+hESk
         nHrHOD/sGKNgRzH5+R3cE8uVYrPlgU+b/EWkVMTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.9 020/165] scsi: qla2xxx: fix a potential NULL pointer dereference
Date:   Thu, 27 Feb 2020 14:34:54 +0100
Message-Id: <20200227132233.946217851@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

commit 35a79a63517981a8aea395497c548776347deda8 upstream.

alloc_workqueue is not checked for errors and as a result a potential
NULL dereference could occur.

Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
Signed-off-by: Allen Pais <allen.pais@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Ajay: Rewrote this patch for v4.9.y, as 4.9.y codebase is different from mainline]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -451,6 +451,12 @@ static int qla25xx_setup_mode(struct scs
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
@@ -458,9 +464,8 @@ static int qla25xx_setup_mode(struct scs
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
@@ -468,7 +473,7 @@ static int qla25xx_setup_mode(struct scs
 			if (!ret) {
 				ql_log(ql_log_warn, vha, 0x00e8,
 				    "Failed to create response queue.\n");
-				goto fail2;
+				goto fail3;
 			}
 		}
 		ha->flags.cpu_affinity_enabled = 1;
@@ -482,11 +487,13 @@ static int qla25xx_setup_mode(struct scs
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


