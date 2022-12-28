Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53F5657E29
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiL1Puq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiL1Pup (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:50:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E75D218
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A0CCB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BECC433D2;
        Wed, 28 Dec 2022 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242641;
        bh=uQYc6Tzfchw3IidOWW+HWTuXrYssLkLX8Ndx4090s5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOmtJcowcwXQxxPvbqJV2n8ddBlKwoiEU7KoAiGpKrI1CKWnwy/6tKIcciHUtoL6a
         oTJJhSb7/H4AES0DiASrh75vjeqrVz7oc6k3c6vBSzm0lJrAneVT+J7n9R6Ki0k0L7
         nUoJKmG2qs2XOaaMRZTQb4c8BObHqjBycSPtrWEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0385/1146] clk: microchip: check for null return of devm_kzalloc()
Date:   Wed, 28 Dec 2022 15:32:04 +0100
Message-Id: <20221228144340.622198913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit e2e6a217a84d09785848a82599729c9a41566e3a ]

Because of the possible failure of devm_kzalloc(), name might be NULL and
will cause null pointer dereference later.

Therefore, it might be better to check it and directly return -ENOMEM.

Fixes: d39fb172760e ("clk: microchip: add PolarFire SoC fabric clock support")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
[claudiu.beznea: s/refrence/reference/, s/possilble/possible]
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221119054858.178629-1-tanghui20@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-mpfs-ccc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/microchip/clk-mpfs-ccc.c b/drivers/clk/microchip/clk-mpfs-ccc.c
index 7be028dced63..32aae880a14f 100644
--- a/drivers/clk/microchip/clk-mpfs-ccc.c
+++ b/drivers/clk/microchip/clk-mpfs-ccc.c
@@ -166,6 +166,9 @@ static int mpfs_ccc_register_outputs(struct device *dev, struct mpfs_ccc_out_hw_
 		struct mpfs_ccc_out_hw_clock *out_hw = &out_hws[i];
 		char *name = devm_kzalloc(dev, 23, GFP_KERNEL);
 
+		if (!name)
+			return -ENOMEM;
+
 		snprintf(name, 23, "%s_out%u", parent->name, i);
 		out_hw->divider.hw.init = CLK_HW_INIT_HW(name, &parent->hw, &clk_divider_ops, 0);
 		out_hw->divider.reg = data->pll_base[i / MPFS_CCC_OUTPUTS_PER_PLL] +
@@ -200,6 +203,9 @@ static int mpfs_ccc_register_plls(struct device *dev, struct mpfs_ccc_pll_hw_clo
 		struct mpfs_ccc_pll_hw_clock *pll_hw = &pll_hws[i];
 		char *name = devm_kzalloc(dev, 18, GFP_KERNEL);
 
+		if (!name)
+			return -ENOMEM;
+
 		pll_hw->base = data->pll_base[i];
 		snprintf(name, 18, "ccc%s_pll%u", strchrnul(dev->of_node->full_name, '@'), i);
 		pll_hw->name = (const char *)name;
-- 
2.35.1



