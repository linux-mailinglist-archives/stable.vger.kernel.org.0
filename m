Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14A64B49EF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbiBNKNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:13:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345925AbiBNKNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F4652FF;
        Mon, 14 Feb 2022 01:51:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EAF3B80DBF;
        Mon, 14 Feb 2022 09:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F4EC340E9;
        Mon, 14 Feb 2022 09:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832276;
        bh=7NkI57KdUooHsPfFBLSmpYBzUAiODq7o7Qw/s+3mQ6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL2crrUhWhdLJBvkVbFEpuFOboJFnLkTyMcd7S0qzbavm+FCfqwM82NnuFMLWQLp8
         X40T0E1yU11xp2Pge0BuAtoDvbSFgIW5Axd7BhzEcVYR91k8fOjt34C+9MwTZP4J7g
         5rNYwEB2CLsT0WO+v3FLvDXy5Ko3dfRsKVuEB9BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lutz Koschorreck <theleks@ko-hh.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/172] arm64: dts: meson-sm1-odroid: fix boot loop after reboot
Date:   Mon, 14 Feb 2022 10:26:01 +0100
Message-Id: <20220214092509.955632629@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lutz Koschorreck <theleks@ko-hh.de>

[ Upstream commit e6b03375132fefddc55cf700418cf794b3884e0c ]

Since the correct gpio pin is used for enabling tf-io regulator the
system did not boot correctly after calling reboot.

[   36.862443] reboot: Restarting system
bl31 reboot reason: 0xd
bl31 reboot reason: 0x0
system cmd  1.
SM1:BL:511f6b:81ca2f;FEAT:A0F83180:20282000;POC:B;RCY:0;SPINOR:0;CHK:1F;EMMC:800;NAND:81;SD?:0;SD:0;READ:0;0.0;CHK:0;
bl2_stage_init 0x01
bl2_stage_init 0x81
hw id:
SM1:BL:511f6b:81ca2f;FEAT:A0F83180:20282000;POC:B;RCY:0;SPINOR:0;CHK:1F;EMMC:800;NAND:81;SD?:0;SD:400;USB:8;LOOP:1;...

Setting the gpio to open drain solves the issue.

Fixes: 1f80a5cf74a6 ("arm64: dts: meson-sm1-odroid: add missing enable gpio and supply for tf_io regulator")
Signed-off-by: Lutz Koschorreck <theleks@ko-hh.de>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: reduced serial log & removed invalid character in commit message]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220128193150.GA1304381@odroid-VirtualBox
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index 328f4adfaaa9d..76ad052fbf0c9 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -48,7 +48,7 @@ tf_io: gpio-regulator-tf_io {
 		regulator-max-microvolt = <3300000>;
 		vin-supply = <&vcc_5v>;
 
-		enable-gpio = <&gpio_ao GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_OPEN_DRAIN>;
 		enable-active-high;
 		regulator-always-on;
 
-- 
2.34.1



