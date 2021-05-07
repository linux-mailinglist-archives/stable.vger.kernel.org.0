Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D2D3763DF
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhEGKfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:35:25 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:48598
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229758AbhEGKfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 06:35:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/EgIZCP0v+L6EvvbaB/bmA3BUvhwdaYDQ2T7D7ms6QNG+JeIqX6AC8Sks7rXkGkOvEMAwMSZ4VO8id5O1oxh38xSstGZg9Pe5ZYXJfPisLQy6NGmq7uwDgB0a3s+BoM9AHok/rTQ5ZgZjHRrf6yfcUm7yGiyq5G5GStPglSNgIjwPptTsnrVkF7D6aUyx2SnKOV2UhcRrYli3aNsaPJE/b57iVTK9MxPubZ8AoO04WpZOPTqC7rxBWFPnnUhqM1WJbMGvSoFYBxQFVSBrhXwH/Ucbb1FTFNxbDBxd7GFtRkkelmh224lkSSRIAmeQgsIK5NdFqKHdDz9LUITT7jGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ducR5XQD/GIiuQJM/fjME0/yBikCbYJUSgUzviYuk4k=;
 b=O/d2HXT1SMS/ZTOy3U/AVGnWyYFsYoRb/GdzqbPWLHHxDOxKwCOTgys0cnk68SPzhrMupZ0lDI0luYKMylP7EfO/aDLV+J/Irr/aM6xNJMYDGWbOFr+gTtM+1eOjJaZfajIAWORkvUO2lIaww04I4+fVmsnhSbhtftSs4Vp5a45g9/836gZZ7J3o8JeeIBNvmdE4knjrhl+mFNhdzloKl1cQfwxkLaNWK2fYaYTiGGmtEHW+MSVzeCcSzpyrrLn9ZGqaohJHgC3zHy2kEsj6hPh0uLacRr+Iom1q9izOd/xdJHEJrTnJu6kUEk7P5uQEAzD8aaoFKj1ia0r4kgYYdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ducR5XQD/GIiuQJM/fjME0/yBikCbYJUSgUzviYuk4k=;
 b=d19PB/op3BMCcQjeHkoiSZ5bEV050ikCCegU03ymUGeoZViX1GqD8t5bGQz18EPrQ5BrDRSnrei7BEI6ALXU9suexD/+ldluCN3Sg0Szvd0igLagK3c6vhb+/fhEQK8+JroYB+EMwg95j0awdibXdJZ1T+6PxMyiC6skoes3xqVTzDOlhkUwxdtV9HG3f5iKOBmWhjfL9bfLUYUcIWAI8cR74BWvCvss7gKeBqR0EliSGqjhAuN9F7enCu187AGJrahHX2+sxsG3THurJlRUUOISm/eorlmMtpIhUwbthPgtto27AZv+CIKcHxrf91DvC1HbTwstWM+wRRoy4/pHMw==
