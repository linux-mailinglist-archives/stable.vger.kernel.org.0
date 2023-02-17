Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CC69AD59
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBQOIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBQOIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:08:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25533252BF
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:08:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzxwkZ9NQARLo7syVLgc+n15eZm96n4eazMR7UeGYRnFEn0p7wjjCLFMiBlzs/is8m1RI3mJRXg89KXdxACj2h1YWOKfY5AwNJdR8YQvWlFCsoKtuvtGl8CCkvp0TNzSlL3wMb1oQHgFxcklZ/FIE01HvVGTRSAJqcuEH28Putgcz1sqMqPhR/r/GirZVQB8OQ7Dott1QvRAUk+kHppdd1sGQNVbgTw6GMpRwik7KpU7+rsX8QeEapH76iQ3i+QqkHoFSenij+0hhw+YqlG79cnbz+fC3/EXIynvawku9y7FAp4NP6MbJdlZ2NB0tus0EOm7t6WqxI/RHAZjysKvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oklCvmHEadmsfjDx1+RS27bNjCiekk/pG6D6WWmu/ac=;
 b=S2zo+vm4fsSQ4curpzoERkXlwCRTWjMkuQ1yrhCMnzvtDpOZXIpV0EzcxtW6zpYpq9fRRmhfmB517GHR188ZhCZY/VZ5Ej4lL6+q6t3DKlexoJZ2YqUtm66FrxGkvzJZZWcUMcXszvQrpPKf7XhEt06d8h0L4rs2RsWp6PcpIm8ZGdUP/ol5s9MGnO0kEh/uo3z83AKua75zj5sjPujO7vsUubKLDsWVpU+ZBZJ9SeSpJi38s44Lv/UFfdhfsIt3CESRfXIP5vsGDoepjb8QLMTaKzjLQuSyZIwqoWpZfoAqDXi8/qtORlGI8wnXes8b7WlMlMhb+Auply/uzgCtYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.ubuntu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oklCvmHEadmsfjDx1+RS27bNjCiekk/pG6D6WWmu/ac=;
 b=KsSxFzsGAwbhIpe83PAJA0SWJFSXR5D6ZPRTUy1EQ/FZpWZg+uCJEvPA2XzlEvgGygkGdSv4PUyii4hw611toRFjtXLba9Z5Wy2nxg4YIu/BUSI1/ZBQe1gO4eM1ZU9pEjstCsfKSLysNqAW4j6HsYZrHt99ZA0HJJhumIKOER4G54rlHBlYohWJUpbwc07o9QmeI7z2HX7yz+8vJmuYUK9Pm2yfGZFX8me0EMHXkDnLnTRiAAJB0bovQ3pBOttfooDRUTwbadTHJuHLilJUc4+UhCEzR6CeKnFzpfs4yEEGC33ynNX18I19cJg+WYvWNrTgMyzUpB61hF44cuYVLQ==
Received: from DM6PR10CA0030.namprd10.prod.outlook.com (2603:10b6:5:60::43) by
 SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13; Fri, 17 Feb 2023 14:08:04 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::ff) by DM6PR10CA0030.outlook.office365.com
 (2603:10b6:5:60::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 14:08:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 14:08:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 06:07:54 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 06:07:54 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 17 Feb
 2023 06:07:52 -0800
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     <kernel-team@lists.ubuntu.com>
CC:     Asmaa Mnebhi <asmaa@nvidia.com>, <khoav@nvidia.com>,
        <meriton@nvidia.com>, <vlad@nvidia.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Shreeya Patel" <shreeya.patel@collabora.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        <lukeluk498@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Takashi Iwai <tiwai@suse.de>, <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [SRU][F:linux-bluefield][PATCH v2 2/2] gpio: Request interrupts after IRQ is initialized
Date:   Fri, 17 Feb 2023 09:07:44 -0500
Message-ID: <20230217140744.20600-3-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217140744.20600-1-asmaa@nvidia.com>
References: <20230217140744.20600-1-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d25a531-f780-4c9a-3d0a-08db10f06327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XDqMsWyMs99K9mLUJfLWl2rlXZN2ML11DdcksvWpaYUx/Bbsqb2qoghqZBQRa29VEl15V4Ep2dVekySHKy+pZBfptGREG/vAYqk6bOIM3PvgH3WMiTiQv9Z+UfL31O/DktiJ8sKM/5/J985mzZfTmZhVYQL6QE5QgCyt8n2DUAvSyu+CntoweLFi/oSBBqQLEEqLCEuTS3xcZ85FTmuTigpJdJZBif1zKdPvyoL/Dwe42dK+2k6F5WvXO2P9HWTZa/ga90r8mVLufVYvSNNajOoWi8PUm+KFZb4C+YUYDHV8yWDu2cTPMIKDltxciLNhlrvXqMBvvD78xp/MgqnZm1grw8wSNVhkXOH9O1N8/eN8HxpTFN09x3E2vDiLmj38/cXTSdOmfbDTO+v0BKsb+f8GQfNd9qfnD7xTRFdkoDtoJf0b+wgP3CDo5kp6VM9Wje260dE63zyynknwGNAjUFz+WcwG1pRSpjnL/VgzTub8wnb1bg/GG9haaHfrf3/hd4DDxQtRQ+xqBAQhi1G9jf9MXPaEsoBDp9/d+6QHTr/yTcepwZVu+wJK8Epw+xL1npJKSIiGvv7alc9CIqJY6Oy1vgtPd4DgLH55nt/dY0OW8nj6PhfMQwsbVZsfemKOYUmwD3Z76BWNOlQDpdstTaXNsxsu3/lAlroEjANwXQxwS5+b9CSx2WkOEy99MABsqo2j95ncoP09hwP6/CpTtXRrdTTZQcznQUV5zs+2JbE5QHxFdLNHwwSSDZr1PU/1upvilpueaZ6UjuJ+c4jdJl/KqhBS9v04OdNOfD3VuxqU0P4YZKJ/dy3Lw12/ZOmeSECIJFOkOnIiuiS4Y7MEA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(36756003)(54906003)(316002)(40480700001)(7416002)(5660300002)(8936002)(7696005)(70586007)(41300700001)(70206006)(8676002)(478600001)(6916009)(4326008)(45080400002)(2906002)(82310400005)(186003)(966005)(26005)(6666004)(86362001)(356005)(1076003)(336012)(2616005)(83380400001)(66574015)(47076005)(7636003)(40460700003)(426003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:08:04.3049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d25a531-f780-4c9a-3d0a-08db10f06327
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

