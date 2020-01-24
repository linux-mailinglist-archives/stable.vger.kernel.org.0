Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD75A14843E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390568AbgAXLRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390565AbgAXLRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:53 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF7F20708;
        Fri, 24 Jan 2020 11:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864672;
        bh=fP4seFa3sMzdM3AjWPyuIv4la9noQfVLiSyeNbinffM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPL4Xd9kKjLUYPlKGQakuwTloko0ucMTHOBpOnOBttpN5GKHIKDl45jMwiqI2gBEq
         nlOgjcg0GSL/PUJtZPQdQuAKZST+9z/KxkuVznBX/Zw3ytC6IEhx3rR/urGtYOkWBK
         cLf4vffn197ERm6ph9/KvKF3mqrIOZ/BmMPYqYHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 333/639] scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory
Date:   Fri, 24 Jan 2020 10:28:23 +0100
Message-Id: <20200124093128.816073746@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a861b49273578e255426a499842cf7f465456351 ]

The "(&ctio->u.status1.sense_data)[i]" where i >= 0 expressions in
qlt_send_resp_ctio() are probably typos and should have been
"(&ctio->u.status1.sense_data[4 * i])" instead. Instead of only fixing
these typos, modify the code for storing sense data such that it becomes
easy to read. This patch fixes a Coverity complaint about accessing an
array outside its bounds.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: be25152c0d9e ("qla2xxx: Improve T10-DIF/PI handling in driver.") # v4.11.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c925ca7875374..95206e227730c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2233,14 +2233,14 @@ void qlt_send_resp_ctio(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		ctio->u.status1.scsi_status |=
 		    cpu_to_le16(SS_RESIDUAL_UNDER);
 
-	/* Response code and sense key */
-	put_unaligned_le32(((0x70 << 24) | (sense_key << 8)),
-	    (&ctio->u.status1.sense_data)[0]);
+	/* Fixed format sense data. */
+	ctio->u.status1.sense_data[0] = 0x70;
+	ctio->u.status1.sense_data[2] = sense_key;
 	/* Additional sense length */
-	put_unaligned_le32(0x0a, (&ctio->u.status1.sense_data)[1]);
+	ctio->u.status1.sense_data[7] = 0xa;
 	/* ASC and ASCQ */
-	put_unaligned_le32(((asc << 24) | (ascq << 16)),
-	    (&ctio->u.status1.sense_data)[3]);
+	ctio->u.status1.sense_data[12] = asc;
+	ctio->u.status1.sense_data[13] = ascq;
 
 	/* Memory Barrier */
 	wmb();
-- 
2.20.1



