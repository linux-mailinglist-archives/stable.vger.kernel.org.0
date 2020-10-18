Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3384291EE0
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgJRTTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgJRTTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDE6222C8;
        Sun, 18 Oct 2020 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048790;
        bh=0GI+iFGj0Hf43RnMbbdic4QxmVMhu9Y7Uqv0mAD2gRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfoR3sbnIY/p86Cm+TyJR+hyZqwPrY/9Tc5m78urour4SfF/aKL9HpGVNsuGZJyzE
         JPZDLw58du3fOyLAlgAvxMDuh3a3SdQy1ICw9Kfappt9uNPf60sqKB5yg1LVT5Uou0
         rNS8SCWURax4r3FnizYdKDHwSsDE7GKEDVVAedSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 085/111] scsi: qedi: Mark all connections for recovery on link down event
Date:   Sun, 18 Oct 2020 15:17:41 -0400
Message-Id: <20201018191807.4052726-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 4118879be3755b38171063dfd4a57611d4b20a83 ]

For short time cable pulls, the in-flight I/O to the firmware is never
cleaned up, resulting in the behaviour of stale I/O completion causing
list_del corruption and soft lockup of the system.

On link down event, mark all the connections for recovery, causing cleanup
of all the in-flight I/O immediately.

Link: https://lore.kernel.org/r/20200908095657.26821-7-mrangankar@marvell.com
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 6f038ae5efcaf..dfe24b505b402 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1127,6 +1127,15 @@ static void qedi_schedule_recovery_handler(void *dev)
 	schedule_delayed_work(&qedi->recovery_work, 0);
 }
 
+static void qedi_set_conn_recovery(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct iscsi_conn *conn = session->leadconn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
+
+	qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
+}
+
 static void qedi_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedi_ctx *qedi = (struct qedi_ctx *)dev;
@@ -1138,6 +1147,7 @@ static void qedi_link_update(void *dev, struct qed_link_output *link)
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 			  "Link Down event.\n");
 		atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
+		iscsi_host_for_each_session(qedi->shost, qedi_set_conn_recovery);
 	}
 }
 
-- 
2.25.1

