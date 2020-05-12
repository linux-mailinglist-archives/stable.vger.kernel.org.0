Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A949B1CEE60
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 09:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgELHll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 03:41:41 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:20452
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbgELHll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 03:41:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kO9mNwSBhd+AsL2eYOGjxhj1/9Rra/g+C0tOiwwFBavr5WQh7dHefD8Qxi7ZL212Bwos3/PtVnLHnvNgAhZACMbQraLeaJ5T4d0HDfUEIu8tafB3kQyc9kjHLbNOq9DW0Ut5s0BpzCX2mCZdycxv2rjJdKEjH+e4Lh8ptweCE1VUgPMCiO9/HCtDAXEdgNkfippibQOcPkOHNfO3mPVDjyHWQD6k9IxPcs2zvpfZ1SNZRw2U99HNPzVGRucbwyTZTl2V2b62E5teJagA6tpLkpivyoXD2ugz9jY/FRBo2Plbsv/qVlWur0+sHjzXc2IrZvlGQWG5/0Dpb5DSvoQ6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdh38duKL00rPRAJZq68HviiLbFScmTqXEKTooXC4MU=;
 b=BN/y4wnoMqLFwA1vxKj67RMfNmx+bS2gb9d2qLMBulFBszyJNto+TfRuzpQjp5OyLHhQBYBs467AcjRdE5ofF2FmdtqhF6PaDDlhHxWgWcaKs4l1zEXwo5kZ8IGk3e2M6CluPkAVyKBdavH/1BIiezc2KYNM9iTg+lBqQCVAxnOLbWN6OUbSo4HF0MVv2gK6hxiSdMx+W+F9QfRNo6zdb2jblb7a+/npsC4N45w0UPA+0nHUNrXabIH26KZOQOAUVK6BhHGLWWhET2vRF4ppi2mQ+rZ+/XWqxEqgvvl07ynuLIRaa25xIC8o3iBsx/xD1cl7qT5TFr9L53lk8TZTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdh38duKL00rPRAJZq68HviiLbFScmTqXEKTooXC4MU=;
 b=i/JGcexBAL7aXxPe1JdCUGCFyxPB2SjILRBJzgkuPS55hl30EdbTe7Eur4IeMAUaNFsjOq3ncdqjL0ktZL6Z6fXhnE7e3LsvWNZ1K3MH2t+fkjLQriymkhQpbjjiUdymS/EiFPzAWiuscNWhbj3E1NdR3siUs/xTSXvWVuDYwao=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Tue, 12 May
 2020 07:41:37 +0000
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::8c3e:70ad:d975:441c]) by VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::8c3e:70ad:d975:441c%3]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 07:41:37 +0000
From:   Liu Ying <victor.liu@nxp.com>
To:     dri-devel@lists.freedesktop.org
Cc:     p.zabel@pengutronix.de, s.hauer@pengutronix.de,
        kernel@pengutronix.de, linux-imx@nxp.com, stable@vger.kernel.org
Subject: [PATCH] drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()
Date:   Tue, 12 May 2020 15:31:58 +0800
Message-Id: <1589268718-29837-1-git-send-email-victor.liu@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:3:17::27) To VI1PR04MB3983.eurprd04.prod.outlook.com
 (2603:10a6:803:4c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SG2PR02CA0015.apcprd02.prod.outlook.com (2603:1096:3:17::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2979.29 via Frontend Transport; Tue, 12 May 2020 07:41:35 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26bcbc68-ac81-4daa-1104-08d7f647e714
X-MS-TrafficTypeDiagnostic: VI1PR04MB4221:|VI1PR04MB4221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4221ADF3ED8F1D773552E6DA98BE0@VI1PR04MB4221.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/PR8TqXr6qfzyNYTzMv6Nora4CDQeAzX5UNeT+3qQ5ZfI2cgnlDn460J2NQkhOnbh6lZrcJMbOoIMoqCQ/eOVKumNR+eQLurWI6f8jjwnseEv2z4CNsGEKhWa5rxQJzmHJkxuqDANJikicH7q5m7Kt67Dx1Xy6gnpaOu6S10rDzB4ycbDa8SpIsxLH8fibABKfDhINiBz5X7/PdRp3aRVG5mai1Dx3q+pMzsFR/4V3frwFBY61MmVl/drtqLZeSbhTB79evlliNXvrIwnlTLIz2R8+6l74ncezpNMiV0xMhb0SznblRSSO7oaYLG5s6QG4eBuCceI66e2dKCllKw5HrRd6S9IuPxHJpRT9ew8pk5zcfpSaHS3occc5fMFYWvUU9OtYxGLObCusTeCdCkablB9PZ15NxPY7ccpg0GkImt1FMw060srKPqthTxVf6TcRUQU7ExVqHTvzAf0qg7legdYcfVZcojaRJ5ZRXfiR5N3ofyE3/OciDMha4Td8uC1AIMmHW/sZvHAhbAm4JYUSWTYVORr8BZH1so5fUi9aKwS1Fl0RNj6XYOBEOxZnt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB3983.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(33430700001)(36756003)(186003)(6666004)(66946007)(6506007)(5660300002)(52116002)(33440700001)(6512007)(6486002)(26005)(66556008)(66476007)(956004)(478600001)(4326008)(2616005)(8936002)(6916009)(16526019)(2906002)(8676002)(316002)(69590400007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YigNNpGNi8HuU5R7W6XlLy7ShcWAmyG/LGMmWas6c0eA0UjzTED0oyVUDS/+kE18mW7ZvOIvwiHpBQYf/hIP9jbodPEkf8W9IaDswvYE7y/MOqetPNRgkSeujxgWWBOizzgYP179nX0jnrBvcwSadQz624hzLEV6ZFUsV+KD6QGTF9gM17erv6SG0nGGtDpnIWOf4d5GeMBpGth5BzJn4kD+WWgor8Xr0p91d7xD9Wd07mNdjfqbTQBVeQVcR8Q5nkQu1egze/9bc9/uv19NxB4gXxt7mgV2RNsG0NtaHfEFN3oOSg8zNvPyw3YUDLdwuj3yrU6u0RCXlLbP/borAROkOSabI/ohesjvuJHHwOd4EuDXYPRTUYkUUJzAXnk8xBcpmZErR/c7kBnbU4ooQXrko96qCIt5Xcym60knkb+TS4LOsu3w9TefN4RPOQodNRTqcouCVzCznK9ZRhh5a1Ify5mZpHMwlkRU29EgC9M=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26bcbc68-ac81-4daa-1104-08d7f647e714
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 07:41:37.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29d7QvYUxLVlZVg094J6z6onsXQxLh3iTNOcZNrYyjgwu0NbwOgCaDCJG96dmILuJGvaxirb7i8EvhCEFzik9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both of the two LVDS channels should be disabled for split mode
in the encoder's ->disable() callback, because they are enabled
in the encoder's ->enable() callback.

Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
---
 drivers/gpu/drm/imx/imx-ldb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 4da22a9..af4d0d8 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -303,18 +303,19 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux, ret;
 
 	drm_panel_disable(imx_ldb_ch->panel);
 
-	if (imx_ldb_ch == &ldb->channel[0])
+	if (imx_ldb_ch == &ldb->channel[0] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
-	else if (imx_ldb_ch == &ldb->channel[1])
+	if (imx_ldb_ch == &ldb->channel[1] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
 
-	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
+	if (dual) {
 		clk_disable_unprepare(ldb->clk[0]);
 		clk_disable_unprepare(ldb->clk[1]);
 	}
-- 
2.7.4

