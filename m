Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE040E772
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbhIPRcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353307AbhIPRa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF56061209;
        Thu, 16 Sep 2021 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810822;
        bh=CbVVI3u3x5LLD1m+rlXi6ZEpQUh2OoookAuquMzZ6qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBbRLaDz3ic/2lCu01gaiUOGJzNfrOaqAFUwrUN+TUbvav4L+MU4CGefwMUTxAvZ9
         mN0tIKvJQnn1W+yZ7XyNFw0GYvy3WBU0APYrEesSiy1KZGoU2nZioqc/lpuwgiBr24
         HyVgCDoNzF0O6lhV9saGFsvA2Qq2+7lJxsm9hNwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 281/432] ARM: dts: ixp4xx: Fix up bad interrupt flags
Date:   Thu, 16 Sep 2021 18:00:30 +0200
Message-Id: <20210916155820.334218413@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



