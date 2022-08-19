Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3161359A31F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353591AbiHSQm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354048AbiHSQlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B422126977;
        Fri, 19 Aug 2022 09:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E876188D;
        Fri, 19 Aug 2022 16:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA338C433C1;
        Fri, 19 Aug 2022 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925341;
        bh=vSvH/Rz3id6GgpM5XIyBjnZ1ovoYcmcsZhjXwT0ljN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7hOtAowznujaTBiXVZyfssPceDKHgZm1tQ6PHov7W5/agXYLDtVuO22U8SIUGyJn
         jQREWSbYSjBzeZyA00F4yOqkZiwElqoW1hvT3cpJEfseEp1jU8aw5h/TcPSPOq375P
         fxuBWvlz+V+icxVgkRRhblDw8bOk4sTBIsLT9lsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/545] mtd: rawnand: Add NV-DDR timings
Date:   Fri, 19 Aug 2022 17:43:50 +0200
Message-Id: <20220819153849.969906479@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 1666b815ad1a5b6373e950da5002ac46521a9b28 ]

Create the relevant ONFI NV-DDR timings structure and fill it with
default values from the ONFI specification.

Add the relevant structure entries and helpers.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210505213750.257417-9-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_timings.c | 255 ++++++++++++++++++++++++++++
 include/linux/mtd/rawnand.h         | 112 ++++++++++++
 2 files changed, 367 insertions(+)

diff --git a/drivers/mtd/nand/raw/nand_timings.c b/drivers/mtd/nand/raw/nand_timings.c
index 94d832646487..481b56d5f60d 100644
--- a/drivers/mtd/nand/raw/nand_timings.c
+++ b/drivers/mtd/nand/raw/nand_timings.c
@@ -292,6 +292,261 @@ static const struct nand_interface_config onfi_sdr_timings[] = {
 	},
 };
 
