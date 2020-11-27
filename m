Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD002C68B8
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgK0PaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 10:30:01 -0500
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:21383
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729113AbgK0PaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 10:30:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqTMDr31EM+czyIzYDxvbAUaJc3gwH/H+mv4mLlts7fUVXUQ5wHxn76o7ipdhe2tcnXuAm47rG8B0szHxSx2MHO/mRpDdoICpbJpOeQ5WX3Ukd2uZbzO40UdhbKUjFQBsMKj0/1KcB0mZ35/vT4exrUBo5b1qy6sNSBvZfwmEzxQthzQioxKfPyi/on/HPS2VOGd6wZqnc+YCaRBXjldm02U6QT92S6x/6ItpL0jpRz0IlHhfGblToQMh1sTSb46SyzXFHgK1EjRzhdoGQ+oj0f6Up2PEFDp0ecOiQd19m38yd+gZ4BpKj8G8AlWwXyCZteqJdLdtrfjYJu7dCMA8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyGT9oSTyzqXuGScKN1G+ssH23AhFvk1QMQMFBgjqE0=;
 b=MSzamTLTLo9ykKtxWfmyFkqOOIiZUKlC80gY6kTEe6ac1ZvA+9M8lC/nrSdLzKvooUNtjCvXlmI9Ir2YV81phAQuVmAq1DJMBH9yn7PWGL+nSGr8xFK/Pp2/QLkbNp4P9FWZSJnJjQY5VrOU/EHLhIgpjQ9T/rlUJ/KsIHouS9OC2SBoHqEsQBVqynprAniMNRt5vNTS7idrOp78NzwF1Ne3PhhitmjE7n6ty0gRooMQi00pW6PrSVYl5WMn4T0Tv/+xo0U6K4DP51quA0ZfdBr8lz78oYDdsCP5rDsBuH0ngi/7Du2hvqujQVogevpj46zKyh3io10rj3/U1zMKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyGT9oSTyzqXuGScKN1G+ssH23AhFvk1QMQMFBgjqE0=;
 b=aeyjn4gbJNUbZzo63c4NF+Q4qfoF+h+GP3kJYpNLvSmA8f4bsmDmZoyR7j/2t3cPDNRTjLDC/C8EYVlqhIMeLyD27aXnjN1hMsJBW5tfB2ceqfxuzuOIjRXhIh9Rx5T2RSCe9HNpdzRSbyfQ1s6/C3S0sZfuTJVJbR28+18pUzU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4227.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 27 Nov
 2020 15:29:57 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 15:29:57 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] spi: fsl: fix use of spisel_boot signal on MPC8309
