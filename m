Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458E944B675
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344580AbhKIW1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344153AbhKIWZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA3E61361;
        Tue,  9 Nov 2021 22:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496367;
        bh=n2QY9ZCzMQ5L/diKzzoUTzlNgTpWjhhgc9Cx+9G/Tvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikXYzuevYNZD5jTlB9etREq0UvjThzXze9S3f8smhgvbHg26PQW21phglW7pBK8NI
         niiZD0ych7+mIogFWbd9RhnCHZ4dCxpLENZ09yKhoeYj2oNG4XLBFIEnOcHvEejhgf
         XVzKErlMJO9Q75wI4Ir1ZisWa5Nn93HZXuFm9Ajx76XcWYP/RGlsODsx4hjVNVRJoR
         uXghLZbl+Ms7lwnxQlpdWev3OQ3PNOLsnKkKdq3Kv8QkfoUKv6SDrRzu1sqttWLCJC
         cr7uTrCWndZk4AnlqrxsO45Oaqy+X3iT2JpbEjwkM08iXsZVLllDnsA/+4b3tpeMux
         aLd+fUSqOM6xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, rjui@broadcom.com, sbranden@broadcom.com,
        jonmason@broadcom.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.14 10/75] ARM: dts: NSP: Fix mpcore, mmc node names
Date:   Tue,  9 Nov 2021 17:18:00 -0500
Message-Id: <20211109221905.1234094-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

