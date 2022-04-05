Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC254F2B38
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353839AbiDEKJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345721AbiDEJW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769D71A26;
        Tue,  5 Apr 2022 02:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9B8615F1;
        Tue,  5 Apr 2022 09:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6160C385A2;
        Tue,  5 Apr 2022 09:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149918;
        bh=otzYYpWm1DE4l/EFXF5rmcG0L81c9Jdh+PbhGx+ObK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBrapJftrBSkE4LyjbNQ0ZLrzoa4RZa1cleiN9bKlKS8oK1NWKFHOTEBdC/YbxQu4
         +l6X6m1blA0KhEG8BCkzpGlMA4WAWyfWgBTjx5+BbtiSHqpew/3Lk916TDpl7x6D+R
         4De1Tff5zmTgqlXh4FQb3Yx0C5SoTkzn2sBDYI7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0889/1017] scsi: qla2xxx: Fix disk failure to rediscover
Date:   Tue,  5 Apr 2022 09:30:02 +0200
Message-Id: <20220405070420.618127102@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -5758,6 +5758,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5865,6 +5867,7 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5879,8 +5882,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		break;
 	}
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -37,6 +37,11 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		return 0;
+
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


