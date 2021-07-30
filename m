Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034EC3DB71B
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbhG3KZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 06:25:44 -0400
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:47840
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238368AbhG3KZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 06:25:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqUsAkeGfgUZHk7ea75hiqpUG7ubhsjP92s6Bv0sj+egLKPudSsDFH9s/8rBKBaprNEN46H60fRsNqynjvYhVBRIKn0+MQslHJ8Ti3znCz6LCFcAQ5ptHQ92TXQvywDMYN3Xujv7kAEMEov42E/t2MzepWEPdwjnpU36mV5idCmeFwR5LMbwZo8MWq48Li0Kmvjkxfvx1Ica3NjcPwABab8t8ffzEtvtURak30P9BwX+gPNEendsr26b7gBcezpkaYNvF3GXFGzDEL5c7CqYIYwU2PCPXYDN7t6Yh7D25SR4TxvNvkn6AiF2RmTszV6J5kAmMdsse7U3t+sAMtbbgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpBb4Gmt4JUqxA5CYudIoX6SNxBPAkpKKB3y89mUsZQ=;
 b=Jo3TkWy5Uy0uvLWZWLhaDGiK0qbEjqvgHBUcfT+pn6r/mn+yfY22+ALCtdPm4F5IyR26VpnNL5Phyp6p7SjZ8I3G+UzW88RVFQuy37YgKSL938RKTjEyVWfT9yDivsL2HxgTqowcEVMmPWHm239rP/9MQYplzBVT+4mbQ8MkWoNWrfFbQucLBSeuZBOG9EksdvUQT3QldLAY7IeZjP80HX4PCZjsBaIsQeFSTC9hk8gR3f4C7v/kmzpYCt/dzwYrZyAwug1nn0todA7EfoaKs2ZF/sNJnISlfc/TQK2dNOpNnhzye0MQeQxhgYdl+OUTh7PEhWpTjYMnDascX2Y3iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=urjc.es; dmarc=pass action=none header.from=urjc.es; dkim=pass
 header.d=urjc.es; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=urjc.onmicrosoft.com;
 s=selector2-urjc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpBb4Gmt4JUqxA5CYudIoX6SNxBPAkpKKB3y89mUsZQ=;
 b=eJCW5vkG5LD0kbC3HHnnJUHi4s4MZLOlWnUTeDu772oOchSIe0MuAESC/oOS1DeNt2/l0tLBu//o9gsaTemCraOuKWjwCcFHB/3YdCQIATP/SCmAnkcZXgqoc6NOPrKxYNIxha7QvuKSXabjAmdiQXuBMjRxLSpxTrzxrwUJ1SY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=urjc.es;
