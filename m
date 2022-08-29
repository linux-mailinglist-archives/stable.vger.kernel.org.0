Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF9F5A47D8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiH2LCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiH2LB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D028D1AF1D;
        Mon, 29 Aug 2022 04:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E4AB80EF3;
        Mon, 29 Aug 2022 11:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF196C433D6;
        Mon, 29 Aug 2022 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770907;
        bh=lVQ679sfJZ+2SBmV9MtbZrTtEVmPXXl4KH8gmTeQKaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJTbZWKjDxpPCQG6j/KpmgT+SnzQMuFVi4GWXiZ8P/Q3Y0EhFjDURILb4qRhurhD8
         vwcEk3QjE61M+4qeSS2Lfr6cuG1VcDeoWarpjf8a3hmDHl+oBf6WuookO2MgY0ra9n
         b4pLDtNmt0r2SFS0yVpDxsf2o6N31/c2LCzx8X0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/136] scsi: qla2xxx: Fix response queue handler reading stale packets
Date:   Mon, 29 Aug 2022 12:58:06 +0200
Message-Id: <20220829105805.396384761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit b1f707146923335849fb70237eec27d4d1ae7d62 ]

On some platforms, the current logic of relying on finding new packet
solely based on signature pattern can lead to driver reading stale
packets. Though this is a bug in those platforms, reduce such exposures by
limiting reading packets until the IN pointer.

Two module parameters are introduced:

  ql2xrspq_follow_inptr:

    When set, on newer adapters that has queue pointer shadowing, look for
    response packets only until response queue in pointer.

    When reset, response packets are read based on a signature pattern
    logic (old way).

  ql2xrspq_follow_inptr_legacy:

    Like ql2xrspq_follow_inptr, but for those adapters where there is no
    queue pointer shadowing.

Link: https://lore.kernel.org/r/20220713052045.10683-5-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 ++
 drivers/scsi/qla2xxx/qla_isr.c | 24 +++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 10 ++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2a6d613a76cf3..f82e4a348330a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,8 @@ extern int ql2xfulldump_on_mpifail;
 extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
+extern int ql2xrspq_follow_inptr;
+extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b218f97396195..ecbc0a5ffb3f5 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3767,6 +3767,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
+	u16 rsp_in = 0;
+	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3776,7 +3778,25 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
+	do {								\
+		if (_update) {						\
+			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+		}							\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
+				ql2xrspq_follow_inptr_legacy;
+
+	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
+
+	while ((likely(follow_inptr &&
+		       rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
+		       (!follow_inptr &&
+			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
 		rsp->ring_index++;
@@ -3889,6 +3909,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(follow_inptr, is_shadow_hba,
+						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6542a258cb751..00e97f0a07ebe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,6 +338,16 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
+int ql2xrspq_follow_inptr = 1;
+module_param(ql2xrspq_follow_inptr, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr,
+		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
+
+int ql2xrspq_follow_inptr_legacy = 1;
+module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
+		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
+
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
-- 
2.35.1



