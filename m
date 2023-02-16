Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12A86999EC
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBPQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjBPQYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:24:50 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9251710F6
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:24:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQkuu+J7ZrFWNtTwqCtiIiIXWeEf5aI6mgET747wmC7naWPWWLOSXIUNyYWvcY5piRGGZswWLPBi7CH8ymwWAMe1s013lpc3z08IXWfwaZkXc5Tyuj8odcuj4sh93C2Q7OCuHNyLiXuNdIB9hgVubPPpFtA8293pKixqHzvOadgQtauAR1vW9S0UTp+p0FCdD2pSIh47yYutsnXfmWL8P9yfIC0yMykCo2lcuGYW3B9v1zRSVi8xa+KeEmmCO3eF/JXvLR2n7/TGPQU0knbHaRSyDCS8XfROwy4AaavdOpE3HLiA0e54ojmyZIWiWi9lfqFMzzXjJuvz5yiy9gbstA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWqSfwhS6N9kEp9r2U2Vywi47twYSmWb04DeRqLL+EE=;
 b=YvO4OJccQLngdlhsBZyQTO4Tdc/fjEZNrkWxzGNpzbIMaR3tAD5riUDoTEZcvYnmKsR1wXC64M/Xd7t84gF5ooj4V0h9NimxS36r+4FIRgxBPsfWwCBmKddzmnyWk1guCZrlb3lKQgZbVYoEdIJxrFZ92q39eQWwntJblD4aw09x9pz4eEfFkIkucsj17b4JgAaC8CKSQ+7XH6FyszqLbBKvWpNdMPrc1erVQ2Bu1odSXBX+cn0uTAyZGGHDlAH4fsOTfzBHyW6WzuNOU9rYL+R9qJd1+3w2pjVeJ7Z7A4PeUaxgXXSbSPqCw5aQDyZ+S2Kp1lc60aS5jaWznXvj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.ubuntu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWqSfwhS6N9kEp9r2U2Vywi47twYSmWb04DeRqLL+EE=;
 b=PWe4KAfu6QH4hXYdlGDWF+OkGI6m3NzXDb7UYdotGw3SJxXJRpP3dV+FUqHox1Wxlo4x+GaUKmjYJ5m0FisVp2j1GNS3SuYYxFFS7jULjbKMTwjU30g8fsADmxhr2X7bFsR9oQBfMZM2MeyzWASsb83V5+12ZWg8i2gbe8KvEabrdN/398X5ip6d35DnJpOb+mWNztTcK2CZAdvl1ZCAnR2j36xR4toWq8QvoAqHoZzxWaCGqvjYCEKfouZ0hA7gijPKE4GAcBr5MqXEeMNlKYtpycZ379/zj+Fv6+aNw+L7kkeiz4aqr/ztobdYMzx6WHrc1gTKS97689coFlUarw==
Received: from BN9PR03CA0290.namprd03.prod.outlook.com (2603:10b6:408:f5::25)
 by CH3PR12MB7595.namprd12.prod.outlook.com (2603:10b6:610:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 16:24:47 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::b9) by BN9PR03CA0290.outlook.office365.com
 (2603:10b6:408:f5::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 16:24:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 16:24:47 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 08:25:30 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 16 Feb 2023 08:24:37 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 16 Feb 2023 08:24:36 -0800
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     <kernel-team@lists.ubuntu.com>
CC:     Shreeya Patel <shreeya.patel@collabora.com>, <asmaa@nvidia.com>,
        <khoav@nvidia.com>, <meriton@nvidia.com>, <vlad@nvidia.com>,
        <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH v1 1/2] gpio: Restrict usage of GPIO chip irq members before initialization
