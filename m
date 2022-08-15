Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0B593FE5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiHOVmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349586AbiHOVl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011AF5C34E;
        Mon, 15 Aug 2022 12:29:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55E66B81122;
        Mon, 15 Aug 2022 19:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D570C433D6;
        Mon, 15 Aug 2022 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591756;
        bh=rgVZ0QPFNWmFUdSoYFtBcF4v79wbdPH3MlDMPbj3SaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kD/hXTBzwMChQ79E7S9Zhr/2wM6WDG14qW01oZ/GEl5z/b+AEFcIzyvnWGnj4DmW+
         6qN/yPk68jDisl4UKZdpl1XNYFR+Ud4HNEwoJRbljYwg2R1vMUmb80XpwjsnR2+5Kb
         GhMHyM3ZH2gWwH1tWQgwEIR62CVY9JnQtvzRMTWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 0004/1157] scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"
Date:   Mon, 15 Aug 2022 19:49:20 +0200
Message-Id: <20220815180439.646297254@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 5bc7b01c513a4a9b4cfe306e8d1720cfcfd3b8a3 upstream.

This fixes the regression of NVMe discovery failure during driver load
time.

This reverts commit 6a45c8e137d4e2c72eecf1ac7cf64f2fdfcead99.

Link: https://lore.kernel.org/r/20220713052045.10683-2-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 ++---
 drivers/scsi/qla2xxx/qla_nvme.c |    5 -----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5767,8 +5767,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5869,7 +5867,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5887,6 +5884,8 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 	if (NVME_TARGET(vha->hw, fcport))
 		qla_nvme_register_remote(vha, fcport);
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -37,11 +37,6 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
-	if (atomic_read(&fcport->state) == FCS_ONLINE)
-		return 0;
-
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


