Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85FA5934AC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiHOSOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiHOSN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE32A702;
        Mon, 15 Aug 2022 11:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC4B4B81063;
        Mon, 15 Aug 2022 18:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E40C433C1;
        Mon, 15 Aug 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587229;
        bh=kyGH0hOwV/DTuyXi7A1qoh1DROR54jDbLKUt9s3fvhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTBDhzLBeTpClnvWs16UgO6w4GkdWNqXmak/WNOGQsb4CnUMuCipJdvtUmP4Pdk8j
         CVOXNJ3T2J6gr0VbqHkADtJJ3YmvB5BcYcDtxw6DewLFws7T8mE4zEDtvbMdVYr0/X
         djlHjsWRmG4jinwxU6dunmj9sLn6bDRZs+lIOqIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 004/779] scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"
Date:   Mon, 15 Aug 2022 19:54:08 +0200
Message-Id: <20220815180337.349120433@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -5749,8 +5749,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5858,7 +5856,6 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5873,6 +5870,8 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		break;
 	}
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -35,11 +35,6 @@ int qla_nvme_register_remote(struct scsi
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
-	if (atomic_read(&fcport->state) == FCS_ONLINE)
-		return 0;
-
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));


