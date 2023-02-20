Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1A869CD51
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjBTNsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjBTNsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D84783F6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1895B80D4E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A00C4339C;
        Mon, 20 Feb 2023 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900890;
        bh=ti1BVA11oLCMABVGyXO76jwSKPpEoAzvWVdIcdiy4NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0RebeQODKemZCGgjR1iWUJyZ2A3Ffok6ojNNj4WFgTkSsJLPG3gUfNtN9Gd+EP7X
         NZ5CejJWw2G4SQxmps/Jbgej7BKvfNYug5356EVrIk5pDWroAvoQpjFf2EeppcDceR
         dJ84NXtxnAzqbZLSCGbYbF5n271hRqBoFl+J99tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/156] pinctrl: aspeed: Fix confusing types in return value
Date:   Mon, 20 Feb 2023 14:35:21 +0100
Message-Id: <20230220133605.618047893@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 287a344a11f1ebd31055cf9b22c88d7005f108d7 ]

The function signature is int, but we return a bool. Instead return a
negative errno as the kerneldoc suggests.

Fixes: 4d3d0e4272d8 ("pinctrl: Add core support for Aspeed SoCs")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20230119231856.52014-1-joel@jms.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 22aca6d182c0c..2c1e799b029e7 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -115,7 +115,7 @@ static int aspeed_disable_sig(struct aspeed_pinmux_data *ctx,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(ctx, *exprs);
-- 
2.39.0



