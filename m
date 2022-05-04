Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387D051A8EC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355701AbiEDRQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356035AbiEDRI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91020527E9;
        Wed,  4 May 2022 09:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F60B8278E;
        Wed,  4 May 2022 16:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9CC385A5;
        Wed,  4 May 2022 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683287;
        bh=xCx+GlsVxmY/H4CVNQZ7axuhJ5gW967unc+iX5+XCBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ANigu09cuqp4P+AcIcoCDKNY4qB2sII/n+I/dSmCXPvZzvX0MRKg6Hynt46SIYL5
         I9Nykpzt/pJ2ZwUaYXrm/+7+9PEj7uRLxqmcHnjZALfz9JXbFfACBaYyhq20RGESmp
         dCnTp8DKwFPBeS7dC9h9+HMSmH4L+39pTyoABOu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 153/177] ARM: dts: imx8mm-venice-gw{71xx,72xx,73xx}: fix OTG controller OC mode
Date:   Wed,  4 May 2022 18:45:46 +0200
Message-Id: <20220504153107.086817776@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

commit 4c79865f3e8a2db93ec1e844509edfebe5a6ae56 upstream.

The GW71xx, GW72xx and GW73xx boards have USB1 routed to a USB OTG
connectors and USB2 routed to a USB hub.

The OTG connector has a over-currently protection with an active-low
pin and the USB1 to HUB connection has no over-current protection (as
the HUB itself implements this for its downstream ports).

Add proper dt nodes to specify the over-current pin polarity for USB1
and disable over-current protection for USB2.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi |    2 ++
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi |    2 ++
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi |    2 ++
 3 files changed, 6 insertions(+)

--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -103,12 +103,14 @@
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	status = "okay";
 };
 
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -139,12 +139,14 @@
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	vbus-supply = <&reg_usb_otg2_vbus>;
 	status = "okay";
 };
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -166,12 +166,14 @@
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	vbus-supply = <&reg_usb_otg2_vbus>;
 	status = "okay";
 };


