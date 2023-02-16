Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C656999EB
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBPQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPQYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:24:48 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0572310F6
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:24:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFWdi0qtYCUTM+1oNPjdZcUvZOjOngKQyTbcVreLicDPdPwNae7iwsVkZaZUV5jEWLOHE06E9O6uZQBQLNy0Gnc7+9xhbcibY34ZlM7sCusVsbxZjKkyPlCc3RXa9K3fBmCBk/vs8TsUaSNua//BLgR7IYalplf4R23zSWfthc/ZkFPI58A1ALLCjA0vO/WZk5X0zr4KQjo6FTfCywKPxohHgz75rV1yPHAPyluwJiisMWmdabz3VuqVRfT04kyybMnQxoqMYRsvrJMErBBtIXkQ2dfZ9XBepawwez5ucZaW8Kn2M9eRBPFXHGLrtXUtaeAcfe7mTGb+Qi6tD2yYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMdJHiNPM5fwrXUumxPD8bG5O3Q+dfeA1wWE0odOjZc=;
 b=BneAQ7QJsdQlCBUtFIqKc1NPf3ggUFJeQWD02iYBu67s6U4yuM1wJxnBxVAisNSioYjqz85ouwpWnPouNjGIdcg47KB4EkCo7plKldWMQukLLSFneYrUoXgNN3ti4RYLCNG/WcATIxYRpqkX5uA0GIEKxYD9phYLKfF1Uxi67nEbS3L7wqvMdCtsIy855aHP+lBk353oTotYeoC64sBuvKpMhZkazVpzuKByAIiga8duS55Gr1qWnMx9IjPBu7fhePonHRo7RNXw6odOMvXWuHb9sCo/JA89JfFlaxnDTq/U9smEzlJxsG+/6FE6oocx46iwz+EuGOhx3dtUtfo0FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.ubuntu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMdJHiNPM5fwrXUumxPD8bG5O3Q+dfeA1wWE0odOjZc=;
 b=M19hdd7F44LnYHvtwX3WlXAbz/J7Zl4WYmLUPleS+61sdCVwaqDKC9U92nFa/6c0aVVF00QofObyfOg/mAfebBKVrVR/H76K4qkmWtCK2uad+MYxo8LIMMfFZUQW7oWUVaIayPtKBrcIOLxhT2/d0jyoLYkZCLJP86G3e0M9V38TNF7q3DmFkPULDPYzNIOK2RSVcqQJQg+1np9Q8wWV2T69qDXwuG5PnSkB8Xcgz2CmJWnCOAK6/yANcTePZBIhQLpe9FLtcX5hTFfW51ggWRtJjXKemOb03vL89CFLB745p+mtCEoLDwyK4zwEmGB/mXdy0Pe+wkM3msUlAn8ESg==
