Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C954A8DA4
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354315AbiBCUcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348713AbiBCUbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB91C0613EB;
        Thu,  3 Feb 2022 12:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C886AB835A3;
        Thu,  3 Feb 2022 20:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F57C340E8;
        Thu,  3 Feb 2022 20:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920265;
        bh=nDySB6UXuT3u6CrlRf1gGUS+olwtOzGHIaEFmYJVFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7BKLUFf7gHZ4HIXDKB/J/UDXGPTzvwcS6Z3iIAhWEn9MkPU+UP/HHv+bbbz5Fr91
         O4GX4aUn0dSsjLculfAT0XFTVCeRug3nawBV1pt13aS7CXh/bZbfn4LGRnTlAGwH8g
         bKii/I9RbcwlrAQg/B1t+C+EAPEM9fLv9qEVmrB2ILKJnJrS0GxawoCGIFLxluMH5P
         4iNrnvFl23m8se0qHx9DJ4P1DFZayM33T8a5+H8jop2OBOtwXA/T1EW8u7t+8WaOa4
         yddQLnkg3vzhxMQ3abAganUPT1rBXdxX8DR6sISwHqXwU9nuMb3zX4kHxukW+4Ysm3
         QWh3UD0WhO4IQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 30/52] scsi: qedf: Change context reset messages to ratelimited
Date:   Thu,  3 Feb 2022 15:29:24 -0500
Message-Id: <20220203202947.2304-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 6e367b40ecc96..e0e03443d7703 100644
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

