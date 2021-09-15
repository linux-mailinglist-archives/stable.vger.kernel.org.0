Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383B840C15B
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 10:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhIOIMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 04:12:41 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:36073
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231654AbhIOILk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 04:11:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVsKCKoE+RoeRApSHAzbahKGsJPbVTAeZmSreQxCJoAGfSra0QKu7LULpirh2wEc/Emj8oN7hiSssAQJZO2IgpiQcZxbEPqo2R8TGE31o+7bKs+H3pN3i7AlGlYwCXMjiNwwtGi1h6RVuhDS3uzDJIRz2a3zDeCVGKuk2viB+1sK+oLto9LjWJ1GWQeT2P/8A1EC1Af7ITUOf7Jk7cxciECnI0Su3h8AttBadNLw91XbYce2A/ILtfVRcQP2B/Xe+O5K/c933y3QwjgU2x1ggaFdxV0s7UiCLHlKU6IJY8QzTCPURbb3o2xN6VIuzmyR47MYJB5/dfqelsAm0jLH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Qu+sV+39EneGiXnIVdTt4O/KLioBZnh/KSrXHvN9Fcg=;
 b=A6B4LPFNPKmnP8KkPS+FDZJTJu9+UuSawkeQSEz0wdGDP9AEzMLs4IMllhDOM71kTUUPsY8zdCIoJdjSUFkzhyI/lMP3OOv+al3IZnuhKmofCGgeVeeBUBkxe302rT5PFbYAHEsHGNDbjn+YQSAt120t/JMAMTrewkAgU37YXHtCXKIB1NgOQRBohOvVv1+kwuueLI/ymRtkHAkRqk2F8PxPAcD3O3J0MlnhZXgCRFIKZQA41joDxgPX+1emdoPjYfO1CM1+i8l0ybYDf+JrHyRyHg+GA6f99XllfcNsYQ90UEbN4hHub5VuAL8gtkOpWfQ2GxLCntfAplCZc+pLlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu+sV+39EneGiXnIVdTt4O/KLioBZnh/KSrXHvN9Fcg=;
 b=s7SM5BKreHosRsMnfkb+I4Y9nOJKiGk3674LtpXu8myJ61KVeCwXXeCyRBHFxeo/XdPfJV0wmGmf8A+Vgw3bf/jv6sxW2wIyvz/FcD6u4HWgJwPop1EevY3zX8IER+pOSTiEY3f8P91Q7/q3YT6I6Y1U6h3gak8e40a5Od/H3Zs=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB7085.eurprd04.prod.outlook.com (2603:10a6:800:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 15 Sep
 2021 08:10:18 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923%7]) with mapi id 15.20.4500.018; Wed, 15 Sep 2021
 08:10:18 +0000
