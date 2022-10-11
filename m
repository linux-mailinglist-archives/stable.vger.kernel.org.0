Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E982F5FB662
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiJKPEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiJKPDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA9EA4B8A;
        Tue, 11 Oct 2022 07:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E469611DF;
        Tue, 11 Oct 2022 14:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251F5C433D6;
        Tue, 11 Oct 2022 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500041;
        bh=8WrLiAaN2f6wpV8GCLNnPxL7lrDtRcB5ZCim2x89qrc=;
        h=From:To:Cc:Subject:Date:From;
        b=ctB4SSYGJMF0NJXMiaUqJZxk54jzgLa3aTlINRg9xaOZ56hhvn1lTF3BP4IGy5Bq0
         S/qvj4XDdkilVKXBYnI/RwYBiR4Buvbezp5yESfGP7ssPGmfS70uFhHBowCwSyjUrZ
         FHjZpq7IddwDFQbkv3t2cC+p5MRwQu+KZNs32w3j0Je4a0EfKzVEBgE5+3dHtsZWel
         23v8vI6pZoP2tUa7xoSRvtTyJ+gg8p7iKjA/atZaV/2MG1JgEAe7tpkdm4zlTLLgOh
         AiID2NRFziTHTJNtLef3qTOWRb1Vh6OoQHrn0wuTxVLW4AXcaRH9SqhnwXvvNjsqck
         NSYN26EVf0URg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/11] ARM: dts: imx7d-sdb: config the max pressure for tsc2046
Date:   Tue, 11 Oct 2022 10:53:48 -0400
Message-Id: <20221011145358.1624959-1-sashal@kernel.org>
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
index 317f1bcc56e2..bd2c3c8f4ebb 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -163,12 +163,7 @@ tsc2046@0 {
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

