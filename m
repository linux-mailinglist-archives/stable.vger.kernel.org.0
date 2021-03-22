Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4BD344316
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhCVMsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhCVMox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73277619F4;
        Mon, 22 Mar 2021 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416917;
        bh=hvrnbfS4nOx/L3MlJrKfQRHaw3x9igwyNNF23FUJdeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J34rJs8pF7Mfc+N9H6Y0utZRX5RFnDJgxN7aHGNNVhl6crwr/4vstpe34RdIAWArO
         mhD3rKtqpi2RKl5E42111UC3CwFGpEinJ1WKAWzWb1a93lkiZwTygT9gknQNEYZ/uT
         a3uGQz3lwh2qxDMt23h8O6cuwdeLfUPU2dq530b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Mark Brown <broonie@kernel.org>,
        Sameer Pujar <spujar@nvidia.com>
Subject: [PATCH 5.4 16/60] ASoC: simple-card-utils: Do not handle device clock
Date:   Mon, 22 Mar 2021 13:28:04 +0100
Message-Id: <20210322121922.915601769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 8ca88d53351cc58d535b2bfc7386835378fb0db2 upstream.

This reverts commit 1e30f642cf29 ("ASoC: simple-card-utils: Fix device
module clock"). The original patch ended up breaking following platform,
which depends on set_sysclk() to configure internal PLL on wm8904 codec
and expects simple-card-utils to not update the MCLK rate.
 - "arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var3-ads2.dts"

It would be best if codec takes care of setting MCLK clock via DAI
set_sysclk() callback.

Reported-by: Michael Walle <michael@walle.cc>
Suggested-by: Mark Brown <broonie@kernel.org>
Suggested-by: Michael Walle <michael@walle.cc>
Fixes: 1e30f642cf29 ("ASoC: simple-card-utils: Fix device module clock")
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Tested-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/1615829492-8972-2-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/generic/simple-card-utils.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -172,15 +172,16 @@ int asoc_simple_parse_clk(struct device
 	 *  or device's module clock.
 	 */
 	clk = devm_get_clk_from_child(dev, node, NULL);
-	if (IS_ERR(clk))
-		clk = devm_get_clk_from_child(dev, dlc->of_node, NULL);
-
 	if (!IS_ERR(clk)) {
-		simple_dai->clk = clk;
 		simple_dai->sysclk = clk_get_rate(clk);
-	} else if (!of_property_read_u32(node, "system-clock-frequency",
-					 &val)) {
+
+		simple_dai->clk = clk;
+	} else if (!of_property_read_u32(node, "system-clock-frequency", &val)) {
 		simple_dai->sysclk = val;
+	} else {
+		clk = devm_get_clk_from_child(dev, dlc->of_node, NULL);
+		if (!IS_ERR(clk))
+			simple_dai->sysclk = clk_get_rate(clk);
 	}
 
 	if (of_property_read_bool(node, "system-clock-direction-out"))


