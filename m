Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5297E3214FD
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBVLYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:24:08 -0500
Received: from mail-eopbgr50114.outbound.protection.outlook.com ([40.107.5.114]:35673
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230044AbhBVLYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 06:24:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc9fk1ox9FMDu0LKJlsAeg1FtuVolxEOtirAKcXZ1PHuMGbR7+5nS5pGfIIZNpY/Jj1ov4aWLkw4CPDlrCYSqd97Ysis7W3xyC6JeINm+LcZ3dcQAwVvfrwlBzpkF1xx+JRZZ5s+Lnsf07lIW4m9Pwa6yZjd6lVUi+GyzaJm5ARVX/xElLElKBGlqQtI8hG/iLcn2H17NNkte24yd5yWMkf9tqqsbHPUpZYukXO2QktyayeJXLPz/Y+ITOG9wP8y65ZUYy2NWoPE3rzbyLJG9TBqgfNiGgv1bjGHfYuyfb9geRZ7ywB5Qi4byOTE6JAyGaOZWfTYCXQAFdjYqeRmyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVgwPMiOlytmqn8vFgNuXpp7+DyxnYgXlb3fnqdVM+o=;
 b=OMw0GPRfaUIPGsmEYNoSBBF0gzQD7E0w6sfRUCjirD8UBLFqYk0iS14KjIpecQvq8Zql2BCSEBQ3T3TctOvxbutMvMFUsON55IoFc33K/Sm/F9fIaTczM7JOl0zCj8mEiUhr7NKQ+wpIkgJHLQk+rx88zvrELG06xIqRHut+n7GhwK/zX0uYg+Lc77mHM6qysPEM0RY3QkjCH7vAJtHEQwTpCK/ATQd37QTX8OezGuOGZYVkhFYpL6i4DwWU17rK4Oc7ZLfIrXI/99QCXSyIm2HSIwEgm5CYvTtt4wh/cK8Xmspi4D7FmocKZ4Ao/Q0aNfGtWjyCuuajeM81j6g+nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVgwPMiOlytmqn8vFgNuXpp7+DyxnYgXlb3fnqdVM+o=;
 b=fWXl/zIPIcrZjjj0DmR7yXegEAqeIIhUyfGdXU6iDZy+YvreefNNWb8pahFhYtC1mXGjw9nMBRkWspv2olxQ4+hKmyv36iJYjc3iQjruwffXhWBVViJVQWCDUx0qBfYOsZ/yYjPVxegxUcDN2R8nbWt882y3mXYk055VNYAVRrI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3108.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:124::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Mon, 22 Feb
 2021 11:23:16 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a907:416:cdde:9538]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a907:416:cdde:9538%3]) with mapi id 15.20.3868.031; Mon, 22 Feb 2021
 11:23:16 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Robin Gong <yibin.gong@nxp.com>
