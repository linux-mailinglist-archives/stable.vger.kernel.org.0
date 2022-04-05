Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFB84F346C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353818AbiDEKJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345702AbiDEJW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A8158387;
        Tue,  5 Apr 2022 02:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEAD61003;
        Tue,  5 Apr 2022 09:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F5C385A2;
        Tue,  5 Apr 2022 09:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149910;
        bh=mPSgUuojiA4asTXgWvTBrqoJBT0/M23y8ddpy8iMcdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txYiIKf8LD16A0CloUZdjAv4S5x69u2yuY1/G7vevsTbyaHD8MOyMqBFjMwRPnSsb
         O4JPJElCBP7GHsdmuOtVqal/kzByh/okRC+EqUnBxJwqIn5SdEcgRUpGs63/olaSt4
         IW/cuibTJQTedVGb7hCgfW730KrE8fNngiZvB7r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Carnuccio <joe.carnuccio@cavium.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0886/1017] scsi: qla2xxx: Add devids and conditionals for 28xx
Date:   Tue,  5 Apr 2022 09:29:59 +0200
Message-Id: <20220405070420.530705496@linuxfoundation.org>
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
@@ -555,7 +555,7 @@ qla2x00_sysfs_read_vpd(struct file *filp
 	if (!capable(CAP_SYS_ADMIN))
 		return -EINVAL;
 
-	if (IS_NOCACHE_VPD_TYPE(ha))
+	if (!IS_NOCACHE_VPD_TYPE(ha))
 		goto skip;
 
 	faddr = ha->flt_region_vpd << 2;
@@ -745,7 +745,7 @@ qla2x00_sysfs_write_reset(struct file *f
 		ql_log(ql_log_info, vha, 0x706f,
 		    "Issuing MPI reset.\n");
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha)) {
 			uint32_t idc_control;
 
 			qla83xx_idc_lock(vha, 0);
@@ -1056,9 +1056,6 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t
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
@@ -3492,7 +3492,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA83XX(ha))
 			fixed_size = offsetof(struct qla83xx_fw_dump, ext_mem);
 		else if (IS_QLA81XX(ha))
 			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
@@ -3504,8 +3504,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable) {
-			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) &&
-			    !IS_QLA28XX(ha))
+			if (!IS_QLA83XX(ha))
 				mq_size = sizeof(struct qla2xxx_mq_chain);
 			/*
 			 * Allocate maximum buffer size for all queues - Q0.
@@ -4066,8 +4065,7 @@ enable_82xx_npiv:
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
@@ -9,6 +9,12 @@
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
@@ -728,6 +734,9 @@ again:
 				vha->min_supported_speed =
 				    nv->min_supported_speed;
 			}
+
+			if (IS_PPCARCH)
+				mcp->mb[11] |= BIT_4;
 		}
 
 		if (ha->flags.exlogins_enabled)
@@ -3029,8 +3038,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 		ha->orig_fw_iocb_count = mcp->mb[10];
 		if (ha->flags.npiv_supported)
 			ha->max_npiv_vports = mcp->mb[11];
-		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha))
 			ha->fw_max_fcf_count = mcp->mb[12];
 	}
 
@@ -5621,7 +5629,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *v
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
@@ -3754,8 +3754,7 @@ qla2x00_unmap_iobases(struct qla_hw_data
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
@@ -844,7 +844,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vh
 				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_IMG_PRI_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
@@ -1356,7 +1356,7 @@ next:
 		    flash_data_addr(ha, faddr), le32_to_cpu(*dwptr));
 		if (ret) {
 			ql_dbg(ql_dbg_user, vha, 0x7006,
-			    "Failed slopw write %x (%x)\n", faddr, *dwptr);
+			    "Failed slow write %x (%x)\n", faddr, *dwptr);
 			break;
 		}
 	}
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7220,8 +7220,7 @@ qlt_probe_one_stage1(struct scsi_qla_hos
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  ((ql2xenablemsix == 0) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {


