Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6228A41922E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 12:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhI0KYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 06:24:41 -0400
Received: from mail-vi1eur05on2051.outbound.protection.outlook.com ([40.107.21.51]:28385
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233759AbhI0KYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 06:24:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKrtseqZdL9WSNTfFzoVdhMXam0rMvCdCIXXnMBOUD5bOYoiTE9fg/Vb+aiIwWv/tZ3tT7NWm2HcH2NV2QP5GH5n7iHtB1/jv2h/IAuA7DZ5mOCtcE5nlRhpEgmPDQGyD9MlHAM/p2m99WHrUjB9yK+jMWT63lLOF50MOkXmLgycfTYDrZyoedRiveNAkpncDJAOmjF3m/7oJL/H7PuR39WRsuVEdPIyTGLIswmTOfSASYvtiPs+0j/TNVcOfo6a7DVkWDZp9VFPDoeOp/ZsbBNS7epwh1ole6WXiHBFt2U05omNQdMSkaRxhCkWCAOk9KfYUWO0ukCQ1SfVwX4OeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=miadFHt/yfh/9JsKrVbzYNpxu0lRuMnMuYbDIeSrd0M=;
 b=kXPD+0bW8j30qZS1pmYwTRPQpnqn/NAlWeBkFot21cOF6eWM5QqxS7uUuay/CMhW49yKGaYCfWhVNcH8FGTW4XHOZEusssBQfg4VaNkwKNRZPcoa2z6bxEOO7b2etEZE0JW4hCSj+h2I4eTK1nLXPzaqJuPhpZmPWXRFsgouyYLp/pwy2J+xsd5jug82Fv/8BU/3Ge0hTMMn+CWyqkj5XWkdTbhMK0RoOPu00cDc4cwaZrQtL9ijuuPWAbpwWx3bOqe5MuEpWiKhOtoT2dORYdx+n/tNMdfs/e4YkpFI/Ro6xkMl3WXhlL4fusTDtDNu3W8j9fjUIqo4oxwBbQHQHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miadFHt/yfh/9JsKrVbzYNpxu0lRuMnMuYbDIeSrd0M=;
 b=HDjsybV0BbXjyZbDhKZxGA5w2tqCq/7kWKDImdfQ8qexaJxDuiUw4iqWMGHrnoLeQpUSQQzqCacf46LTA62iuJjm7pxWMwn7JtqQNT9e1ZlMQSLRmi5zvCxUpPMXne7YtN467bLBLLMCczeaQa/dEJRp4+XM/jx2n/zsjPdWHCU=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR0401MB2528.eurprd04.prod.outlook.com (2603:10a6:800:56::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 10:23:01 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923%7]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 10:23:01 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     gregkh@linuxfoundation.org
Cc:     heikki.krogerus@linux.intel.com, jon@solid-run.com,
        rafael.j.wysocki@intel.com,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH] software node: balance refcount for managed sw nodes
Date:   Mon, 27 Sep 2021 13:22:49 +0300
Message-Id: <20210927102249.12939-1-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
Received: from fsr-ub1864-101.ea.freescale.net (92.120.5.2) by AM0PR02CA0029.eurprd02.prod.outlook.com (2603:10a6:208:3e::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 10:23:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ec0ce3f-3d8d-4183-2119-08d981a0c8ae
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2528BD17004DF56D5F8B9FB3ECA79@VI1PR0401MB2528.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:352;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKJfR4A6SRLF6QfKYLO+06JT7PO0ULq3ONapSMLqebbMEQsiyOUNQqyJxNUzG2PTPqA2fkLg7s7JwoqDMZqZTbbeLmeeY+Xkm4D2ZB7FdRvBtEN1ewAeVVRmkpwiIpzKEdSeroZ/MZWH5U3MhtvMfUtu/rYi3WEjJCaSN3jNj7/PuwaDhaes1ppG4DMGAYTSOxKy3gwuPhReKyMpVcDXv+rJS/a+BwAnktui920V3eVlfDOhK+ngglOeovD2Y9obqBWBoMzU7FBW3UxyLyex2EVpPbAhwB/LnpxWV913LyCYfuvZLyJ4Fu15GNtwXaafcwzHVYbnPNmwoYwpniImbX0NcnIKE0oXxl63gOh1nxnqI54mRMPUcLLPvHFV+1waiZ66GvCg8O3unh4WfPOKg5y/hBK4qFwIKIvbCk+ZUvKyJL2klY43/+w0Lm8nOCooF7z7KFEeJwGFmuu14+VpR3emGXQg2CBu1+N5fTtHxY1zhef8Vn9Bk+yeKSrIt9ghE2QtNStaQpHU2m1oSQhBPLrWWtSwikLbNpjZc6ASdvFhjfVGGM/OVof4/aw6MasLez8sg+BKg0BqZDqJSi6A1267CvWpODiIlL6Ido4105IopYVtn0ckFCcHfs1i5t3L8hlM4lEuNXe+Ol5Tx7D9BdVb4cLtzd7RRHz9NZol5D8kkrNOzkupc379rzLJbPYlEkGU7Cai3ozmfZsgB2uPJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6486002)(66476007)(66556008)(52116002)(38100700002)(38350700002)(1076003)(6512007)(4326008)(44832011)(5660300002)(6506007)(2616005)(316002)(186003)(6916009)(8676002)(36756003)(6666004)(508600001)(8936002)(26005)(956004)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?74cS79rbrLqY/PnciDA2hdu73+R2V6QoGhyKYeOKxaUTt9KApaodam5D5TxG?=
 =?us-ascii?Q?+SCnPxPlQIHdJZ1LOJ0/MXKlNVUgFs0DNPGfemcU6YAVGzlUkswfsSi140Pj?=
 =?us-ascii?Q?LFsoiOm4Sskh0dj8pa9gWbTxDHZKgkj1NNzY1ICYvmjfG+Zi8Or3jUModi+a?=
 =?us-ascii?Q?XCwwBdXEYGRkgznlgkziAKAWNQR588PWTCobAfsdLz+dxbaruS3wpaijWj5q?=
 =?us-ascii?Q?X874Si9+TUZzN9eHdDG3IubNly9OInBJpqVtTpBi3cXuB56+yCTG5g4ap1Ko?=
 =?us-ascii?Q?c+0aYHVLIegMvnFKhxqhKNAQHNQsks9Z3hMpMc3t32cp606UOHTdu9Pke1WD?=
 =?us-ascii?Q?VQyLS23ABTjVNAJy0s1yyEHrI5KpH4FbxSFblZD9qi85n17DkkBcWBvs4WvS?=
 =?us-ascii?Q?k/f4ZFC43ACPm4Id1bCYkaQFGvygSfh1Fg3EHjNEn6JM5aBmsea03z7a/DaE?=
 =?us-ascii?Q?1OihL4aO2DTtB7M/RXvW6tzPZi+u9tBV97uUL01Ds4i1idYYHF4+oX/s47Kq?=
 =?us-ascii?Q?ieETzAalicpO4faYLwmE425bifLR8DIDfpHLPLX66M2o6EmaFChjmq6fNjqX?=
 =?us-ascii?Q?OPFiGS8gf34yq7bIrZlzRImjuQ90fTdiXbtrE7trGFhwZVEh91eVr5u24mvK?=
 =?us-ascii?Q?p8peFN7HnLo1BzOYLxLkxsVyYH3cVMWR12sOlALaFF/MRTRusQCVaZcESFQW?=
 =?us-ascii?Q?BxLbL2w+LV5x5x+3fwffLsa9PXdykyJ+kLgDmJ+zwWX1dTD5m422sWIASngk?=
 =?us-ascii?Q?kHTNKUAjxGLlHSaJDAADGv5sifZqWaFc2FJJasIrjN8Q6YEz/GXDXLnTmUYB?=
 =?us-ascii?Q?6d3AkShe4z/GrkwMsNVmG+ljEhxFY2pBszKAOuY9mBroKO/2ACMJVvAV2Ra1?=
 =?us-ascii?Q?bnqzNt9opT9a0Hq0T2KXqKYR+2+RLWsmna+X5O2Ismhnr7YfSxHaBoGQ4fiB?=
 =?us-ascii?Q?wqXozAsMmd5uN2PXxh/9T8kO8ghp5YvE4xIVrfJJeQtD3KkzT+alRLvovg1p?=
 =?us-ascii?Q?V3Hsbn60Mijm3UTEnRAwdtvzkFr485bCaAdHLy12htaYOq2MqA7CdJpE+Veb?=
 =?us-ascii?Q?2pf9Zol1kU1aVO0fu0c4wbeX8J/exFwSx54vzGcMtjd67T2ahovQRSXtzgzk?=
 =?us-ascii?Q?dUMZUd//EI723Y7p59mitNfps/pLIN+ufWPBStjQI/Ly3xzPkSgUr+jZehiF?=
 =?us-ascii?Q?e6a1EZEnAWIa0mlciu2Hrgg4j3efQ8uzG/YFYu0c9iNivsabPwC67DnmXfdD?=
 =?us-ascii?Q?4D556dPqd+ildNw+cr83wwEVj3EOITmk9xsyTaAkj+tzuEoFbf0d0TVQmOgi?=
 =?us-ascii?Q?DxIgl73RzYJSCwWfCyMZqWtO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec0ce3f-3d8d-4183-2119-08d981a0c8ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 10:23:01.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J66MUAHMnyNq8lw2AvG7MP/F+21csCx+q1H70JEgxsU4NoEnjyupslVY2IwcFBYyylHgg59NlseGSZiGea+goQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2528
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
software nodes, thus leading to underflow errors. Balance the refcount by
bumping it in the device_create_managed_software_node() function.

