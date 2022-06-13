Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090D0548D5A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377350AbiFMNct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377964AbiFMNam (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EC66EB27;
        Mon, 13 Jun 2022 04:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C63261221;
        Mon, 13 Jun 2022 11:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C76C34114;
        Mon, 13 Jun 2022 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119518;
        bh=NnYNH6IYy9RIKjB57M8bXB1He/zInldRkDkUMteEkPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+rjMh7U0fDKNYAP6H3rFmAOhFDqEc99DYNZ+Oz1SaKvhAAf6vB5On1kyz1c2Xd4s
         wmGFPOmA+T7kF/TR5OkVjCkTgNeE6Ys5D/Unu4E/5PbRziEk8iV8ciwb+l7tw0s5He
         eE4NwH2rN10pzwdKi1aawKnLh2mCyI4VEb+ln08M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 041/339] power: supply: core: Initialize struct to zero
Date:   Mon, 13 Jun 2022 12:07:46 +0200
Message-Id: <20220613094927.765614010@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e56a4be2843c95c08cf8421dc1f8e880cafbaf91 ]

As we rely on pointers in the battery info to be zero-initialized
such as in the helper function power_supply_supports_vbat2ri()
we certainly need to allocate the struct power_supply_battery_info
with kzalloc() as well. Else this happens:

Unable to handle kernel paging request at virtual address 00280000
(...)
PC is at power_supply_vbat2ri+0x50/0x12c
LR is at ab8500_fg_battery_resistance+0x34/0x108

Fixes: e9e7d165b4b0 ("power: supply: Support VBAT-to-Ri lookup tables")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index d925cb137e12..fad5890c899e 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -616,7 +616,7 @@ int power_supply_get_battery_info(struct power_supply *psy,
 		goto out_put_node;
 	}
 
-	info = devm_kmalloc(&psy->dev, sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&psy->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		err = -ENOMEM;
 		goto out_put_node;
-- 
2.35.1



