Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837CC106B04
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKVKkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbfKVKkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDC92072E;
        Fri, 22 Nov 2019 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419238;
        bh=F7RTstoBj9MhJlraUZgCHS4+eqaNUQ8PVRe/l/A7ptg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEiEGvK2WPLyjnKzUeOdOVYOab3gWFnjER3hlIC/XDIr05RtQnTiDr2LuneFCsDsR
         MO9T8YRsMKHi9jUDjV0WNHcJVV292tGWXNQxJ+Q9c+DEJzSe+NUg75wM8bi4H00EUO
         icfuBd68o86Xm/X9e5qlRJ8sNjC5T/Hx076rJ1wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 044/222] ARM: dts: omap3-gta04: fixes for tvout / venc
Date:   Fri, 22 Nov 2019 11:26:24 +0100
Message-Id: <20191122100852.080374655@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit f6591391373dbff2c0200e1055d4ff86191578d2 ]

* fix connector compatibility (composite)
* add comment for gpio1 23
* add proper #address-cells
* we use only one venc_out channel for composite

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 95c6ac44e307f..67b50dbe28189 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -122,7 +122,7 @@
 	};
 
 	tv0: connector {
-		compatible = "svideo-connector";
+		compatible = "composite-video-connector";
 		label = "tv";
 
 		port {
@@ -134,7 +134,7 @@
 
 	tv_amp: opa362 {
 		compatible = "ti,opa362";
-		enable-gpios = <&gpio1 23 GPIO_ACTIVE_HIGH>;
+		enable-gpios = <&gpio1 23 GPIO_ACTIVE_HIGH>;	/* GPIO_23 to enable video out amplifier */
 
 		ports {
 			#address-cells = <1>;
@@ -539,10 +539,14 @@
 
 	vdda-supply = <&vdac>;
 
+	#address-cells = <1>;
+	#size-cells = <0>;
+
 	port {
+		reg = <0>;
 		venc_out: endpoint {
 			remote-endpoint = <&opa_in>;
-			ti,channels = <2>;
+			ti,channels = <1>;
 			ti,invert-polarity;
 		};
 	};
-- 
2.20.1



