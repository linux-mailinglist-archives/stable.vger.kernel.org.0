Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48286689663
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbjBCK0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjBCKZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3419694
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C822061E53
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8401EC4339B;
        Fri,  3 Feb 2023 10:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419935;
        bh=JsiWS+7KNeSbTQQFXDvtXNQD3ONyxlL+PZH9zajMm1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OP6XVLs/2fM5i6I75M9+mJJ+W5Ktup16hg0S4SH47YprH6xHcHVK0ztuUnfRmiiwq
         pOSQg1Hc8JvtXTEzX6Or/9g0GKtMhHDHmPYYeuZGzC0Uqm2Zpf5ofWEWLPQqd1z8iG
         7qZ03qPhPeYbQJLF1Y+3oDsJttOxdZEDwXLQk9zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@denx.de>,
        Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/134] ARM: dts: imx6qdl-gw560x: Remove incorrect uart-has-rtscts
Date:   Fri,  3 Feb 2023 11:11:50 +0100
Message-Id: <20230203101024.105438792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 9dfbc72256b5de608ad10989bcbafdbbd1ac8d4e ]

The following build warning is seen when running:

make dtbs_check DT_SCHEMA_FILES=fsl-imx-uart.yaml

arch/arm/boot/dts/imx6dl-gw560x.dtb: serial@2020000: rts-gpios: False schema does not allow [[20, 1, 0]]
	From schema: Documentation/devicetree/bindings/serial/fsl-imx-uart.yaml

The imx6qdl-gw560x board does not expose the UART RTS and CTS
as native UART pins, so 'uart-has-rtscts' should not be used.

Using 'uart-has-rtscts' with 'rts-gpios' is an invalid combination
detected by serial.yaml.

Fix the problem by removing the incorrect 'uart-has-rtscts' property.

Fixes: b8a559feffb2 ("ARM: dts: imx: add Gateworks Ventana GW5600 support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
index e8e36dfd0a6b..c951834f4984 100644
--- a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
@@ -464,7 +464,6 @@ &ssi1 {
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-	uart-has-rtscts;
 	rts-gpios = <&gpio7 1 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
-- 
2.39.0



