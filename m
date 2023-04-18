Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B9F6E64E6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjDRMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjDRMx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD32916F84
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F29363459
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DDBC433D2;
        Tue, 18 Apr 2023 12:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822389;
        bh=UwyG6Gy9KDhGWvKveRFzAcaAt077RRfEM4d2FevbDdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwWP6G1hyCnFGjkmrTwyUh+gK+nHVwjV5mYdvTvrVP3hbY0LyNHUudKOGKCmnMSpQ
         RLdPep5jlcPl5wHA9BDholfh/I6pLJhMrOp23rg/Z8U84SvwZ5zCeY4Xk7bsI1aR6K
         zzBWDMGbHCWG6buL7TfSM6g6sdPtfrw7v1DK5Gyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 130/139] i2c: mchp-pci1xxxx: Update Timing registers
Date:   Tue, 18 Apr 2023 14:23:15 +0200
Message-Id: <20230418120318.759398953@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>

[ Upstream commit aa874cdfec07d4dd9c6f0c356d65c609ba31a26f ]

Update I2C timing registers based on latest hardware design.
This fix does not break functionality of chips with older design and
existing users will not be affected.

Fixes: 361693697249 ("i2c: microchip: pci1xxxx: Add driver for I2C host controller in multifunction endpoint of pci1xxxx switch")
Signed-off-by: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mchp-pci1xxxx.c | 60 +++++++++++++-------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mchp-pci1xxxx.c b/drivers/i2c/busses/i2c-mchp-pci1xxxx.c
index 09af759211478..b21ffd6df9276 100644
--- a/drivers/i2c/busses/i2c-mchp-pci1xxxx.c
+++ b/drivers/i2c/busses/i2c-mchp-pci1xxxx.c
@@ -48,9 +48,9 @@
  * SR_HOLD_TIME_XK_TICKS field will indicate the number of ticks of the
  * baud clock required to program 'Hold Time' at X KHz.
  */
-#define SR_HOLD_TIME_100K_TICKS	133
-#define SR_HOLD_TIME_400K_TICKS	20
-#define SR_HOLD_TIME_1000K_TICKS	11
+#define SR_HOLD_TIME_100K_TICKS		150
+#define SR_HOLD_TIME_400K_TICKS		20
+#define SR_HOLD_TIME_1000K_TICKS	12
 
 #define SMB_CORE_COMPLETION_REG_OFF3	(SMBUS_MAST_CORE_ADDR_BASE + 0x23)
 
@@ -65,17 +65,17 @@
  * the baud clock required to program 'fair idle delay' at X KHz. Fair idle
  * delay establishes the MCTP T(IDLE_DELAY) period.
  */
-#define FAIR_BUS_IDLE_MIN_100K_TICKS		969
-#define FAIR_BUS_IDLE_MIN_400K_TICKS		157
-#define FAIR_BUS_IDLE_MIN_1000K_TICKS		157
+#define FAIR_BUS_IDLE_MIN_100K_TICKS		992
+#define FAIR_BUS_IDLE_MIN_400K_TICKS		500
+#define FAIR_BUS_IDLE_MIN_1000K_TICKS		500
 
 /*
  * FAIR_IDLE_DELAY_XK_TICKS field will indicate the number of ticks of the
  * baud clock required to satisfy the fairness protocol at X KHz.
  */
-#define FAIR_IDLE_DELAY_100K_TICKS	1000
-#define FAIR_IDLE_DELAY_400K_TICKS	500
-#define FAIR_IDLE_DELAY_1000K_TICKS	500
+#define FAIR_IDLE_DELAY_100K_TICKS	963
+#define FAIR_IDLE_DELAY_400K_TICKS	156
+#define FAIR_IDLE_DELAY_1000K_TICKS	156
 
 #define SMB_IDLE_SCALING_100K		\
 	((FAIR_IDLE_DELAY_100K_TICKS << 16) | FAIR_BUS_IDLE_MIN_100K_TICKS)
@@ -105,7 +105,7 @@
  */
 #define BUS_CLK_100K_LOW_PERIOD_TICKS		156
 #define BUS_CLK_400K_LOW_PERIOD_TICKS		41
-#define BUS_CLK_1000K_LOW_PERIOD_TICKS	15
+#define BUS_CLK_1000K_LOW_PERIOD_TICKS		15
 
 /*
  * BUS_CLK_XK_HIGH_PERIOD_TICKS field defines the number of I2C Baud Clock
@@ -131,7 +131,7 @@
  */
 #define CLK_SYNC_100K			4
 #define CLK_SYNC_400K			4
-#define CLK_SYNC_1000K		4
+#define CLK_SYNC_1000K			4
 
 #define SMB_CORE_DATA_TIMING_REG_OFF	(SMBUS_MAST_CORE_ADDR_BASE + 0x40)
 
@@ -142,25 +142,25 @@
  * determines the SCLK hold time following SDAT driven low during the first
  * START bit in a transfer.
  */
