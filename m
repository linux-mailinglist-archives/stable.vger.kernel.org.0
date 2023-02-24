Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90A76A1415
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 01:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBXAEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 19:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBXAEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 19:04:24 -0500
Received: from thorn.bewilderbeest.net (thorn.bewilderbeest.net [IPv6:2605:2700:0:5::4713:9cab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFED5BBAE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 16:04:16 -0800 (PST)
Received: from hatter.bewilderbeest.net (174-21-161-58.tukw.qwest.net [174.21.161.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: zev)
        by thorn.bewilderbeest.net (Postfix) with ESMTPSA id ADB684228;
        Thu, 23 Feb 2023 16:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bewilderbeest.net;
        s=thorn; t=1677197051;
        bh=SVvuc4nE5AlFPl8sNCRV4mTme19ET0laznkxlRxM+Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD9X4h7zNd8khM2nvt6c3AjBC/gs7VCbGTNIANnCs+IxnaVroeCZ9rd+6wrFR4vdm
         bfUg70n8UCqhVMJriV6k+6i7SCWHsQFqT7Cl6NdQ19a9aD6hM3vEv9SuEE4MZSrzsQ
         xbCNC4a3Puta97EcnRYnFSyAvj5rrAqKBl7AohjU=
From:   Zev Weiss <zev@bewilderbeest.net>
To:     Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.id.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, stable@vger.kernel.org
Subject: [PATCH v2 3/3] ARM: dts: aspeed: asrock: Correct firmware flash SPI clocks
Date:   Thu, 23 Feb 2023 16:04:00 -0800
Message-Id: <20230224000400.12226-4-zev@bewilderbeest.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224000400.12226-1-zev@bewilderbeest.net>
References: <20230224000400.12226-1-zev@bewilderbeest.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While I'm not aware of any problems that have occurred running these
at 100 MHz, the official word from ASRock is that 50 MHz is the
correct speed to use, so let's be safe and use that instead.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@vger.kernel.org
Fixes: 2b81613ce417 ("ARM: dts: aspeed: Add ASRock E3C246D4I BMC")
Fixes: a9a3d60b937a ("ARM: dts: aspeed: Add ASRock ROMED8HM3 BMC")
---
 arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts | 2 +-
 arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
index 67a75aeafc2b..c4b2efbfdf56 100644
--- a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
@@ -63,7 +63,7 @@ flash@0 {
 		status = "okay";
 		m25p,fast-read;
 		label = "bmc";
-		spi-max-frequency = <100000000>; /* 100 MHz */
+		spi-max-frequency = <50000000>; /* 50 MHz */
 #include "openbmc-flash-layout.dtsi"
 	};
 };
diff --git a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts b/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
index 00efe1a93a69..4554abf0c7cd 100644
--- a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
@@ -51,7 +51,7 @@ flash@0 {
 		status = "okay";
 		m25p,fast-read;
 		label = "bmc";
-		spi-max-frequency = <100000000>; /* 100 MHz */
+		spi-max-frequency = <50000000>; /* 50 MHz */
 #include "openbmc-flash-layout-64.dtsi"
 	};
 };
-- 
2.39.1.438.gdcb075ea9396.dirty

