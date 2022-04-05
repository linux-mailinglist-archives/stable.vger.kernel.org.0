Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83B64F2EC5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbiDEIeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbiDEIUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5932DB0D10;
        Tue,  5 Apr 2022 01:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB27660AFB;
        Tue,  5 Apr 2022 08:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE0AC385A0;
        Tue,  5 Apr 2022 08:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146444;
        bh=MFXNHr0FDQkSO9QWU3UIHNIuPq6c3AtM2CaRknD3t3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmxXsNNVIGJ9YWduFY7XR0MN3MtvXVmhOy5I4uw1or1EyM+pzOoQkTyI1mgRYL8yb
         JyDqwZaVxq5Sv9mFr3g/KjGDdD6aMMEbpAfby/8T2kcyhhus0S/zECYGMwubVpKEvS
         1FKbqUW39F2a7xDVgpigS+7W1E0bpcEQKLm7UNlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0767/1126] pinctrl: ocelot: fix confops resource index
Date:   Tue,  5 Apr 2022 09:25:14 +0200
Message-Id: <20220405070430.096851204@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 94ef32970d4076b3179b801c251bf99446b62da5 ]

Prior to commit ad96111e658a ("pinctrl: ocelot: combine get resource and
ioremap into single call") the resource index was 1, now it is 0. But 0
is the base region for the pinctrl block. Fix it.
I noticed this because there was an error that the memory region was
ioremapped twice.

Fixes: ad96111e658a ("pinctrl: ocelot: combine get resource and ioremap into single call")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/20220216082020.981797-1-michael@walle.cc
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index fc969208d904..a719c0bfbc91 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1790,7 +1790,7 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 		.max_register = 32,
 	};
 
-	base = devm_platform_ioremap_resource(pdev, 0);
+	base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(base)) {
 		dev_dbg(&pdev->dev, "Failed to ioremap config registers (no extended pinconf)\n");
 		return NULL;
-- 
2.34.1



