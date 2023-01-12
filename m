Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC016673F9
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjALOBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjALOBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA94F517C5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:01:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F7E560AB3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9B6C433EF;
        Thu, 12 Jan 2023 14:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532063;
        bh=+8A78q1ww1z/NDjK3cqrITmEk/bJ489GwbL+JtnA1Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUpzgZTt/Cn/jgRrWAahOpE/jyGlzV18lgsw67u1Bx43m9gnzSVvB+kWXVQ+/1fHb
         TyY4IzwkujMT5qRyLP2NQeAOpop9PIB69D/uBXNpUYmjdufBtzIIprcK3kbzZ0h7Ym
         z7dRP/iNLJrNZFOG9e+tiPlWufYpeeZBJBbMq3zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/783] ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
Date:   Thu, 12 Jan 2023 14:45:26 +0100
Message-Id: <20230112135524.663240103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index f3e0c790a4b1..723b39bb2129 100644
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



