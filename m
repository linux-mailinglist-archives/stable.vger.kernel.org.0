Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DADF12133F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbfLPSAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbfLPSAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E2DB20700;
        Mon, 16 Dec 2019 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519207;
        bh=goQk/I4Xym0APb84CrpGO0nBV80m32nM16OUvb9b9Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEO3+e+rYph1KqashtSzjHQ4mrzH1EmVfpa6IMwn5z/oDviNuJb1Sja34+7+E9VN/
         jZgtL2ZKdPh6D6Xb2dxFocTUpDFj+LEUsZkN1xobSBlFVF2vIYwBWpUj8IYTTcWTv7
         +WTwxpOuVnUN5PUud3GoiD1F4Mw/vwmErO18F228=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 240/267] scsi: qla2xxx: Fix session lookup in qlt_abort_work()
Date:   Mon, 16 Dec 2019 18:49:26 +0100
Message-Id: <20191216174915.703737343@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ac452b8e79320c9e90c78edf32ba2d42431e4daf ]

Pass the correct session ID to find_sess_by_s_id() instead of passing an
uninitialized variable.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 2d70c103fd2a ("[SCSI] qla2xxx: Add LLD target-mode infrastructure for >= 24xx series") # v3.5.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 11753ed3433ca..2f5658554275c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5918,7 +5918,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_port *sess = NULL;
 	unsigned long flags = 0, flags2 = 0;
-	uint32_t be_s_id;
 	uint8_t s_id[3];
 	int rc;
 
@@ -5931,8 +5930,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
 	s_id[2] = prm->abts.fcp_hdr_le.s_id[0];
 
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
-	    (unsigned char *)&be_s_id);
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
-- 
2.20.1



