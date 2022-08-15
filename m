Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC0594FE8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiHPEet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHPEeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:34:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B096716C117;
        Mon, 15 Aug 2022 13:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D6760EE9;
        Mon, 15 Aug 2022 20:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1E7C433B5;
        Mon, 15 Aug 2022 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595093;
        bh=mRieoNHNybmvhgqFLxKCQp2Qv0ReCsVc0va6SUcxowk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3zPx8/Dkj6p4A885NY8xUVcxmj0EkV16FS9St4P9hnFa4V1gJv48/E0JFxAepeHw
         EChQM0VTOFj/45B2KWWhlbJEVWhH8mmBpE2gRLhT93JmzWPnUhmOIm9pR0Nee0jGQb
         rd9W87CIMfOE5eQmMMnE6bNG/3Qc+neiM6V83KvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0622/1157] scsi: qla2xxx: edif: Fix session thrash
Date:   Mon, 15 Aug 2022 19:59:38 +0200
Message-Id: <20220815180504.537697603@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index c4bebbb17e92..7239439120c0 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3588,7 +3588,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
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



