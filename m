Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B785594FDD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiHPEd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiHPEdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7055D16C139;
        Mon, 15 Aug 2022 13:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E086960EE9;
        Mon, 15 Aug 2022 20:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2FFC433C1;
        Mon, 15 Aug 2022 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595099;
        bh=tFkkwFdno4ZcUY/URwDOd5A/e9+/y3VV30bBCrtFwAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfOFKRPdkfjnIWSY1Qudh1CMrkUzLQ+NbNZcMNEpKldrH5fY9TO18l7G4VSPJNxHd
         Lvu77P9kE/WCiKETJur4203p8K+JXiMf79g/FznDDYr5IYKgKQ2U3Mkfdh1whtslmU
         DT09fbDE0xQzOqJeMGCFPejNKfirnxfM+k8uCyYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0624/1157] scsi: qla2xxx: edif: Reduce N2N thrashing at app_start time
Date:   Mon, 15 Aug 2022 19:59:40 +0200
Message-Id: <20220815180504.624882999@linuxfoundation.org>
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

[ Upstream commit 37be3f9d6993a721bc019f03c97ea0fe66319997 ]

For N2N + remote WWPN is bigger than local adapter, remote adapter will
login to local adapter while authentication application is not running.
When authentication application starts, the current session in FW needs to
to be invalidated.

Make sure the old session is torn down before triggering a relogin.

Link: https://lore.kernel.org/r/20220608115849.16693-9-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 47 ++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 7239439120c0..ee8931392ce2 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -517,11 +517,28 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
 			fcport->n2n_link_reset_cnt = 0;
 
-		if (vha->hw->flags.n2n_fw_acc_sec)
-			set_bit(N2N_LINK_RESET, &vha->dpc_flags);
-		else
+		if (vha->hw->flags.n2n_fw_acc_sec) {
+			list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
+				qla_edif_sa_ctl_init(vha, fcport);
+
+			/*
+			 * While authentication app was not running, remote device
+			 * could still try to login with this local port.  Let's
+			 * clear the state and try again.
+			 */
+			qla2x00_wait_for_sess_deletion(vha);
+
+			/* bounce the link to get the other guy to relogin */
+			if (!vha->hw->flags.n2n_bigger) {
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
+		} else {
+			qla2x00_wait_for_hba_online(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+			qla2xxx_wake_dpc(vha);
+			qla2x00_wait_for_hba_online(vha);
+		}
 	} else {
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
@@ -920,17 +937,21 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
 				continue;
 
-			if (fcport->scan_state != QLA_FCPORT_FOUND)
-				continue;
+			if (!N2N_TOPO(vha->hw)) {
+				if (fcport->scan_state != QLA_FCPORT_FOUND)
+					continue;
 
-			if (fcport->port_type == FCT_UNKNOWN && !fcport->fc4_features)
-				rval = qla24xx_async_gffid(vha, fcport, true);
+				if (fcport->port_type == FCT_UNKNOWN &&
+				    !fcport->fc4_features)
+					rval = qla24xx_async_gffid(vha, fcport,
+								   true);
 
-			if (!rval &&
-			    !(fcport->fc4_features & FC4_FF_TARGET ||
-			      fcport->port_type &
-			      (FCT_TARGET | FCT_NVME_TARGET)))
-				continue;
+				if (!rval &&
+				    !(fcport->fc4_features & FC4_FF_TARGET ||
+				      fcport->port_type &
+				      (FCT_TARGET | FCT_NVME_TARGET)))
+					continue;
+			}
 
 			rval = 0;
 
-- 
2.35.1



