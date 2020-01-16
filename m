Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3113FD1C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbgAPXWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390894AbgAPXWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB44206D9;
        Thu, 16 Jan 2020 23:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216925;
        bh=V2J9YfWSVeAVG7GVUmiIj3FqxophZV4LyMA8bfFylx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+Aa1uEGVZw8IVKzPlNj40rXhZLgiHmicJaTFakGkpV5MTGw3AH3cI9pW5Nlzv0RN
         ZQ4wOwtMxjTSe0wwQstEqJQGnyK+rGrQyvgAEUi+vYM/8jlyvUj0yyF5Bh9mbWWvPC
         pNWp/kTrLKGbjLhx8cMFAkSje545PaiEMq9rMzTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Honggang Li <honli@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 076/203] RDMA/srpt: Report the SCSI residual to the initiator
Date:   Fri, 17 Jan 2020 00:16:33 +0100
Message-Id: <20200116231750.951965385@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit e88982ad1bb12db699de96fbc07096359ef6176c upstream.

The code added by this patch is similar to the code that already exists in
ibmvscsis_determine_resid(). This patch has been tested by running the
following command:

strace sg_raw -r 1k /dev/sdb 12 00 00 00 60 00 -o inquiry.bin |&
    grep resid=

Link: https://lore.kernel.org/r/20191105214632.183302-1-bvanassche@acm.org
Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Honggang Li <honli@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1364,9 +1364,11 @@ static int srpt_build_cmd_rsp(struct srp
 			      struct srpt_send_ioctx *ioctx, u64 tag,
 			      int status)
 {
+	struct se_cmd *cmd = &ioctx->cmd;
 	struct srp_rsp *srp_rsp;
 	const u8 *sense_data;
 	int sense_data_len, max_sense_len;
+	u32 resid = cmd->residual_count;
 
 	/*
 	 * The lowest bit of all SAM-3 status codes is zero (see also
@@ -1388,6 +1390,28 @@ static int srpt_build_cmd_rsp(struct srp
 	srp_rsp->tag = tag;
 	srp_rsp->status = status;
 
+	if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		if (cmd->data_direction == DMA_TO_DEVICE) {
+			/* residual data from an underflow write */
+			srp_rsp->flags = SRP_RSP_FLAG_DOUNDER;
+			srp_rsp->data_out_res_cnt = cpu_to_be32(resid);
+		} else if (cmd->data_direction == DMA_FROM_DEVICE) {
+			/* residual data from an underflow read */
+			srp_rsp->flags = SRP_RSP_FLAG_DIUNDER;
+			srp_rsp->data_in_res_cnt = cpu_to_be32(resid);
+		}
+	} else if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+		if (cmd->data_direction == DMA_TO_DEVICE) {
+			/* residual data from an overflow write */
+			srp_rsp->flags = SRP_RSP_FLAG_DOOVER;
+			srp_rsp->data_out_res_cnt = cpu_to_be32(resid);
+		} else if (cmd->data_direction == DMA_FROM_DEVICE) {
+			/* residual data from an overflow read */
+			srp_rsp->flags = SRP_RSP_FLAG_DIOVER;
+			srp_rsp->data_in_res_cnt = cpu_to_be32(resid);
+		}
+	}
+
 	if (sense_data_len) {
 		BUILD_BUG_ON(MIN_MAX_RSP_SIZE <= sizeof(*srp_rsp));
 		max_sense_len = ch->max_ti_iu_len - sizeof(*srp_rsp);


