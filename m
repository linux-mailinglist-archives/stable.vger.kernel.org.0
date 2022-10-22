Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6E608854
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiJVIQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbiJVIPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:15:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911F2112A93;
        Sat, 22 Oct 2022 00:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CC3EB82DF2;
        Sat, 22 Oct 2022 07:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187EC433C1;
        Sat, 22 Oct 2022 07:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425362;
        bh=srv/EIl8izX/BPUoVv3mGmNEBkCdcC6kZNz8wlmMOUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0rVqZXFH8MimDFqY3LYb/xwraQ6RuWIE6mGMRo2n47KwozVTuPPjPADWFijxKBJI
         jIQfqP7GPjYTnzDWKEnHgWBfblALY1n9+aJ1zClFaZO29VA0ydQhQRTMsjW1l21ng2
         rqJgn6l5Do43TBoU/Dym4wCr8rPuRcPTEkwwMnFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 476/717] clk: mediatek: Migrate remaining clk_unregister_*() to clk_hw_unregister_*()
Date:   Sat, 22 Oct 2022 09:25:55 +0200
Message-Id: <20221022072519.406403441@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 53bb8b88332f..35845163edae 100644
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



