Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638A24F2D22
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiDEI1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiDEIUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDF0B0D26;
        Tue,  5 Apr 2022 01:14:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C3AC60AFB;
        Tue,  5 Apr 2022 08:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD4FC385A0;
        Tue,  5 Apr 2022 08:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146447;
        bh=WHog4N/cB+r7Q5qVBu/VTZU2oQBTeZ6/4VO5wSsfzc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtoolzIK+OJdHI1CLlmRp5Zl5yPEyrNHUl9su5HHf1FFzZ7wllLvddw0cmTsZYMBu
         A/5V6tECpd14rCoxMXYXdf6qNDSL9soHsscnAUMewCpE9VjkZfq2lPwgZaKQMqQz9+
         2yxhAVuhCoYYkv8OjOukk1tAxSOP1zYh88NO7mMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0768/1126] pinctrl: ocelot: fix duplicate debugfs entry
Date:   Tue,  5 Apr 2022 09:25:15 +0200
Message-Id: <20220405070430.125185334@linuxfoundation.org>
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

[ Upstream commit 359afd90fef3ec9285432f50720c813987df4a89 ]

This driver can have up to two regmaps. If the second one is registered
its debugfs entry will have the same name as the first one and the
following error will be printed:

[    2.242568] debugfs: Directory 'e2004064.pinctrl' with parent 'regmap' already present!

Give the second regmap a name to avoid this.

Fixes: 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/20220216122727.1005041-1-michael@walle.cc
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index a719c0bfbc91..9c13a7c90fc3 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1788,6 +1788,7 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 		.val_bits = 32,
 		.reg_stride = 4,
 		.max_register = 32,
+		.name = "pincfg",
 	};
 
 	base = devm_platform_ioremap_resource(pdev, 1);
-- 
2.34.1



