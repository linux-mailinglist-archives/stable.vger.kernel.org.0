Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561DC69AD58
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBQOIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBQOID (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:08:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D3644AC
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:08:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KH3GFlM8H8AdbbnJUSc72DwQNYvJzZW1BQRVflHMz7G5quqfOslIHEUeWAPgMFrx6s9sk66oJCdIMuOI4IAYt99m4zv95jZlficMThwT8GUfVseyu2gZho171MiXistnMj/PZkGWcciZG6/RYfXavoiLq714nK40uhhgBjy+wAKLHKxwyICSjkrJxHA3qhnfx/b4/A0gSmyeVq93YeDtWpzwqdnu2B8HILg0cfe/3KoT44j9F7pNflo0vyw8DfZ2r982DBMMGKO7YFWTDyBPfasDMah7MWSBSC2Cjik5Ah/FNP9JR2MAF4AoWfi/aU00laBiBJsZ62Y0pNRDjD/f/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwWY9jjse3mbxgSrvhQJkaeozhoEwdd/xiJFdvEAbAY=;
 b=GNiJtTCGDwQFuf0ZdJZ/NGR6BL23eYypZorDJX35gV96lJiEJMQhafrkO+UJdYl+W4PAbLtkDJzz+TfSPDPQ+5LzlfcMnuWtJoyzbnAVSreXeIiI00d7oWdIUgnZoV/poypiHvfN8mYpPKFr+3tVykio9t54KKNfNJi2ODp+Jhcu9NlVcJgAcVijX2XyISHl9XylPUqD/+d5io4zJfeY5wbdnUXh5B5WkvEnzTiwGTVB8AUl54uAwUm/coSCKfQpDRh+kb9JRJTa+nYs+1DKJC8LRjTiZWJRTXBsAoS9UkEoZ3mQ1rJYMtV6LznbOImnowqGJmGG7eHkRGchSRqo+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.ubuntu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwWY9jjse3mbxgSrvhQJkaeozhoEwdd/xiJFdvEAbAY=;
 b=Ue+3RVtdUz1MUlkjyOY8cUct8VylJ/fDEQ3uk8BbGIQCJ+sPGhrUWB99eQKxp0xunaibPQsS6/Nv9WHAqzq3XAA4RfvNlRpRA8uFYxcsEDnHaP6njBVi/SEQ895GZa90Ubq+14ykG49i/xTWhoKvNuAKcGQnJJVsJBmIkkULsw3DkLHhGBRLW4AqDGcbNSfYMZSKhIHYL+vjbGscymu2aNIYaPWdpJMIrOAlOwxKrhGqnW7z/JawOhbNOUvJqFpCWEsUV9CpAsPdMYWgHmExV3TzdePco+R0A3CtxcxFaNCf0L4UHtp0iu+yXeAEi270mBly3hr5Kn4HpkQq5+eEBg==
Received: from DM6PR10CA0007.namprd10.prod.outlook.com (2603:10b6:5:60::20) by
 DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Fri, 17 Feb 2023 14:07:59 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::7e) by DM6PR10CA0007.outlook.office365.com
 (2603:10b6:5:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 14:07:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 14:07:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 06:07:51 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 06:07:50 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 17 Feb
 2023 06:07:49 -0800
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     <kernel-team@lists.ubuntu.com>
CC:     Asmaa Mnebhi <asmaa@nvidia.com>, <khoav@nvidia.com>,
        <meriton@nvidia.com>, <vlad@nvidia.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of GPIO chip irq members before initialization
Date:   Fri, 17 Feb 2023 09:07:43 -0500
Message-ID: <20230217140744.20600-2-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217140744.20600-1-asmaa@nvidia.com>
References: <20230217140744.20600-1-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f80ddfb-802b-47f1-bcaf-08db10f0600f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TsvQc3RLXjoImSsVUVnkECUinuk3rneipvOeqrcDnjyisc954Fm3ym6Womv7UbHjHfy9/bKGoXAnfV8En8vevHXxvGXc+/SrXJJt4jraYZzNZ3gNmSxLA+iH59fl5RN+QjIGG7I0hZrRwGgIuFhOX3Tiv5e9xmtRtVT9S8ttC336u++SgFZzwVsACaupSvCq4xaQk4/y/+b6nnbbrcW15RiJCFrio4Ijb/MJRcRQPYsQR9bXU5kSVjBPwWDcc6Y0mlG4dvgtwxK1qU5ltctwSeetDyF1h6my5Vmvuu7Ydu5UI6lgiPxTnUOEakY/BtD2Bj9ZCbBsLiUnQwohhfQu70Tq8mPOkp1gd4M3m8zCG50XVRHkt8MdTj3pssnICY1bS7mDOdSQUVRmoYcIV2PJsEHUXlNjQwhEpzWGqn/B3ynwioVrbIY1KyK168iC41oZSUlBHkudDjlrw0s9EC/MaeW8X5fJlBrLWN5KcYRKKdKmdYBgnYYXd/0Chh4T5nSGcXXq62LyLYM73zoP+SLM3Ybl6k5xsUrcqilINnQdZkP3t5RQQJtsB990bzinbrrdlZ1AH3Gmd77v8QzeIz2t1bhwNNV63uNokWvXKsIA28G3LAgv05In6XE/PVAvXBoEukE8NujNLfUF6abYFOgJc8gyGwSn57iG21td9qWki/nafRbAGC5qGa9zqewWR+CLOjAvwRDgXXhSWRTZ1+55t8nDoLTWqJzBL/mmcg6KWuziuLn0FiFkXApawMt5lMdd
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(40470700004)(36840700001)(46966006)(36756003)(5660300002)(2616005)(356005)(7696005)(41300700001)(8936002)(26005)(2906002)(83380400001)(40460700003)(186003)(1076003)(426003)(47076005)(6666004)(82310400005)(6916009)(4326008)(54906003)(316002)(478600001)(336012)(8676002)(966005)(70586007)(7636003)(70206006)(36860700001)(82740400003)(86362001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:07:59.1334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f80ddfb-802b-47f1-bcaf-08db10f0600f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

