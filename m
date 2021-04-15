Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53568361324
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhDOTxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:53:05 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38384 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234654AbhDOTxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 15:53:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9C0BE41390;
        Thu, 15 Apr 2021 19:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1618516359; x=1620330760; bh=+DgJ3q4Twfj1gAmBeLPaVUPy5XJqwxFcGZA
        9mV9fccc=; b=Kur+oh87Z31kJGgNKYcqMThPYgH/+Kfe78Jj795GJTSUzKhey7H
        CWWqchyIwg4CJkgXKCo7eBx5B6rd4X08BtCO6T5Eab0IhK8E739ax3BzaWzHsdPd
        1keOmxR9VxrbL5cMtvZOspAbGCJF6a6Jdx8/nf5C8EjeE3Lov6qJgdBI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BcOF62v0pEV6; Thu, 15 Apr 2021 22:52:39 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F41BE4138F;
        Thu, 15 Apr 2021 22:52:38 +0300 (MSK)
Received: from localhost (172.17.204.113) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 15
 Apr 2021 22:52:38 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <kernel-team@lists.ubuntu.com>, <linux@yadro.com>,
        Arun Easi <aeasi@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH for-5.4 2/2] scsi: qla2xxx: Fix device connect issues in P2P configuration
Date:   Thu, 15 Apr 2021 22:51:44 +0300
Message-ID: <20210415195144.91903-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415195144.91903-1-a.kovaleva@yadro.com>
References: <20210415195144.91903-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.113]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 65e9200938052ce90f24421bb057e1be1d6147c7 ]

P2P needs to take the alternate plogi route.

Link: https://lore.kernel.org/r/20191105150657.8092-8-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[yadro: otherwise PRLI doesn't happen in N2N topology]
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 5 ++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d11416dcee4e..5b163ad85c34 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -917,4 +917,5 @@ int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
+void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bdc46e6c3de8..6d5953c529cd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1756,6 +1756,15 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	qla24xx_fcport_handle_login(vha, fcport);
 }
 
+void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
+				      struct event_arg *ea)
+{
+	ql_dbg(ql_dbg_disc, vha, 0x2118,
+	    "%s %d %8phC post PRLI\n",
+	    __func__, __LINE__, ea->fcport->port_name);
+	qla24xx_post_prli_work(vha, ea->fcport);
+}
+
 /*
  * RSCN(s) came in for this fcport, but the RSCN(s) was not able
  * to be consumed by the fcport
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index aed4ce66e6cf..53ccbd6b71ed 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2769,9 +2769,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 		case CS_COMPLETE:
 			memset(&ea, 0, sizeof(ea));
 			ea.fcport = fcport;
-			ea.data[0] = MBS_COMMAND_COMPLETE;
-			ea.sp = sp;
-			qla24xx_handle_plogi_done_event(vha, &ea);
+			ea.rc = res;
+			qla_handle_els_plogi_done(vha, &ea);
 			break;
 
 		case CS_IOCB_ERROR:
-- 
2.30.2

