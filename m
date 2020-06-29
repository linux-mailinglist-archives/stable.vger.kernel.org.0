Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAA120E700
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733077AbgF2Vwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4F9247DF;
        Mon, 29 Jun 2020 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444148;
        bh=oqOzstyS6Poeb0QoznX9WUTIjyYQlORjyJQqIL90QTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8Un/ZsZ9m65JMdw9VSunrlT0xD9Gbh+f7l6GTFOK/Gl0OYvrUeC3agBibZ/ZarNb
         B1uBXLmSztgLFV+ZpDGbtulNE8oSTfjANr8AT4UqTfBYt7yVeveqM5fj2Q8P3ulPrx
         HZc26eeLueQjlrUCuh64MVJ2G1LVW66ZOeYN1PvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 254/265] ARM: dts: imx6ul-kontron: Change WDOG_ANY signal from push-pull to open-drain
Date:   Mon, 29 Jun 2020 11:18:07 -0400
Message-Id: <20200629151818.2493727-255-sashal@kernel.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit d22a16cc92e04d053fd807ef3587e4f135e4206f upstream.

The WDOG_ANY signal is connected to the RESET_IN signal of the SoM
and baseboard. It is currently configured as push-pull, which means
that if some external device like a programmer wants to assert the
RESET_IN signal by pulling it to ground, it drives against the high
level WDOG_ANY output of the SoC.

To fix this we set the WDOG_ANY signal to open-drain configuration.
That way we make sure that the RESET_IN can be asserted by the
watchdog as well as by external devices.

Fixes: 1ea4b76cdfde ("ARM: dts: imx6ul-kontron-n6310: Add Kontron i.MX6UL N6310 SoM and boards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
index fc316408721d0..61ba21a605a81 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
@@ -116,7 +116,7 @@
 
 	pinctrl_wdog: wdoggrp {
 		fsl,pins = <
-			MX6UL_PAD_GPIO1_IO09__WDOG1_WDOG_ANY    0x30b0
+			MX6UL_PAD_GPIO1_IO09__WDOG1_WDOG_ANY    0x18b0
 		>;
 	};
 };
-- 
2.25.1