Received: from DM6PR11CA0035.namprd11.prod.outlook.com (2603:10b6:5:190::48)
 by PH7PR12MB6537.namprd12.prod.outlook.com (2603:10b6:510:1f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 16:24:44 +0000
Received: from DS1PEPF0000E655.namprd02.prod.outlook.com
 (2603:10b6:5:190:cafe::62) by DM6PR11CA0035.outlook.office365.com
 (2603:10b6:5:190::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 16:24:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0000E655.mail.protection.outlook.com (10.167.18.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Thu, 16 Feb 2023 16:24:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 08:25:34 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 16 Feb 2023 08:24:40 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 16 Feb 2023 08:24:39 -0800
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     <kernel-team@lists.ubuntu.com>
CC:     Mario Limonciello <mario.limonciello@amd.com>, <asmaa@nvidia.com>,
        <khoav@nvidia.com>, <meriton@nvidia.com>, <vlad@nvidia.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        <lukeluk498@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Takashi Iwai <tiwai@suse.de>, <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v1 2/2] gpio: Request interrupts after IRQ is initialized
Date:   Thu, 16 Feb 2023 11:24:31 -0500
Message-ID: <01f9f78d0f3c72a953ddf64db601745b3b3d9976.1676564505.git.asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <cover.1676564505.git.asmaa@nvidia.com>
References: <cover.1676564505.git.asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E655:EE_|PH7PR12MB6537:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc6f18e-2d42-4ce5-9e03-08db103a5058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0nHzlAvAxqMgaFqSWboW1NFzJo823n0+tGW3fXwsjHd2mtQLxtKsy3MQYWuCeXjx0x4kxCQqSdU1FoPQMZ06kZlgPO8gnT/MlKFGtxvn/xpNlfsxlOCogtW33ADW3tDzo8fai+B0IMVWtTYe3sNY8LijOn5lzTtDJpkg578beiQy7dQgq7ca7Gm+DrUOJ42i6obWRTMMsIOlWwPUzDp45c5yYnwmLgQ/FVrEBh5O8dPiw7goVQOKJJf5eAh5G3m3f7vrYkd9zf+zCZYPwNcL91frfzXS5oQkUnjGATmwRvn1DeM8n0jp+WjojC49XvZL49FD1JeTCgbxF5nxD9YEYLtUJB+tofuH29ksIeGXM/kGSisVK1tMM9Oi4gguCrA/riM/8xoaGyOBpvAV1qE4iY0434weKNLr6vGZldZJw0Lfn4dxx8zszTFAbi03zLoaEJmAC0KldcsFv2uK/g1lKkVOWa07XOuFoMsC9OkEDfdkxtDR6uEYXQxuleqsmNR3dofSVC2Ttl6rHToD6k1GdwGWZh6SJ1DeQqjv46ET/loRDOA1iHtG/RJ30fxf+wF3qI7YqIfkQkw1lEg7iRWde/LN3RmWoNWT3KgOICo8s4lUcyiWR6HSHSX2IFgmZA/GNRtVyNPxROjHZjQ4AoXgfDN0MdrVx9SwdnVYOcaqd8m9f2J6cg7drNT6rWmVX+MkeLYPjK25l4BVXTswAj2y0WOigSj1gt47nZc3FaWvNE86uCb7/X9VQJnav1Kk+RWjRaVI9DVv3sjFvPc9TNzQpVEhSFNBWD7DZDy9NbzJWI=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(41300700001)(70586007)(70206006)(6916009)(4326008)(8676002)(2906002)(7636003)(40480700001)(356005)(36756003)(86362001)(82310400005)(82740400003)(36860700001)(5660300002)(8936002)(7416002)(40460700003)(6666004)(186003)(966005)(426003)(336012)(7696005)(478600001)(47076005)(66574015)(26005)(2616005)(45080400002)(54906003)(316002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 16:24:44.3939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc6f18e-2d42-4ce5-9e03-08db103a5058
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E655.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6537
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

BugLink: https://bugs.launchpad.net/bugs/2007581

Commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members
before initialization") attempted to fix a race condition that lead to a
NULL pointer, but in the process caused a regression for _AEI/_EVT
declared GPIOs.

This manifests in messages showing deferred probing while trying to
allocate IRQs like so:

  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
  [ .. more of the same .. ]

The code for walking _AEI doesn't handle deferred probing and so this
leads to non-functional GPIO interrupts.

Fix this issue by moving the call to `acpi_gpiochip_request_interrupts`
to occur after gc->irc.initialized is set.

Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/
Link: https://bugzilla.suse.com/show_bug.cgi?id=1198697
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215850
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1979
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Shreeya Patel <shreeya.patel@collabora.com>
Tested-By: Samuel Čavoj <samuel@cavoj.net>
Tested-By: lukeluk498@gmail.com Link:
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-and-tested-by: Takashi Iwai <tiwai@suse.de>
Cc: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(backported from commit 06fb4ecfeac7e00d6704fa5ed19299f2fefb3cc9)
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e4d47e00c392..049cdfc975b3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2329,8 +2329,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gpiochip,
 
 	gpiochip_set_irq_hooks(gpiochip);
 
-	acpi_gpiochip_request_interrupts(gpiochip);
-
 	/*
 	 * Using barrier() here to prevent compiler from reordering
 	 * gc->irq.initialized before initialization of above
@@ -2340,6 +2338,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gpiochip,
 
 	gpiochip->irq.initialized = true;
 
+	acpi_gpiochip_request_interrupts(gpiochip);
+
 	return 0;
 }
 
-- 
2.30.1

