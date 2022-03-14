Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904B04D82FE
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiCNMMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241917AbiCNMJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39D021E36;
        Mon, 14 Mar 2022 05:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6ABB80DF0;
        Mon, 14 Mar 2022 12:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B0AC340EC;
        Mon, 14 Mar 2022 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259562;
        bh=9NQFTWAPNISxKZgzADV4wKywB3/kKMexDBkUedIuC3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAb2SIz28tk67q5q4tGU9PJQRIMQXmJ70/EnwiA6+7xdyhDXsdrYmxjEIDmC1IyBP
         qvf/YV3e/pT+IBrWoMo+kZGXumL0REuBXxLwRL9ixFBKlJf1nQPPy9mCdMFbpPnuWi
         ekhmvBODc1VNuh/HZMf6K9oAyYA1XBWzx1BYs4F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/110] clk: qcom: gdsc: Add support to update GDSC transition delay
Date:   Mon, 14 Mar 2022 12:53:08 +0100
Message-Id: <20220314112743.209771395@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 4e7c4d3652f96f41179aab3ff53025c7a550d689 ]

GDSCs have multiple transition delays which are used for the GDSC FSM
states. Older targets/designs required these values to be updated from
gdsc code to certain default values for the FSM state to work as
expected. But on the newer targets/designs the values updated from the
GDSC driver can hamper the FSM state to not work as expected.

On SC7180 we observe black screens because the gdsc is being
enabled/disabled very rapidly and the GDSC FSM state does not work as
expected. This is due to the fact that the GDSC reset value is being
updated from SW.

Thus add support to update the transition delay from the clock
controller gdscs as required.

Fixes: 45dd0e55317cc ("clk: qcom: Add support for GDSCs)
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/20220223185606.3941-1-tdas@codeaurora.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 26 +++++++++++++++++++++-----
 drivers/clk/qcom/gdsc.h |  8 +++++++-
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 4ece326ea233..cf23cfd7e467 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2015, 2017-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2017-2018, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/bitops.h>
@@ -34,9 +34,14 @@
 #define CFG_GDSCR_OFFSET		0x4
 
 /* Wait 2^n CXO cycles between all states. Here, n=2 (4 cycles). */
-#define EN_REST_WAIT_VAL	(0x2 << 20)
-#define EN_FEW_WAIT_VAL		(0x8 << 16)
-#define CLK_DIS_WAIT_VAL	(0x2 << 12)
+#define EN_REST_WAIT_VAL	0x2
+#define EN_FEW_WAIT_VAL		0x8
+#define CLK_DIS_WAIT_VAL	0x2
+
+/* Transition delay shifts */
+#define EN_REST_WAIT_SHIFT	20
+#define EN_FEW_WAIT_SHIFT	16
+#define CLK_DIS_WAIT_SHIFT	12
 
 #define RETAIN_MEM		BIT(14)
 #define RETAIN_PERIPH		BIT(13)
@@ -341,7 +346,18 @@ static int gdsc_init(struct gdsc *sc)
 	 */
 	mask = HW_CONTROL_MASK | SW_OVERRIDE_MASK |
 	       EN_REST_WAIT_MASK | EN_FEW_WAIT_MASK | CLK_DIS_WAIT_MASK;
-	val = EN_REST_WAIT_VAL | EN_FEW_WAIT_VAL | CLK_DIS_WAIT_VAL;
+
+	if (!sc->en_rest_wait_val)
+		sc->en_rest_wait_val = EN_REST_WAIT_VAL;
+	if (!sc->en_few_wait_val)
+		sc->en_few_wait_val = EN_FEW_WAIT_VAL;
+	if (!sc->clk_dis_wait_val)
+		sc->clk_dis_wait_val = CLK_DIS_WAIT_VAL;
+
+	val = sc->en_rest_wait_val << EN_REST_WAIT_SHIFT |
+		sc->en_few_wait_val << EN_FEW_WAIT_SHIFT |
+		sc->clk_dis_wait_val << CLK_DIS_WAIT_SHIFT;
+
 	ret = regmap_update_bits(sc->regmap, sc->gdscr, mask, val);
 	if (ret)
 		return ret;
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index 5bb396b344d1..762f1b5e1ec5 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2015, 2017-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2017-2018, 2022, The Linux Foundation. All rights reserved.
  */
 
 #ifndef __QCOM_GDSC_H__
@@ -22,6 +22,9 @@ struct reset_controller_dev;
  * @cxcs: offsets of branch registers to toggle mem/periph bits in
  * @cxc_count: number of @cxcs
  * @pwrsts: Possible powerdomain power states
+ * @en_rest_wait_val: transition delay value for receiving enr ack signal
+ * @en_few_wait_val: transition delay value for receiving enf ack signal
+ * @clk_dis_wait_val: transition delay value for halting clock
  * @resets: ids of resets associated with this gdsc
  * @reset_count: number of @resets
  * @rcdev: reset controller
@@ -35,6 +38,9 @@ struct gdsc {
 	unsigned int			clamp_io_ctrl;
 	unsigned int			*cxcs;
 	unsigned int			cxc_count;
+	unsigned int			en_rest_wait_val;
+	unsigned int			en_few_wait_val;
+	unsigned int			clk_dis_wait_val;
 	const u8			pwrsts;
 /* Powerdomain allowable state bitfields */
 #define PWRSTS_OFF		BIT(0)
-- 
2.34.1



