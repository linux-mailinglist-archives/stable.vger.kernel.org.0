Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE6657960
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiL1PAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiL1PAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36412ABF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828C861130
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F4DC433F0;
        Wed, 28 Dec 2022 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239613;
        bh=jV+jo97mkdKvm8iSkp3Cpt/piH5zPWbhM9ZmxXg4gDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9XexnGcpaHMvbCvmz7OUap7oyUM4gGpyEe7thf6BRT0fmu1n7/mi1EuWwTJ0z5gz
         BiLXc5NIBRR2sytkRnf/Vq8AxXGZyOhMcXKhC4/UXl4L1CDpuap4qHCNlAVmiRzEvk
         EXpGhM+UrKzWCSqq7SROjhpY92feYzIEewuOnDHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0019/1146] ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
Date:   Wed, 28 Dec 2022 15:25:58 +0100
Message-Id: <20221228144330.694034563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit d5d577e3d50713ad11d98dbdaa48bb494346c26d ]

The WLAN regulator uses 'gpios' property instead of 'gpio' to specify
regulator enable GPIO. While the former is also currently handled by
the Linux kernel regulator-fixed driver, the later is the correct one
per DT bindings. Update the DT to use the later.

Fixes: 7dd5cbba42c93 ("ARM: dts: stm32: Enable WiFi on AV96")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 90933077d66d..b6957cbdeff5 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -100,7 +100,7 @@ wlan_pwr: regulator-wlan {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpios = <&gpioz 3 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpioz 3 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.35.1



