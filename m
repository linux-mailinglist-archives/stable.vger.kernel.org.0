Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC15EB8DF
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 05:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiI0Dfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 23:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiI0Dfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 23:35:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5676286F2;
        Mon, 26 Sep 2022 20:35:41 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mc4w41409zHqHV;
        Tue, 27 Sep 2022 11:33:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 11:35:39 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Yang Guo <guoyang2@huawei.com>, <stable@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH v2] clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO and CNTVCT_LO value
Date:   Tue, 27 Sep 2022 11:32:21 +0800
Message-ID: <20220927033221.49589-1-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Guo <guoyang2@huawei.com>

CNTPCT_LO and CNTVCT_LO are defined by mistake in commit '8b82c4f883a7',
so fix them according to the Arm ARM DDI 0487I.a, Table I2-4
"CNTBaseN memory map" as follows:

Offset    Register      Type Description
0x000     CNTPCT[31:0]  RO   Physical Count register.
0x004     CNTPCT[63:32] RO
0x008     CNTVCT[31:0]  RO   Virtual Count register.
0x00C     CNTVCT[63:32] RO

Fixes: 8b82c4f883a7 ("clocksource/drivers/arm_arch_timer: Move MMIO timer programming over to CVAL")
Cc: stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9ab8221ee3c6..8122a1646925 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -44,8 +44,8 @@
 #define CNTACR_RWVT	BIT(4)
 #define CNTACR_RWPT	BIT(5)
 
-#define CNTVCT_LO	0x00
-#define CNTPCT_LO	0x08
+#define CNTPCT_LO	0x00
+#define CNTVCT_LO	0x08
 #define CNTFRQ		0x10
 #define CNTP_CVAL_LO	0x20
 #define CNTP_CTL	0x2c
-- 
2.33.0

