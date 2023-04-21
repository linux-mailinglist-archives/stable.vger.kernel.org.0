Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F766EA9F8
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjDUMGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjDUMGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:06:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FD283C6;
        Fri, 21 Apr 2023 05:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyPIPQvd2I/7rmnOPp15DH7Z72Nh2bwGT6dTL3hLKTafvZ9DFZ+pJbXDo06aM1RM1z8Jj5QGzzOra8b7nKDJUs9xMs2FyHZ9Yej1uMlopEcdNNhfpoHFbhlW24sWlTVXwpxxJ2Gp9yQnIcdBQdoFINV6waDhVROaN0fyBW8yNt9pgSzLQ42Mzc4HFo2Xe5UYz5qQSsthJQYZetbTlDZbXu1POERFqlc3sAo7AW/6LY0Giax6zzJOpnlk2XEmWG7xFntpRRcQxyySEi4M0oG+okdbudX9yqh/i6mNuXXjy+tl20alWzveIbF8daAsJFvuCenEUbpS2Rjp3XXQUid4VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3dmXtuT0wkhyWGRIyFyJccpHddZ/crJvACgzfO4Tyg=;
 b=G5EA/K/LnpPC/6oRWHM9ez7sBN51Smv4dQ0eyn0bLEuu0a/eqw8oSc0PSpe7MyJQUozxNvcFvmOKar2gJLNQIESutWnSUIX+zAwMLGaOQrPHZra+spih1jPStY0BwQsWOUo4L7O0XT3useeldkPgesUoaXu09wlHwYux8U6Qjb21FjfSYV0YTxp55jJnJRaI3Dlw32D4LOs9DgEPNAKQnWn2s/1GMFtoMak00OgEjYgtJpAiqABNCvM06Tncs6dzXoA9ERJppRwAwswPeM0Kk0Oh0JozJWAC7uiRjLarKmTXQTB7lLaG88JI6bNt2ZVsgHZhvqux3PM74EOw5IYkcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3dmXtuT0wkhyWGRIyFyJccpHddZ/crJvACgzfO4Tyg=;
 b=gRz0Bs6BIMDtJ0CC1/rDZSMF5k3LIhB4THNjHJFHxS2M+wwKcZpt6h1EjZqRXU+QkxhX+53MbyQnYAwwKdOGNokyhHYJhMg1NVDdwxt9u5VLr03jOCLJimUSNuPEh5lcMDuypzD0H+sGkIGKROkJv5HrAm1JcUG5BspehJcpppk=
Received: from MW4PR03CA0083.namprd03.prod.outlook.com (2603:10b6:303:b6::28)
 by IA1PR12MB6436.namprd12.prod.outlook.com (2603:10b6:208:3ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 12:06:42 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::7c) by MW4PR03CA0083.outlook.office365.com
 (2603:10b6:303:b6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 12:06:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.25 via Frontend Transport; Fri, 21 Apr 2023 12:06:42 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 07:06:40 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <linus.walleij@linaro.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
CC:     <nakato@nakato.io>, <korneld@chromium.org>, <richard.gong@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] pinctrl: amd: Detect and mask spurious interrupts
Date:   Fri, 21 Apr 2023 07:06:23 -0500
Message-ID: <20230421120625.3366-4-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230421120625.3366-1-mario.limonciello@amd.com>
References: <20230421120625.3366-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT093:EE_|IA1PR12MB6436:EE_
X-MS-Office365-Filtering-Correlation-Id: 10e80c02-f0de-4057-7be2-08db4260deb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsFwLF5BibBLSJS5JjHs+qbyGXZJ/k7jxgAILXSZCtqDblGLD81IrUUc29OMs4dydWnyN4ZAupK0OPSIAkxWdp9BzIrziuk+fg/BLF2IpWWAEcU7Xh2AXDhGt+rRCoSaJa1bQ2aUrVkMnitcGgmo9XbBpMXWuzed7b/K8SDZY5SPzY6gbjGnqMvreCCb1Ionw9d4Kf0elVmKsNvNlevRxCeNpecNthj2HjChs7nWu6ij7qGEifDUL9cGqTkO5U7/a3/jZAYBlWf+l6N33XPkJieZKT9xjjjpuZ0GcS2lX1slEsDwwvWULW/kVDMXS381uWFZmXDXOd+nwlI7p9RkiHSWoPLY816qAOpoMaF0Y32LP9QMqIrqPre0JFkiO/7cDQEfKpS5ub46eSZo4gqaXwnH/zzhgSvNRZQBUwoTv59ve62Q7la3l3cXxoqGt3KFKjeZW83ySaf9ayB+tMWFODAJfy0eY+nDxqQXXYquGorwJuQ6yzYbsQnZCLdzaNASBG8+T+iZHv6oLy4YSAXe/ADrxrjxNwnrDRE54JaKM2F9DdXhn+bD9flDcMjYQUFFQGxGNUTWsC7VyrE0ILf9c2trLMNeYQ7O16rS/pafOyfD7qk8P++parrK+XUf2p/20E+vSA6AYbXS+laNepBfzGURJBmS0OL5Egee1KY/BamyGflEF0HAdR/80v4tWP/dKHWnvMULfn5T+xLYwcCRt5l2QkvCZQxsEydBhlHYLQU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199021)(46966006)(36840700001)(40470700004)(36756003)(6636002)(4326008)(54906003)(110136005)(316002)(966005)(70586007)(70206006)(6666004)(478600001)(41300700001)(5660300002)(82310400005)(8936002)(8676002)(40480700001)(44832011)(2906002)(82740400003)(86362001)(426003)(81166007)(356005)(336012)(2616005)(26005)(1076003)(40460700003)(36860700001)(16526019)(47076005)(83380400001)(66574015)(186003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:06:42.2486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e80c02-f0de-4057-7be2-08db4260deb9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6436
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kornel Dulęba <korneld@chromium.org>

Leverage gpiochip_line_is_irq to check whether a pin has an irq
associated with it. The previous check ("irq == 0") didn't make much
sense. The irq variable refers to the pinctrl irq, and has nothing do to
with an individual pin.

On some systems, during suspend/resume cycle, the firmware leaves
an interrupt enabled on a pin that is not used by the kernel.
Without this patch that caused an interrupt storm.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/pinctrl/pinctrl-amd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 24465010397b..675c9826b78a 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -660,21 +660,21 @@ static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
 			 * We must read the pin register again, in case the
 			 * value was changed while executing
 			 * generic_handle_domain_irq() above.
-			 * If we didn't find a mapping for the interrupt,
-			 * disable it in order to avoid a system hang caused
-			 * by an interrupt storm.
+			 * If the line is not an irq, disable it in order to
+			 * avoid a system hang caused by an interrupt storm.
 			 */
 			raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 			regval = readl(regs + i);
-			if (irq == 0) {
-				regval &= ~BIT(INTERRUPT_ENABLE_OFF);
+			if (!gpiochip_line_is_irq(gc, irqnr + i)) {
+				regval &= ~BIT(INTERRUPT_MASK_OFF);
 				dev_dbg(&gpio_dev->pdev->dev,
 					"Disabling spurious GPIO IRQ %d\n",
 					irqnr + i);
+			} else {
+				ret = true;
 			}
 			writel(regval, regs + i);
 			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-			ret = true;
 		}
 	}
 	/* did not cause wake on resume context for shared IRQ */
-- 
2.34.1

