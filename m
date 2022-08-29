Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4525A47DB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiH2LCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiH2LB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC2A2AC7A;
        Mon, 29 Aug 2022 04:01:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F035F611A6;
        Mon, 29 Aug 2022 11:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E3C433D6;
        Mon, 29 Aug 2022 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770910;
        bh=X5oYj97w2Zr9o+u8wQ8RFXzUEGRTSZQ+I3WOqowwdAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkB3xCLF+OcZDwzv1x//CGzsHDGDR4/wBLnT5Qz8uX6uHay6h+anWJnWShEQAZjXh
         q7CrAqlu5Da0KChhOJVF0kBG5MRs6hexZtAPd697RPe/NNatrk8QfeA+yTVoXM3JA9
         tPzlrsbZd1+IWCOQwVxvoWsnvjP2rOzswS0eq/x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/136] scsi: qla2xxx: edif: Fix dropped IKE message
Date:   Mon, 29 Aug 2022 12:58:07 +0200
Message-Id: <20220829105805.432538063@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c019cd656e717349ff22d0c41d6fbfc773f48c52 ]

This patch fixes IKE message being dropped due to error in processing Purex
IOCB and Continuation IOCBs.

Link: https://lore.kernel.org/r/20220713052045.10683-6-njavali@marvell.com
Fixes: fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 54 +++++++++++++++-------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ecbc0a5ffb3f5..59f5918dca95f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3707,12 +3707,11 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
  * Return: 0 all iocbs has arrived, xx- all iocbs have not arrived.
  */
 static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, response_t *pkt)
+	struct rsp_que *rsp, response_t *pkt, u32 rsp_q_in)
 {
-	int start_pkt_ring_index, end_pkt_ring_index, n_ring_index;
-	response_t *end_pkt;
+	int start_pkt_ring_index;
+	u32 iocb_cnt = 0;
 	int rc = 0;
-	u32 rsp_q_in;
 
 	if (pkt->entry_count == 1)
 		return rc;
@@ -3723,34 +3722,18 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 	else
 		start_pkt_ring_index = rsp->ring_index - 1;
 
-	if ((start_pkt_ring_index + pkt->entry_count) >= rsp->length)
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count -
-			rsp->length - 1;
+	if (rsp_q_in < start_pkt_ring_index)
+		/* q in ptr is wrapped */
+		iocb_cnt = rsp->length - start_pkt_ring_index + rsp_q_in;
 	else
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count - 1;
+		iocb_cnt = rsp_q_in - start_pkt_ring_index;
 
-	end_pkt = rsp->ring + end_pkt_ring_index;
-
-	/*  next pkt = end_pkt + 1 */
-	n_ring_index = end_pkt_ring_index + 1;
-	if (n_ring_index >= rsp->length)
-		n_ring_index = 0;
-
-	rsp_q_in = rsp->qpair->use_shadow_reg ? *rsp->in_ptr :
-		rd_reg_dword(rsp->rsp_q_in);
-
-	/* rsp_q_in is either wrapped or pointing beyond endpkt */
-	if ((rsp_q_in < start_pkt_ring_index && rsp_q_in < n_ring_index) ||
-			rsp_q_in >= n_ring_index)
-		/* all IOCBs arrived. */
-		rc = 0;
-	else
+	if (iocb_cnt < pkt->entry_count)
 		rc = -EIO;
 
-	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x5091,
-	    "%s - ring %p pkt %p end pkt %p entry count %#x rsp_q_in %d rc %d\n",
-	    __func__, rsp->ring, pkt, end_pkt, pkt->entry_count,
-	    rsp_q_in, rc);
+	ql_dbg(ql_dbg_init, vha, 0x5091,
+	       "%s - ring %p pkt %p entry count %d iocb_cnt %d rsp_q_in %d rc %d\n",
+	       __func__, rsp->ring, pkt, pkt->entry_count, iocb_cnt, rsp_q_in, rc);
 
 	return rc;
 }
@@ -3767,7 +3750,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0;
+	u16 rsp_in = 0, cur_ring_index;
 	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
@@ -3798,6 +3781,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		       (!follow_inptr &&
 			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
+		cur_ring_index = rsp->ring_index;
 
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
@@ -3918,7 +3902,17 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				break;
 
 			case ELS_AUTH_ELS:
-				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt)) {
+				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt, rsp_in)) {
+					/*
+					 * ring_ptr and ring_index were
+					 * pre-incremented above. Reset them
+					 * back to current. Wait for next
+					 * interrupt with all IOCBs to arrive
+					 * and re-process.
+					 */
+					rsp->ring_ptr = (response_t *)pkt;
+					rsp->ring_index = cur_ring_index;
+
 					ql_dbg(ql_dbg_init, vha, 0x5091,
 					    "Defer processing ELS opcode %#x...\n",
 					    purex_entry->els_frame_payload[3]);
-- 
2.35.1



