Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDB4B49B7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiBNKAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:00:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343831AbiBNJ7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:59:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAD7BC0;
        Mon, 14 Feb 2022 01:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89E92B80DC4;
        Mon, 14 Feb 2022 09:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E5EC340E9;
        Mon, 14 Feb 2022 09:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831999;
        bh=5iu/sAGG6wb7UUIEvchXz4hefR0zgVYDTXIjM/ieclM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7ncJhlX4EVeSuNUGxanbSZIGCsSTvvnhrjjAfEMqGCovEQcIa388cALQTam+4Dq8
         qXwTd34bEI0r3bjGzufSGLjL+RJtkZSvoy+YBR6OnlfiGzNpKpTheIrtekz5f5z59q
         X5D/x9Xk/N0lt4lnefRZGBQitsKWv7LppihdyI1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/172] scsi: qedf: Change context reset messages to ratelimited
Date:   Mon, 14 Feb 2022 10:25:05 +0100
Message-Id: <20220214092508.011334271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



