Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5890E32157C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhBVLy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:54:56 -0500
Received: from mail-db8eur05on2139.outbound.protection.outlook.com ([40.107.20.139]:58305
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229943AbhBVLyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 06:54:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0y2yfHaXlt7xYsxlzgf7Lz0gGx8B7ZRFsZEMNGSUkE3OrfziJQSLbUpBccsuNlacIx1XUm11+8Wl18JMdFmuhIHF8bjoC6onbNxJriQ60ep8m6Gs/u79Wb+WMCmA8OmrnhO9tcKbQ62rU2zIUQhX3FGnJPjGz5BXq5uOVLFfxziKRD66kHgDwMbCvYUTMI66uAVtVH+BqzCco6Pl4oosEjPspszdSvEyilrrAPrxgYbcVO8c/1TPOb5FLdQdYKV75wvu9KkAspTjQ/GWou323M79IetvnXuvJeEKiu/xpFv1I443Bxi6UJZKQ8aJX7nnIeDqRDUaOOR5PaDjlUu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulNMc33F4e1KtOtkxk0nV+v6FzWK22C+UXr/AxvpuLc=;
 b=K+MaGcZY25dy8DHvBrrbu6+FcjXl/vKZzJADrfa2n6iezxgqhZnY82LnkKCcNjNg6EP+Jptn6IaJAo2w61pe0NoahnkwyCbyRn3tYYNC9CLe3gDi3OptmqbeN4AoNJTgm7icz1Xwj/9YA50LJHo/WB/1SofRXUM3HQ7v0Pd1/d+c9G7Vl+X9aeQk42y4BvkZ0MDsYICah7GMdZudYjMPqdg3RnYm+kOHPrSllwrhtgglg/bGjLXwBQWGFHlwzUDOiBZicU9IJID5H4isf7d9qZHfsqjT0TAugjpO/Tl+/UE8V2+lUO18rwksPSR0XbiosfhTshrBphIV1mJOa+JDAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulNMc33F4e1KtOtkxk0nV+v6FzWK22C+UXr/AxvpuLc=;
 b=d2qLD2ZfOCilyUEc5+ruXzEsO5SETmXbPQvw9RnXGSsiNx3sMzm72CmnIjMuCEMOSpS0aHcribW6CotfQdBN/36Zvwp6JMLaN+YvoY//A7kcSaWmIDj7lGY/E+LJBs92m8uyqT69wTUBiUiRgr27MmaPQTOADO4t07jD0Iy6bVg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3108.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:124::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Mon, 22 Feb
 2021 11:53:57 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a907:416:cdde:9538]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a907:416:cdde:9538%3]) with mapi id 15.20.3868.031; Mon, 22 Feb 2021
 11:53:57 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Robin Gong <yibin.gong@nxp.com>
