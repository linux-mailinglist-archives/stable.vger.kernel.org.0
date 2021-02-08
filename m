Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7783137E7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhBHPc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhBHP3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DEE64F26;
        Mon,  8 Feb 2021 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797397;
        bh=i7aH55UCf84lDGj/wVz0K2TdKwppSpxqd0Kdj/FbDOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdVX8MNTX9NgBI5OyaEiSQdP/qxU/TV84RG6UShrd22IuFrzChu8arWht8zWc/OVn
         rMEjsQbJs4JnzRYRsO5izlnjnJrQTi8gNszLkpMiyMQen7r4Bxsqy1oV1o+CPnTbgy
         N0o3hp81GhoEPbVLs/ddWyP+Np5LYh4xTUVeRTgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 094/120] DTS: ARM: gta04: remove legacy spi-cs-high to make display work again
Date:   Mon,  8 Feb 2021 16:01:21 +0100
Message-Id: <20210208145822.140858617@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 07af7810e0a5bc4e51682c90f9fa19fc4cb93f18 upstream.

This reverts

commit f1f028ff89cb ("DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again")

which had to be intruduced after

commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")

broke the GTA04 display. This contradicted the data sheet but was the only
way to get it as an spi client operational again.

The panel data sheet defines the chip-select to be active low.

Now, with the arrival of

commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

the logic of interaction between spi-cs-high and the gpio descriptor flags
has been changed a second time, making the display broken again. So we have
to remove the original fix which in retrospect was a workaround of a bug in
the spi subsystem and not a feature of the panel or bug in the device tree.

With this fix the device tree is back in sync with the data sheet and
spi subsystem code.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
CC: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -124,7 +124,6 @@
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
-			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";


