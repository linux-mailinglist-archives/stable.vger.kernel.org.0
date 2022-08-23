Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F074959E0B8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbiHWLHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357349AbiHWLGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:06:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95CE66A72;
        Tue, 23 Aug 2022 02:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31531B81C65;
        Tue, 23 Aug 2022 09:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D13AC433C1;
        Tue, 23 Aug 2022 09:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246160;
        bh=MK5jHsvSDZHB9qkETyV0HF0usiYTdxtTqoTyNDodXLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7zE7Hdj/Iv+y0gCGpPeo8sfgHL9FwLVhc9XNYyGXvh36D2u9Ro/8xASQJ3w5lVkp
         se4mFRB1kvatEZEXHax/WitkrNII9fXxvDsCpFWQEBDcI+5TgJB0iysR8HbMh/LS/2
         s9YKdXCn1oBDmjTzg29yJ9E/I2RYfn92MMIgzakY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 003/389] scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"
Date:   Tue, 23 Aug 2022 10:21:21 +0200
Message-Id: <20220823080115.762205526@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -5388,8 +5388,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5485,7 +5483,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5500,6 +5497,8 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		break;
 	}
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -36,11 +36,6 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
-	if (atomic_read(&fcport->state) == FCS_ONLINE)
-		return 0;
-
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


