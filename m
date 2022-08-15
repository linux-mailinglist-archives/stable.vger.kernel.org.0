Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD945940DB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347983AbiHOV3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348540AbiHOV1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01AEC4FD;
        Mon, 15 Aug 2022 12:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D41B810C6;
        Mon, 15 Aug 2022 19:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3405AC433D6;
        Mon, 15 Aug 2022 19:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591426;
        bh=h8Q516GPAhcvv277OwVBGuM0KfIRuOS34O8QA4RBpXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hK8MHP89RbMbWBGdfCFRNiwk3WYuYNArG6vO+nHWqR5s/uA7cuHCxUghIs/YgJJXB
         oZv/WygMUIC/AQovMtljLi0h+6C8emIock+FBSbZFPmzVMurW7cWHuiiZEd5ntwI37
         EQKW088/ml43OgKn6UE0TnIi8zY7RS5u8BlVMpsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0574/1095] scsi: qla2xxx: edif: Send LOGO for unexpected IKE message
Date:   Mon, 15 Aug 2022 19:59:33 +0200
Message-Id: <20220815180453.309795070@linuxfoundation.org>
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

[ Upstream commit 2b659ed67a12f39f56d8dcad9b5d5a74d67c01b3 ]

If the session is down and the local port continues to receive AUTH ELS
messages, the driver needs to send back LOGO so that the remote device
knows to tear down its session. Terminate and clean up the AUTH ELS
exchange followed by a passthrough LOGO.

Link: https://lore.kernel.org/r/20220608115849.16693-3-njavali@marvell.com
Fixes: 225479296c4f ("scsi: qla2xxx: edif: Reject AUTH ELS on session down")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 19 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_fw.h   |  2 +-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index c17e177864d3..0ead3d95f594 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2644,8 +2644,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
 
-	if (DBELL_INACTIVE(vha) ||
-	    (fcport && EDIF_SESSION_DOWN(fcport))) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
 		    __func__, host->e_dbell.db_flags,
 		    fcport ? fcport->d_id.b24 : 0);
@@ -2655,6 +2654,22 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 		return;
 	}
 
+	if (fcport && EDIF_SESSION_DOWN(fcport)) {
+		ql_dbg(ql_dbg_edif, host, 0x13b6,
+		    "%s terminate exchange. Send logo to 0x%x\n",
+		    __func__, a.did.b24);
+
+		a.tx_byte_count = a.tx_len = 0;
+		a.tx_addr = 0;
+		a.control_flags = EPD_RX_XCHG;  /* EPD_RX_XCHG = terminate cmd */
+		qla_els_reject_iocb(host, (*rsp)->qpair, &a);
+		qla_enode_free(host, ptr);
+		/* send logo to let remote port knows to tear down session */
+		fcport->send_els_logo = 1;
+		qlt_schedule_sess_for_deletion(fcport);
+		return;
+	}
+
 	/* add the local enode to the list */
 	qla_enode_add(host, ptr);
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 0bb1d562f0bf..361015b5763e 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -807,7 +807,7 @@ struct els_entry_24xx {
 #define EPD_ELS_COMMAND		(0 << 13)
 #define EPD_ELS_ACC		(1 << 13)
 #define EPD_ELS_RJT		(2 << 13)
-#define EPD_RX_XCHG		(3 << 13)
+#define EPD_RX_XCHG		(3 << 13)  /* terminate exchange */
 #define ECF_CLR_PASSTHRU_PEND	BIT_12
 #define ECF_INCL_FRAME_HDR	BIT_11
 #define ECF_SEC_LOGIN		BIT_3
-- 
2.35.1