From:   laurentiu.tudor@nxp.com
To:     andriy.shevchenko@linux.intel.com, heikki.krogerus@linux.intel.com,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jon@solid-run.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] software node: balance refcount for managed sw nodes
Date:   Wed, 15 Sep 2021 11:09:39 +0300
Message-Id: <20210915080939.21388-1-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0097.eurprd07.prod.outlook.com
 (2603:10a6:207:6::31) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1864-101.ea.freescale.net (92.120.5.2) by AM3PR07CA0097.eurprd07.prod.outlook.com (2603:10a6:207:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Wed, 15 Sep 2021 08:10:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e996c16b-5f2f-4c44-0ea4-08d978204183
X-MS-TrafficTypeDiagnostic: VI1PR04MB7085:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7085EDAD2BD5918F458B8EF2ECDB9@VI1PR04MB7085.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WaV6NEewJn5iALaLeIdjIyzwGHJK5JlfPeCB2mizg4Sq3TfVH3GiRVpbRfhgelSDeY2mJYJ1JMl66gYd7qSAR955vFVmaLU5+tTcVWednGWYfq7eHl4ozowECQUjIHqIl7QP5YCidFVtayPwU///YIHYbUbxQhPUjzp1PZ6b2lvofEk48yb/m8zRyJJqC31T18HEjYCvNS2i5nKuClEP2LxlcGUjgb2dv+1LAEFW7ZaC6+NYOhKs8Cl8uhcI9MJ3O88jRIsb1HCvDGLMtFWSJClhLn387hoAGRxRXxg5xpw1q9vsu4TOgWnO5+uYpdEJLhQBliOakNmHlFrRrJ3VkvuJ3Lx5yVualxO3D/yhH1MyKgu6WCx5uS6G9DFPIXjVvpFnk17Cp/QPGQ6r12uy27m4nMWRDlDAzKAIv0jkM0m6XgB2Qm9dKQ3iQ2UHTCD2idcYSm16gBhLL5Tj+m7OBtVz5glhj4gSel7a1Rr/isjPksrALlMaNMYKXEYgBSjM3FfEZ/tAeWcTvQdLl3d3qqWo9DGP49I5Bgkkx4nhUmEFb7Nzrkt8SdL+zqg5zAh8iYwQmaxOoO4p4HG8LDW7xsu+H8ZRq7qgKOB2hDZvEQjQ2kWBhft8HqeNvEH7lOxu5r//nVr6dhFgfExx3qnQpGG4uYVhannLMx/03xsi7FA5sRZ5yN7vPebYmWGfZEqOQMseDj2eezIG4kCA1MvSVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(186003)(6486002)(4326008)(2906002)(86362001)(66476007)(26005)(478600001)(9686003)(6512007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(66946007)(8936002)(36756003)(8676002)(1076003)(316002)(52116002)(956004)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jixp+aH7Miyl9a6r+/Kx1YhFZSLIDkmqxqKYYZvnEnziY6lvBWD3PafhRcsJ?=
 =?us-ascii?Q?Fb/0AYIBj2N80vt4mjPQWGrSuWp6MHHFGO9FLxChGwWooPt/lr3NXOE3b83m?=
 =?us-ascii?Q?fva4aE9ECh5u1y1Jjc6X+z21gWQlx4tSmzW2Zs3srnC57XTXJsYuvzP6mAoM?=
 =?us-ascii?Q?chWnJMvwPhMtv7Nr/MNI+t5rZJZDJRxfC7gByMzdnpMxYq8xtA/J1wPR82so?=
 =?us-ascii?Q?zcXWX0yYfaekpW9IDJ1g+igdO9Mc0CEyOXcLoGdLswwsvEFn5DICmN40khIc?=
 =?us-ascii?Q?ze4XS+iIQbeaJhpaIicOWCrPN/dl7+V/avWxopF/ylOcQXPKo4neGlav7DCt?=
 =?us-ascii?Q?UYz0JbiDTa/RNgJve1QFhQNlBN9YmobZX+t89D2zWlpGeZqWZq0I7Dv1aXTV?=
 =?us-ascii?Q?zTcRG0o3fyX4PQcFB98j50xrkEsAL+gBSfAurtnoSzWGWHc+3SxoSZA8+QrZ?=
 =?us-ascii?Q?9LYx2IALqKzV1ZTqIQ70pQfsUiEbseNfE1OtbG7lPy07rNsSMT99HUnV9MOq?=
 =?us-ascii?Q?ZrRPf2BR28L1c3XPoDfVUFSnYPbPa65sfBxROzrbn92uTOPJ97WwBOskUoQm?=
 =?us-ascii?Q?DIB5gQI305wpLPWOJxgvba1Nlk+90f2Q0q6jDjKIQ6x7Wu/4ATnEtPXn48G6?=
 =?us-ascii?Q?VxnrCbh1BfjKba10xORNJVFyighrMZizE/l+fW25IVOiO6zjxM73BpKkR5BT?=
 =?us-ascii?Q?8M2rIr9ITOPwNfgB4nJRRh0Te3FyyciWMczDRk+CeeNBbRs+rhv8d7EoVk13?=
 =?us-ascii?Q?NC+StgBoX9HzjpwbkXF5dY8X3ShxGr5dvvIQBDti2GnVtTSKM+5HOW7c9zt5?=
 =?us-ascii?Q?v0HYyXGaJp3oNLjTWiDUoxRoruW5l5ouIb2bJf475F+vdWKvfEiabB10rwcG?=
 =?us-ascii?Q?yCrG1o9vGBihvyx+mYsyCMRMa4v6opgt4NG8nFp21p5OanGppdKfaCVxCtPB?=
 =?us-ascii?Q?xqVIExS4VahWkPvA3+hXJACKMx0tFKVnR0IOYHYDwsvdZPx2u5FGhbAwUZ/8?=
 =?us-ascii?Q?wVhOeymPpM7OytRS0xDp3INLxGN4DoNOyyvihnFdjlygcu9u3YCpA35QsD9W?=
 =?us-ascii?Q?vmDBnVnnZ+OQ460CncbLFzhjHZYKHVVVg1dYFUuHUDBBxH6nHChcBjn0/y65?=
 =?us-ascii?Q?aqZq0Khjj/DJOS6nGE2Aq42VOlXxJCRMtpEkf6Ue708eInDgbl74aPD4nOID?=
 =?us-ascii?Q?rtT7NKdIB4iPy5DbPTb9rsS2m7HZT5MiE1cPMa8FCu+G8Yz0h+vrsqlBl0dz?=
 =?us-ascii?Q?FEMVJG8AoGRRDb+qlDZl+UQc0SSIzqbOc8xvcdKn414vuLsaVhy+kJ8zaPTR?=
 =?us-ascii?Q?kvh1+cCIAEjxs0nOxzA2Yd5O?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e996c16b-5f2f-4c44-0ea4-08d978204183
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 08:10:18.4839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JsLdenZLODDAcEBdCgMbRwykjSOB9UTvzwK82RN2zNiakNqiIHUj6IZE0aeW6/H8+G5B+c6c0m3HHVcxjOKqdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
software nodes, thus leading to underflow errors. Balance the refcount by
bumping it in the device_create_managed_software_node() function.

The error [1] was encountered after adding a .shutdown() op to our
fsl-mc-bus driver.

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
Cc: stable@vger.kernel.org
---
Changes since v2:
 - added Fixes: tag
 - Cc-ed stable

Changes since v1:
 - added Heikki's Reviewed-by: (Thanks!)

Changes since RFC:
 - use software_node_notify(KOBJ_ADD) instead of directly bumping
   refcount (Heikki)


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

