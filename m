Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884AD45C3EA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351081AbhKXNol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353543AbhKXNn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72719632CC;
        Wed, 24 Nov 2021 12:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758727;
        bh=n2QY9ZCzMQ5L/diKzzoUTzlNgTpWjhhgc9Cx+9G/Tvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJkFDLOd7Uv8Cu5auF66e/73h4ZcBfuQdnHcBTwJjE8R7Y4mtBtjS7xeifKHS8ro+
         e0P1CAhuh5W03YnLjBRq3s6w75+bu1MIjbXO5j1X1RJXQyfPkGZ/Clf2PouDu+LlJz
         9ioOkLU4S5+nMO1YicysqdAooxKbgMm73xrsKrqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/279] ARM: dts: NSP: Fix mpcore, mmc node names
Date:   Wed, 24 Nov 2021 12:54:57 +0100
Message-Id: <20211124115719.111324719@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 15a563d008ef9d04df525f0c476cd7d7127bb883 ]

Running dtbs_check yielded the issues with bcm-nsp.dtsi.

Firstly this patch fixes the following message by appending "-bus" to
the mpcore node name:
mpcore@19000000: $nodename:0: 'mpcore@19000000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Secondly mmc node name. The label name can remain as is.
sdhci@21000: $nodename:0: 'sdhci@21000' does not match '^mmc(@.*)?$'

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 748df7955ae67..e96ddb2e26e2c 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -77,7 +77,7 @@
 		interrupt-affinity = <&cpu0>, <&cpu1>;
 	};
 
-	mpcore@19000000 {
+	mpcore-bus@19000000 {
 		compatible = "simple-bus";
 		ranges = <0x00000000 0x19000000 0x00023000>;
 		#address-cells = <1>;
@@ -219,7 +219,7 @@
 			status = "disabled";
 		};
 
-		sdio: sdhci@21000 {
+		sdio: mmc@21000 {
 			compatible = "brcm,sdhci-iproc-cygnus";
 			reg = <0x21000 0x100>;
 			interrupts = <GIC_SPI 145 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.33.0



