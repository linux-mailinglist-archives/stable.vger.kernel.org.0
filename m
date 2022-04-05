Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927614F399A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244511AbiDELgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353373AbiDEKGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05B5BF531;
        Tue,  5 Apr 2022 02:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A3361500;
        Tue,  5 Apr 2022 09:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5176C385A2;
        Tue,  5 Apr 2022 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152490;
        bh=Wn3JxQQnYj5scrd2H9Ydr3wFpxUS1p1tfgW+6PBkh4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPzAKTbxDu4p6mPJAUe1ImdV1TGPXycKI9VRU86+waE6XXxWpUp7ocTysQzIl2Snf
         JSRnQl4swZiakSg3yJ95XgLLHpiLsfCmrS4D3Pw/qvnvbfxdUD1O4915OGWXieRwDg
         8rRxiwNmZwOC8vAAKcqcg3aQeIyKDMgRJDiYjrVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 796/913] scsi: qla2xxx: edif: Fix clang warning
Date:   Tue,  5 Apr 2022 09:30:58 +0200
Message-Id: <20220405070403.692757202@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 73825fd7a37c1a685e9e9e27c9dc91ef1f3e2971 upstream.

Silence compile warning due to unaligned memory access.

qla_edif.c:713:45: warning: taking address of packed member 'u' of class or
   structure 'auth_complete_cmd' may result in an unaligned pointer value
   [-Waddress-of-packed-member]
    fcport = qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);

Link: https://lore.kernel.org/r/20220110050218.3958-13-njavali@marvell.com
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_edif.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -668,6 +668,11 @@ qla_edif_app_authok(scsi_qla_host_t *vha
 	    bsg_job->request_payload.sg_cnt, &appplogiok,
 	    sizeof(struct auth_complete_cmd));
 
+	/* silent unaligned access warning */
+	portid.b.domain = appplogiok.u.d_id.b.domain;
+	portid.b.area   = appplogiok.u.d_id.b.area;
+	portid.b.al_pa  = appplogiok.u.d_id.b.al_pa;
+
 	switch (appplogiok.type) {
 	case PL_TYPE_WWPN:
 		fcport = qla2x00_find_fcport_by_wwpn(vha,
@@ -678,7 +683,7 @@ qla_edif_app_authok(scsi_qla_host_t *vha
 			    __func__, appplogiok.u.wwpn);
 		break;
 	case PL_TYPE_DID:
-		fcport = qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
+		fcport = qla2x00_find_fcport_by_pid(vha, &portid);
 		if (!fcport)
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s d_id lookup failed: %x\n", __func__,
@@ -777,6 +782,11 @@ qla_edif_app_authfail(scsi_qla_host_t *v
 	    bsg_job->request_payload.sg_cnt, &appplogifail,
 	    sizeof(struct auth_complete_cmd));
 
+	/* silent unaligned access warning */
+	portid.b.domain = appplogifail.u.d_id.b.domain;
+	portid.b.area   = appplogifail.u.d_id.b.area;
+	portid.b.al_pa  = appplogifail.u.d_id.b.al_pa;
+
 	/*
 	 * TODO: edif: app has failed this plogi. Inform driver to
 	 * take any action (if any).
@@ -788,7 +798,7 @@ qla_edif_app_authfail(scsi_qla_host_t *v
 		SET_DID_STATUS(bsg_reply->result, DID_OK);
 		break;
 	case PL_TYPE_DID:
-		fcport = qla2x00_find_fcport_by_pid(vha, &appplogifail.u.d_id);
+		fcport = qla2x00_find_fcport_by_pid(vha, &portid);
 		if (!fcport)
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s d_id lookup failed: %x\n", __func__,
@@ -1253,6 +1263,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_
 	int result = 0;
 	struct qla_sa_update_frame sa_frame;
 	struct srb_iocb *iocb_cmd;
+	port_id_t portid;
 
 	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d,
 	    "%s entered, vha: 0x%p\n", __func__, vha);
@@ -1276,7 +1287,12 @@ qla24xx_sadb_update(struct bsg_job *bsg_
 		goto done;
 	}
 
-	fcport = qla2x00_find_fcport_by_pid(vha, &sa_frame.port_id);
+	/* silent unaligned access warning */
+	portid.b.domain = sa_frame.port_id.b.domain;
+	portid.b.area   = sa_frame.port_id.b.area;
+	portid.b.al_pa  = sa_frame.port_id.b.al_pa;
+
+	fcport = qla2x00_find_fcport_by_pid(vha, &portid);
 	if (fcport) {
 		found = 1;
 		if (sa_frame.flags == QLA_SA_UPDATE_FLAGS_TX_KEY)


