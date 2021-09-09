Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1886A404B8B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhIILws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238776AbhIILus (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30F861211;
        Thu,  9 Sep 2021 11:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187836;
        bh=CbVVI3u3x5LLD1m+rlXi6ZEpQUh2OoookAuquMzZ6qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QclNTWN4aRJeyaHJxsoM3lDDc03+FesSSM2gBVD79oveBupRouitljz/mS3lI6KtP
         FsWklszgPvuHymGQATQjPB9A22K1E7jSGF3w/8NflHL/A3UyTJMj4wZyvnfChOhytW
         m4D0pb+/xmXceUTeR5fyTYIZadePKhipErfwtm7eg/0Rsp4htMCmZKKaSll5tuM7Ev
         +99V7QMmyQb0KUZXMQ2uAEGfB4E4G8PGz4gz03mLrLLqlHJGFD9O/kzATb/iMAKAGr
         7K8uM26wkZ+tgK+JOxxQS3wkf2UtbmzrY7NY/+75j5gBphf3j3u6FTpbVHBs/8Q6sd
         BYYf9OC+AZD0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 131/252] ARM: dts: ixp4xx: Fix up bad interrupt flags
Date:   Thu,  9 Sep 2021 07:39:05 -0400
Message-Id: <20210909114106.141462-131-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit f775d2150cb48bece63270fdefc2a0c69cf17f0f ]

The PCI hosts had bad IRQ semantics, these are all active low.
Use the proper define and fix all in-tree users.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/intel-ixp42x-linksys-nslu2.dts   | 24 +++++-----
 .../dts/intel-ixp43x-gateworks-gw2358.dts     | 48 +++++++++----------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/boot/dts/intel-ixp42x-linksys-nslu2.dts b/arch/arm/boot/dts/intel-ixp42x-linksys-nslu2.dts
