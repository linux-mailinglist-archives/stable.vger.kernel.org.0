Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9835A20E652
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgF2Vq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgF2Sft (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7CD5246B5;
        Mon, 29 Jun 2020 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444010;
        bh=FNpzwp1s02R1GjuXV+0y15viWvqFwwi/HZ1PMgAv9kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6p6hCOi6sSuJGX/d+wGwc7E8y5I+mBH5JVVAgjerUcrLAFWIAIezYW9nG6PtvgVr
         wHL1AiuvK2KCdXgmnXPPRxfl3SAyQ3ogziIy7r5/haE5+DAu7k80hV/p+fHqtqJiXi
         shkS1yVbwQ/PDY+0v3b1dFzAqIW2OJlIkQFkoCSM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 116/265] ARM: dts: NSP: Disable PL330 by default, add dma-coherent property
Date:   Mon, 29 Jun 2020 11:15:49 -0400
Message-Id: <20200629151818.2493727-117-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit b9dbe0101e344e8339406a11b7a91d4a0c50ad13 ]

Currently the PL330 is enabled by default. However if left in IDM reset, as is
the case with the Meraki and Synology NSP devices, the system will hang when
probing for the PL330's AMBA peripheral ID. We therefore should be able to
disable it in these cases.

The PL330 is also included among of the list of peripherals put into coherent
mode, so "dma-coherent" has been added here as well.

Fixes: 5fa1026a3e4d ("ARM: dts: NSP: Add PL330 support")
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi     | 4 +++-
 arch/arm/boot/dts/bcm958522er.dts  | 4 ++++
 arch/arm/boot/dts/bcm958525er.dts  | 4 ++++
 arch/arm/boot/dts/bcm958525xmc.dts | 4 ++++
 arch/arm/boot/dts/bcm958622hr.dts  | 4 ++++
 arch/arm/boot/dts/bcm958623hr.dts  | 4 ++++
 arch/arm/boot/dts/bcm958625hr.dts  | 4 ++++
 arch/arm/boot/dts/bcm958625k.dts   | 4 ++++
 8 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index da6d70f09ef19..920c0f561e5ce 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -200,7 +200,7 @@
 			status = "disabled";
 		};
 
-		dma@20000 {
+		dma: dma@20000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x20000 0x1000>;
 			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
@@ -215,6 +215,8 @@
 			clocks = <&iprocslow>;
 			clock-names = "apb_pclk";
 			#dma-cells = <1>;
+			dma-coherent;
+			status = "disabled";
 		};
 
 		sdio: sdhci@21000 {
diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index 8c388eb8a08f8..7be4c4e628e02 100644
--- a/arch/arm/boot/dts/bcm958522er.dts
+++ b/arch/arm/boot/dts/bcm958522er.dts
@@ -58,6 +58,10 @@
 
 /* USB 3 support needed to be complete */
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958525er.dts b/arch/arm/boot/dts/bcm958525er.dts
index c339771bb22e0..e58ed7e953460 100644
--- a/arch/arm/boot/dts/bcm958525er.dts
+++ b/arch/arm/boot/dts/bcm958525er.dts
@@ -58,6 +58,10 @@
 
 /* USB 3 support needed to be complete */
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958525xmc.dts b/arch/arm/boot/dts/bcm958525xmc.dts
index 1c72ec8288de4..716da62f57885 100644
--- a/arch/arm/boot/dts/bcm958525xmc.dts
+++ b/arch/arm/boot/dts/bcm958525xmc.dts
@@ -58,6 +58,10 @@
 
 /* XHCI support needed to be complete */
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index 96a021cebd97b..a49c2fd21f4a8 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -58,6 +58,10 @@
 
 /* USB 3 and SLIC support needed to be complete */
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index b2c7f21d471e6..dd6dff6452b87 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -58,6 +58,10 @@
 
 /* USB 3 and SLIC support needed to be complete */
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index 536fb24f38bb7..a71371b4065ed 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -69,6 +69,10 @@
 	status = "okay";
 };
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 3fcca12d83c2d..7b84b54436edd 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -48,6 +48,10 @@
 	};
 };
 
+&dma {
+	status = "okay";
+};
+
 &amac0 {
 	status = "okay";
 };
-- 
2.25.1

