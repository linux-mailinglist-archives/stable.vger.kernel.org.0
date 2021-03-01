Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC82A328D97
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhCATOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:14:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235261AbhCATJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE476024A;
        Mon,  1 Mar 2021 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620825;
        bh=np4pLtvbnCOYPihpSn9/7tNShNDH24Oz5BOxu8A21GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPFeTQNfi1ln9sM34+3Tk/iaU5dHG8xdgEw1lkoSH5ocqyOnll93DLbjawTUrJ8Q8
         LC6obXX1WJS3W/d0UV5+KrI+H55XnJm5Rokpc7aqQ9OfhXSZx25kzKisWZnTDH0o/x
         VMmoHkdzpqH080pGMBHGH6ezwi5GuGazIFUNFaLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 293/775] ASoC: simple-card-utils: Fix device module clock
Date:   Mon,  1 Mar 2021 17:07:41 +0100
Message-Id: <20210301161216.095959496@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit 1e30f642cf2939bbdac82ea0dd3071232670b5ab ]

If "clocks = <&xxx>" is specified from the CPU or Codec component
device node, the clock is not getting enabled. Thus audio playback
or capture fails.

Fix this by populating "simple_dai->clk" field when clocks property
is specified from device node as well. Also tidy up by re-organising
conditional statements of parsing logic.

Fixes: bb6fc620c2ed ("ASoC: simple-card-utils: add asoc_simple_card_parse_clk()")
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1612939421-19900-2-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 6cada4c1e283b..ab31045cfc952 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -172,16 +172,15 @@ int asoc_simple_parse_clk(struct device *dev,
 	 *  or device's module clock.
 	 */
 	clk = devm_get_clk_from_child(dev, node, NULL);
-	if (!IS_ERR(clk)) {
-		simple_dai->sysclk = clk_get_rate(clk);
+	if (IS_ERR(clk))
+		clk = devm_get_clk_from_child(dev, dlc->of_node, NULL);
 
+	if (!IS_ERR(clk)) {
 		simple_dai->clk = clk;
-	} else if (!of_property_read_u32(node, "system-clock-frequency", &val)) {
+		simple_dai->sysclk = clk_get_rate(clk);
+	} else if (!of_property_read_u32(node, "system-clock-frequency",
+					 &val)) {
 		simple_dai->sysclk = val;
-	} else {
-		clk = devm_get_clk_from_child(dev, dlc->of_node, NULL);
-		if (!IS_ERR(clk))
-			simple_dai->sysclk = clk_get_rate(clk);
 	}
 
 	if (of_property_read_bool(node, "system-clock-direction-out"))
-- 
2.27.0



