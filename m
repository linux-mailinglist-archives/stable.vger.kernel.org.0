Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C323A6DA
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHCMzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbgHCMWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CACE204EC;
        Mon,  3 Aug 2020 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457364;
        bh=jszrOfa5nKzHqEo0F+i0vxWlMIXxIz6UnwpnWJDRnB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcrcKRDq7ODtj/xHMC5+HC5D6bNQIc9+NLtLc4mOLtzabarlmFVKioieTpvG1KZ0L
         DQkITFrlqHtHR9GnW6jJ4ZoMlqd/vUtatv5eOhGJCZN0kwZAO/yM6x8IM95StxN1SA
         bPV5Y0IVHHQ0KyDrqgsZfk6bn4YcpcVbNyo8k8zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 041/120] ARM: dts: armada-38x: fix NETA lockup when repeatedly switching speeds
Date:   Mon,  3 Aug 2020 14:18:19 +0200
Message-Id: <20200803121904.816816539@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 09781ba0395c46b1c844f47e405e3ce7856f5989 ]

To support the change in "phy: armada-38x: fix NETA lockup when
repeatedly switching speeds" we need to update the DT with the
additional register.

Fixes: 14dc100b4411 ("phy: armada38x: add common phy support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-38x.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index e038abc0c6b40..420ae26e846b6 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -344,7 +344,8 @@
 
 			comphy: phy@18300 {
 				compatible = "marvell,armada-380-comphy";
-				reg = <0x18300 0x100>;
+				reg-names = "comphy", "conf";
+				reg = <0x18300 0x100>, <0x18460 4>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 
-- 
2.25.1



