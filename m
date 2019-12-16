Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8761B12149C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLPSM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbfLPSM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4266A21835;
        Mon, 16 Dec 2019 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519976;
        bh=E+F7Y1VTnP3l3yQ9F4Q3uNcIk7A4nImUB8xp1cxOo4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3JghY5sJZ06dPZWmKkHDtfWDg184QzSQmokBOsagdOQw6FoqH/aitHs7U7/zd66U
         KP2PzaDjjMg7cmLGkozexdlRn8GskxCQ5UhsBIcPRJmO9SDLibdEGHVOIhAfkzuFyq
         UGNe2QUA1Mo0Hs3VulYxJXiXUGATBRkWBVD/rMtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 145/180] scsi: qla2xxx: Fix session lookup in qlt_abort_work()
Date:   Mon, 16 Dec 2019 18:49:45 +0100
Message-Id: <20191216174843.492359033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
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
index 1bb0fc9324ead..7e98d1be757dc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6195,7 +6195,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_port *sess = NULL;
 	unsigned long flags = 0, flags2 = 0;
-	uint32_t be_s_id;
 	uint8_t s_id[3];
 	int rc;
 
@@ -6208,8 +6207,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
 	s_id[2] = prm->abts.fcp_hdr_le.s_id[0];
 
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
-	    (unsigned char *)&be_s_id);
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
-- 
2.20.1



