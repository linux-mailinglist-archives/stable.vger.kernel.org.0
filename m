Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA18D3C2D38
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhGJCWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhGJCVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8EE61404;
        Sat, 10 Jul 2021 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883537;
        bh=6DCloj/Qq/rLahaj4a/7ASsaS4TG2vOx87BOfLvF36A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLMgr9eTJi3LXyEbnQrNnnuqvxZFDpi1tU7JH28N+JTAhTvrcyGzcxxW8ZzZ3Fz2A
         8DOqcbihYcoma2Tj734pfiloyzg7U/SENvmkimhaaGOiMWxbqx1EbMwmrCqmAVH+E0
         5/zabwOU7NhXPPGV3asA7vfnP8Yd5EsHz+P2NmfuNbwu6oKhfrf//C6UmBS4D2FoL1
         maeaQixspD6nCCyljD7izDzP3V1Xsug5beMqeMEaMe9hajVinKdxDdIfVzE0zoRqIs
         UJCnuduzSDoHjmAjomW8cEFFyb5+ENGJmMQk9xjOtUJt1xbE+2xIbAGDLXpoeyrYSp
         ECTQyWUzzqbRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 050/114] scsi: qedi: Fix cleanup session block/unblock use
Date:   Fri,  9 Jul 2021 22:16:44 -0400
Message-Id: <20210710021748.3167666-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 0c72191da68638a479602dd515b587ada913184a ]

Drivers shouldn't be calling block/unblock session for cmd cleanup because
the functions can change the session state from under libiscsi.  This adds
a new a driver level bit so it can block all I/O the host while it drains
the card.

Link: https://lore.kernel.org/r/20210525181821.7617-26-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi.h       |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index c342defc3f52..ce199a7a16b8 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -284,6 +284,7 @@ struct qedi_ctx {
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
 #define QEDI_IN_SHUTDOWN	7
+#define QEDI_BLOCK_IO		8
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index a7003847bd4c..8f8036ae9a56 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session *cls_session, uint32_t cid)
 
 void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	iscsi_block_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 void qedi_mark_device_available(struct iscsi_cls_session *cls_session)
 {
-	iscsi_unblock_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi,
@@ -789,6 +799,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
+	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
+		return -EACCES;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
-- 
2.30.2

