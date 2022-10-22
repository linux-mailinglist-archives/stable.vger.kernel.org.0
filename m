Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38666087F0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiJVIH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiJVIGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:06:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7032C6E1F;
        Sat, 22 Oct 2022 00:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13192B82E2C;
        Sat, 22 Oct 2022 07:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C711C433C1;
        Sat, 22 Oct 2022 07:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425036;
        bh=ai7WfVWVVq/rsQxbxqD2P3T55B+WLzqUqFD0GQQ004k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6dlImjyRRGoTafyrybcRYHprtNp7yNZtITMA6KbMwzoR4m6nm2FgAdFASGJTt7vR
         LQjtzxMBIgCYPtZdyCbm6e/J/+yK49KOkRO6KKE3la/ta4TzA0QYptyLrthmaGp92q
         WlrHBNyn0MU94/5Xc5i7X+4f/Re3DsR1DKRTUvOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 369/717] ARM: dts: exynos: fix polarity of VBUS GPIO of Origen
Date:   Sat, 22 Oct 2022 09:24:08 +0200
Message-Id: <20221022072513.004199583@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 6db09dba07ff..a3905e27b9cd 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -95,7 +95,7 @@
 };
 
 &ehci {
-	samsung,vbus-gpio = <&gpx3 5 1>;
+	samsung,vbus-gpio = <&gpx3 5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 	phys = <&exynos_usbphy 2>, <&exynos_usbphy 3>;
 	phy-names = "hsic0", "hsic1";
-- 
2.35.1



