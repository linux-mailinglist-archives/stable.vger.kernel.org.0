Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929BF126C66
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfLSSsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbfLSSsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C0224676;
        Thu, 19 Dec 2019 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781301;
        bh=vbSty8xfqqjy3G3EUlVHgCD1DEQzgp/nrTCd4ktqP+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTDRjk3JFrzKg1d5Au+gWabIQqh1/TPWhWR5aZaBCdiRSDJw4jzccz0XaImHcWcB8
         rafWwe8xwyo59Q2QFZ7/+0fgqqpF5rql/q+6dK+LxTCYlS31h7+bQZvNKMKiy1fuoC
         xs1B5WOzdepHFuA/8JQw7f929MLK/JbamYEQl49w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 163/199] scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
Date:   Thu, 19 Dec 2019 19:34:05 +0100
Message-Id: <20191219183224.439797920@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c29282c65d1cf54daeea63be46243d7f69d72f4d ]

Set the r??_data_len variables before using these instead of after.

This patch fixes the following Coverity complaint:

const: At condition req_data_len != rsp_data_len, the value of req_data_len
must be equal to 0.
const: At condition req_data_len != rsp_data_len, the value of rsp_data_len
must be equal to 0.
dead_error_condition: The condition req_data_len != rsp_data_len cannot be
true.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: a9b6f722f62d ("[SCSI] qla2xxx: Implementation of bidirectional.") # v3.7.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e7db95d442deb..09f7a8cfed4d0 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1744,8 +1744,8 @@ qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 	uint32_t tot_dsds;
 	srb_t *sp = NULL;
-	uint32_t req_data_len = 0;
-	uint32_t rsp_data_len = 0;
+	uint32_t req_data_len;
+	uint32_t rsp_data_len;
 
 	/* Check the type of the adapter */
 	if (!IS_BIDI_CAPABLE(ha)) {
@@ -1850,6 +1850,9 @@ qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 		goto done_unmap_sg;
 	}
 
+	req_data_len = bsg_job->request_payload.payload_len;
+	rsp_data_len = bsg_job->reply_payload.payload_len;
+
 	if (req_data_len != rsp_data_len) {
 		rval = EXT_STATUS_BUSY;
 		ql_log(ql_log_warn, vha, 0x70aa,
@@ -1857,10 +1860,6 @@ qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 		goto done_unmap_sg;
 	}
 
-	req_data_len = bsg_job->request_payload.payload_len;
-	rsp_data_len = bsg_job->reply_payload.payload_len;
-
-
 	/* Alloc SRB structure */
 	sp = qla2x00_get_sp(vha, &(vha->bidir_fcport), GFP_KERNEL);
 	if (!sp) {
-- 
2.20.1



