Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69939364419
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242173AbhDSNZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239806AbhDSNXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99D36140F;
        Mon, 19 Apr 2021 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838336;
        bh=eVJTdSXp52+ov1WizSm1cTPnEm1uWgn2xymq+IvtMkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvpjwYKqNPQBYqIguEu05RJ1SFpJQ2zjBG0Gk9dz6dnZhMMXmssdOMG7oj9B/pjVA
         xQvBg+91D3VVbAAEw28M7PQSt7/S1wMwD5qpEP9J+/YVEIJtxZfrupDmVvr6jPuc4H
         N4FZzaZXxhfIE7PXkaSFvbhcd2MyE16ZeJqCR4LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/73] scsi: qla2xxx: Fix device connect issues in P2P configuration
Date:   Mon, 19 Apr 2021 15:05:55 +0200
Message-Id: <20210419130523.947276247@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index bc7460da394f..633317651138 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1738,6 +1738,15 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
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
index 2e272fc858ed..c0720c8e2f6d 100644
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
 			switch (fw_status[1]) {
-- 
2.30.2