Cc:     stable@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Axel Lin <axel.lin@ingics.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: pca9450: Reset PRESET_EN bit to fix BUCK1/2/3 voltage setting
Date:   Mon, 22 Feb 2021 12:19:27 +0100
Message-Id: <20210222111935.44038-1-frieder.schrempf@kontron.de>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [88.130.66.75]
X-ClientProxiedBy: ZR0P278CA0128.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::7) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fs-work.as-domain.local (88.130.66.75) by ZR0P278CA0128.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32 via Frontend Transport; Mon, 22 Feb 2021 11:23:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a2d84f1-cd64-4d47-4055-08d8d7243fef
X-MS-TrafficTypeDiagnostic: AM0PR10MB3108:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB31086BE545BC1BF35CE48C4EE9819@AM0PR10MB3108.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/lUID1n+F/umDNsa195gP9AARhbgxQOZE9r4scm9wBrB3LGnhNPE/CvtwdaPBV3bf/CS/VtS+3LrmZwqRR5omsrYlDft64s4FhU63v80ejtv2BsCKoZ/+n+bjfyHTVYZStxV4dGXYnzyiW3+FFCEADig34CRyEmWr2Z4dm9LbcAxFjJ5+DHvT65pY3Gxe/QPRPe3WGDYD2wryCfV+Nz5PsePTkgLjyC/FWrT6dzLHhzUrLdBlnKu8YpVU4CWjEpIN1e6IBFsxzLw6G/p1k8lLFYTlhNZuIVCecWw5kYp0Lco6C/sT56Xr8vr1AvpumWLCvu5U8+I9fDBWkuSFGPRrQdUyWmdOvBXAJFhPFuF4IJJFbOtdLQGP+FHFvSSoOMh2xyIsEh1OW6JXaw/u31VzNkj/ogNnausKlfRdq0NKrm89Ethts2g3VaXhwTAf4JxNZ+lY/rpO069hjIBheDpzVpYjPgAPxb5fnJZZsXfgNzkSnjlK7N3XCMpOZCpcp02hPMyWr6htIHhW62bTI7Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(8676002)(4326008)(83380400001)(26005)(6486002)(86362001)(2616005)(316002)(1076003)(36756003)(54906003)(110136005)(8936002)(6512007)(6666004)(16526019)(956004)(478600001)(66556008)(2906002)(5660300002)(52116002)(186003)(6506007)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?meL/6f7S4bTdd33T3niXUdejpwcIi+c7xWsAeRr0UfCOeqZanJ1XW9109yGF?=
 =?us-ascii?Q?x4ZgWFcLAXcBbsES+k5CjB559heRdh3eYdoCvzgQYj74qseO7X2mYjnB/X+g?=
 =?us-ascii?Q?sJ/lgejiSiSeZfvANT4q3u5b+bAcj0WCxE14ks7Ew6SWLKOS9DuQmAthmy3n?=
 =?us-ascii?Q?vH6ziUTobp6453DpWKGjNMQsUlJg+oAZRqZVYDnqtvxMPFk+9UCcPqYP9IB2?=
 =?us-ascii?Q?5Gt4XqQUFifsxK0WRVPJCiQPvghajM/lVHxSdUPqGC4fCcdh8IT0jFML/WEy?=
 =?us-ascii?Q?fThnzs2F0R522K0SelBMXam+JKqGX7NqJPRaNioRGO8KCzFyPeXc1KSdMGpM?=
 =?us-ascii?Q?hiMd+HInbE8Ude432hPBXrEH4jrn4vHrxbkxDiiw0hN4PzEu0nuwNQJgSljM?=
 =?us-ascii?Q?lY7lS0KoPNIrWecqrM4xtnoV34JOa2p+zQiFk9kP3uLhZ85rpxeZ/f9Gj6/t?=
 =?us-ascii?Q?UAPySwrGz8knl39X7mo/FBPnbMMntXlSsG4A/d4n7cOabi1eA5zy6AAeaT64?=
 =?us-ascii?Q?I1zOiSSaRcW6klHsClk23Ajf9jdIQx92BHX/+F5730HxGS4qsVMx7PtoGd2Q?=
 =?us-ascii?Q?tOPXHOHm75WbICL6VqPR56lsoGIlhCvx+kW/h/pRp9sTuVVD4DtlSiIvRZjK?=
 =?us-ascii?Q?oN4RCeTedaTV4mkIb/PO47R5VUAd7ysbUPQANlDURQxj1KLh4fd4urTug21B?=
 =?us-ascii?Q?aF8ruC8jiP4Aw9fX9vSABdQ7kPCVryCAGVepjqnYxvRO88JY2TedxOeT0oe2?=
 =?us-ascii?Q?Llv31DO7NfV7XU0DAChj2nrHbjnZLD8psOnx/jX7yKeqkJEtxaRTrz/lLI1M?=
 =?us-ascii?Q?p/0KZVyNr25YRWMGAKUvEH0aMWFD1aquEBKjAqUKxHBFD1ZuwBZGzPH4N+0s?=
 =?us-ascii?Q?V9t6Oi/hc55OkBhCsKhTKGVFCvJU3ZyeQutPqpO1+EBAnGucZNgGFCqYKXdf?=
 =?us-ascii?Q?VN8c2pN74RJOfg8A8neiKKEtM6q29QqNq6E9YLNqeiU8h5v63FcwzZD9BeB2?=
 =?us-ascii?Q?uQIOCmNAJEAigSO22yqkbFMxknXJhx2jvB3VbZn4DU1TlpHd3GluUfYo7fiw?=
 =?us-ascii?Q?2n60a9w09TF36S9JVRs9BOUnkmOrOUV1JCezxvJutL6+4yfCGwDt7gA7iPu4?=
 =?us-ascii?Q?pZkVzbNsXI+hvTBfrrQmXPtF/I6O8VSnvD+iOZcLWSx7NnhKwUVcIy7Lrj2r?=
 =?us-ascii?Q?zkfbGSOq5WGUTzpl62HaSUfORn6DQDjTXx6ck2aP3YeAUpNo+X4e8fvkUpa5?=
 =?us-ascii?Q?4AOED98kEv2CtImDyP6c7YCNXATwLqnKfsO4OYxjDkCR4BCaUi/BeXbGb8Mf?=
 =?us-ascii?Q?k7Dtzgp/sTjgglR8UOwgGR5n?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2d84f1-cd64-4d47-4055-08d8d7243fef
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 11:23:16.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jM4HPYf1sOUj4XFJ/QW9JiAsCENULBu6gyMOTULtMqTL/YMMWMB+wnXmUB5hAE6XIoWOf81mCHg6LuYgK9YasiOAD0yndQ1ONyDv+NXRAqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The driver uses the DVS registers PCA9450_REG_BUCKxOUT_DVS0 to set the
voltage for the buck regulators 1, 2 and 3. This has no effect as the
PRESET_EN bit is set by default. This causes the preset values to be
used instead, which are set to 850 mV by default.

To fix this we reset the PRESET_EN bit at time of initialization.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/regulator/pca9450-regulator.c | 8 ++++++++
 include/linux/regulator/pca9450.h     | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 833d398c6aa2..cf329341cb2f 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -797,6 +797,14 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* Reset PRESET_EN bit in BUCK123_DVS to use DVS registers */
+	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_BUCK123_DVS,
+				BUCK123_PRESET_EN, ~BUCK123_PRESET_EN);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to reset PRESET_EN bit\n");
+		return ret;
+	}
+
 	/* Set reset behavior on assertion of WDOG_B signal */
 	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
 				WDOG_B_CFG_MASK, WDOG_B_CFG_COLD_LDO12);
diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index ccdb5320a240..71902f41c919 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -147,6 +147,9 @@ enum {
 #define BUCK6_FPWM			0x04
 #define BUCK6_ENMODE_MASK		0x03
 
+/* PCA9450_REG_BUCK123_PRESET_EN bit */
+#define BUCK123_PRESET_EN		0x80
+
 /* PCA9450_BUCK1OUT_DVS0 bits */
 #define BUCK1OUT_DVS0_MASK		0x7F
 #define BUCK1OUT_DVS0_DEFAULT		0x14
-- 
2.25.1

