Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFB43F51
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbfFMP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731530AbfFMIvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8537E21473;
        Thu, 13 Jun 2019 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415883;
        bh=SyJwNShy55tKhclXb+GU9q0BgotQ9kP/VIB+jVyeH9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQP4rAj/1bGaLutfkCFoRaIoq/Ypdxy81rruQqBaWOr6Az/ws5OWRo4BB4wCkICw2
         zf6E5ow8VrSzcnY4BWUggTiBQiErS9aOVy81GZuaGb3r/dMJrsejyE+zuPpHZ7xXgx
         9yeWcvRvgw/ykuKouwSAJ9hi8V/Qu0Xnnrqidk7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 149/155] ARM: shmobile: porter: enable R-Car Gen2 regulator quirk
Date:   Thu, 13 Jun 2019 10:34:21 +0200
Message-Id: <20190613075701.211814686@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d5aa84087eadd6f2619628bc9f3d028eeabded0f ]

Porter needs the regulator quirk, just like the other boards.
But unlike the other boards, the Porter uses DA9063L, which
is at 0x5a. Otherwise, DA9063L and DA9210 IRQ line is still
connected to CPU IRQ2 .

Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
index dc526ef2e9b3..ee949255ced3 100644
--- a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
+++ b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * R-Car Generation 2 da9063/da9210 regulator quirk
+ * R-Car Generation 2 da9063(L)/da9210 regulator quirk
  *
  * Certain Gen2 development boards have an da9063 and one or more da9210
  * regulators. All of these regulators have their interrupt request lines
@@ -65,6 +65,7 @@ static struct i2c_msg da9210_msg = {
 
 static const struct of_device_id rcar_gen2_quirk_match[] = {
 	{ .compatible = "dlg,da9063", .data = &da9063_msg },
+	{ .compatible = "dlg,da9063l", .data = &da9063_msg },
 	{ .compatible = "dlg,da9210", .data = &da9210_msg },
 	{},
 };
@@ -147,6 +148,7 @@ static int __init rcar_gen2_regulator_quirk(void)
 
 	if (!of_machine_is_compatible("renesas,koelsch") &&
 	    !of_machine_is_compatible("renesas,lager") &&
+	    !of_machine_is_compatible("renesas,porter") &&
 	    !of_machine_is_compatible("renesas,stout") &&
 	    !of_machine_is_compatible("renesas,gose"))
 		return -ENODEV;
@@ -210,7 +212,7 @@ static int __init rcar_gen2_regulator_quirk(void)
 		goto err_free;
 	}
 
-	pr_info("IRQ2 is asserted, installing da9063/da9210 regulator quirk\n");
+	pr_info("IRQ2 is asserted, installing regulator quirk\n");
 
 	bus_register_notifier(&i2c_bus_type, &regulator_quirk_nb);
 	return 0;
-- 
2.20.1



