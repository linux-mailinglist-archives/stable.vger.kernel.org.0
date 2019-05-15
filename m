Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25741F057
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbfEOLnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732224AbfEOL11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2219820843;
        Wed, 15 May 2019 11:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919646;
        bh=T2QqfvhbHzDVSRQbMsQ6S98gh0+Bw32FInU2Ut6QmSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl07EyPDif8UjhZFPdsCa7Ot4/mwcbmPar9EmZ2PCaQlGc2Jx4cU8ZvcZOuerBefR
         KUtCzBt1g1+B9iQzpb4/ighVQsH6sjP+zzcoJQ8XUUCDr4ca3CWprisjTFq35sAnBp
         swsylspcTblIwR6COa2FNwH7QQSKIfspYnYDDkus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 041/137] qed: Delete redundant doorbell recovery types
Date:   Wed, 15 May 2019 12:55:22 +0200
Message-Id: <20190515090656.397170610@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9ac6bb1414ac0d45fe9cefbd1f5b06f0e1a3c98a ]

DB_REC_DRY_RUN (running doorbell recovery without sending doorbells) is
never used. DB_REC_ONCE (send a single doorbell from the doorbell recovery)
is not needed anymore because by running the periodic handler we make sure
we check the overflow status later instead.
This patch is needed because in the next patches, the only doorbell
recovery type being used is DB_REC_REAL_DEAL, and the fixes are much
cleaner without this enum.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h     |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 69 +++++++++--------------
 drivers/net/ethernet/qlogic/qed/qed_int.c |  6 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h |  4 +-
 4 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 2d8a77cc156ba..d5fece7eb1698 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -918,8 +918,7 @@ u16 qed_get_cm_pq_idx_llt_mtc(struct qed_hwfn *p_hwfn, u8 tc);
 
 /* doorbell recovery mechanism */
 void qed_db_recovery_dp(struct qed_hwfn *p_hwfn);
-void qed_db_recovery_execute(struct qed_hwfn *p_hwfn,
-			     enum qed_db_rec_exec db_exec);
+void qed_db_recovery_execute(struct qed_hwfn *p_hwfn);
 bool qed_edpm_enabled(struct qed_hwfn *p_hwfn);
 
 /* Other Linux specific common definitions */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 2ecaaaa4469a6..ff0bbf8d073d6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -300,26 +300,19 @@ void qed_db_recovery_dp(struct qed_hwfn *p_hwfn)
 
 /* Ring the doorbell of a single doorbell recovery entry */
 static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
-				 struct qed_db_recovery_entry *db_entry,
-				 enum qed_db_rec_exec db_exec)
-{
-	if (db_exec != DB_REC_ONCE) {
-		/* Print according to width */
-		if (db_entry->db_width == DB_REC_WIDTH_32B) {
-			DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-				   "%s doorbell address %p data %x\n",
-				   db_exec == DB_REC_DRY_RUN ?
-				   "would have rung" : "ringing",
-				   db_entry->db_addr,
-				   *(u32 *)db_entry->db_data);
-		} else {
-			DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-				   "%s doorbell address %p data %llx\n",
-				   db_exec == DB_REC_DRY_RUN ?
-				   "would have rung" : "ringing",
-				   db_entry->db_addr,
-				   *(u64 *)(db_entry->db_data));
-		}
+				 struct qed_db_recovery_entry *db_entry)
+{
+	/* Print according to width */
+	if (db_entry->db_width == DB_REC_WIDTH_32B) {
+		DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
+			   "ringing doorbell address %p data %x\n",
+			   db_entry->db_addr,
+			   *(u32 *)db_entry->db_data);
+	} else {
+		DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
+			   "ringing doorbell address %p data %llx\n",
+			   db_entry->db_addr,
+			   *(u64 *)(db_entry->db_data));
 	}
 
 	/* Sanity */
@@ -334,14 +327,12 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 	wmb();
 
 	/* Ring the doorbell */
