Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC71A1535BA
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBEQ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:59:06 -0500
Received: from mail-vi1eur05on2091.outbound.protection.outlook.com ([40.107.21.91]:16321
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbgBEQ7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 11:59:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOnlne8lwC5kqeu0oCB7+gk0aUiBA9y9wPDhRM5B+vy+DJUtPe231DE6f6F0iJof31IiTO0y2DbuP7FqUiQcWNxZH8o4eX0NUsxqtNSco40oiwYQNU4d8lrGdqYyUGP9acee0FwNg8FDvu/7LQAAx4zsfP5l6c1i8YPyCBKMPJCZl5VEFgX2xUUMQv5SuWMKEUXNV9PTdFoZKV1czHuwCUpPMTB1f6JLYR92Sh8jdn4nZXHavcf3fu6AhSuiB2LAeQnTuMqiRDPWxKyMBB+YAdtITr8g++DZVXZV4fSp/AZbJW/46CVD2bf5DaZa++YjEcIyDnjR46OwAmKN2nSCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRo92GJTBdH+kSs0Kxt1tmRS2B/7JOGT37sW0OUjA+E=;
 b=hg1fcMD0+5LnVOANw7LQkDBAuOgZ0ZkFR6b8iPgphdHvKzoealwGSGpVZ/+eWVz74e7CuVfEFmCtXEfcL6/Kvyloit/5+19hM4p5Dr9hcQiIrMHpL6juaA9u87BcsSB+rjoHNa56o8wVf/h2E0d+WLUJaKnOsYKNmmjh039QLThqNfbH71Y+26eltqtX5uC4LjEX69FL5LLDVZfom4bSkTVxnSjEXQoZAKcJZ36tMdNoEIT0ZwtqQ/iAD1YkrAh98aEIkb0Qug9UgNLRCEzJd1vUqyO4Q2/67Go01NzFR7rj/VabEKZGlmXpGYzQEd71rA19eXaCu1IWikzFvI0dzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRo92GJTBdH+kSs0Kxt1tmRS2B/7JOGT37sW0OUjA+E=;
 b=drvgkAfPav4oJmRlWt5C6he9iH590NqPZl2kQZOqn84Egl/fz31EWSDcmJzi374EEhwGyIIi8FdgwVpsiRXyZOjadMLDH2hsi1KxMlPLZQbZY8Qo128KrjeAY8gevDykg8+1ZFLOQJ7ghxofMuyO+FnAYrAZnJVb8LZ98dHvx+0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB4527.eurprd07.prod.outlook.com (20.177.54.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.19; Wed, 5 Feb 2020 16:59:02 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2707.011; Wed, 5 Feb 2020
 16:59:02 +0000
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
Subject: [PATCH v2] mtd: spi-nor: Fixup page size for S25FS-S
Date:   Wed,  5 Feb 2020 17:57:36 +0100
Message-Id: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.25.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To VI1PR07MB5040.eurprd07.prod.outlook.com (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from localhost.localdomain (131.228.32.191) by HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Wed, 5 Feb 2020 16:59:01 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [131.228.32.191]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9669d798-7a9d-483e-d138-08d7aa5cb3d1
X-MS-TrafficTypeDiagnostic: VI1PR07MB4527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB4527B391FE81AAEB20B25AC188020@VI1PR07MB4527.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(316002)(16526019)(81156014)(186003)(956004)(69590400006)(8676002)(81166006)(8936002)(66946007)(6666004)(66476007)(66556008)(478600001)(6916009)(5660300002)(36756003)(52116002)(26005)(1076003)(6506007)(86362001)(4326008)(54906003)(2616005)(6512007)(2906002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4527;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCWDbpcdD78QR0kGrtcneHE4YBJzYZscn8ID1QP9teme20M9noWJyAfkRPGaMKA9v28OOXltqkewCka58WCNuK6uXj2d9Nq9BiH6Emqz1DmCPajvZzbUZYwOu1DU03wO5kdjOYgUSMCP6uX1B442/ZNI5Gft8UPHkpa/6VjdiAKEPdO3fy7bWMG8lFEd2bt4aiTMACRpJQPorGzLxAy7DmRfy2fbbrzf31aaqRgfcFAKzcwM7glw51Wvx9d8bjG3n+h0EMbzx/ysqxXBY5bUFEOaqEpUJrIysEX7k3UJ+kpvKdTs+hI2rYwfWAI3eYrDuA4UIlbu7VjLVbYen3HStWPDC+9lhngGaeLomnqvXgsPbB9+yHz/zbyQ/JZyjvhT6gO1iaUdPrc1x51xdOzfQfCG1uvFlg4isTp6KKh2iiIiCErGSwC19mS6IHupoX0xseABO/42ibJ1oAaxeNyTkggasj7yoTof+sYFBKwFDURprEgTewGPp6Pm0FM20VpD6lf/GR0y055G36OeTadFndQWAJO5e/TJNvcYGV6JdTo=
X-MS-Exchange-AntiSpam-MessageData: q4CoxdWNmUZEj3tZD9Vft9GMIZAYkc2RcH0gDgYJt42L4AhZy7ewwwyiDu+Vrqc7oHvw1QsNuPJL9B2nKLP/E+9aBvslkR8nulh05V/xBSrjwLGtuWVJaBqxS4bOGKwsVdk2f4U4Iwi95fKsnCgNZw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9669d798-7a9d-483e-d138-08d7aa5cb3d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 16:59:02.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BoTr6BocrigdMg+3BRF2kzer4jksfPqzrUgmQmvYOFpvMSVQG51BC6IMx/Ru3XyatED9wTlO/yGX5BMzD/LPoFjAWLX+g6JrswhsKJ/R0zw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4527
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

Cc: stable@vger.kernel.org
Fixes: f384b352c ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
Changelog:
v2: Thankfully rebased on the hint from John Garry

 drivers/mtd/spi-nor/spi-nor.c | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/mtd/spi-nor.h   |  5 +++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index 928a660..c0a5041 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2302,6 +2302,39 @@ static struct spi_nor_fixups gd25q256_fixups = {
 	.default_init = gd25q256_default_init,
 };
 
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
+	ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);
+	if (!ret && (buf & CR3V_02H_V))
+		params->page_size = 512;
+
+	nor->read_opcode = read_opcode;
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
@@ -2536,7 +2569,8 @@ static const struct flash_info spi_nor_ids[] = {
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
 	{ "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
-	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
+	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
+			.fixups = &s25fs_s_fixups, },
 	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
 	{ "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
 			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
@@ -2546,7 +2580,8 @@ static const struct flash_info spi_nor_ids[] = {
 	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
 	{ "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
 	{ "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
-	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
+	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
+			.fixups = &s25fs_s_fixups, },
 	{ "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
 	{ "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
 	{ "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 5abd91c..7ce3e79 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -116,6 +116,7 @@
 /* Used for Spansion flashes only. */
 #define SPINOR_OP_BRWR		0x17	/* Bank register write */
 #define SPINOR_OP_CLSR		0x30	/* Clear status register 1 */
+#define SPINOR_OP_RDAR		0x65	/* Read Any Register */
 
 /* Used for Micron flashes only. */
 #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
@@ -150,6 +151,10 @@
 #define SR2_QUAD_EN_BIT1	BIT(1)
 #define SR2_QUAD_EN_BIT7	BIT(7)
 
+/* Used for Spansion flashes RDAR command only. */
+#define SPINOR_REG_CR3V		0x800004
+#define CR3V_02H_V		BIT(4)	/* Page Buffer Wrap */
+
 /* Supported SPI protocols */
 #define SNOR_PROTO_INST_MASK	GENMASK(23, 16)
 #define SNOR_PROTO_INST_SHIFT	16
-- 
2.4.6

