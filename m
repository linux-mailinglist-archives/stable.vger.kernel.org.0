Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3978E501429
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbiDNOCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345582AbiDNNxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7BAAB65;
        Thu, 14 Apr 2022 06:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB0C61D29;
        Thu, 14 Apr 2022 13:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2767C385A9;
        Thu, 14 Apr 2022 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943895;
        bh=WRZldZ06m2ENn2Nq5B0GnVlgAaxvMUwIjmtL3uYhPbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkaFNyEWMBYvkGdCdinP3Qfl6dC06K6fzL75px1lxus209Gvh91orKhryyve/xT66
         rvwkRV+BQg0Qyhm0c0Ja4YU3oWlie3jAJvMTxxYL1qoPN8qd3BOr4l8l+xScNhrTuk
         1+aePBam6OyLyzKT0CHg010qSmgJ05SgNVsI1/PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 321/475] scsi: qla2xxx: Fix disk failure to rediscover
Date:   Thu, 14 Apr 2022 15:11:46 +0200
Message-Id: <20220414110904.071257013@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -5372,6 +5372,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5467,6 +5469,7 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5481,8 +5484,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		break;
 	}
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -36,6 +36,11 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		return 0;
+
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


