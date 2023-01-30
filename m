Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72B6681299
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbjA3OXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbjA3OWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:22:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCF93FF1B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 168C9B810C5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6986DC433D2;
        Mon, 30 Jan 2023 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088453;
        bh=TZ2l8vhywVHirnNwaO3I4uaoRq+4QC+PF8k0ul6JD60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pACfcAoZ7SU+oErUh7bjifobPfkCRk+DsQIsB/pyOgAYNmHDSqD91BznX7mx47g4L
         EXP6cP7mQqYtWyseVrgFL1MHVx2dhypcJRCBBmqTsCfijFU79bEDxxxjGqmhA9tmJE
         0gAWjVc+lCXRNKgfehHp2Baih1s+W7bhzohT9nmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/143] arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux
Date:   Mon, 30 Jan 2023 14:51:05 +0100
Message-Id: <20230130134307.227583398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 5225ba9db112ec4ed67da5e4d8b72e618573955e ]

Early hardware did not support hardware handshaking on the UART, but
final production hardware did.  When the hardware was updated the chip
select was changed to facilitate hardware handshaking on UART3.  Fix the
ecspi2 pin mux to eliminate a pin conflict with UART3 and allow the
EEPROM to operate again.

Fixes: 4ce01ce36d77 ("arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
index 5667009aae13..674a0ab8a539 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -70,7 +70,7 @@ sound {
 &ecspi2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_espi2>;
-	cs-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
+	cs-gpios = <&gpio5 13 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
 	eeprom@0 {
@@ -187,7 +187,7 @@ pinctrl_espi2: espi2grp {
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK		0x82
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI		0x82
 			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO		0x82
-			MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9		0x41
+			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13              0x41
 		>;
 	};
 
-- 
2.39.0