+static const struct nand_interface_config onfi_nvddr_timings[] = {
+	/* Mode 0 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 0,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 10000,
+			.tCALH_min = 10000,
+			.tCALS_min = 10000,
+			.tCAS_min = 10000,
+			.tCEH_min = 20000,
+			.tCH_min = 10000,
+			.tCK_min = 50000,
+			.tCS_min = 35000,
+			.tDH_min = 5000,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 5000,
+			.tDS_min = 5000,
+			.tDSC_min = 50000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 6000,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+	/* Mode 1 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 1,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 5000,
+			.tCALH_min = 5000,
+			.tCALS_min = 5000,
+			.tCAS_min = 5000,
+			.tCEH_min = 20000,
+			.tCH_min = 5000,
+			.tCK_min = 30000,
+			.tCS_min = 25000,
+			.tDH_min = 2500,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 2500,
+			.tDS_min = 3000,
+			.tDSC_min = 30000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 3000,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+	/* Mode 2 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 2,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 4000,
+			.tCALH_min = 4000,
+			.tCALS_min = 4000,
+			.tCAS_min = 4000,
+			.tCEH_min = 20000,
+			.tCH_min = 4000,
+			.tCK_min = 20000,
+			.tCS_min = 15000,
+			.tDH_min = 1700,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 1700,
+			.tDS_min = 2000,
+			.tDSC_min = 20000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 2000,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+	/* Mode 3 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 3,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 3000,
+			.tCALH_min = 3000,
+			.tCALS_min = 3000,
+			.tCAS_min = 3000,
+			.tCEH_min = 20000,
+			.tCH_min = 3000,
+			.tCK_min = 15000,
+			.tCS_min = 15000,
+			.tDH_min = 1300,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 1300,
+			.tDS_min = 1500,
+			.tDSC_min = 15000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 1500,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+	/* Mode 4 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 4,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 2500,
+			.tCALH_min = 2500,
+			.tCALS_min = 2500,
+			.tCAS_min = 2500,
+			.tCEH_min = 20000,
+			.tCH_min = 2500,
+			.tCK_min = 12000,
+			.tCS_min = 15000,
+			.tDH_min = 1100,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 1000,
+			.tDS_min = 1100,
+			.tDSC_min = 12000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 1200,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+	/* Mode 5 */
+	{
+		.type = NAND_NVDDR_IFACE,
+		.timings.mode = 5,
+		.timings.nvddr = {
+			.tCCS_min = 500000,
+			.tR_max = 200000000,
+			.tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX,
+			.tAC_min = 3000,
+			.tAC_max = 25000,
+			.tADL_min = 400000,
+			.tCAD_min = 45000,
+			.tCAH_min = 2000,
+			.tCALH_min = 2000,
+			.tCALS_min = 2000,
+			.tCAS_min = 2000,
+			.tCEH_min = 20000,
+			.tCH_min = 2000,
+			.tCK_min = 10000,
+			.tCS_min = 15000,
+			.tDH_min = 900,
+			.tDQSCK_min = 3000,
+			.tDQSCK_max = 25000,
+			.tDQSD_min = 0,
+			.tDQSD_max = 18000,
+			.tDQSHZ_max = 20000,
+			.tDQSQ_max = 850,
+			.tDS_min = 900,
+			.tDSC_min = 10000,
+			.tFEAT_max = 1000000,
+			.tITC_max = 1000000,
+			.tQHS_max = 1000,
+			.tRHW_min = 100000,
+			.tRR_min = 20000,
+			.tRST_max = 500000000,
+			.tWB_max = 100000,
+			.tWHR_min = 80000,
+			.tWRCK_min = 20000,
+			.tWW_min = 100000,
+		},
+	},
+};
+
 /* All NAND chips share the same reset data interface: SDR mode 0 */
 const struct nand_interface_config *nand_get_reset_interface_config(void)
 {
diff --git a/include/linux/mtd/rawnand.h b/include/linux/mtd/rawnand.h
index 75535036b126..2044fbd55d73 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -474,12 +474,100 @@ struct nand_sdr_timings {
 	u32 tWW_min;
 };
 
+/**
+ * struct nand_nvddr_timings - NV-DDR NAND chip timings
+ *
+ * This struct defines the timing requirements of a NV-DDR NAND data interface.
+ * These information can be found in every NAND datasheets and the timings
+ * meaning are described in the ONFI specifications:
+ * https://media-www.micron.com/-/media/client/onfi/specs/onfi_4_1_gold.pdf
+ * (chapter 4.18.2 NV-DDR)
+ *
+ * All these timings are expressed in picoseconds.
+ *
+ * @tBERS_max: Block erase time
+ * @tCCS_min: Change column setup time
+ * @tPROG_max: Page program time
+ * @tR_max: Page read time
+ * @tAC_min: Access window of DQ[7:0] from CLK
+ * @tAC_max: Access window of DQ[7:0] from CLK
+ * @tADL_min: ALE to data loading time
+ * @tCAD_min: Command, Address, Data delay
+ * @tCAH_min: Command/Address DQ hold time
+ * @tCALH_min: W/R_n, CLE and ALE hold time
+ * @tCALS_min: W/R_n, CLE and ALE setup time
+ * @tCAS_min: Command/address DQ setup time
+ * @tCEH_min: CE# high hold time
+ * @tCH_min:  CE# hold time
+ * @tCK_min: Average clock cycle time
+ * @tCS_min: CE# setup time
+ * @tDH_min: Data hold time
+ * @tDQSCK_min: Start of the access window of DQS from CLK
+ * @tDQSCK_max: End of the access window of DQS from CLK
+ * @tDQSD_min: Min W/R_n low to DQS/DQ driven by device
+ * @tDQSD_max: Max W/R_n low to DQS/DQ driven by device
+ * @tDQSHZ_max: W/R_n high to DQS/DQ tri-state by device
+ * @tDQSQ_max: DQS-DQ skew, DQS to last DQ valid, per access
+ * @tDS_min: Data setup time
+ * @tDSC_min: DQS cycle time
+ * @tFEAT_max: Busy time for Set Features and Get Features
+ * @tITC_max: Interface and Timing Mode Change time
+ * @tQHS_max: Data hold skew factor
+ * @tRHW_min: Data output cycle to command, address, or data input cycle
+ * @tRR_min: Ready to RE# low (data only)
+ * @tRST_max: Device reset time, measured from the falling edge of R/B# to the
+ *	      rising edge of R/B#.
+ * @tWB_max: WE# high to SR[6] low
+ * @tWHR_min: WE# high to RE# low
+ * @tWRCK_min: W/R_n low to data output cycle
+ * @tWW_min: WP# transition to WE# low
+ */
+struct nand_nvddr_timings {
+	u64 tBERS_max;
+	u32 tCCS_min;
+	u64 tPROG_max;
+	u64 tR_max;
+	u32 tAC_min;
+	u32 tAC_max;
+	u32 tADL_min;
+	u32 tCAD_min;
+	u32 tCAH_min;
+	u32 tCALH_min;
+	u32 tCALS_min;
+	u32 tCAS_min;
+	u32 tCEH_min;
+	u32 tCH_min;
+	u32 tCK_min;
+	u32 tCS_min;
+	u32 tDH_min;
+	u32 tDQSCK_min;
+	u32 tDQSCK_max;
+	u32 tDQSD_min;
+	u32 tDQSD_max;
+	u32 tDQSHZ_max;
+	u32 tDQSQ_max;
+	u32 tDS_min;
+	u32 tDSC_min;
+	u32 tFEAT_max;
+	u32 tITC_max;
+	u32 tQHS_max;
+	u32 tRHW_min;
+	u32 tRR_min;
+	u32 tRST_max;
+	u32 tWB_max;
+	u32 tWHR_min;
+	u32 tWRCK_min;
+	u32 tWW_min;
+};
+
 /**
  * enum nand_interface_type - NAND interface type
  * @NAND_SDR_IFACE:	Single Data Rate interface
+ * @NAND_NVDDR_IFACE:	Double Data Rate interface
  */
 enum nand_interface_type {
 	NAND_SDR_IFACE,
+	NAND_NVDDR_IFACE,
 };
 
 /**
@@ -488,6 +576,7 @@ enum nand_interface_type {
  * @timings:	 The timing information
  * @timings.mode: Timing mode as defined in the specification
  * @timings.sdr: Use it when @type is %NAND_SDR_IFACE.
+ * @timings.nvddr: Use it when @type is %NAND_NVDDR_IFACE.
  */
 struct nand_interface_config {
 	enum nand_interface_type type;
@@ -495,6 +584,7 @@ struct nand_interface_config {
 		unsigned int mode;
 		union {
 			struct nand_sdr_timings sdr;
+			struct nand_nvddr_timings nvddr;
 		};
 	} timings;
 };
@@ -508,6 +598,15 @@ static bool nand_interface_is_sdr(const struct nand_interface_config *conf)
 	return conf->type == NAND_SDR_IFACE;
 }
 
+/**
+ * nand_interface_is_nvddr - get the interface type
+ * @conf:	The data interface
+ */
+static bool nand_interface_is_nvddr(const struct nand_interface_config *conf)
+{
+	return conf->type == NAND_NVDDR_IFACE;
+}
+
 /**
  * nand_get_sdr_timings - get SDR timing from data interface
  * @conf:	The data interface
@@ -521,6 +620,19 @@ nand_get_sdr_timings(const struct nand_interface_config *conf)
 	return &conf->timings.sdr;
 }
 
+/**
+ * nand_get_nvddr_timings - get NV-DDR timing from data interface
+ * @conf:	The data interface
+ */
+static inline const struct nand_nvddr_timings *
+nand_get_nvddr_timings(const struct nand_interface_config *conf)
+{
+	if (!nand_interface_is_nvddr(conf))
+		return ERR_PTR(-EINVAL);
+
+	return &conf->timings.nvddr;
+}
+
 /**
  * struct nand_op_cmd_instr - Definition of a command instruction
  * @opcode: the command to issue in one cycle
-- 
2.35.1



