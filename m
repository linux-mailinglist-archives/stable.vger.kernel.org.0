Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45DB591F70
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiHNKMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiHNKMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521452018E
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60276100C
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25E7C433D7;
        Sun, 14 Aug 2022 10:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660471925;
        bh=hfYxzXfLa/PTER9JTf5yNN0QJM+wk7I1VcZQMqHh7Oo=;
        h=Subject:To:Cc:From:Date:From;
        b=lQo6fubwlyD0ASUuQw5BUl8BVDkyQ/Y0RYAGme+cXQ8DYYuHDNG8Wiwv/gUpH8evu
         u0wsLaj17rcy6c+unkeHk7d8WYy2bJGQOdQfE/6oS8kvNA7swro6iNaA6bNrrr+zF5
         BqRMQsD5hNsojoSSucVlBcR7A0yS1AqLAV7QNLKU=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: edif: Fix dropped IKE message" failed to apply to 5.19-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:11:54 +0200
Message-ID: <1660471914136103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c019cd656e717349ff22d0c41d6fbfc773f48c52 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Tue, 12 Jul 2022 22:20:40 -0700
Subject: [PATCH] scsi: qla2xxx: edif: Fix dropped IKE message

This patch fixes IKE message being dropped due to error in processing Purex
IOCB and Continuation IOCBs.

Link: https://lore.kernel.org/r/20220713052045.10683-6-njavali@marvell.com
Fixes: fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 35b425c446b9..76e79f350a22 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3720,12 +3720,11 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
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
@@ -3736,34 +3735,18 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
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
@@ -3780,7 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0;
+	u16 rsp_in = 0, cur_ring_index;
 	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
@@ -3811,6 +3794,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		       (!follow_inptr &&
 			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
+		cur_ring_index = rsp->ring_index;
 
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
@@ -3931,7 +3915,17 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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