The error [1] was encountered after adding a .shutdown() op to our
fsl-mc-bus driver.

[Backported to stable from mainline commit
5aeb05b27f81 ("software node: balance refcount for managed software nodes")]

[1]
pc : refcount_warn_saturate+0xf8/0x150
lr : refcount_warn_saturate+0xf8/0x150
sp : ffff80001009b920
x29: ffff80001009b920 x28: ffff1a2420318000 x27: 0000000000000000
x26: ffffccac15e7a038 x25: 0000000000000008 x24: ffffccac168e0030
x23: ffff1a2428a82000 x22: 0000000000080000 x21: ffff1a24287b5000
x20: 0000000000000001 x19: ffff1a24261f4400 x18: ffffffffffffffff
x17: 6f72645f726f7272 x16: 0000000000000000 x15: ffff80009009b607
x14: 0000000000000000 x13: ffffccac16602670 x12: 0000000000000a17
x11: 000000000000035d x10: ffffccac16602670 x9 : ffffccac16602670
x8 : 00000000ffffefff x7 : ffffccac1665a670 x6 : ffffccac1665a670
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff1a2420318000
Call trace:
 refcount_warn_saturate+0xf8/0x150
 kobject_put+0x10c/0x120
 software_node_notify+0xd8/0x140
 device_platform_notify+0x4c/0xb4
 device_del+0x188/0x424
 fsl_mc_device_remove+0x2c/0x4c
 rebofind sp.c__fsl_mc_device_remove+0x14/0x2c
 device_for_each_child+0x5c/0xac
 dprc_remove+0x9c/0xc0
 fsl_mc_driver_remove+0x28/0x64
 __device_release_driver+0x188/0x22c
 device_release_driver+0x30/0x50
 bus_remove_device+0x128/0x134
 device_del+0x16c/0x424
 fsl_mc_bus_remove+0x8c/0x114
 fsl_mc_bus_shutdown+0x14/0x20
 platform_shutdown+0x28/0x40
 device_shutdown+0x15c/0x330
 __do_sys_reboot+0x218/0x2a0
 __arm64_sys_reboot+0x28/0x34
 invoke_syscall+0x48/0x114
 el0_svc_common+0x40/0xdc
 do_el0_svc+0x2c/0x94
 el0_svc+0x2c/0x54
 el0t_64_sync_handler+0xa8/0x12c
 el0t_64_sync+0x198/0x19c
---[ end trace 32eb1c71c7d86821 ]---

Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
Reported-by: Jon Nettleton <jon@solid-run.com>
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc: <stable@vger.kernel.org> # 5.12+
---
 drivers/base/swnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index d1f1a8240120..bdb50a06c82a 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1113,6 +1113,9 @@ int device_create_managed_software_node(struct device *dev,
 	to_swnode(fwnode)->managed = true;
 	set_secondary_fwnode(dev, fwnode);
 
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_ADD);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(device_create_managed_software_node);
-- 
2.17.1

