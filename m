Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEB2608A0D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiJVIqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiJVIpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:45:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8822ECF44;
        Sat, 22 Oct 2022 01:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3825E60B9E;
        Sat, 22 Oct 2022 07:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41333C43142;
        Sat, 22 Oct 2022 07:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425359;
        bh=mCt10wEUGdkbYKVqsikirEnFY/fRySLGrPNv1mk+zm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZWkGUSDTg2C3+RurIScZZU07UIY3w8SO46LaQQ0h+h0MPIGGX80dpXtbl6MMBIkI
         kemOBnyTiE7mjGM/mVA1Kq5kQ658bMlmHoWP2P9idXXFkdYuan0ZurLNdzE3GiSkA7
         UxAOlzELzqgkphI0DyleICPlzfmurXKDpsIRQ0uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 475/717] clk: mediatek: fix unregister function in mtk_clk_register_dividers cleanup
Date:   Sat, 22 Oct 2022 09:25:54 +0200
Message-Id: <20221022072519.358479275@linuxfoundation.org>
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

[ Upstream commit 20f7a0dba9075fb0e3d645495bc24d7025b58de1 ]

When the cleanup paths for the various clk register APIs in the MediaTek
clk library were added, the one in the dividers type used the wrong type
of unregister function. This would result in incorrect dereferencing of
the clk pointer and freeing of invalid pointers.

Fix this by switching to the correct type of clk unregistration call.

Fixes: 3c3ba2ab0226 ("clk: mediatek: mtk: Implement error handling in register APIs")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220926102523.2367530-2-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index b9188000ab3c..53bb8b88332f 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -393,7 +393,7 @@ int mtk_clk_register_dividers(const struct mtk_clk_divider *mcds, int num,
 		if (IS_ERR_OR_NULL(clk_data->hws[mcd->id]))
 			continue;
 
-		mtk_clk_unregister_composite(clk_data->hws[mcd->id]);
+		clk_hw_unregister_divider(clk_data->hws[mcd->id]);
 		clk_data->hws[mcd->id] = ERR_PTR(-ENOENT);
 	}
 
-- 
2.35.1