-#define FIRST_START_HOLD_100K_TICKS	22
-#define FIRST_START_HOLD_400K_TICKS	16
-#define FIRST_START_HOLD_1000K_TICKS	6
+#define FIRST_START_HOLD_100K_TICKS	23
+#define FIRST_START_HOLD_400K_TICKS	8
+#define FIRST_START_HOLD_1000K_TICKS	12
 
 /*
  * STOP_SETUP_XK_TICKS will indicate the number of ticks of the baud clock
  * required to program 'STOP_SETUP' timer at X KHz. This timer determines the
  * SDAT setup time from the rising edge of SCLK for a STOP condition.
  */
-#define STOP_SETUP_100K_TICKS		157
+#define STOP_SETUP_100K_TICKS		150
 #define STOP_SETUP_400K_TICKS		20
-#define STOP_SETUP_1000K_TICKS	12
+#define STOP_SETUP_1000K_TICKS		12
 
 /*
  * RESTART_SETUP_XK_TICKS will indicate the number of ticks of the baud clock
  * required to program 'RESTART_SETUP' timer at X KHz. This timer determines the
  * SDAT setup time from the rising edge of SCLK for a repeated START condition.
  */
-#define RESTART_SETUP_100K_TICKS	157
+#define RESTART_SETUP_100K_TICKS	156
 #define RESTART_SETUP_400K_TICKS	20
 #define RESTART_SETUP_1000K_TICKS	12
 
@@ -169,7 +169,7 @@
  * required to program 'DATA_HOLD' timer at X KHz. This timer determines the
  * SDAT hold time following SCLK driven low.
  */
-#define DATA_HOLD_100K_TICKS		2
+#define DATA_HOLD_100K_TICKS		12
 #define DATA_HOLD_400K_TICKS		2
 #define DATA_HOLD_1000K_TICKS		2
 
@@ -190,35 +190,35 @@
  * Bus Idle Minimum time = BUS_IDLE_MIN[7:0] x Baud_Clock_Period x
  * (BUS_IDLE_MIN_XK_TICKS[7] ? 4,1)
  */
-#define BUS_IDLE_MIN_100K_TICKS		167UL
-#define BUS_IDLE_MIN_400K_TICKS		139UL
-#define BUS_IDLE_MIN_1000K_TICKS		133UL
+#define BUS_IDLE_MIN_100K_TICKS		36UL
+#define BUS_IDLE_MIN_400K_TICKS		10UL
+#define BUS_IDLE_MIN_1000K_TICKS	4UL
 
 /*
  * CTRL_CUM_TIME_OUT_XK_TICKS defines SMBus Controller Cumulative Time-Out.
  * SMBus Controller Cumulative Time-Out duration =
  * CTRL_CUM_TIME_OUT_XK_TICKS[7:0] x Baud_Clock_Period x 2048
  */
-#define CTRL_CUM_TIME_OUT_100K_TICKS		159
-#define CTRL_CUM_TIME_OUT_400K_TICKS		159
-#define CTRL_CUM_TIME_OUT_1000K_TICKS		159
+#define CTRL_CUM_TIME_OUT_100K_TICKS		76
+#define CTRL_CUM_TIME_OUT_400K_TICKS		76
+#define CTRL_CUM_TIME_OUT_1000K_TICKS		76
 
 /*
  * TARGET_CUM_TIME_OUT_XK_TICKS defines SMBus Target Cumulative Time-Out duration.
  * SMBus Target Cumulative Time-Out duration = TARGET_CUM_TIME_OUT_XK_TICKS[7:0] x
  * Baud_Clock_Period x 4096
  */
-#define TARGET_CUM_TIME_OUT_100K_TICKS	199
-#define TARGET_CUM_TIME_OUT_400K_TICKS	199
-#define TARGET_CUM_TIME_OUT_1000K_TICKS	199
+#define TARGET_CUM_TIME_OUT_100K_TICKS	95
+#define TARGET_CUM_TIME_OUT_400K_TICKS	95
+#define TARGET_CUM_TIME_OUT_1000K_TICKS	95
 
 /*
  * CLOCK_HIGH_TIME_OUT_XK defines Clock High time out period.
  * Clock High time out period = CLOCK_HIGH_TIME_OUT_XK[7:0] x Baud_Clock_Period x 8
  */
-#define CLOCK_HIGH_TIME_OUT_100K_TICKS	204
-#define CLOCK_HIGH_TIME_OUT_400K_TICKS	204
-#define CLOCK_HIGH_TIME_OUT_1000K_TICKS	204
+#define CLOCK_HIGH_TIME_OUT_100K_TICKS	97
+#define CLOCK_HIGH_TIME_OUT_400K_TICKS	97
+#define CLOCK_HIGH_TIME_OUT_1000K_TICKS	97
 
 #define TO_SCALING_100K		\
 	((BUS_IDLE_MIN_100K_TICKS << 24) | (CTRL_CUM_TIME_OUT_100K_TICKS << 16) | \
-- 
2.39.2



