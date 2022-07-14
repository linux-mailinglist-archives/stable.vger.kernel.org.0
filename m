Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6141574239
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiGNEWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiGNEWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:22:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F430252A8;
        Wed, 13 Jul 2022 21:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE1BEB82371;
        Thu, 14 Jul 2022 04:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28190C3411C;
        Thu, 14 Jul 2022 04:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772546;
        bh=I/S6MXKj+pJExOorvIiThOlDOL37GW0RHtgnBej/vcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xak1LbDzW3KzB6ZkyWWdNZqxOvwpxZEXDQUjVyY5087A3iQGVEJAAWOvBgbb6tWtV
         HOCoANuj7eCiK+ac3/PDc+FSVNHyUcQO70EdkhMjezDBFsO2f4qPa8JeFluIswrdtU
         N1bYAq2hD4Ze7ch4iSUjMG5fBu/gem/EpRNIypc0vgYYGeuuD8HE5IZVKwG9nVEEFF
         ia4j7vaORdqiegJQcm5e9g9xaIQgNy/RLMUur5sltIigwQ8BN/Q8OGEVbD7fqSBlYQ
         1ojg/t2ZIvsQMBMUmetDN4LZZkDoJggvc0+U64JGmSAlMaDes+RpVrnMFKE7PSYgSz
         Nu0M3TWUBZsJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrew@aj.id.au,
        joel@jms.id.au, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 02/41] pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()
Date:   Thu, 14 Jul 2022 00:21:42 -0400
Message-Id: <20220714042221.281187-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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
index c94e24aadf92..83d47ff1cea8 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -236,11 +236,11 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
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