Date:   Fri, 27 Nov 2020 16:29:47 +0100
Message-Id: <20201127152947.376-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [81.216.59.226]
X-ClientProxiedBy: HE1PR0401CA0080.eurprd04.prod.outlook.com
 (2603:10a6:3:19::48) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (81.216.59.226) by HE1PR0401CA0080.eurprd04.prod.outlook.com (2603:10a6:3:19::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Fri, 27 Nov 2020 15:29:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04330c99-a20e-4e76-2a1c-08d892e94ba6
X-MS-TrafficTypeDiagnostic: AM8PR10MB4227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB42275ECDB4B7CBB6E40B518393F80@AM8PR10MB4227.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGgq/TJb+IZ5umO1NQm+RrXLwPF8fYK1q4RsBSrE+rEY0s9ZalGzhDDdOuko/1VbKrsOSUZgWsrBmTnjjUkeUDnK4FoyztE8aPdbqzXvgaz1JkpXxPt1/l12znpIMv1FNe2hOURB9hMPxBNrMoPDK6mYb/FDMixpBqaoVpQe50mBBEY0ChLAVTpjv64I9X+5P3SjuQ/6aGcU2WFN37dpaUL1+bL/DyBvC/YLEHF7SUl8ZJKnL8A7d7zmr8Kssxac25vGrPJWWhXLSePx7GdICU9V2Ge0SN6B5swj0mvmHlL2e8atIbWlJugL9ZpA0vtTAOfAbv9S/2wPcPa+gzErOdYR2t7YBBGUe8rWmo9TXpVtbmrx/u4zxJZ7OVctaqRCss3LBKIlU/3+YUVcmoSsZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39850400004)(136003)(66476007)(8976002)(2906002)(186003)(478600001)(8936002)(8676002)(16526019)(4326008)(5660300002)(44832011)(6486002)(6666004)(6506007)(956004)(83380400001)(966005)(316002)(26005)(1076003)(86362001)(66946007)(6512007)(66556008)(54906003)(52116002)(36756003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BPEyrAhJEKih1Iowueag0GXLD0ad1rRiwUNHd/Eh/UBvThKuHJxeVyXB8Mas?=
 =?us-ascii?Q?SOgzMi9H9vT58IeM3IcMRG6/l/sxVUrn0zk+qMnlt+JZxxtIiBmhRQ02vazv?=
 =?us-ascii?Q?mGSX4pScWYORzzKEYqMbVEyEVnXssEuYa1xPrl6NycF3emTKJ7/HQ4DXCPtl?=
 =?us-ascii?Q?U5afRc6wF5q0nZgZpnl2liWqxqTCs2LND17cyv1dCKtSw/cdlz5kA9th5/Yx?=
 =?us-ascii?Q?psnQr37GbCTsrZk8mwBHELy4oCVjSF+g9jTsMwG88ZJOMlTClXEXp8JC8ROS?=
 =?us-ascii?Q?Djxh2V2SiixV1nnOimoz1qs8Cf++J9OWsA36cFxj2VKVtr2v/1NM4ItAr20h?=
 =?us-ascii?Q?XN7QqXY0l+glHngMm+r92uhsN5fXJou1SRnYjnwgcfiJiehNNoJlIcSCN8Ct?=
 =?us-ascii?Q?/iBvGpKL8JuwE7GcyU3NRNa7fTo4Tk27UEhUdTW6zRZND19enV3cXNObCGPV?=
 =?us-ascii?Q?wRf7TT2PcIXeHL9PClh4FJntLWSEJeXtmOE6o72ss6x0MnOU6kGApTduwKyA?=
 =?us-ascii?Q?42gFhhdcATRHNARz1JE5L34s7LHLnNL9Gn4XoLgrOktqeNwp9FbWy2OsS80A?=
 =?us-ascii?Q?jVzWZ2zCwNfDkFVyp/g3h27EqP1bljnjX4mwR4UqC46zstllWBxlFQigR1wf?=
 =?us-ascii?Q?xUQdX4g7FTkFCRA7d95McJIYO4jGe8Xkxi6kpe+kUFxrFJ9YKdDNtfmLGPQ6?=
 =?us-ascii?Q?155dgAlGHAlNv3JUBiK8v4fv6+6sG5y1FtTg24KAhn1AB2Yfn7+CKapQxXCY?=
 =?us-ascii?Q?SFAy3wFtjeWVBCda5mTAuj/01ceSV6aEDkRMWWHqrP6nyB+cGQfZtLJv7qj2?=
 =?us-ascii?Q?fbPcsaTdvz0/dFShbRsMS+83acznVjf+WB2hHpSig+1gzyTvfkQu/gyFlYpa?=
 =?us-ascii?Q?F72AFwGrETM2ugXHf2m9828WSeFeCUPLA5mGh36/ON8xxE7HuqiJQfr1q/oQ?=
 =?us-ascii?Q?j/0iqpuuta8WJjcsi2SdJc9X+c3RkaboF6pWPuddFD14+B2QiVKXrGQZvu43?=
 =?us-ascii?Q?y8/l?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 04330c99-a20e-4e76-2a1c-08d892e94ba6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 15:29:56.9490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZtCcEOqUOvKA55CFrbdiuF5An3Vubzpx+tDw+6lOS6PrTKkRtZf+Z41v2m+KBExa2VmENZDrSSiqCx4rUM9SupI287XQ+s/WELZOUR0jmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4227
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
broke the use of the SPISEL_BOOT signal as a chip select on the
MPC8309.

pdata->max_chipselect, which becomes master->num_chipselect, must be
initialized to take into account the possibility that there's one more
chip select in use than the number of GPIO chip selects.

Cc: stable@vger.kernel.org # v5.4+
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Linus Walleij <linus.walleij@linaro.org>
Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
Longer-term, it might be nicer to introduce a very trivial "gpiochip"
with nr_gpios=1, which doesn't really implement neither the
"general-purpose" nor the "input" part of the gpio acronym. That's how
this ended up being handled in U-Boot, for example:

https://github.com/u-boot/u-boot/commit/3fb22bc2f825ea1b3326edc5b32d711a759a265f

But for -stable, this is much simpler.

 drivers/spi/spi-fsl-spi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 299e9870cf58..9494257e1c33 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -716,10 +716,11 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	type = fsl_spi_get_type(&ofdev->dev);
 	if (type == TYPE_FSL) {
 		struct fsl_spi_platform_data *pdata = dev_get_platdata(dev);
+		bool spisel_boot = false;
 #if IS_ENABLED(CONFIG_FSL_SOC)
 		struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
-		bool spisel_boot = of_property_read_bool(np, "fsl,spisel_boot");
 
+		spisel_boot = of_property_read_bool(np, "fsl,spisel_boot");
 		if (spisel_boot) {
 			pinfo->immr_spi_cs = ioremap(get_immrbase() + IMMR_SPI_CS_OFFSET, 4);
 			if (!pinfo->immr_spi_cs)
@@ -734,10 +735,14 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 		 * supported on the GRLIB variant.
 		 */
 		ret = gpiod_count(dev, "cs");
-		if (ret <= 0)
+		if (ret < 0)
+			ret = 0;
+		if (ret == 0 && !spisel_boot) {
 			pdata->max_chipselect = 1;
-		else
+		} else {
+			pdata->max_chipselect = ret + spisel_boot;
 			pdata->cs_control = fsl_spi_cs_control;
+		}
 	}
 
 	ret = of_address_to_resource(np, 0, &mem);
-- 
2.23.0

