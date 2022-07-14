Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D857435B
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiGNEdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiGNEcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57237FB1;
        Wed, 13 Jul 2022 21:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB1E1B82379;
        Thu, 14 Jul 2022 04:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1F6C385A2;
        Thu, 14 Jul 2022 04:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772745;
        bh=i8j8lN8pZ+HBk9c+r3zEGf+7yulVsOuUqHCIcEWp5X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8boJ2oWMc1eMcBkSFOxAcRTLiIaMgqNWYCVfjv4Me5M1QZPrZJpJHrdqrfRlezdv
         679LT6yyP5feH7yBSniPe0rkmLzlZm003LnbLyFhmLlXpWE+Op6LovE9uX1idXG11S
         V8GxVz4OolZU+zbPg9NDlzAHGXvnY+hEh2sKhBCo7y/QW3PbsynXrl2t1ExoTdpMI9
         +Z2G0dS3mUBGzcu5FF59nt18Ejd6GZqTORns78p9uh56lJsRh3395KXr5ip3IwfEqb
         XumVlbAM3C6Zrp/LwWnYsTerMI+tM4d2Ic2TqEDsBtngYeiIySv2wQHedKjnbDrCnX
         H2i0PqShSJOxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrew@aj.id.au,
        joel@jms.id.au, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/15] pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()
Date:   Thu, 14 Jul 2022 00:25:27 -0400
Message-Id: <20220714042541.282175-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042541.282175-1-sashal@kernel.org>
References: <20220714042541.282175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 84a85d3fef2e75b1fe9fc2af6f5267122555a1ed ]

pdesc could be null but still dereference pdesc->name and it will lead to
a null pointer access. So we move a null check before dereference.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Link: https://lore.kernel.org/r/1650508019-22554-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 9c65d560d48f..e792318c3894 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -235,11 +235,11 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
 		const struct aspeed_sig_expr **funcs;
 		const struct aspeed_sig_expr ***prios;
 
-		pr_debug("Muxing pin %s for %s\n", pdesc->name, pfunc->name);
-
 		if (!pdesc)
 			return -EINVAL;
 
+		pr_debug("Muxing pin %s for %s\n", pdesc->name, pfunc->name);
+
 		prios = pdesc->prios;
 
 		if (!prios)
-- 
2.35.1

