Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69CC68D822
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjBGNGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjBGNGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:06:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEC13B653
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0531C61405
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18080C433D2;
        Tue,  7 Feb 2023 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775131;
        bh=CYFQnn3biJ0HCKTJBtsmSFwTgBIf/HXY+qDFM2MA6qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilCgwAQpjgv++hv6kDXRqgeNGVX2+aB+sdyPeUc/1oAe8qmmOt7gopwt/pLp6vB19
         AcpjhuPGl+Zoe2UdVYH8ogdHOe/GdAEN6qRt7pU+ktIQuiYysHqV3Sjt/v9svHXJJC
         LGbqMB3wtQAf2tBvwlMN7tWcEHg5BpCSl9adSLeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 118/208] ARM: dts: imx7d-smegw01: Fix USB host over-current polarity
Date:   Tue,  7 Feb 2023 13:56:12 +0100
Message-Id: <20230207125639.741905130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 1febf88ef907b142fdde34f7c64ed3535d9339e4 upstream.

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
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx7d-smegw01.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-smegw01.dts b/arch/arm/boot/dts/imx7d-smegw01.dts
index 546268b8d0b1..c0f00f5db11e 100644
--- a/arch/arm/boot/dts/imx7d-smegw01.dts
+++ b/arch/arm/boot/dts/imx7d-smegw01.dts
@@ -198,6 +198,7 @@
 &usbotg2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbotg2>;
+	over-current-active-low;
 	dr_mode = "host";
 	status = "okay";
 };
@@ -374,7 +375,7 @@
 
 	pinctrl_usbotg2: usbotg2grp {
 		fsl,pins = <
-			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x04
+			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x5c
 		>;
 	};
 
-- 
2.39.1



