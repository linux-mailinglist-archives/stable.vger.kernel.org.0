Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83E266C893
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjAPQkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAPQkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6B1367ED
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6AA5B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8C9C433D2;
        Mon, 16 Jan 2023 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886509;
        bh=66wqCw2cqksrKT00fufHQltWomr3SnDks9QpMQStgQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAVRbf9a9EMYj5jQdmKeY7L9sfqFWs8v2RB5c9gZSzo9xI1wtD3HshevUd4qPVic/
         +AeujuDGV+xj5KBY3ypBGBA+17fC6Qowwxb1l2ARUEZjiJ27sCX1jrrpvGmHsoZdkG
         sBc9XamkWxHXGWROHSNyHcnAmMUTBb7MxmlWnIg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Revanth Rajashekar <revanth.rajashekar@intel.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 458/658] nvme: resync include/linux/nvme.h with nvmecli
Date:   Mon, 16 Jan 2023 16:49:06 +0100
Message-Id: <20230116154930.454219574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Revanth Rajashekar <revanth.rajashekar@intel.com>

[ Upstream commit 48c9e85b23464a7d1e3ebd70b79cc3a2d97d3222 ]

Update enumerations and structures in include/linux/nvme.h
to resync with the nvmecli.

All the updates are mentioned in the ratified NVMe 1.4 spec
https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4-2019.06.10-Ratified.pdf

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 685e6311637e ("nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 53 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index a260cd754f28..3eca4f7d8510 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -107,8 +107,22 @@ enum {
 	NVME_REG_AQA	= 0x0024,	/* Admin Queue Attributes */
 	NVME_REG_ASQ	= 0x0028,	/* Admin SQ Base Address */
 	NVME_REG_ACQ	= 0x0030,	/* Admin CQ Base Address */
-	NVME_REG_CMBLOC = 0x0038,	/* Controller Memory Buffer Location */
+	NVME_REG_CMBLOC	= 0x0038,	/* Controller Memory Buffer Location */
 	NVME_REG_CMBSZ	= 0x003c,	/* Controller Memory Buffer Size */
+	NVME_REG_BPINFO	= 0x0040,	/* Boot Partition Information */
+	NVME_REG_BPRSEL	= 0x0044,	/* Boot Partition Read Select */
+	NVME_REG_BPMBL	= 0x0048,	/* Boot Partition Memory Buffer
+					 * Location
+					 */
+	NVME_REG_PMRCAP	= 0x0e00,	/* Persistent Memory Capabilities */
+	NVME_REG_PMRCTL	= 0x0e04,	/* Persistent Memory Region Control */
+	NVME_REG_PMRSTS	= 0x0e08,	/* Persistent Memory Region Status */
+	NVME_REG_PMREBS	= 0x0e0c,	/* Persistent Memory Region Elasticity
+					 * Buffer Size
+					 */
+	NVME_REG_PMRSWTP = 0x0e10,	/* Persistent Memory Region Sustained
+					 * Write Throughput
+					 */
 	NVME_REG_DBS	= 0x1000,	/* SQ 0 Tail Doorbell */
 };
 
