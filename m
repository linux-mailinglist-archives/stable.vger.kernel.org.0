Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18901330E17
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCHMfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhCHMep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DFB664EBC;
        Mon,  8 Mar 2021 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206884;
        bh=hpFS5Mt+/sKWEA++sZSRWAjmJI0iaLKwzasAjqc8TPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7CMXxy8xRrluJqSIDcgG+LdL5wmEy8dlIFmcVH5V8cL+JwWyvRrpjTLZEK5m44Pc
         U4b9ubvZ+rvUHYptDOXJWt/QwcpwRWfu/RXFb+FKFwfC79LYKFHNSevIHs8DewaSzR
         vkGZ8DoUPxMnMF1HDJIX9o5lR0CMB8H0IG6xxG+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Brunet?= <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.10 39/42] Revert "arm64: dts: amlogic: add missing ethernet reset ID"
Date:   Mon,  8 Mar 2021 13:31:05 +0100
Message-Id: <20210308122720.021070104@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 19f6fe976a61f9afc289b062b7ef67f99b72e7b9 upstream.

It has been reported on IRC and in KernelCI boot tests, this change breaks
internal PHY support on the Amlogic G12A/SM1 Based boards.

We suspect the added signal to reset more than the Ethernet MAC but also
the MDIO/(RG)MII mux used to redirect the MAC signals to the internal PHY.

This reverts commit f3362f0c18174a1f334a419ab7d567a36bd1b3f3 while we find
and acceptable solution to cleanly reset the Ethernet MAC.

Reported-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Jérôme Brunet <jbrunet@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20210126080951.2383740-1-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi        |    2 --
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi |    2 --
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi         |    3 ---
 3 files changed, 7 deletions(-)

--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -227,8 +227,6 @@
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			status = "disabled";
 		};
 
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -224,8 +224,6 @@
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			status = "disabled";
 
 			mdio0: mdio {
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -13,7 +13,6 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/power/meson-gxbb-power.h>
-#include <dt-bindings/reset/amlogic,meson-gxbb-reset.h>
 #include <dt-bindings/thermal/thermal.h>
 
 / {
@@ -576,8 +575,6 @@
 			interrupt-names = "macirq";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			power-domains = <&pwrc PWRC_GXBB_ETHERNET_MEM_ID>;
 			status = "disabled";
 		};


