Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D850B824
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447841AbiDVNSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447826AbiDVNSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:18:10 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469E3267F;
        Fri, 22 Apr 2022 06:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGf2JL/TfMBVGq9h27JZ0b7fblUMtJzqj29/VD5rpwSnDRfGZxHrZThxdBQgY3A9wA2ejviBmegfaIicS45LcS57nEGXgCjwXrtQM6q+27Lku1EHcixqi5LeLL5KESs2AXnlLE2VP3ZvIJrwtEWTnllAQ/JbVBnikE54NDGWKognDNALYMi6r2PO/gvOpjHA7CmEXfp58fACEEjo/L/4hUGJn58zTVZdcEBwI5h/dXRNQHsb4aoDeNvPjkxs4tIGJzSXnrf2O7QG617BPMnB1BcsYwNi8G4AWTbeMLid89HAVMDX/d0eYz/o1afAWMbR7iqEHIfY/dmMFLSI9NKl2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=896jnF0U7pXuz4FVFHsHXyYPANBVKaszqjSRz1PN7qQ=;
 b=Poa3SdY+AGRXBqZcUaDKQwXkpExmfs9oiMsDqDa7gYKjlcCwWinK0vBRwVs1CP3iQdxaVjP+8Px3QxuUknwliC4yjTQY6YR9GP6KxY7e3i578M/rnPeZF7LRyRfB6Uq0em7M+TqVsBEijxozDhb/x0tg/fkp0fR+gktT2/NkWInOC0kyf8idNF+Gm6AjtnbuoZU3JLzfGxjj3F7sAtgzyR/vkVnNtr7rjHqLmdPo/zW0AwXOUZNrhXvd0TyDyCeMRP6s8+vaX+G9YGbbP7MaJLePPwtEY19Z2GIVtDZYNP2tdhw/x2g8OP4/OS7jY3iKZ40zy0qsEN3fouGL2Nheow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=896jnF0U7pXuz4FVFHsHXyYPANBVKaszqjSRz1PN7qQ=;
 b=acBbSxrhGUnC3J+KJ6booGZXtpq4A98cJLB0NejW5m2q/B+6I8pQvKOP70o4C9saF3ubVsbejk1+x9ztMHYZU3s8Dr9t9FdUPzHgFuZ3TfWA/0TjcdzJo/f59tPZCaCNtrb9dEAK2VdIQBJUzDL93MECTBtIBGuv+IaUHmptiMU=
Received: from BN8PR07CA0034.namprd07.prod.outlook.com (2603:10b6:408:ac::47)
 by CY4PR12MB1367.namprd12.prod.outlook.com (2603:10b6:903:3c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 13:15:09 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::a9) by BN8PR07CA0034.outlook.office365.com
 (2603:10b6:408:ac::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 13:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 13:15:08 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 22 Apr
 2022 08:15:07 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <torvalds@linux-foundation.org>
CC:     Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Gong Richard <Richard.Gong@amd.com>,
        <regressions@lists.linux.dev>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Mario Limonciello" <mario.limonciello@amd.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        <lukeluk498@gmail.com>
Subject: [PATCH v2 1/1] gpio: Request interrupts after IRQ is initialized
Date:   Fri, 22 Apr 2022 08:14:52 -0500
Message-ID: <20220422131452.20757-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422131452.20757-1-mario.limonciello@amd.com>
References: <20220422131452.20757-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c4c16a-cfe0-47dc-d100-08da24622017
X-MS-TrafficTypeDiagnostic: CY4PR12MB1367:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13677F563D70F265C63213ADE2F79@CY4PR12MB1367.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5GOev1MLJPHAN7rGCYWbECdIUC24J2tjSai6Tt3BdohYZIDSMU1vChmhRAt8mcNquM4Qw2AhjNdDa6b7uyd6WtP9X5nNXEEOXo0PPjyy7Kl10Y/uA6bK+b67LGFrN745g2hgygNtN9mNfdXoiF7lWHXF88G2No9qIP4cqJhkkENjV4Y09qRDUDcmhBILgFFVhvQvig2RrMYJ933w2ByrSrN+GZZh55izkcLKKRVKSBnPYrQhmuAkODvKENqta3FEQ4AYkzAayWB4qzCCjD8BX1OvXZcZH9+o01I+Bn+FLbEDP6QhGTmKVdQ6E+xFxg9zMwsYVopfEhMryHchVLD0KOgKDucDq37hWgNnJaDLFU9aoMcIhCj9NcT6KTeDvEG/8yIpd/kdmZyjKuwUIB2SrIUDUIQn5x5xMGOe5mMtTS4ceyU+ronT48WTQih2SHIhclx/h4HmdntRuQAWMzqw89g5EQqHL71v2xIIr1fG0qlyfVlG2w1XglQKHZ1XOMYd0xoMmQaDk3Aw2e6q77vvGhohKjGE0foIm+kV4FeqYjtQ88F1V95TmEudcAXtNkvwfX/HI4WLhLibkef2o00N05JAK8VsFS0ghCa92RNUi9tYblEE+u4OQilPqEKh39zE8XB120T4s8hNtn4Ev8uOVUsok6ivVVC8IOYDO/FysHLoD/HXObY4UnLn9dh0itTaIjL5+0unFEstizR6CppRX+ZNxauYk4r+9g9iuD8rdmTKDMvHsnKec51bNBm3LGrUJ63fZyraMVW+pqJB79aNTVjK0srvToGx69Ltachu1RSxSMDn+7PuqINW8PL8udXI7MeyK7/ljzOPTC84gaRGQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7416002)(5660300002)(508600001)(82310400005)(2616005)(81166007)(356005)(83380400001)(45080400002)(44832011)(70206006)(4326008)(966005)(7696005)(8676002)(2906002)(6666004)(8936002)(86362001)(36860700001)(70586007)(6916009)(54906003)(36756003)(16526019)(186003)(26005)(1076003)(40460700003)(336012)(426003)(47076005)(66574015)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 13:15:08.9391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c4c16a-cfe0-47dc-d100-08da24622017
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before
initialization") attempted to fix a race condition that lead to a NULL
pointer, but in the process caused a regression for _AEI/_EVT declared
GPIOs. This manifests in messages showing deferred probing while trying
to allocate IRQs like so:

[    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
[    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
[    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
[    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to IRQ, err -517
[    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to IRQ, err -517
[    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to IRQ, err -517
[    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to IRQ, err -517
[    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to IRQ, err -517
[    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to IRQ, err -517
[    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to IRQ, err -517

The code for walking _AEI doesn't handle deferred probing and so this leads
to non-functional GPIO interrupts.

Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` to
occur after gc->irc.initialized is set.

Cc: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Shreeya Patel <shreeya.patel@collabora.com>
Tested-By: Samuel Čavoj <samuel@cavoj.net>
Tested-By: lukeluk498@gmail.com Link:
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1979
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215850
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
v1->v2:
 * Pick up acked-by/reviewed-by/link/tested-by

 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 085348e08986..b7694171655c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gpiochip_set_irq_hooks(gc);
 
-	acpi_gpiochip_request_interrupts(gc);
-
 	/*
 	 * Using barrier() here to prevent compiler from reordering
 	 * gc->irq.initialized before initialization of above
@@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gc->irq.initialized = true;
 
+	acpi_gpiochip_request_interrupts(gc);
+
 	return 0;
 }
 
-- 
2.34.1

