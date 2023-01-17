Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2794666DC4E
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbjAQLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 06:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbjAQLZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 06:25:33 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3C212F
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 03:25:31 -0800 (PST)
Received: from localhost.localdomain (unknown [IPv6:2804:14c:485:4b69:397b:3f71:abf6:af24])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4340281F28;
        Tue, 17 Jan 2023 12:25:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673954730;
        bh=Gxz/xpYVmQiLx/EmncyxfyarbJ9K6Fv6Zw7Fla3nmEw=;
        h=From:To:Cc:Subject:Date:From;
        b=NxYCzA3CYaYXODoYe5fMUWT7HtdDT66vB0MqLFGapLK8Z5P79V4S98gABp3DXUymp
         Gwa0yAs/rrSYVzB+qwSyzNeg2e5HWF7WNaM+p3FLIkZPfQKNSump4BnmeqvER+J+Tf
         L55prsr1fjemKYhXXJaQwcUvJHrLIsE/jppMQiwhsj9OPqrMWb3koTLZ72CcJpDtmn
         AYiPgUQ2bZuV2oCWWK19diG62A5XUmKlF3tPdAzzo1+ay0ziuY/glFsKH+AG6lMSTk
         cLKzTXZO/+n8BMlr6S1WCDQiNj6GybWUR7FkGY0ZrpC/vz2MfzYqGVe8V07Gd08Rs6
         o13wQ6odtn7ug==
From:   Fabio Estevam <festevam@denx.de>
To:     shawnguo@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@denx.de>, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx7d-smegw01: Fix USB host over-current polarity
Date:   Tue, 17 Jan 2023 08:25:10 -0300
Message-Id: <20230117112510.109123-1-festevam@denx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, when resetting the USB modem via AT commands, the modem is
no longer re-connected.

This problem is caused by the incorrect description of the USB_OTG2_OC
pad. It should have pull-up enabled, hysteresis enabled and the
property 'over-current-active-low' should be passed.

With this change, the USB modem can be successfully re-connected
after a reset.

Cc: stable@vger.kernel.org
Fixes: 9ac0ae97e349 ("ARM: dts: imx7d-smegw01: Add support for i.MX7D SMEGW01 board")
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 arch/arm/boot/dts/imx7d-smegw01.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-smegw01.dts b/arch/arm/boot/dts/imx7d-smegw01.dts
index 546268b8d0b1..c0f00f5db11e 100644
--- a/arch/arm/boot/dts/imx7d-smegw01.dts
+++ b/arch/arm/boot/dts/imx7d-smegw01.dts
@@ -198,6 +198,7 @@ &usbotg1 {
 &usbotg2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbotg2>;
+	over-current-active-low;
 	dr_mode = "host";
 	status = "okay";
 };
@@ -374,7 +375,7 @@ MX7D_PAD_LPSR_GPIO1_IO05__GPIO1_IO5	0x04
 
 	pinctrl_usbotg2: usbotg2grp {
 		fsl,pins = <
-			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x04
+			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x5c
 		>;
 	};
 
-- 
2.25.1

