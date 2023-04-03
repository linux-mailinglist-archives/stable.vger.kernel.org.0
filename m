Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029526D48F1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjDCOdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjDCOdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDE5E78
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC7861B72
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F95C433D2;
        Mon,  3 Apr 2023 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532385;
        bh=7mSKqYYkPEGWqVbb6AWBoCjN4l4k7XzbuK3iv6ICfos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYhBQoJFXkwpzToCRON2hO1VM9tN2U5yvvFDSWgoXkgq10Z8nmgUU//zU1QjfhkJi
         YaDjhNd7weIR+BNpYSZA33kU2yXjGGXJaD6uOSG9igwn0veUep/RtyxTviewaIP7dy
         d5Fq7Pb614PqlXcjgNHUeNNSXGZ+kpLKXfkRLMoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/99] pinctrl: ocelot: Fix alt mode for ocelot
Date:   Mon,  3 Apr 2023 16:09:26 +0200
Message-Id: <20230403140405.810898798@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 657fd9da2d4b4aa0a384105b236baa22fa0233bf ]

In case the driver was trying to set an alternate mode for gpio
0 or 32 then the mode was not set correctly. The reason is that
there is computation error inside the function ocelot_pinmux_set_mux
because in this case it was trying to shift to left by -1.
Fix this by actually shifting the function bits and not the position.

Fixes: 4b36082e2e09 ("pinctrl: ocelot: fix pinmuxing for pins after 31")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20230206203720.1177718-1-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 0a36ec8775a38..b14f1b7a625ec 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -739,7 +739,7 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
 	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
-			   BIT(p), f << (p - 1));
+			   BIT(p), (f >> 1) << p);
 
 	return 0;
 }
-- 
2.39.2



