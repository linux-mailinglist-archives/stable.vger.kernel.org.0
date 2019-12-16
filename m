Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66869121664
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbfLPS2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731217AbfLPSOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AAF206E0;
        Mon, 16 Dec 2019 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520064;
        bh=6+Xon98xyuUDg6YRXqvsnRkbM2QYa3frpTr9C/0umUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddJs0zEuQU2xgw7BKo+sjHfS/v6WGmdJ42M7wToGYn1xfCYCfvxA8xZ0FMsbArG+i
         wkct3uNc9zTgx33K6qtjgQq9OQT4dW1ymyg0Ep9bhGGi1kPqIgrewG7y7XiaD5jSeo
         a9RvPV91vaOVqkn/AJZyfcLyP6gBezoPP63civwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 161/180] scsi: qla2xxx: Introduce the function qla2xxx_init_sp()
Date:   Mon, 16 Dec 2019 18:50:01 +0100
Message-Id: <20191216174846.265168496@linuxfoundation.org>
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

[ Upstream commit bdb61b9b944d1e5b7cee5a9fe21014363c55b811 ]

This patch does not change any functionality but makes the next patch
easier to read.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_inline.h | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index bf063c6643523..0c3d907af7692 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -152,6 +152,18 @@ qla2x00_chip_is_down(scsi_qla_host_t *vha)
 	return (qla2x00_reset_active(vha) || !vha->hw->flags.fw_started);
 }
 
+static void qla2xxx_init_sp(srb_t *sp, scsi_qla_host_t *vha,
+			    struct qla_qpair *qpair, fc_port_t *fcport)
+{
+	memset(sp, 0, sizeof(*sp));
+	sp->fcport = fcport;
+	sp->iocbs = 1;
+	sp->vha = vha;
+	sp->qpair = qpair;
+	sp->cmd_type = TYPE_SRB;
+	INIT_LIST_HEAD(&sp->elem);
+}
+
 static inline srb_t *
 qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
     fc_port_t *fcport, gfp_t flag)
@@ -164,19 +176,9 @@ qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
 		return NULL;
 
 	sp = mempool_alloc(qpair->srb_mempool, flag);
-	if (!sp)
-		goto done;
-
-	memset(sp, 0, sizeof(*sp));
-	sp->fcport = fcport;
-	sp->iocbs = 1;
-	sp->vha = vha;
-	sp->qpair = qpair;
-	sp->cmd_type = TYPE_SRB;
-	INIT_LIST_HEAD(&sp->elem);
-
-done:
-	if (!sp)
+	if (sp)
+		qla2xxx_init_sp(sp, vha, qpair, fcport);
+	else
 		QLA_QPAIR_MARK_NOT_BUSY(qpair);
 	return sp;
 }
-- 
2.20.1



