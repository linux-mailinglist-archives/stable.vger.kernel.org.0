Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6D4F3184
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiDEJd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiDEIQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3721CFEC;
        Tue,  5 Apr 2022 01:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA2016167A;
        Tue,  5 Apr 2022 08:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F5EC385A2;
        Tue,  5 Apr 2022 08:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145814;
        bh=oBueRlGnsA+SB0G09LAGMW5kSeGEyH/mD0Q4eBI8Owk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tfb33VJYW5O0sHCdK3bPBdJdwadjwIT0rNhnFwXBk9Ye6rzBQZwsJPImI4IJXaULz
         K1kdQ4fK5+WjN+dqPi/VhzRo1BYRFd2dv1+/9Xhbfy67a/v9IYDhpdEEYrYvv0q0eX
         TOCdAVjg2aTjei/T7eQX9VQs5RhbIu6gIAmdN6pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0538/1126] power: supply: ab8500: Swap max and overvoltage
Date:   Tue,  5 Apr 2022 09:21:25 +0200
Message-Id: <20220405070423.423986849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d662a7df36e1edc65eaf166ec1c8527ce9d088ea ]

We should terminate charging when we reach the voltage_max_design_uv
not overvoltage_limit_uv, this is an abuse of that struct member.

The overvoltage limit is actually not configurable on the AB8500,
it is fixed to 4.75 V so drop a comment about that in the code.

Fixes: 2a5f41830aad ("power: supply: ab8500: Standardize voltages")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c   | 8 +++-----
 drivers/power/supply/ab8500_chargalg.c | 2 +-
 drivers/power/supply/ab8500_fg.c       | 8 +++++++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 7ae95f537580..9a8334a65de1 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -188,13 +188,11 @@ int ab8500_bm_of_probe(struct power_supply *psy,
 	 * fall back to safe defaults.
 	 */
 	if ((bi->voltage_min_design_uv < 0) ||
-	    (bi->voltage_max_design_uv < 0) ||
-	    (bi->overvoltage_limit_uv < 0)) {
+	    (bi->voltage_max_design_uv < 0)) {
 		/* Nominal voltage is 3.7V for unknown batteries */
 		bi->voltage_min_design_uv = 3700000;
-		bi->voltage_max_design_uv = 3700000;
-		/* Termination voltage (overcharge limit) 4.05V */
-		bi->overvoltage_limit_uv = 4050000;
+		/* Termination voltage 4.05V */
+		bi->voltage_max_design_uv = 4050000;
 	}
 
 	if (bi->constant_charge_current_max_ua < 0)
diff --git a/drivers/power/supply/ab8500_chargalg.c b/drivers/power/supply/ab8500_chargalg.c
index c4a2fe07126c..bcf85ae6828e 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -802,7 +802,7 @@ static void ab8500_chargalg_end_of_charge(struct ab8500_chargalg *di)
 	if (di->charge_status == POWER_SUPPLY_STATUS_CHARGING &&
 		di->charge_state == STATE_NORMAL &&
 		!di->maintenance_chg && (di->batt_data.volt_uv >=
-		di->bm->bi->overvoltage_limit_uv ||
+		di->bm->bi->voltage_max_design_uv ||
 		di->events.usb_cv_active || di->events.ac_cv_active) &&
 		di->batt_data.avg_curr_ua <
 		di->bm->bi->charge_term_current_ua &&
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index b0919a6a6587..236fd9f9d6f1 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2263,7 +2263,13 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
 {
 	int ret;
 
-	/* Set VBAT OVV threshold */
+	/*
+	 * Set VBAT OVV (overvoltage) threshold to 4.75V (typ) this is what
+	 * the hardware supports, nothing else can be configured in hardware.
+	 * See this as an "outer limit" where the charger will certainly
+	 * shut down. Other (lower) overvoltage levels need to be implemented
+	 * in software.
+	 */
 	ret = abx500_mask_and_set_register_interruptible(di->dev,
 		AB8500_CHARGER,
 		AB8500_BATT_OVV,
-- 
2.34.1



