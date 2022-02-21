Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52714BE697
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350622AbiBUJjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351818AbiBUJhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F665C33;
        Mon, 21 Feb 2022 01:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF65A608C4;
        Mon, 21 Feb 2022 09:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4587C340E9;
        Mon, 21 Feb 2022 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434993;
        bh=e9ZpdAT6Gyf/FwltTfaIsYCa4En2ZtPtS2zL1mxBgcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZ47oBTGtVAQ7LyahY7mofgp+TVulSfm9Pu4/wOZ79ABEWSGjTxoInj6He6OwMMLi
         ZKP8D36wGYfkMYabc30kOWyIogOoE2bC1CHfFq3+3bxJBkR6G3r5JVcX4e83ViZuOG
         rmFayrMqd6sVM6uk44oiWD1foeLAoJoOVEJeB07A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 193/196] scsi: qedi: Fix ABBA deadlock in qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp()
Date:   Mon, 21 Feb 2022 09:50:25 +0100
Message-Id: <20220221084937.394936468@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

commit f10f582d28220f50099d3f561116256267821429 upstream.

This fixes a deadlock added with commit b40f3894e39e ("scsi: qedi: Complete
TMF works before disconnect")

Bug description from Jia-Ju Bai:

qedi_process_tmf_resp()
  spin_lock(&session->back_lock); --> Line 201 (Lock A)
  spin_lock(&qedi_conn->tmf_work_lock); --> Line 230 (Lock B)

qedi_process_cmd_cleanup_resp()
  spin_lock_bh(&qedi_conn->tmf_work_lock); --> Line 752 (Lock B)
  spin_lock_bh(&conn->session->back_lock); --> Line 784 (Lock A)

When qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp() are
concurrently executed, the deadlock can occur.

This patch fixes the deadlock by not holding the tmf_work_lock in
qedi_process_cmd_cleanup_resp while holding the back_lock. The
tmf_work_lock is only needed while we remove the tmf_work from the
work_list.

Link: https://lore.kernel.org/r/20220208185448.6206-1-michael.christie@oracle.com
Fixes: b40f3894e39e ("scsi: qedi: Complete TMF works before disconnect")
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedi/qedi_fw.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -772,11 +772,10 @@ static void qedi_process_cmd_cleanup_res
 			qedi_cmd->list_tmf_work = NULL;
 		}
 	}
+	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
-	if (!found) {
-		spin_unlock_bh(&qedi_conn->tmf_work_lock);
+	if (!found)
 		goto check_cleanup_reqs;
-	}
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
 		  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
@@ -807,7 +806,6 @@ static void qedi_process_cmd_cleanup_res
 	qedi_cmd->state = CLEANUP_RECV;
 unlock:
 	spin_unlock_bh(&conn->session->back_lock);
-	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 	wake_up_interruptible(&qedi_conn->wait_queue);
 	return;
 