Date:   Thu, 16 Feb 2023 11:24:30 -0500
Message-ID: <315ba43ba7a5db36a5eef4a5bf42ac913a23ebf5.1676564505.git.asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <cover.1676564505.git.asmaa@nvidia.com>
References: <cover.1676564505.git.asmaa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT059:EE_|CH3PR12MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 6589576d-fa46-4cbd-1ef2-08db103a522f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0VSJhrARztdGIfPAgD5qCPZ3OPUjAQemSxfZaNBUwwCB3A+oxMG5ilgDSAOBSdr2xOf1b8vtqcZFTPw2fN99LFXHm2Z/MpQv7LPuRt8NUSa0/jXsDh+6T48MVRkoK3lIm94MfgJDG8P2nffHSmYSPh8q0tDMqAtbxOufe1UKCqrTcxnjPAc25xNVtiVUFN6UoWnsEjkP9p6XJZY5RiF29TotHNZ152Mbb24PX3auQNkl/DM9Egh++7uFhmP72scx6rPRZIOYqExqKVnF2IBtC3SPRCGg9hg7gm5lN6QSq74eXbDrv4RJ/sJ4TSarqZm2eu1xzjO8YE7m2Fn91rQrhEB61QdETKvLDORYP27tnxxwhk90m7oa4iX2L9w6UL9wt7GpPoFLMf14dEn5rIXNuSDTrO+CaEKPnxEj6LuXsazcN8egOv291mAarvFRSv+fk980s7sS/fusCZqiUzCPvRmnhbMWYp3s4d3GkMvTOA3wXrrQpyg8XhsQ6VrrXixKn3TbdD60ibBzCwnzLKVFu2qUjRaR5k7WG69MjkCMC0nhPCdxxOSvsvTaMZ82Eh8Tf4xwv/LaombC935fAn1zB0HrBC4cIiIXZhscVP14XcC3ueo3XuOl+jmPooK7hn9wzOVkJRV/MJFK4WPUPdB97NtcFSH9f/WpUsyhBmIEjnk0WYuCIRKq1Cr1HXmEayLrK9BeOKvWT53L3n3LfQEetOaxG3CKRTFoCz3zyIpj/PC/yoRz4lCdvizSIlSzh0N
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199018)(46966006)(36840700001)(40470700004)(70586007)(83380400001)(7636003)(8676002)(356005)(6916009)(4326008)(41300700001)(82740400003)(426003)(8936002)(316002)(47076005)(70206006)(54906003)(966005)(36860700001)(5660300002)(336012)(2616005)(82310400005)(40460700003)(6666004)(36756003)(40480700001)(7696005)(2906002)(86362001)(26005)(186003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 16:24:47.3993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6589576d-fa46-4cbd-1ef2-08db103a522f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7595
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreeya Patel <shreeya.patel@collabora.com>

BugLink: https://bugs.launchpad.net/bugs/2007581

GPIO chip irq members are exposed before they could be completely
initialized and this leads to race conditions.

One such issue was observed for the gc->irq.domain variable which
was accessed through the I2C interface in gpiochip_to_irq() before
it could be initialized by gpiochip_add_irqchip(). This resulted in
Kernel NULL pointer dereference.

Following are the logs for reference :-

kernel: Call Trace:
kernel:  gpiod_to_irq+0x53/0x70
kernel:  acpi_dev_gpio_irq_get_by+0x113/0x1f0
kernel:  i2c_acpi_get_irq+0xc0/0xd0
kernel:  i2c_device_probe+0x28a/0x2a0
kernel:  really_probe+0xf2/0x460
kernel: RIP: 0010:gpiochip_to_irq+0x47/0xc0

To avoid such scenarios, restrict usage of GPIO chip irq members before
they are completely initialized.

Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
(backported from commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320)
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/gpio/gpiolib.c      | 19 +++++++++++++++++++
 include/linux/gpio/driver.h |  9 +++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index abdf448b11a3..e4d47e00c392 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2146,6 +2146,16 @@ static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct irq_domain *domain = chip->irq.domain;
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	/*
+	 * Avoid race condition with other code, which tries to lookup
+	 * an IRQ before the irqchip has been properly registered,
+	 * i.e. while gpiochip is still being brought up.
+	 */
+	if (!chip->irq.initialized)
+		return -EPROBE_DEFER;
+#endif
+
 	if (!gpiochip_irqchip_irq_valid(chip, offset))
 		return -ENXIO;
 
@@ -2321,6 +2331,15 @@ static int gpiochip_add_irqchip(struct gpio_chip *gpiochip,
 
 	acpi_gpiochip_request_interrupts(gpiochip);
 
+	/*
+	 * Using barrier() here to prevent compiler from reordering
+	 * gc->irq.initialized before initialization of above
+	 * GPIO chip irq members.
+	 */
+	barrier();
+
+	gpiochip->irq.initialized = true;
+
 	return 0;
 }
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 5dd9c982e2cb..15418caf76fc 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -201,6 +201,15 @@ struct gpio_irq_chip {
 	 */
 	bool threaded;
 
+	/**
+	 * @initialized:
+	 *
+	 * Flag to track GPIO chip irq member's initialization.
+	 * This flag will make sure GPIO chip irq members are not used
+	 * before they are initialized.
+	 */
+	bool initialized;
+
 	/**
 	 * @init_hw: optional routine to initialize hardware before
 	 * an IRQ chip will be added. This is quite useful when
-- 
2.30.1

