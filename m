Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60682156645
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBHSdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:33:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34346 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727913AbgBHS3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-0003fl-5t; Sat, 08 Feb 2020 18:29:39 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CQu-51; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Honggang Li" <honli@redhat.com>,
        "Jason Gunthorpe" <jgg@mellanox.com>,
        "Bart Van Assche" <bvanassche@acm.org>
Date:   Sat, 08 Feb 2020 18:20:32 +0000
Message-ID: <lsq.1581185940.462189931@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 093/148] RDMA/srpt: Report the SCSI residual to the
 initiator
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1519,9 +1519,11 @@ static int srpt_build_cmd_rsp(struct srp
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
@@ -1543,6 +1545,28 @@ static int srpt_build_cmd_rsp(struct srp
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

