Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13649171785
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgB0MhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:37:17 -0500
Received: from mail-eopbgr00092.outbound.protection.outlook.com ([40.107.0.92]:29206
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728977AbgB0MhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 07:37:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0Y53pcPYxhZo0Q1K+S57tzhHFAwda1vLT+wKwNEEzZNm04r+rFoxI+mPgxGuFC64FzIlSFgzDqZGMAB0DRt4tZW93awZF/09Icg3QePacJ0zT4+gCCu6argChAV9faTgS6g32IubEh3Z2sh2w5gwC+OIsfVkwp+9bd7/9d4gvXoiOoFS5BP74w3mG8IVff6g9YmA0KMateUETyLkEyeBHo/KU32zoTD+k1N0CiAZaSEx7YG7Uf3BP09arlSEgFEsWuW6PwpPAr4bToKcvuNpaIb4Prtp00uRChdsMtG8aWLLmPfQ2aoitMrwYfRg/9sQdkZbIbiqQI/f7W5I4alGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDRIrCeAmVFkhD6MCaoT/0NwEVDsgEpw2jOqW04/Qpw=;
 b=G8+t/hcGspgZpcjMxNvlGuroXcYnsvx25g8NkYAx/9DKRulXMfX/DOYeKj0/WxcJxWj6o9WwKVRg3VOqY9qhy1cs1EfVsUqreHTwggiZ2sy4spIBr2VGiHBlM7hxYO+NEjQkKk2hPphd/3hp+WT2x0wNPvA0hs5e/AEPIbAMmVX4cX5vn/Jj4gMGiKeK0fM0Z3zxSURh25C48TuRt6z3/Ga2ixAu+roVZPBgTOI6EBTu4T4aVeuPptNamum9YBx0W5YsezDy3nXPgNr+hwC33N/4kRkcXqKDconYaDlpfLLeZMUBpG6F4h+LENSQOLkyBLALPo0zyOFHcWSjGGfz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDRIrCeAmVFkhD6MCaoT/0NwEVDsgEpw2jOqW04/Qpw=;
 b=P9X3o06HzvYkuKabFYl0loOIGw6tFUygjqjsOefack34JzRsYp7jXKNhM0A+kL7maDEzZG7DVAOtWc3kiPZfPdqQuvdhwQZW6NxporO47OftBpzJzg6zydSZW/ZEYouPRz1mcrDTfoKFp3b7I0mnDPpvOwT44MmpQVoIf3dVKns=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB5933.eurprd07.prod.outlook.com (20.178.81.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.10; Thu, 27 Feb 2020 12:37:11 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd%7]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 12:37:11 +0000
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     linux-mtd@lists.infradead.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        John Garry <john.garry@huawei.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>, stable@vger.kernel.org
Subject: [PATCH] mtd: spi-nor: Fixup page size and map selection for S25FS-S
Date:   Thu, 27 Feb 2020 13:36:57 +0100
Message-Id: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0102CA0025.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::38) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.2.1) by HE1PR0102CA0025.eurprd01.prod.exchangelabs.com (2603:10a6:7:14::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Thu, 27 Feb 2020 12:37:10 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [131.228.2.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 911d4af8-acc0-4c86-42a9-08d7bb81c419
X-MS-TrafficTypeDiagnostic: VI1PR07MB5933:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB5933EACC067C1026A0B51EA588EB0@VI1PR07MB5933.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(189003)(199004)(5660300002)(4326008)(1076003)(52116002)(6512007)(8676002)(36756003)(81166006)(8936002)(54906003)(6666004)(81156014)(6506007)(66556008)(186003)(2906002)(16526019)(26005)(966005)(6486002)(956004)(2616005)(478600001)(6916009)(86362001)(316002)(66476007)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5933;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qH5p4CdKxUoTAA+ruEHdSHLulq/r506LH/e8EDb8ZvN9e9oU25N6YpBzpieeSV6HAq/j54RQANVsPQHTZjwHkhn9KEcs/cVr5N73k0KzQLCO+neo4URvPrAHTrUOErPThvj7rWZBNErpQ0QNvwUa70F63CsWLOpfWsNiO/IyojJVxhqXqukSnKO02qN2LDCXbYuywISIHHgCD02Ly4RgfKifSNuipHXfsvpa9US9wQkf66jXyVzZGJrk0ts56zhlxSl96QrqIQ2Hz5rcVgT7oB98MZHT5JOQKNfyaOn+3GBi8geuIDyDA2yt6ocPi4O5dnfF3bHl+ggZUg6ilTeJcBHV2M+xrZIRX+wRFPc+fSAjV/ldzHNHevtJLQCM4qICh4DBIZFcuT01wFWYmTx99lRff1iaTMiBLaaQxU3wNx+ApEye3DObA1Vr6gFH/xLKGiLtutEogypTAhGHr1tW9220zVvImQLG4jrVdNZRAkqYGUSeeaaltp45CejSjvLrXbhq5DlzvwBHbHv2U52MtA==
X-MS-Exchange-AntiSpam-MessageData: +temKrDoq6VeFQ59FlOLPah3F+PhXG+X6+xg4kNMHquS7yo2aIhgKf0QkPafMsL1IE7LLGEea59N2eJpmhtWSXUUhnKu6YhwIkm4RHGgB/zyJaKVEMLLKnJtn0wWAr/CgRyqCVNXPvp7jrXM4m1P6g==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911d4af8-acc0-4c86-42a9-08d7bb81c419
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 12:37:11.4707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHLpuHOHuwh0aISyuQCGl/JYajPeUk1qKblD2AnUTKK9Fp/eJk4LSBw7IqarDOtv2IcvJoitzIZ4NX4AVpC5CcbHOL4AnWrIRx/68ImUFlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5933
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Spansion S25FS-S family has an issue in Basic Flash Parameter Table:
DWORD-11 bits 7-4 specify write page size 512 bytes. In reality this
is configurable in the non-volatile CR3NV register and even factory
default configuration is "wrap at 256 bytes". So blind relying on BFPT
breaks write operation on these Flashes.

All this story is vendor-specific, so add the corresponding fixup hook
which first restores the safe page size of 256 bytes from
struct flash_info but checks is more performant 512 bytes configuration
is active and adjusts the page_size accordingly.

To read CR3V RDAR command is required which in turn requires addr width
and read latency to be configured, which was not the case before. Setting
these parameters is also later required for sector map selection, because:

JESD216 allows "variable address length" and "variable latency" in
Configuration Detection Command Descriptors, in other words "as-is".
And they are still unset during Sector Map Parameter Table parsing,
which led to "map_id" determined erroneously as 0 for, e.g. S25FS128S.

New warning is added to catch the potential misconfiguration with other
chips.

Link: http://lists.infradead.org/pipermail/linux-mtd/2020-February/093950.html
Link: http://lists.infradead.org/pipermail/linux-mtd/2018-December/085956.html
Fixes: f384b352cbf0 ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
Yes, this is a combination of two previously sent patches as it turned out,
width/dummy quirk is necessary even earlier, during post_bfpt fixup.

 drivers/mtd/spi-nor/spi-nor.c | 132 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/mtd/spi-nor.h   |  11 ++++
 2 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index 1224247..1d0e2ef 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2326,6 +2326,122 @@ static struct spi_nor_fixups gd25q256_fixups = {
 	.default_init = gd25q256_default_init,
 };
 
+/*
+ * Return true if it was possible to read something known and non-zero with
+ * the probed parameters. struct spi_nor is updated in this case as well.
+ */
+static bool spi_nor_probe_width_and_dummy(struct spi_nor *nor, u8 width,
+					  u8 dummy)
+{
+	u8 read_opcode = nor->read_opcode;
+	u8 savedw = nor->addr_width;
+	u8 savedd = nor->read_dummy;
+	int ret;
+	u8 buf;
+
+	nor->addr_width = width;
+	nor->read_dummy = dummy;
+	nor->read_opcode = SPINOR_OP_RDAR;
+	ret = spi_nor_read_data(nor, SPINOR_REG_CR2V, 1, &buf);
+	nor->read_opcode = read_opcode;
+
+	if (ret == 1 && (CR2V_RL(buf) == dummy) &&
+	    (!!(buf & CR2V_AL) == (width == 4)))
+		return true;
+
+	nor->addr_width = savedw;
+	nor->read_dummy = savedd;
+
+	return false;
+}
+
+/*
+ * JESD216 allows to omit particular address length or latency specification in
+ * the header and at this point they are still unset, so we need some
+ * heuristics. One example is S25FS128S.
+ *
+ * It was observed that RDAR with incorrect parameters result in all-zeroes or
+ * all-ones reads. That's why probed dummy is limited to 14 and loops are built
+ * in a way to probe width 3 and 0 dummy bits last to avoid false-positive
+ * (refer to CR2 mapping). 8 dummy bits are probed on the first iteration.
+ */
+static void spi_nor_fixup_width_and_dummy(struct spi_nor *nor)
+{
+	u8 width_min = 3;
+	u8 width_max = 4;
+	u8 dummy_min = 0;
+	u8 dummy_max = 14;
+	u8 w, d;
+
+	if (nor->addr_width && nor->read_dummy)
+		return;
+
+	if (nor->addr_width) {
+		width_min = nor->addr_width;
+		width_max = nor->addr_width;
+	}
+	if (nor->read_dummy) {
+		dummy_min = nor->read_dummy;
+		dummy_max = nor->read_dummy;
+	}
+
+	for (w = width_min; w <= width_max; ++w)
+		for (d = 8; d <= dummy_max; ++d)
+			if (d >= dummy_min &&
+			    spi_nor_probe_width_and_dummy(nor, w, d))
+				return;
+	for (w = width_max; w >= width_min; --w)
+		for (d = 7; d >= dummy_min; --d)
+			if (d <= dummy_max &&
+			    spi_nor_probe_width_and_dummy(nor, w, d))
+				return;
+}
+
+/* Spansion S25FS-S SFDP workarounds */
+static int s25fs_s_post_bfpt_fixups(struct spi_nor *nor,
+	const struct sfdp_parameter_header *bfpt_header,
+	const struct sfdp_bfpt *bfpt,
+	struct spi_nor_flash_parameter *params)
+{
+	const struct flash_info *info = nor->info;
+	u8 read_opcode, buf;
+	int ret;
+
+	/*
+	 * RDAR command below requires nor->addr_width and nor->dummy correctly
+	 * set. spi_nor_get_map_in_use() later requires them as well.
+	 */
+	spi_nor_fixup_width_and_dummy(nor);
+
+	/* Default is safe */
+	params->page_size = info->page_size;
+
+	/*
+	 * But is the chip configured for more performant 512 bytes write page
+	 * size?
+	 */
+	read_opcode = nor->read_opcode;
+
+	nor->read_opcode = SPINOR_OP_RDAR;
+	ret = spi_nor_read_data(nor, SPINOR_REG_CR3V, 1, &buf);
+	nor->read_opcode = read_opcode;
+
+	switch (ret) {
+	case 0:
+		return -EIO;
+	case 1:
+		if (buf & CR3V_02H_V)
+			params->page_size = 512;
+		return 0;
+	}
+
+	return ret;
+}
+
+static const struct spi_nor_fixups s25fs_s_fixups = {
+	.post_bfpt = s25fs_s_post_bfpt_fixups,
+};
+
 /* NOTE: double check command sets and memory organization when you add
  * more nor chips.  This current list focusses on newer chips, which
  * have been converging on command sets which including JEDEC ID.
@@ -2560,7 +2676,8 @@ static const struct flash_info spi_nor_ids[] = {
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
 	{ "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
-	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
+	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
+			.fixups = &s25fs_s_fixups, },
 	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
 	{ "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
@@ -2570,7 +2687,8 @@ static const struct flash_info spi_nor_ids[] = {
 	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
 	{ "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
 	{ "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
-	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
+	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
+			.fixups = &s25fs_s_fixups, },
 	{ "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
 	{ "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
 	{ "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
@@ -3897,6 +4015,16 @@ static const u32 *spi_nor_get_map_in_use(struct spi_nor *nor, const u32 *smpt,
 		nor->read_opcode = SMPT_CMD_OPCODE(smpt[i]);
 		addr = smpt[i + 1];
 
+		switch (nor->read_opcode) {
+		case SPINOR_OP_RDAR:
+			if (nor->read_dummy && nor->addr_width)
+				break;
+			dev_warn(nor->dev, "OP 0x%02x width %u dummy %u\n",
+				 nor->read_opcode, nor->addr_width,
+				 nor->read_dummy);
+			break;
+		}
+
 		err = spi_nor_read_raw(nor, addr, 1, buf);
 		if (err) {
 			ret = ERR_PTR(err);
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index de90724..1e21592 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -116,6 +116,7 @@
 /* Used for Spansion flashes only. */
 #define SPINOR_OP_BRWR		0x17	/* Bank register write */
 #define SPINOR_OP_CLSR		0x30	/* Clear status register 1 */
+#define SPINOR_OP_RDAR		0x65	/* Read Any Register */
 
 /* Used for Micron flashes only. */
 #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
@@ -152,6 +153,16 @@
 #define SR2_QUAD_EN_BIT1	BIT(1)
 #define SR2_QUAD_EN_BIT7	BIT(7)
 
+/* Used for Spansion flashes RDAR command only. */
+#define SPINOR_REG_CR2V		0x800003
+#define CR2V_AL			BIT(7)	/* Address Length */
+/* Read Latency */
+#define CR2V_RL_MASK		GENMASK(3, 0)
+#define CR2V_RL(_nbits)		((_nbits) & CR2V_RL_MASK)
+
+#define SPINOR_REG_CR3V		0x800004
+#define CR3V_02H_V		BIT(4)	/* Page Buffer Wrap */
+
 /* Supported SPI protocols */
 #define SNOR_PROTO_INST_MASK	GENMASK(23, 16)
 #define SNOR_PROTO_INST_SHIFT	16
-- 
2.4.6

