Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC359604005
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiJSJmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiJSJhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC33CBED;
        Wed, 19 Oct 2022 02:15:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E1F617E8;
        Wed, 19 Oct 2022 09:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D65C433C1;
        Wed, 19 Oct 2022 09:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170251;
        bh=1wghsjgKKn7NZz43uELGlj/gxRjZkbBQYsZJUpGB+wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIxPga6lQQp1q5iZNxztv0hLMsF+xIlgqsfeC5o7X38F+kuCoW45TmTABmD6DN149
         F+/iZoJJe2m3swl3uRzZjnmWAPxHYlH5wAOCrzhb5oAgWRoJNj+TYm6osV49xTo4+Z
         nflOn4rLxajupD2NQww9n90YaM72a1fiTkkOM5oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 584/862] clk: mediatek: Migrate remaining clk_unregister_*() to clk_hw_unregister_*()
Date:   Wed, 19 Oct 2022 10:31:11 +0200
Message-Id: <20221019083315.771298596@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit fef14676fc4be40b8441745a3c96b7e7d7d8592d ]

During the previous |struct clk| to |struct clk_hw| clk provider API
migration in commit 6f691a586296 ("clk: mediatek: Switch to clk_hw
provider APIs"), a few clk_unregister_*() calls were missed.

Migrate the remaining ones to the |struct clk_hw| provider API, i.e.
change clk_unregister_*() to clk_hw_unregister_*().

Fixes: 6f691a586296 ("clk: mediatek: Switch to clk_hw provider APIs")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220926102523.2367530-3-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 9b82956260d3..e1b445f2c5c5 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -80,7 +80,7 @@ int mtk_clk_register_fixed_clks(const struct mtk_fixed_clk *clks, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[rc->id]))
 			continue;
 
-		clk_unregister_fixed_rate(clk_data->hws[rc->id]->clk);
+		clk_hw_unregister_fixed_rate(clk_data->hws[rc->id]);
 		clk_data->hws[rc->id] = ERR_PTR(-ENOENT);
 	}
 
@@ -102,7 +102,7 @@ void mtk_clk_unregister_fixed_clks(const struct mtk_fixed_clk *clks, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[rc->id]))
 			continue;
 
-		clk_unregister_fixed_rate(clk_data->hws[rc->id]->clk);
+		clk_hw_unregister_fixed_rate(clk_data->hws[rc->id]);
 		clk_data->hws[rc->id] = ERR_PTR(-ENOENT);
 	}
 }
@@ -146,7 +146,7 @@ int mtk_clk_register_factors(const struct mtk_fixed_factor *clks, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[ff->id]))
 			continue;
 
-		clk_unregister_fixed_factor(clk_data->hws[ff->id]->clk);
+		clk_hw_unregister_fixed_factor(clk_data->hws[ff->id]);
 		clk_data->hws[ff->id] = ERR_PTR(-ENOENT);
 	}
 
@@ -168,7 +168,7 @@ void mtk_clk_unregister_factors(const struct mtk_fixed_factor *clks, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[ff->id]))
 			continue;
 
-		clk_unregister_fixed_factor(clk_data->hws[ff->id]->clk);
+		clk_hw_unregister_fixed_factor(clk_data->hws[ff->id]);
 		clk_data->hws[ff->id] = ERR_PTR(-ENOENT);
 	}
 }
@@ -414,7 +414,7 @@ void mtk_clk_unregister_dividers(const struct mtk_clk_divider *mcds, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[mcd->id]))
 			continue;
 
-		clk_unregister_divider(clk_data->hws[mcd->id]->clk);
+		clk_hw_unregister_divider(clk_data->hws[mcd->id]);
 		clk_data->hws[mcd->id] = ERR_PTR(-ENOENT);
 	}
 }
-- 
2.35.1