-	if (db_exec == DB_REC_REAL_DEAL || db_exec == DB_REC_ONCE) {
-		if (db_entry->db_width == DB_REC_WIDTH_32B)
-			DIRECT_REG_WR(db_entry->db_addr,
-				      *(u32 *)(db_entry->db_data));
-		else
-			DIRECT_REG_WR64(db_entry->db_addr,
-					*(u64 *)(db_entry->db_data));
-	}
+	if (db_entry->db_width == DB_REC_WIDTH_32B)
+		DIRECT_REG_WR(db_entry->db_addr,
+			      *(u32 *)(db_entry->db_data));
+	else
+		DIRECT_REG_WR64(db_entry->db_addr,
+				*(u64 *)(db_entry->db_data));
 
 	/* Flush the write combined buffer. Next doorbell may come from a
 	 * different entity to the same address...
@@ -350,29 +341,21 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 }
 
 /* Traverse the doorbell recovery entry list and ring all the doorbells */
-void qed_db_recovery_execute(struct qed_hwfn *p_hwfn,
-			     enum qed_db_rec_exec db_exec)
+void qed_db_recovery_execute(struct qed_hwfn *p_hwfn)
 {
 	struct qed_db_recovery_entry *db_entry = NULL;
 
-	if (db_exec != DB_REC_ONCE) {
-		DP_NOTICE(p_hwfn,
-			  "Executing doorbell recovery. Counter was %d\n",
-			  p_hwfn->db_recovery_info.db_recovery_counter);
+	DP_NOTICE(p_hwfn, "Executing doorbell recovery. Counter was %d\n",
+		  p_hwfn->db_recovery_info.db_recovery_counter);
 
-		/* Track amount of times recovery was executed */
-		p_hwfn->db_recovery_info.db_recovery_counter++;
-	}
+	/* Track amount of times recovery was executed */
+	p_hwfn->db_recovery_info.db_recovery_counter++;
 
 	/* Protect the list */
 	spin_lock_bh(&p_hwfn->db_recovery_info.lock);
 	list_for_each_entry(db_entry,
-			    &p_hwfn->db_recovery_info.list, list_entry) {
-		qed_db_recovery_ring(p_hwfn, db_entry, db_exec);
-		if (db_exec == DB_REC_ONCE)
-			break;
-	}
-
+			    &p_hwfn->db_recovery_info.list, list_entry)
+		qed_db_recovery_ring(p_hwfn, db_entry);
 	spin_unlock_bh(&p_hwfn->db_recovery_info.lock);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 92340919d8521..b994f81eb51c3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -409,10 +409,8 @@ int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 	overflow = qed_rd(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY);
 	DP_NOTICE(p_hwfn, "PF Overflow sticky 0x%x\n", overflow);
-	if (!overflow) {
-		qed_db_recovery_execute(p_hwfn, DB_REC_ONCE);
+	if (!overflow)
 		return 0;
-	}
 
 	if (qed_edpm_enabled(p_hwfn)) {
 		rc = qed_db_rec_flush_queue(p_hwfn, p_ptt);
@@ -427,7 +425,7 @@ int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	qed_wr(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY, 0x0);
 
 	/* Repeat all last doorbells (doorbell drop recovery) */
-	qed_db_recovery_execute(p_hwfn, DB_REC_REAL_DEAL);
+	qed_db_recovery_execute(p_hwfn);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index d81a62ebd5244..df26bf333893d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -192,8 +192,8 @@ void qed_int_disable_post_isr_release(struct qed_dev *cdev);
 
 /**
  * @brief - Doorbell Recovery handler.
- *          Run DB_REAL_DEAL doorbell recovery in case of PF overflow
- *          (and flush DORQ if needed), otherwise run DB_REC_ONCE.
+ *          Run doorbell recovery in case of PF overflow (and flush DORQ if
+ *          needed).
  *
  * @param p_hwfn
  * @param p_ptt
-- 
2.20.1