index 5b8dcc19deee..b9a5268fe7ad 100644
--- a/arch/arm/boot/dts/intel-ixp42x-linksys-nslu2.dts
+++ b/arch/arm/boot/dts/intel-ixp42x-linksys-nslu2.dts
@@ -124,20 +124,20 @@ pci@c0000000 {
 			 */
 			interrupt-map =
 			/* IDSEL 1 */
-			<0x0800 0 0 1 &gpio0 11 3>, /* INT A on slot 1 is irq 11 */
-			<0x0800 0 0 2 &gpio0 10 3>, /* INT B on slot 1 is irq 10 */
-			<0x0800 0 0 3 &gpio0 9  3>, /* INT C on slot 1 is irq 9 */
-			<0x0800 0 0 4 &gpio0 8  3>, /* INT D on slot 1 is irq 8 */
+			<0x0800 0 0 1 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 1 is irq 11 */
+			<0x0800 0 0 2 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 1 is irq 10 */
+			<0x0800 0 0 3 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 1 is irq 9 */
+			<0x0800 0 0 4 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 1 is irq 8 */
 			/* IDSEL 2 */
-			<0x1000 0 0 1 &gpio0 10 3>, /* INT A on slot 2 is irq 10 */
-			<0x1000 0 0 2 &gpio0 9  3>, /* INT B on slot 2 is irq 9 */
-			<0x1000 0 0 3 &gpio0 11 3>, /* INT C on slot 2 is irq 11 */
-			<0x1000 0 0 4 &gpio0 8  3>, /* INT D on slot 2 is irq 8 */
+			<0x1000 0 0 1 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 2 is irq 10 */
+			<0x1000 0 0 2 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 2 is irq 9 */
+			<0x1000 0 0 3 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 2 is irq 11 */
+			<0x1000 0 0 4 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 2 is irq 8 */
 			/* IDSEL 3 */
-			<0x1800 0 0 1 &gpio0 9  3>, /* INT A on slot 3 is irq 9 */
-			<0x1800 0 0 2 &gpio0 11 3>, /* INT B on slot 3 is irq 11 */
-			<0x1800 0 0 3 &gpio0 10 3>, /* INT C on slot 3 is irq 10 */
-			<0x1800 0 0 4 &gpio0 8  3>; /* INT D on slot 3 is irq 8 */
+			<0x1800 0 0 1 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 3 is irq 9 */
+			<0x1800 0 0 2 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 3 is irq 11 */
+			<0x1800 0 0 3 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 3 is irq 10 */
+			<0x1800 0 0 4 &gpio0 8  IRQ_TYPE_LEVEL_LOW>; /* INT D on slot 3 is irq 8 */
 		};
 
 		ethernet@c8009000 {
diff --git a/arch/arm/boot/dts/intel-ixp43x-gateworks-gw2358.dts b/arch/arm/boot/dts/intel-ixp43x-gateworks-gw2358.dts
index 60a1228a970f..f5fe309f7762 100644
--- a/arch/arm/boot/dts/intel-ixp43x-gateworks-gw2358.dts
+++ b/arch/arm/boot/dts/intel-ixp43x-gateworks-gw2358.dts
@@ -108,35 +108,35 @@ pci@c0000000 {
 			 */
 			interrupt-map =
 			/* IDSEL 1 */
-			<0x0800 0 0 1 &gpio0 11 3>, /* INT A on slot 1 is irq 11 */
-			<0x0800 0 0 2 &gpio0 10 3>, /* INT B on slot 1 is irq 10 */
-			<0x0800 0 0 3 &gpio0 9  3>, /* INT C on slot 1 is irq 9 */
-			<0x0800 0 0 4 &gpio0 8  3>, /* INT D on slot 1 is irq 8 */
+			<0x0800 0 0 1 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 1 is irq 11 */
+			<0x0800 0 0 2 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 1 is irq 10 */
+			<0x0800 0 0 3 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 1 is irq 9 */
+			<0x0800 0 0 4 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 1 is irq 8 */
 			/* IDSEL 2 */
-			<0x1000 0 0 1 &gpio0 10 3>, /* INT A on slot 2 is irq 10 */
-			<0x1000 0 0 2 &gpio0 9  3>, /* INT B on slot 2 is irq 9 */
-			<0x1000 0 0 3 &gpio0 8  3>, /* INT C on slot 2 is irq 8 */
-			<0x1000 0 0 4 &gpio0 11 3>, /* INT D on slot 2 is irq 11 */
+			<0x1000 0 0 1 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 2 is irq 10 */
+			<0x1000 0 0 2 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 2 is irq 9 */
+			<0x1000 0 0 3 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 2 is irq 8 */
+			<0x1000 0 0 4 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 2 is irq 11 */
 			/* IDSEL 3 */
-			<0x1800 0 0 1 &gpio0 9  3>, /* INT A on slot 3 is irq 9 */
-			<0x1800 0 0 2 &gpio0 8  3>, /* INT B on slot 3 is irq 8 */
-			<0x1800 0 0 3 &gpio0 11 3>, /* INT C on slot 3 is irq 11 */
-			<0x1800 0 0 4 &gpio0 10 3>, /* INT D on slot 3 is irq 10 */
+			<0x1800 0 0 1 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 3 is irq 9 */
+			<0x1800 0 0 2 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 3 is irq 8 */
+			<0x1800 0 0 3 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 3 is irq 11 */
+			<0x1800 0 0 4 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 3 is irq 10 */
 			/* IDSEL 4 */
-			<0x2000 0 0 1 &gpio0 8  3>, /* INT A on slot 3 is irq 8 */
-			<0x2000 0 0 2 &gpio0 11 3>, /* INT B on slot 3 is irq 11 */
-			<0x2000 0 0 3 &gpio0 10 3>, /* INT C on slot 3 is irq 10 */
-			<0x2000 0 0 4 &gpio0 9  3>, /* INT D on slot 3 is irq 9 */
+			<0x2000 0 0 1 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 3 is irq 8 */
+			<0x2000 0 0 2 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 3 is irq 11 */
+			<0x2000 0 0 3 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 3 is irq 10 */
+			<0x2000 0 0 4 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 3 is irq 9 */
 			/* IDSEL 6 */
-			<0x3000 0 0 1 &gpio0 10 3>, /* INT A on slot 3 is irq 10 */
-			<0x3000 0 0 2 &gpio0 9  3>, /* INT B on slot 3 is irq 9 */
-			<0x3000 0 0 3 &gpio0 8  3>, /* INT C on slot 3 is irq 8 */
-			<0x3000 0 0 4 &gpio0 11 3>, /* INT D on slot 3 is irq 11 */
+			<0x3000 0 0 1 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 3 is irq 10 */
+			<0x3000 0 0 2 &gpio0 9  IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 3 is irq 9 */
+			<0x3000 0 0 3 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 3 is irq 8 */
+			<0x3000 0 0 4 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT D on slot 3 is irq 11 */
 			/* IDSEL 15 */
-			<0x7800 0 0 1 &gpio0 8  3>, /* INT A on slot 3 is irq 8 */
-			<0x7800 0 0 2 &gpio0 11 3>, /* INT B on slot 3 is irq 11 */
-			<0x7800 0 0 3 &gpio0 10 3>, /* INT C on slot 3 is irq 10 */
-			<0x7800 0 0 4 &gpio0 9  3>; /* INT D on slot 3 is irq 9 */
+			<0x7800 0 0 1 &gpio0 8  IRQ_TYPE_LEVEL_LOW>, /* INT A on slot 3 is irq 8 */
+			<0x7800 0 0 2 &gpio0 11 IRQ_TYPE_LEVEL_LOW>, /* INT B on slot 3 is irq 11 */
+			<0x7800 0 0 3 &gpio0 10 IRQ_TYPE_LEVEL_LOW>, /* INT C on slot 3 is irq 10 */
+			<0x7800 0 0 4 &gpio0 9  IRQ_TYPE_LEVEL_LOW>; /* INT D on slot 3 is irq 9 */
 		};
 
 		ethernet@c800a000 {
-- 
2.30.2