Received: from DM5PR06CA0035.namprd06.prod.outlook.com (2603:10b6:3:5d::21) by
 BN6PR12MB1409.namprd12.prod.outlook.com (2603:10b6:404:1e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.27; Fri, 7 May 2021 10:34:22 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::ee) by DM5PR06CA0035.outlook.office365.com
 (2603:10b6:3:5d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Fri, 7 May 2021 10:34:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 10:34:22 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 May
 2021 10:34:22 +0000
Received: from moonraker.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 May 2021 10:34:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Marc Zyngier" <maz@kernel.org>
CC:     <linux-gpio@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] gpio: tegra186: Don't set parent IRQ affinity
Date:   Fri, 7 May 2021 11:34:11 +0100
Message-ID: <20210507103411.235206-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a98d8137-e280-48c9-22e5-08d91143adec
X-MS-TrafficTypeDiagnostic: BN6PR12MB1409:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1409A491C5F7FBD29F3211C2D9579@BN6PR12MB1409.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ww2K+fDyc2BRw+b84s23kMKoOfX/NMe9sq3T0Q2sPLY72+9/xN9AsD2nuN8e+3wdMtvlINSjqSD+HfJWpb2my2Z6dGzDKCBeLYfyS1QcNsO5az16SBB1iDTOWggWcAOAod8GsEvn88IISFarb1Ly6iYKp4IEROyJfRONIyLeEJcUKcyk7tufCfCX7nFMbQaEDQ8r9w6WaGQIKGmfLEwIni578IyutmD4u+ye1lTCKbPYRuKuLaXTNViXYyofbPflEkzQWUbRKnTaYfXIvEBSQ3dpC8YtH1L8CxEMXS8dZsurH0t0/gGVwj2fr7IIXAFgeGIuV+6wznG3kc+OB03GukOI7RBYOs815v2v/XtzmBWFOrEJX1JumKpPJjNo5eoUGToYtNlWbkJG+QTSLO8hILppKH5dsvFmgWdmbRReapX9HZdHvLS9AaXGmD9/4W110D1ScoM5kpaARxSyXDMqMSEf2pxsSKdBg+5lAl2VTacNxQpTja8LDTubPb9fHzhIVZn8DZap35XS1ta9gaJToRwPAkCxp2qR6y9+bLIzw5KVZ56jsoXIZFKXBbIIOUhnX2wcquASW438NpppPBMoabaUz7Je+CxPlvw7EeH6sVm8/AOrTzKpRriHYVjh+W0fwQzFyMD+MLvLkddoCsFcdRGgMuONMwz8i31MxnnHxeY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(46966006)(54906003)(110136005)(8936002)(83380400001)(7696005)(70586007)(4326008)(36860700001)(36906005)(2616005)(356005)(70206006)(26005)(8676002)(7636003)(426003)(316002)(86362001)(47076005)(186003)(5660300002)(82740400003)(2906002)(336012)(82310400003)(6666004)(478600001)(36756003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 10:34:22.6961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a98d8137-e280-48c9-22e5-08d91143adec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1409
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When hotplugging CPUs on Tegra186 and Tegra194 errors such as the
following are seen ...

 IRQ63: set affinity failed(-22).
 IRQ65: set affinity failed(-22).
 IRQ66: set affinity failed(-22).
 IRQ67: set affinity failed(-22).

Looking at the /proc/interrupts the above are all interrupts associated
with GPIOs. The reason why these error messages occur is because there
is no 'parent_data' associated with any of the GPIO interrupts and so
tegra186_irq_set_affinity() simply returns -EINVAL.

To understand why there is no 'parent_data' it is first necessary to
understand that in addition to the GPIO interrupts being routed to the
interrupt controller (GIC), the interrupts for some GPIOs are also
routed to the Tegra Power Management Controller (PMC) to wake up the
system from low power states. In order to configure GPIO events as
wake events in the PMC, the PMC is configured as IRQ parent domain
for the GPIO IRQ domain. Originally the GIC was the IRQ parent domain
of the PMC and although this was working, this started causing issues
once commit 64a267e9a41c ("irqchip/gic: Configure SGIs as standard
interrupts") was added, because technically, the GIC is not a parent
of the PMC. Commit c351ab7bf2a5 ("soc/tegra: pmc: Don't create fake
interrupt hierarchy levels") fixed this by severing the IRQ domain
hierarchy for the Tegra GPIOs and hence, there may be no IRQ parent
domain for the GPIOs.

The GPIO controllers on Tegra186 and Tegra194 have either one or six
interrupt lines to the interrupt controller. For GPIO controllers with
six interrupts, the mapping of the GPIO interrupt to the controller
interrupt is configurable within the GPIO controller. Currently a
default mapping is used, however, it could be possible to use the
set affinity callback for the Tegra186 GPIO driver to do something a
bit more interesting. Currently, because interrupts for all GPIOs are
have the same mapping and any attempts to configure the affinity for
a given GPIO can conflict with another that shares the same IRQ, for
now it is simpler to just remove set affinity support and this avoids
the above warnings being seen.

Cc: <stable@vger.kernel.org>
Fixes: c4e1f7d92cd6 ("gpio: tegra186: Set affinity callback to parent")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/gpio/gpio-tegra186.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
index 1bd9e44df718..05974b760796 100644
--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -444,16 +444,6 @@ static int tegra186_irq_set_wake(struct irq_data *data, unsigned int on)
 	return 0;
 }
 
-static int tegra186_irq_set_affinity(struct irq_data *data,
-				     const struct cpumask *dest,
-				     bool force)
-{
-	if (data->parent_data)
-		return irq_chip_set_affinity_parent(data, dest, force);
-
-	return -EINVAL;
-}
-
 static void tegra186_gpio_irq(struct irq_desc *desc)
 {
 	struct tegra_gpio *gpio = irq_desc_get_handler_data(desc);
@@ -700,7 +690,6 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 	gpio->intc.irq_unmask = tegra186_irq_unmask;
 	gpio->intc.irq_set_type = tegra186_irq_set_type;
 	gpio->intc.irq_set_wake = tegra186_irq_set_wake;
-	gpio->intc.irq_set_affinity = tegra186_irq_set_affinity;
 
 	irq = &gpio->gpio.irq;
 	irq->chip = &gpio->intc;
-- 
2.17.1