Cc:     stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting
Date:   Mon, 22 Feb 2021 12:52:20 +0100
Message-Id: <20210222115229.166620-1-frieder.schrempf@kontron.de>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [88.130.66.75]
X-ClientProxiedBy: AM6P195CA0099.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::40) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fs-work.localdomain (88.130.66.75) by AM6P195CA0099.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:86::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 11:53:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bae726a2-9a20-4be0-92d1-08d8d7288945
X-MS-TrafficTypeDiagnostic: AM0PR10MB3108:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3108B7AF7E3963EEBF45B671E9819@AM0PR10MB3108.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0oLw7Pjv6GAf+/zHyAfbJ6LBtXVJwvngx8h3c53s8M7jzqL3nW1CD2FtTPQUCapGK9K2CXThIAeTpXEHQ3+VU0wbGHeJ0GYRFs/2aSb3jM/CSfjwhkX+LR6ezRT95QTvopSgK2lds4K5mzlnSPeBXD1SFXANG7FN3i3YigC4FrLh8xM8VI67IOHjXiRhoeaGxh3xB937Z46C+/jCSfKf9ZI5YW3V7Q8EEokiJzRjNuOxOMWV7lhhU2idH92bz9v+tWuF+ITB+oU0zzLpd4BoYC+TNVbHijTZqdkH2mEE2Bg97f0PgqaaJXt2amAlLN2jVLKcBjRj1OyjGpv/mObka3/g5wAzXKRmpaV9qlG/qjiGbaGmxZ/5PRo4tyZ8buVTNA4OfP02HeNQxmaDg8wYqahfNPki68rwrJm95NTsDj3eWqgieQg5kLJKF5lbQ9x4iHewHvXVdd9D0nAWSRxdsmUAq92nczByDibzaaPmV9N6NbkCRWLXn9cTn93a8HLT0x6aBlGqXosWrJdtpzvgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(8676002)(4326008)(83380400001)(6486002)(26005)(86362001)(2616005)(316002)(1076003)(54906003)(36756003)(110136005)(8936002)(6512007)(6666004)(16526019)(956004)(478600001)(66556008)(2906002)(5660300002)(52116002)(186003)(6506007)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aiAvwnMYCPK2zeeoYgAjxWWEWEE2YTm3ty+CUtRxgWWuz1zkw4kxIvZswbdz?=
 =?us-ascii?Q?JwXMlIXlPeac4BDfkAPMfXyqLh1TLy9A4r4cfBezRZD07wfcpffhYNRUoJ1C?=
 =?us-ascii?Q?UG4ThkuqfU5YbQEjBW0xm/fQtSjL0L0Q2oRiIvSc8wvXc2tsHgpbPWlDQDT8?=
 =?us-ascii?Q?RXRCDxwuOhfuqWSt7J+d87gAMxHBk3bFs8VWJAlIVUlBRMKLQPF5Y+PCme48?=
 =?us-ascii?Q?zVJ7+8lCO12rYSf2k7DPVxiz1dLj6wvTUI8lk09pZIF02DRAn5j2yrd6MALE?=
 =?us-ascii?Q?hpWwaXvffrEHiuFqY3bdI8xKx7aXaB1ZtCBeRZtk1dLwX1Q3d07CIwDa2Ws3?=
 =?us-ascii?Q?SB3ox2V8y8zOPJ9lstO2spc6SUnpRuvMWFplrLcoeLIW8spa0Qk3jc3DbwmQ?=
 =?us-ascii?Q?VlrD5Nm4F0bqVsQ0gPpHE4G1jMtZULSwfWvaXNGnX1Rd88+9+7cgr9vNbGnl?=
 =?us-ascii?Q?vv6dvlF0FzuWe4tbqgZKprZ/pM6DSq6g4AeR79//xHSS7L3IRMkWgS4NauDg?=
 =?us-ascii?Q?MXxH9aDJlqm5bw1i4oBvlT8r/RV+5YJGVALzbaxUskzhbeS5yd/PdR0a1lWv?=
 =?us-ascii?Q?y+LG0VlsB1wUBQQCOxRERlBgsW08phOfP00jf/cPNGgIijtw+iZLQmu46F4b?=
 =?us-ascii?Q?yYX3FIS56HeiACrEz+2xeCsX+IclSREewijFqAVnHk/7x4y6BC42A67iyJSc?=
 =?us-ascii?Q?EspjM2S2mUJVqtTNxOLxNw1NXJthwDuszyu7kKAYi3xf+yZm3NiKrZFlFN+I?=
 =?us-ascii?Q?Nl9rXyA19rx95x8SxKSULtIn6SRW/kSsgZnSP2G7Z3Lqj1/F2/cd1SzFmvYJ?=
 =?us-ascii?Q?HDAXiyJ84vzVHiow2Reuz+UZgLUvLjd/iIIPF+8qyxz/ftq2R261Cjjp08Le?=
 =?us-ascii?Q?/YhEcavInlYudeJygpBPZ1qpPHSOas0Vzf8ivUGouaLF9aBMBPXXcIq6gPlM?=
 =?us-ascii?Q?X3xvmVEuacreM/SITNtaX0VXwEfXh04vyH879dd889KKFee8o5IHCDM/Kn9H?=
 =?us-ascii?Q?YnPWhst6Uh6tV+0LJp/b3b5sa3YaxMliJJO6c2xkHWGvQF7kfqsYT8dqX8X8?=
 =?us-ascii?Q?0V8vSCqOsbPfmWDUoH8A3Rfxu5oIihWD/MIB4TYOBdQb6tpiz8wyOUfzCviy?=
 =?us-ascii?Q?60hpyjDrHddyYuAR1oDNpiqwARGT8q6CHLTEK+CCfoqj1w0s10rHd2OcHT8c?=
 =?us-ascii?Q?8HMM5ovFl4c/5rYAQnCn9Avj2Vf1h1qdWqdEB/m1/ayfVq8kEIBaXSH3mryS?=
 =?us-ascii?Q?FDzu3Cn4urpgzpKx88xYCC8IAtK+xeMpm5iqEmdeZkulJOyX3ts4HRhUQrIz?=
 =?us-ascii?Q?9cUU3NpRb5QaCzYTmFuV8sKm?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: bae726a2-9a20-4be0-92d1-08d8d7288945
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 11:53:57.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpMTCW7rqrxAD+9rJp4BW11Cdx+d1M2honTtzdNkL7qgYDKVeRKktlTzoGCjAsaJc5wp2w3G+rTplvmrZplSOOU1xTDIyjUPLYVnj0gaApc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The driver uses the DVS registers PCA9450_REG_BUCKxOUT_DVS0 to set the
voltage for the buck regulators 1, 2 and 3. This has no effect as the
PRESET_EN bit is set by default and therefore the preset values are used
instead, which are set to 850 mV.

To fix this we clear the PRESET_EN bit at time of initialization.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Improve comment and commit message
  * Use regmap_clear_bits() instead of regmap_update_bits()
  * Add error code to log message
---
 drivers/regulator/pca9450-regulator.c | 8 ++++++++
 include/linux/regulator/pca9450.h     | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 833d398c6aa2..d38109cc3a01 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -797,6 +797,14 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* Clear PRESET_EN bit in BUCK123_DVS to use DVS registers */
+	ret = regmap_clear_bits(pca9450->regmap, PCA9450_REG_BUCK123_DVS,
+				BUCK123_PRESET_EN);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to clear PRESET_EN bit: %d\n", ret);
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

