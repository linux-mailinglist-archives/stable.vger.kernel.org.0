Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CB25FB68E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiJKPHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiJKPGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:06:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39F9A9DC;
        Tue, 11 Oct 2022 08:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00C08CE1894;
        Tue, 11 Oct 2022 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5011BC433C1;
        Tue, 11 Oct 2022 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500068;
        bh=ZKqdnQMa/+2RfkAcTiUU4Xus5d98+Iw5gHIgLSwoHH0=;
        h=From:To:Cc:Subject:Date:From;
        b=OVHJje8+lundF99pG4DEMAOcSarxF2O7nqcbFIqbIdKi36obxrZDBQ3ayeWIg5hld
         Bi1IRFt6NruAM9l1DCZy0e/MPtBK6Rt/fz9YyngBWqwYL1/YdhLw/t4bZgnZ27VIPL
         +2MNUzjEvgmE1pjlE8Ytp9wprkT2F5niem/ukiZf3UxpklGD2KggO2OPPr3yhjJEn4
         3Ykr/PQuYu8aI3fWNN1EZI+1Rz8Z5w2JYpyfjOPyhtFgHihYUQ1H3v0nj/jL3yv4Vg
         pMltDzCcuaxvpciZ5r6TZL9/okQ+rS39SwnGnVzn/NHjvWx87A6Uw2NBfUvsUl9odS
         5SOJzUt5uQebw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 1/6] ARM: dts: imx7d-sdb: config the max pressure for tsc2046
Date:   Tue, 11 Oct 2022 10:54:20 -0400
Message-Id: <20221011145425.1625494-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit e7c4ebe2f9cd68588eb24ba4ed122e696e2d5272 ]

Use the general touchscreen method to config the max pressure for
touch tsc2046(data sheet suggest 8 bit pressure), otherwise, for
ABS_PRESSURE, when config the same max and min value, weston will
meet the following issue,

[17:19:39.183] event1  - ADS7846 Touchscreen: is tagged by udev as: Touchscreen
[17:19:39.183] event1  - ADS7846 Touchscreen: kernel bug: device has min == max on ABS_PRESSURE
[17:19:39.183] event1  - ADS7846 Touchscreen: was rejected
[17:19:39.183] event1  - not using input device '/dev/input/event1'

This will then cause the APP weston-touch-calibrator can't list touch devices.

root@imx6ul7d:~# weston-touch-calibrator
could not load cursor 'dnd-move'
could not load cursor 'dnd-copy'
could not load cursor 'dnd-none'
No devices listed.

And accroding to binding Doc, "ti,x-max", "ti,y-max", "ti,pressure-max"
belong to the deprecated properties, so remove them. Also for "ti,x-min",
"ti,y-min", "ti,x-plate-ohms", the value set in dts equal to the default
value in driver, so are redundant, also remove here.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-sdb.dts | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d-sdb.dts b/arch/arm/boot/dts/imx7d-sdb.dts
index 2f33c463cbce..83867357f135 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -126,12 +126,7 @@ tsc2046@0 {
 		interrupt-parent = <&gpio2>;
 		interrupts = <29 0>;
 		pendown-gpio = <&gpio2 29 GPIO_ACTIVE_HIGH>;
-		ti,x-min = /bits/ 16 <0>;
-		ti,x-max = /bits/ 16 <0>;
-		ti,y-min = /bits/ 16 <0>;
-		ti,y-max = /bits/ 16 <0>;
-		ti,pressure-max = /bits/ 16 <0>;
-		ti,x-plate-ohms = /bits/ 16 <400>;
+		touchscreen-max-pressure = <255>;
 		wakeup-source;
 	};
 };
-- 
2.35.1

