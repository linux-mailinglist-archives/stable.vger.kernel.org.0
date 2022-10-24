Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC38360B9A7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiJXUQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiJXUQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:16:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F1D963BB;
        Mon, 24 Oct 2022 11:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15271B81145;
        Mon, 24 Oct 2022 11:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63989C433C1;
        Mon, 24 Oct 2022 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611867;
        bh=X12gymILKrBqN2UagWsYOuLELZwdwf54zxIm9HZty9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgX8DkCK23UCn7qWWCv68BuQCeHxFwLH9X1qJuSYy39eZQOHN7KrmBSQyssPRNVEV
         e8LKblkM96qmLMIbtxuK9zSAv46A3GUk5RFHLbhxay8eRfmS48OAjcj3YHbfmXoKOG
         5fSwSLU0mqO1G0wdU7WndHf+Pl1yc2s5munCdWKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 141/159] ARM: dts: imx7d-sdb: config the max pressure for tsc2046
Date:   Mon, 24 Oct 2022 13:31:35 +0200
Message-Id: <20221024112954.607235171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -126,12 +126,7 @@
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



