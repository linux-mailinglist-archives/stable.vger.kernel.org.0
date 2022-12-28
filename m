Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37676580E4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiL1QW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiL1QVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910F21B1EE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E45861568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EB1C433D2;
        Wed, 28 Dec 2022 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244357;
        bh=kHYnQcbDkTQfgJl0KpLUriDVaVrup0eOHrDTsP8DpgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4vbqS09vo3ePZ9z3pLZ/ovQb+mDh+VjyCkBdT+/5FDne0tbgZxtQuO4txv5eIQF/
         qX7ooMNu6PnarDnfOz3Gh5Wzd/7FKUM03e7R4LkznDy6anY6knQ8OTngcU+3NhDnMS
         eRIP17Z/HcViR3N8gqj8GcLocx89zXw1hbZFjlSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0656/1146] scsi: ufs: core: Fix the polling implementation
Date:   Wed, 28 Dec 2022 15:36:35 +0100
Message-Id: <20221228144347.976904298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ee8c88cab4afbd5ee10a127d6cbecd6b200185a5 ]

Fix the following issues in ufshcd_poll():

 - If polling succeeds, return a positive value.

 - Do not complete polling requests from interrupt context because the
   block layer expects these requests to be completed from thread
   context. From block/bio.c:

     If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done from
     process context, not hard/soft IRQ.

Fixes: eaab9b573054 ("scsi: ufs: Implement polling support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221118233717.441298-1-bvanassche@acm.org
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b1f59a5fe632..5432be4cd0ed 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5382,6 +5382,26 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	}
 }
 
+/* Any value that is not an existing queue number is fine for this constant. */
+enum {
+	UFSHCD_POLL_FROM_INTERRUPT_CONTEXT = -1
+};
+
+static void ufshcd_clear_polled(struct ufs_hba *hba,
+				unsigned long *completed_reqs)
+{
+	int tag;
+
+	for_each_set_bit(tag, completed_reqs, hba->nutrs) {
+		struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
+
+		if (!cmd)
+			continue;
+		if (scsi_cmd_to_rq(cmd)->cmd_flags & REQ_POLLED)
+			__clear_bit(tag, completed_reqs);
+	}
+}
+
 /*
  * Returns > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -5398,13 +5418,17 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
 		  hba->outstanding_reqs);
+	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
 	hba->outstanding_reqs &= ~completed_reqs;
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
 
-	return completed_reqs;
+	return completed_reqs != 0;
 }
 
 /**
@@ -5435,7 +5459,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
 	 * do not want polling to trigger spurious interrupt complaints.
 	 */
-	ufshcd_poll(hba->host, 0);
+	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 
 	return IRQ_HANDLED;
 }
-- 
2.35.1



