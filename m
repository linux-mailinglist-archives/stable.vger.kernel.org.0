Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DD513F5D8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388143AbgAPRGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388940AbgAPRGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB8720730;
        Thu, 16 Jan 2020 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194390;
        bh=oUxuQepRUEKu++HXwriPcKSaTS7OHkGAGIHwak+Ax6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XCbY8I9s+R+h5p8ABvc63bdeSbDpGO66YFThwrvm1KjqL7oW0eOAeNQbWQe+EabW
         8tcCLeGlNEWr1O6sUwXmb7qYuicwWqIdoL/017uP503orzmQXBDMbyiny+FZk7KaMb
         d/hs2zpJLqKXLQXvj6JNARLioI8Sakl0zu2mNs8g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 318/671] scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory
Date:   Thu, 16 Jan 2020 11:59:16 -0500
Message-Id: <20200116170509.12787-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c925ca787537..95206e227730 100644
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

