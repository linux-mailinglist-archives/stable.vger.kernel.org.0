Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356895011F0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbiDNOCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345484AbiDNNxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D922D69722;
        Thu, 14 Apr 2022 06:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7658861D29;
        Thu, 14 Apr 2022 13:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5E7C385A5;
        Thu, 14 Apr 2022 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943886;
        bh=w4WKydU6Nn9pxhdgp5zxAadvtDA/K6whSBp79ozYitg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2wqr9Ff0JrDTd5fWmmctYpw5Ubqvctgwqj/3OkaeAlBaWzhKFVcTFYqypLLU24Ht
         EkQ3RhFCY8NIH6+b1a87dsiFs9HTtChEwNQ6wSIhGpSpwvh2Ed5GYDfhOZKtPsbEDf
         tHCQV7DXVIKC21/ZWhnNQ8ncgY7iazwe6v6Nh8wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Carnuccio <joe.carnuccio@cavium.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 318/475] scsi: qla2xxx: Add devids and conditionals for 28xx
Date:   Thu, 14 Apr 2022 15:11:43 +0200
Message-Id: <20220414110903.988026866@linuxfoundation.org>
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

From: Joe Carnuccio <joe.carnuccio@cavium.com>

commit 0d6a536cb1fcabb6c3e9c94871c8d0b29bb5813b upstream.

This is an update to the original 28xx adapter enablement. Add a bunch of
conditionals that are applicable for 28xx.

Link: https://lore.kernel.org/r/20220110050218.3958-16-njavali@marvell.com
Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    7 ++-----
 drivers/scsi/qla2xxx/qla_init.c   |    8 +++-----
 drivers/scsi/qla2xxx/qla_mbx.c    |   14 +++++++++++---
 drivers/scsi/qla2xxx/qla_os.c     |    3 +--
 drivers/scsi/qla2xxx/qla_sup.c    |    4 ++--
 drivers/scsi/qla2xxx/qla_target.c |    3 +--
 6 files changed, 20 insertions(+), 19 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -527,7 +527,7 @@ qla2x00_sysfs_read_vpd(struct file *filp
 	if (!capable(CAP_SYS_ADMIN))
 		return -EINVAL;
 
-	if (IS_NOCACHE_VPD_TYPE(ha))
+	if (!IS_NOCACHE_VPD_TYPE(ha))
 		goto skip;
 
 	faddr = ha->flt_region_vpd << 2;
@@ -710,7 +710,7 @@ qla2x00_sysfs_write_reset(struct file *f
 		ql_log(ql_log_info, vha, 0x706f,
 		    "Issuing MPI reset.\n");
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha)) {
 			uint32_t idc_control;
 
 			qla83xx_idc_lock(vha, 0);
@@ -1020,9 +1020,6 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t
 			continue;
 		if (iter->type == 3 && !(IS_CNA_CAPABLE(ha)))
 			continue;
-		if (iter->type == 0x27 &&
-		    (!IS_QLA27XX(ha) || !IS_QLA28XX(ha)))
-			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3241,7 +3241,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA83XX(ha))
 			fixed_size = offsetof(struct qla83xx_fw_dump, ext_mem);
 		else if (IS_QLA81XX(ha))
 			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
@@ -3253,8 +3253,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable) {
-			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) &&
-			    !IS_QLA28XX(ha))
+			if (!IS_QLA83XX(ha))
 				mq_size = sizeof(struct qla2xxx_mq_chain);
 			/*
 			 * Allocate maximum buffer size for all queues - Q0.
@@ -3751,8 +3750,7 @@ enable_82xx_npiv:
 			    ha->fw_major_version, ha->fw_minor_version,
 			    ha->fw_subminor_version);
 
-			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-			    IS_QLA28XX(ha)) {
+			if (IS_QLA83XX(ha)) {
 				ha->flags.fac_supported = 0;
 				rval = QLA_SUCCESS;
 			}
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -10,6 +10,12 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+#ifdef CONFIG_PPC
+#define IS_PPCARCH      true
+#else
+#define IS_PPCARCH      false
+#endif
+
 static struct mb_cmd_name {
 	uint16_t cmd;
 	const char *str;
@@ -731,6 +737,9 @@ qla2x00_execute_fw(scsi_qla_host_t *vha,
 				vha->min_supported_speed =
 				    nv->min_supported_speed;
 			}
+
+			if (IS_PPCARCH)
+				mcp->mb[11] |= BIT_4;
 		}
 
 		if (ha->flags.exlogins_enabled)
@@ -2897,8 +2906,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 		ha->orig_fw_iocb_count = mcp->mb[10];
 		if (ha->flags.npiv_supported)
 			ha->max_npiv_vports = mcp->mb[11];
-		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha))
 			ha->fw_max_fcf_count = mcp->mb[12];
 	}
 
@@ -5391,7 +5399,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *v
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
-		mcp->in_mb |= MBX_3;
+		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3627,8 +3627,7 @@ qla2x00_unmap_iobases(struct qla_hw_data
 		if (ha->mqiobase)
 			iounmap(ha->mqiobase);
 
-		if ((IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
-		    ha->msixbase)
+		if (ha->msixbase)
 			iounmap(ha->msixbase);
 	}
 }
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -843,7 +843,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vh
 				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_IMG_PRI_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
@@ -1355,7 +1355,7 @@ next:
 		    flash_data_addr(ha, faddr), cpu_to_le32(*dwptr));
 		if (ret) {
 			ql_dbg(ql_dbg_user, vha, 0x7006,
-			    "Failed slopw write %x (%x)\n", faddr, *dwptr);
+			    "Failed slow write %x (%x)\n", faddr, *dwptr);
 			break;
 		}
 	}
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7084,8 +7084,7 @@ qlt_probe_one_stage1(struct scsi_qla_hos
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  ((ql2xenablemsix == 0) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {


