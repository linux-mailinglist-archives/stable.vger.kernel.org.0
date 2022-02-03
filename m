Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5894A8E28
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355249AbiBCUfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:35:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36290 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354900AbiBCUdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 533FEB835AA;
        Thu,  3 Feb 2022 20:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13485C340F0;
        Thu,  3 Feb 2022 20:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920425;
        bh=5iu/sAGG6wb7UUIEvchXz4hefR0zgVYDTXIjM/ieclM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqKLY50rM5uMCeaIzwaTifr1os/fPpqgQqMDWxPLpF7waWaUkwvCcJu5VRMq0kh/C
         M0v7BUt2FS4Ycoz1OwXMs8iT0rPgGp0wz9iGgZVlPEEQIWFeITIDFDiMRjXCviGSxa
         XzLuzpILxcMVnwEy4n1KU0TA5RRst44d3zeqeR89JyktpJ1W6v3TaR/YNP+F+cdStb
         5RUAzBcy8QqEpxpXSYDV9y8NytUdbptzetY3UGczLxgtS0XWgh2+WtJGWFitfhcx1K
         GEyGp52iBE13QZCOpdzw5sYZpm2LQDxzKnMf7sjZ/DBWUTOE1YPaJqyi0GagrKKHd9
         xOZvX2DKVuAuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/41] scsi: qedf: Change context reset messages to ratelimited
Date:   Thu,  3 Feb 2022 15:32:31 -0500
Message-Id: <20220203203245.3007-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 64fd4af6274eb0f49d29772c228fffcf6bde1635 ]

If FCoE is not configured, libfc/libfcoe keeps on retrying FLOGI and after
3 retries driver does a context reset and tries fipvlan again.  This leads
to context reset message flooding the logs. Hence ratelimit the message to
prevent flooding the logs.

Link: https://lore.kernel.org/r/20220117135311.6256-4-njavali@marvell.com
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9a256dbddaf55..544401f76c079 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -911,7 +911,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qed_link_output if_link;
 
 	if (lport->vport) {
-		QEDF_ERR(NULL, "Cannot issue host reset on NPIV port.\n");
+		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
@@ -3979,7 +3979,9 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
-	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
+	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
+			dev_name(&qedf->pdev->dev), __func__, __LINE__,
+			qedf->dbg_ctx.host_no);
 	qedf_ctx_soft_reset(qedf->lport);
 }
 
-- 
2.34.1