Received: from DB7PR02MB4663.eurprd02.prod.outlook.com (2603:10a6:10:5c::15)
 by DB3PR0202MB3433.eurprd02.prod.outlook.com (2603:10a6:8:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Fri, 30 Jul
 2021 10:25:34 +0000
Received: from DB7PR02MB4663.eurprd02.prod.outlook.com
 ([fe80::1048:a385:a5d8:1f0e]) by DB7PR02MB4663.eurprd02.prod.outlook.com
 ([fe80::1048:a385:a5d8:1f0e%7]) with mapi id 15.20.4352.035; Fri, 30 Jul 2021
 10:25:34 +0000
Date:   Fri, 30 Jul 2021 12:25:32 +0200
From:   Javier Pello <javier.pello@urjc.es>
To:     stable@vger.kernel.org
Subject: Patch "Kernel oopses on ext2 filesystems after 782b76d7abdf"
Message-Id: <20210730122532.6966a03a1d2e07b81486e0f4@urjc.es>
Organization: Universidad Rey Juan Carlos
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0040.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::28)
 To DB7PR02MB4663.eurprd02.prod.outlook.com (2603:10a6:10:5c::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mo-dep2-d036-01.escet.urjc.es (212.128.1.36) by MR2P264CA0040.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 10:25:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22763aa8-0065-4b2e-48dd-08d953445d59
X-MS-TrafficTypeDiagnostic: DB3PR0202MB3433:
X-Microsoft-Antispam-PRVS: <DB3PR0202MB343364201BC3572A24F77DD09BEC9@DB3PR0202MB3433.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jdOLduy6jGYOD1T92aLDQoegbBknGnNUKA/WBDTnjQFacEgH312+DeufcAd0bFQ/MZFh5MbJFY+b12Wv77b9FtHVM2Sbfc2S63/nTlmGk48qH/0Pp4/sWODar8VVDxbFF5pJKAnLmctT2W88b0bjKg6PVsnLIy0sS5yJGjtQF5WFLj1AWP9Wzd++xER5H/cXlVN1xGDVA6BQGSKJdcnu2y09TyqYphvHPxBLjI6FWCljME4IoF/L+YgVTdRz82yXP6nKOfrG1sPVd367t/GWtkFNBp9CeaTnHy5WRtaT1usDZyWTfZNhquBr8zdgGJwPUveXAjeoiwhOy44GkAFTdcnifupHwehOc5JspiYaHNgu/JwsV5dgVpM96rsAy4BLxa/zz7qBpIgtbfTny8EGUpr5E+MM1y7invPSwtZvlUalfwU0t9ZwWNjMlogHWhEa4BaQzXxeXZ4C/eJz1oId+rfdd9n7gZ2idVFUaK7PEtN3majW/DLB+/UzeNd2nPoRvabmhxdUQAx04zQnNmLdISJwUOhm873u0uB0oQ5DjGeHnN7JMEo8a1CjwA1w11ALyr/nGk4Onvn5PA15TX+Uu/tvtH0Og752CaFw5uY4llROw3jW5MUvfo5pUV1+mGISobbJqZlIUEk3txODPQ4EcEBipHk2dYD8O55kApzs/CLWS1wn1hvoqV1SE47PB+lVShedyhhWpX09J4uSL4IE1kYcvAnrNv3Pi7Iv/ttnXpZ5neGP2ECenMgWJythIRxfzZgN9ooJwOJ5wlqSfehH5OK4cfgpH2cSKA0qOQ27VA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR02MB4663.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39840400004)(366004)(396003)(36916002)(66556008)(83380400001)(44832011)(5660300002)(36756003)(8676002)(786003)(86362001)(8936002)(66476007)(38100700002)(186003)(956004)(316002)(966005)(6486002)(1076003)(66946007)(2616005)(7696005)(4744005)(38350700002)(6916009)(52116002)(26005)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d8lJRwzrahe7Vqu58tOpSyVSDKPS31w8eUzTCd/tn3ujqJBYTboN/Jqmv1WU?=
 =?us-ascii?Q?bld2L3+NEi6Ayx4aXQ3odeNqusc6fYjjC0C0nXtg97nmEmRhLDAGfjInh6qF?=
 =?us-ascii?Q?hONct6hHtNXmnvj9W3y7jNeONRqcfpXve5NFXjsZA/gDt+n2KI+XVrUKVhZQ?=
 =?us-ascii?Q?8xaMS4K43pit47EtH0Vm4wOhI90WoqZgb1qdgDfSyGQYZgzc9TOEtj+MM+AL?=
 =?us-ascii?Q?l2fUVAtLrJ4uMAkXDgkECKA//b/0yIcep7vazeZaW3oe3CwaTFejRqXeCTq6?=
 =?us-ascii?Q?Qa2ltW85bRT3Xgvax5rTWjCkx8MkwQibG9GDiP+jyW06Xxf15iKGOgXjCLmD?=
 =?us-ascii?Q?Y/fjHU5xnepr31MUBGhbv53rre1ofTdYWWqxQDU3IWPjT+V89MgYlPpVb5qD?=
 =?us-ascii?Q?WdHn8AnKXdQ/mctxO6Tikk31HUJKKfI3nyoNDH+ieXeIjt32SkJlBDl1J5/b?=
 =?us-ascii?Q?dQbej6DsSyHE2tEEyt6mZIrMN86AqxwkMehGfZKLS0uyp3GoF/glTNasSQW9?=
 =?us-ascii?Q?MwtjxsRQyMxTL+mYyfsG4LrLbfMlBszl1tIDB5wAjw3v9sdcD8dKW5GWiK8f?=
 =?us-ascii?Q?n173F2EUoucyO+IrLXDnMT6z10vbyMXZAAwKLIRR3YwAvXDbsbPWvZWMcj/w?=
 =?us-ascii?Q?++b4K54u8JO9KyAE25TjTuLoSiQkX/6o+Gq20RTZCuEtB8TGAKo3SzNZ5XFR?=
 =?us-ascii?Q?6GLeDb8wdVYmaK3tcbpeW9dPq6tK/Zf6EtrDeJKhG9Odgv6mDCMkJwYE6RrC?=
 =?us-ascii?Q?dBZz1QpkqGFroOECIRbmaZ40WqaAGLK4PlP8eO2O/AXLr4ICcw25CEFvUj0D?=
 =?us-ascii?Q?S7kpYyobtnkpdxfPYC9VYSrmgEkkBDnr1pWcAASjX/Nt6Zzzy728ZhRRTT/Y?=
 =?us-ascii?Q?kaHOicBBF6hnJRQH38EzrLeo+CUzLV2rJ+dDwqsANm77EXBCHWfGsFIhP3yI?=
 =?us-ascii?Q?/6jdLEE+TYR4rvzNjQjeSyNseU4O55Auhlzv63eUwbA+QJc8USH9xzjpTeTs?=
 =?us-ascii?Q?bthzSoQ1JCMuZ2KWKa6kolNIKofZy5Eo/kAWn4hkz195pz+ifDD67LOdrIjW?=
 =?us-ascii?Q?/IA25Go/Kr6mjz4MSmvUQ9agHFLhQBS8jvQLU62OWpEu0+qYRhxlygzbELYn?=
 =?us-ascii?Q?rP7r6iRVREslBcPTnPxIwWq2KHgb+9/4UdFs5ggQuoOQGR/8AjX9SkDEw/Hx?=
 =?us-ascii?Q?7vZaUuIBwQBLs9bCHcLfHN6ULbInyn8jOIbF9pELbBR+eJkAOZSSqCaRu4Cf?=
 =?us-ascii?Q?Sz6k+quZaMqBls/CbkZ2ZbWFdj5BOGXY58VREBuF/6FNtMO+qCK6W5sxzBlw?=
 =?us-ascii?Q?VNqhZ8Lz6IrXF/20fiEWXlLb?=
X-OriginatorOrg: urjc.es
X-MS-Exchange-CrossTenant-Network-Message-Id: 22763aa8-0065-4b2e-48dd-08d953445d59
X-MS-Exchange-CrossTenant-AuthSource: DB7PR02MB4663.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 10:25:34.0968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5f84c4ea-370d-4b9e-830c-756f8bf1b51f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Caqf5biX5MJGRZ7AwbZEPDlV5hYhLo2mjK4c77g+Ktb0+B2QGV69Hwq0psQ9ZYLOL73/iesc7WHiCcIKMGhOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0202MB3433
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear list,

The current 5.13 stable kernel branch oopses when handling ext2
filesystems, and the filesystem is not usable, sometimes leading
to a panic.

The bug was introduced during the 5.13 development cycle.
A complete analysis can be found here:
https://lore.kernel.org/linux-ext4/20210713165821.8a268e2c1db4fd5cf452acd2@urjc.es/T/

A fix for this bug has been recently merged into the mainline
kernel, with commit id 728d392f8a799f037812d0f2b254fb3b5e115fcf.

The 5.13 branch is the only one affected by this bug.

Best regards,
Javier
