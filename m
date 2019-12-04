Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88C11342F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfLDSEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbfLDSEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:37 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B122081B;
        Wed,  4 Dec 2019 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482675;
        bh=RW7bwmdzHleJQLSbNditI9A7eUXwuSN4dTehAe8Fghw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mp6yQlOPBrVDFNjxVpB9xTqjEy2BtiMUpN1jYw6MbvvDiz9+wWqmDwOp9BoSojHVY
         y67fHz2cVZk3w1gvsy2XlAoBG2m+YuxloWG8e2YcH/LyIFb+TzYPuKZKMXlQ3n0Ded
         kZm0ajyC4U+2T/oyeZ+u1iwzozcUEALIc3ZZ+lf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatoliy Glagolev <glagolig@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/209] scsi: qla2xxx: deadlock by configfs_depend_item
Date:   Wed,  4 Dec 2019 18:55:01 +0100
Message-Id: <20191204175327.837306856@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatoliy Glagolev <glagolig@gmail.com>

[ Upstream commit 17b18eaa6f59044a5172db7d07149e31ede0f920 ]

The intent of invoking configfs_depend_item in commit 7474f52a82d51
("tcm_qla2xxx: Perform configfs depend/undepend for base_tpg")
was to prevent a physical Fibre Channel port removal when
virtual (NPIV) ports announced through that physical port are active.
The change does not work as expected: it makes enabled physical port
dependent on target configfs subsystem (the port's parent), something
the configfs guarantees anyway.

Besides, scheduling work in a worker thread and waiting for the work's
completion is not really a valid workaround for the requirement not to call
configfs_depend_item from a configfs callback: the call occasionally
deadlocks.

Thus, removing configfs_depend_item calls does not break anything and fixes
the deadlock problem.

Signed-off-by: Anatoliy Glagolev <glagolig@gmail.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 48 +++++-------------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  3 --
 2 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2fcdaadd10fa5..e08ac431bc496 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -903,38 +903,14 @@ static ssize_t tcm_qla2xxx_tpg_enable_show(struct config_item *item,
 			atomic_read(&tpg->lport_tpg_enabled));
 }
 
-static void tcm_qla2xxx_depend_tpg(struct work_struct *work)
-{
-	struct tcm_qla2xxx_tpg *base_tpg = container_of(work,
-				struct tcm_qla2xxx_tpg, tpg_base_work);
-	struct se_portal_group *se_tpg = &base_tpg->se_tpg;
-	struct scsi_qla_host *base_vha = base_tpg->lport->qla_vha;
-
-	if (!target_depend_item(&se_tpg->tpg_group.cg_item)) {
-		atomic_set(&base_tpg->lport_tpg_enabled, 1);
-		qlt_enable_vha(base_vha);
-	}
-	complete(&base_tpg->tpg_base_comp);
-}
-
-static void tcm_qla2xxx_undepend_tpg(struct work_struct *work)
-{
-	struct tcm_qla2xxx_tpg *base_tpg = container_of(work,
-				struct tcm_qla2xxx_tpg, tpg_base_work);
-	struct se_portal_group *se_tpg = &base_tpg->se_tpg;
-	struct scsi_qla_host *base_vha = base_tpg->lport->qla_vha;
-
-	if (!qlt_stop_phase1(base_vha->vha_tgt.qla_tgt)) {
-		atomic_set(&base_tpg->lport_tpg_enabled, 0);
-		target_undepend_item(&se_tpg->tpg_group.cg_item);
-	}
-	complete(&base_tpg->tpg_base_comp);
-}
-
 static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
+	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 			struct tcm_qla2xxx_tpg, se_tpg);
 	unsigned long op;
@@ -953,24 +929,16 @@ static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
 		if (atomic_read(&tpg->lport_tpg_enabled))
 			return -EEXIST;
 
-		INIT_WORK(&tpg->tpg_base_work, tcm_qla2xxx_depend_tpg);
+		atomic_set(&tpg->lport_tpg_enabled, 1);
+		qlt_enable_vha(vha);
 	} else {
 		if (!atomic_read(&tpg->lport_tpg_enabled))
 			return count;
 
-		INIT_WORK(&tpg->tpg_base_work, tcm_qla2xxx_undepend_tpg);
+		atomic_set(&tpg->lport_tpg_enabled, 0);
+		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 	}
-	init_completion(&tpg->tpg_base_comp);
-	schedule_work(&tpg->tpg_base_work);
-	wait_for_completion(&tpg->tpg_base_comp);
 
-	if (op) {
-		if (!atomic_read(&tpg->lport_tpg_enabled))
-			return -ENODEV;
-	} else {
-		if (atomic_read(&tpg->lport_tpg_enabled))
-			return -EPERM;
-	}
 	return count;
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 7550ba2831c36..147cf6c903666 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -48,9 +48,6 @@ struct tcm_qla2xxx_tpg {
 	struct tcm_qla2xxx_tpg_attrib tpg_attrib;
 	/* Returned by tcm_qla2xxx_make_tpg() */
 	struct se_portal_group se_tpg;
-	/* Items for dealing with configfs_depend_item */
-	struct completion tpg_base_comp;
-	struct work_struct tpg_base_work;
 };
 
 struct tcm_qla2xxx_fc_loopid {
-- 
2.20.1



