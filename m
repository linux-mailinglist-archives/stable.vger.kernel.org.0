Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF54F443D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347854AbiDEMVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiDEKjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FB7222A0;
        Tue,  5 Apr 2022 03:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0100CCE1B5F;
        Tue,  5 Apr 2022 10:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A6AC385A2;
        Tue,  5 Apr 2022 10:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154289;
        bh=1NZLc0/sH1SyykNuSfDvnX00seDYpNkLrjie/b+aJ8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG30JxjkvwTJWdxQcwY+utA2DwoLZOBsjciy6SPbXQnGp4Rk5QE6iO1NJUl8LwlEz
         eIRmtRGLuKzn5O1LUt/UXdvEr8gAPoXje0BDSd8ywms7sOIzogBV9k5fuPjqqmNktH
         oyjPxgdLgOvgyxB8Dv5JTrdSs0obO2AtiuOsDOUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 525/599] scsi: qla2xxx: Fix disk failure to rediscover
Date:   Tue,  5 Apr 2022 09:33:39 +0200
Message-Id: <20220405070314.463076687@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

commit 6a45c8e137d4e2c72eecf1ac7cf64f2fdfcead99 upstream.

User experienced some of the LUN failed to get rediscovered after long
cable pull test. The issue is triggered by a race condition between driver
setting session online state vs starting the LUN scan process at the same
time. Current code set the online state after notifying the session is
available. In this case, trigger to start the LUN scan process happened
before driver could set the session in online state.  LUN scan ends up with
failure due to the session online check was failing.

Set the online state before reporting of the availability of the session.

Link: https://lore.kernel.org/r/20220310092604.22950-3-njavali@marvell.com
Fixes: aecf043443d3 ("scsi: qla2xxx: Fix Remote port registration")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 drivers/scsi/qla2xxx/qla_nvme.c |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5531,6 +5531,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5631,6 +5633,7 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5645,8 +5648,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		break;
 	}
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -35,6 +35,11 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		return 0;
+
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