@@ -295,6 +309,14 @@ enum {
 	NVME_CTRL_OACS_DIRECTIVES		= 1 << 5,
 	NVME_CTRL_OACS_DBBUF_SUPP		= 1 << 8,
 	NVME_CTRL_LPA_CMD_EFFECTS_LOG		= 1 << 1,
+	NVME_CTRL_CTRATT_128_ID			= 1 << 0,
+	NVME_CTRL_CTRATT_NON_OP_PSP		= 1 << 1,
+	NVME_CTRL_CTRATT_NVM_SETS		= 1 << 2,
+	NVME_CTRL_CTRATT_READ_RECV_LVLS		= 1 << 3,
+	NVME_CTRL_CTRATT_ENDURANCE_GROUPS	= 1 << 4,
+	NVME_CTRL_CTRATT_PREDICTABLE_LAT	= 1 << 5,
+	NVME_CTRL_CTRATT_NAMESPACE_GRANULARITY	= 1 << 7,
+	NVME_CTRL_CTRATT_UUID_LIST		= 1 << 9,
 };
 
 struct nvme_lbaf {
@@ -352,6 +374,9 @@ enum {
 	NVME_ID_CNS_NS_PRESENT		= 0x11,
 	NVME_ID_CNS_CTRL_NS_LIST	= 0x12,
 	NVME_ID_CNS_CTRL_LIST		= 0x13,
+	NVME_ID_CNS_SCNDRY_CTRL_LIST	= 0x15,
+	NVME_ID_CNS_NS_GRANULARITY	= 0x16,
+	NVME_ID_CNS_UUID_LIST		= 0x17,
 };
 
 enum {
@@ -409,7 +434,8 @@ struct nvme_smart_log {
 	__u8			avail_spare;
 	__u8			spare_thresh;
 	__u8			percent_used;
-	__u8			rsvd6[26];
+	__u8			endu_grp_crit_warn_sumry;
+	__u8			rsvd7[25];
 	__u8			data_units_read[16];
 	__u8			data_units_written[16];
 	__u8			host_reads[16];
@@ -423,7 +449,11 @@ struct nvme_smart_log {
 	__le32			warning_temp_time;
 	__le32			critical_comp_time;
 	__le16			temp_sensor[8];
-	__u8			rsvd216[296];
+	__le32			thm_temp1_trans_count;
+	__le32			thm_temp2_trans_count;
+	__le32			thm_temp1_total_time;
+	__le32			thm_temp2_total_time;
+	__u8			rsvd232[280];
 };
 
 struct nvme_fw_slot_info_log {
@@ -440,6 +470,7 @@ enum {
 	NVME_CMD_EFFECTS_NIC		= 1 << 3,
 	NVME_CMD_EFFECTS_CCC		= 1 << 4,
 	NVME_CMD_EFFECTS_CSE_MASK	= 3 << 16,
+	NVME_CMD_EFFECTS_UUID_SEL	= 1 << 19,
 };
 
 struct nvme_effects_log {
@@ -563,6 +594,7 @@ enum nvme_opcode {
 	nvme_cmd_compare	= 0x05,
 	nvme_cmd_write_zeroes	= 0x08,
 	nvme_cmd_dsm		= 0x09,
+	nvme_cmd_verify		= 0x0c,
 	nvme_cmd_resv_register	= 0x0d,
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
@@ -806,10 +838,14 @@ enum nvme_admin_opcode {
 	nvme_admin_ns_mgmt		= 0x0d,
 	nvme_admin_activate_fw		= 0x10,
 	nvme_admin_download_fw		= 0x11,
+	nvme_admin_dev_self_test	= 0x14,
 	nvme_admin_ns_attach		= 0x15,
 	nvme_admin_keep_alive		= 0x18,
 	nvme_admin_directive_send	= 0x19,
 	nvme_admin_directive_recv	= 0x1a,
+	nvme_admin_virtual_mgmt		= 0x1c,
+	nvme_admin_nvme_mi_send		= 0x1d,
+	nvme_admin_nvme_mi_recv		= 0x1e,
 	nvme_admin_dbbuf		= 0x7C,
 	nvme_admin_format_nvm		= 0x80,
 	nvme_admin_security_send	= 0x81,
@@ -873,6 +909,7 @@ enum {
 	NVME_FEAT_PLM_CONFIG	= 0x13,
 	NVME_FEAT_PLM_WINDOW	= 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	= 0x16,
+	NVME_FEAT_SANITIZE	= 0x17,
 	NVME_FEAT_SW_PROGRESS	= 0x80,
 	NVME_FEAT_HOST_ID	= 0x81,
 	NVME_FEAT_RESV_MASK	= 0x82,
@@ -883,6 +920,10 @@ enum {
 	NVME_LOG_FW_SLOT	= 0x03,
 	NVME_LOG_CHANGED_NS	= 0x04,
 	NVME_LOG_CMD_EFFECTS	= 0x05,
+	NVME_LOG_DEVICE_SELF_TEST = 0x06,
+	NVME_LOG_TELEMETRY_HOST = 0x07,
+	NVME_LOG_TELEMETRY_CTRL = 0x08,
+	NVME_LOG_ENDURANCE_GROUP = 0x09,
 	NVME_LOG_ANA		= 0x0c,
 	NVME_LOG_DISC		= 0x70,
 	NVME_LOG_RESERVATION	= 0x80,
@@ -1290,7 +1331,11 @@ enum {
 	NVME_SC_SGL_INVALID_OFFSET	= 0x16,
 	NVME_SC_SGL_INVALID_SUBTYPE	= 0x17,
 
+	NVME_SC_SANITIZE_FAILED		= 0x1C,
+	NVME_SC_SANITIZE_IN_PROGRESS	= 0x1D,
+
 	NVME_SC_NS_WRITE_PROTECTED	= 0x20,
+	NVME_SC_CMD_INTERRUPTED		= 0x21,
 
 	NVME_SC_LBA_RANGE		= 0x80,
 	NVME_SC_CAP_EXCEEDED		= 0x81,
@@ -1328,6 +1373,8 @@ enum {
 	NVME_SC_NS_NOT_ATTACHED		= 0x11a,
 	NVME_SC_THIN_PROV_NOT_SUPP	= 0x11b,
 	NVME_SC_CTRL_LIST_INVALID	= 0x11c,
+	NVME_SC_BP_WRITE_PROHIBITED	= 0x11e,
+	NVME_SC_PMR_SAN_PROHIBITED	= 0x123,
 
 	/*
 	 * I/O Command Set Specific - NVM commands:
-- 
2.35.1



