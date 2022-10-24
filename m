Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632F860B33B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiJXRAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJXQ62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:58:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770373E777;
        Mon, 24 Oct 2022 08:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2DF9B811E7;
        Mon, 24 Oct 2022 11:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4613AC433C1;
        Mon, 24 Oct 2022 11:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612798;
        bh=m13IFTUaEZZ3IJYKl4KRUETJ2GzfudCnvdR4i1l9oaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqEbLNyAPCTEwuAFuaX3eekFLcL0S1oIz+RLtdlcknsqZgvAt/AavZudW850fudZF
         ooVuuwcQOHABYyC5jKdcLMJWuhPmN/dphp+/q8fiRhE49A0HI2zXoRjX93YmFZCtSb
         RjhziRO5E2nvCsXgmxi+4UYgvaVYAeiQFE7743ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/229] ARM: dts: exynos: fix polarity of VBUS GPIO of Origen
Date:   Mon, 24 Oct 2022 13:30:35 +0200
Message-Id: <20221024113002.753802574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit a08137bd1e0a7ce951dce9ce4a83e39d379b6e1b ]

EHCI Oxynos (drivers/usb/host/ehci-exynos.c) drives VBUS GPIO high when
trying to power up the bus, therefore the GPIO in DTS must be marked as
"active high". This will be important when EHCI driver is converted to
gpiod API that respects declared polarities.

Fixes: 4e8991def565 ("ARM: dts: exynos: Enable AX88760 USB hub on Origen board")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20220927220504.3744878-1-dmitry.torokhov@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-origen.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 346f71932457..e5bfa76185a2 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -87,7 +87,7 @@
 };
 
 &ehci {
-	samsung,vbus-gpio = <&gpx3 5 1>;
+	samsung,vbus-gpio = <&gpx3 5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
 	port@1 {
-- 
2.35.1



