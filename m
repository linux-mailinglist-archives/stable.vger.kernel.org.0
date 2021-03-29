Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744F334C834
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhC2IUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232339AbhC2IUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E659D61580;
        Mon, 29 Mar 2021 08:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006003;
        bh=IqcPHXLgtrtzAZhXUaILknZGz7KfL7ZOlFcg20FTnB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pLo6Ln6GI17YE1BJ7dGB4TrKHCAwAunhrZ/JiZoxyFVs8gYLWZgaCMJoBxOmmmTT
         qGuQkkaEqy3OGcU+HZsI9Oegs+Ilc694mj1A46gbrzA0siOE56X8z+a5MgWWtgpoxV
         7A2uOkmmXUIW6ZIL6kzvqkRZIYIAvTF6SBAQ75LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.10 082/221] ARM: dts: at91-sama5d27_som1: fix phy address to 7
Date:   Mon, 29 Mar 2021 09:56:53 +0200
Message-Id: <20210329075631.949909256@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 221c3a09ddf70a0a51715e6c2878d8305e95c558 upstream.

Fix the phy address to 7 for Ethernet PHY on SAMA5D27 SOM1. No
connection established if phy address 0 is used.

The board uses the 24 pins version of the KSZ8081RNA part, KSZ8081RNA
pin 16 REFCLK as PHYAD bit [2] has weak internal pull-down.  But at
reset, connected to PD09 of the MPU it's connected with an internal
pull-up forming PHYAD[2:0] = 7.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Fixes: 2f61929eb10a ("ARM: dts: at91: at91-sama5d27_som1: fix PHY ID")
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
@@ -84,8 +84,8 @@
 				pinctrl-0 = <&pinctrl_macb0_default>;
 				phy-mode = "rmii";
 
-				ethernet-phy@0 {
-					reg = <0x0>;
+				ethernet-phy@7 {
+					reg = <0x7>;
 					interrupt-parent = <&pioA>;
 					interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
 					pinctrl-names = "default";


