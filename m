Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6323C59403E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiHOVgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiHOVeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:34:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1375CED;
        Mon, 15 Aug 2022 12:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EB4EB81126;
        Mon, 15 Aug 2022 19:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74175C433C1;
        Mon, 15 Aug 2022 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591486;
        bh=mRN+4lFH/UimAOYwqFZmkEk6HCUaxjjt8ALsrbdobtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz62bFEzOO50zdGRk7T686/nWQkR5iSODIfZaJ0aLluXq9LDgeGOBWvxLb/YlRX/H
         p2fD9qFfH1/p6FHaj39gbGLx9Bt3DBt5utXa2ETRw8uNE2Mhg78WbrfYDljc+UE0e/
         PZZoV9G2XsE0W2foqj6W7HadOkqyq5NZoNomaEIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0578/1095] scsi: qla2xxx: edif: Fix session thrash
Date:   Mon, 15 Aug 2022 19:59:37 +0200
Message-Id: <20220815180453.491081599@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit a8fdfb0b39c2b31722c70bdf2272b949d5af4b7b ]

Current code prematurely sends out PRLI before authentication application
has given the OK to do so. This causes PRLI failure and session teardown.

Prevents PRLI from going out before authentication app gives the OK.

Link: https://lore.kernel.org/r/20220608115849.16693-7-njavali@marvell.com
Fixes: 91f6f5fbe87b ("scsi: qla2xxx: edif: Reduce connection thrash")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c |  2 +-
 drivers/scsi/qla2xxx/qla_edif.h |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 10 +++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 9020cc3c61df..3f886b86d74a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3589,7 +3589,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	if (qla_bsg_check(vha, bsg_job, fcport))
 		return 0;
 
-	if (fcport->loop_id == FC_NO_LOOP_ID) {
+	if (EDIF_SESS_DELETE(fcport)) {
 		ql_dbg(ql_dbg_edif, vha, 0x910d,
 		    "%s ELS code %x, no loop id.\n", __func__,
 		    bsg_request->rqst_data.r_els.els_code);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 3561e22b8f0f..7cdb89ccdc6e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -141,4 +141,8 @@ struct enode {
 	(DBELL_ACTIVE(_fcport->vha) && \
 	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
 
+#define EDIF_SESS_DELETE(_s) \
+	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state == DSC_DELETE_PEND || \
+	 _s->disc_state == DSC_DELETED))
+
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 177ce45b76a6..7bd10b4ed9ed 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1762,8 +1762,16 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		break;
 
 	case DSC_LOGIN_PEND:
-		if (fcport->fw_login_state == DSC_LS_PLOGI_COMP)
+		if (vha->hw->flags.edif_enabled)
+			break;
+
+		if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+			ql_dbg(ql_dbg_disc, vha, 0x2118,
+			       "%s %d %8phC post %s PRLI\n",
+			       __func__, __LINE__, fcport->port_name,
+			       NVME_TARGET(vha->hw, fcport) ? "NVME" : "FC");
 			qla24xx_post_prli_work(vha, fcport);
+		}
 		break;
 
 	case DSC_UPD_FCPORT:
-- 
2.35.1



