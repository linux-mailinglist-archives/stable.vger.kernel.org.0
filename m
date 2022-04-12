Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D622D4FDB0F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355809AbiDLH3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351579AbiDLHSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:18:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCE91FCC8;
        Mon, 11 Apr 2022 23:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2831DB81A8F;
        Tue, 12 Apr 2022 06:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB22C385A6;
        Tue, 12 Apr 2022 06:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746764;
        bh=9knYtZs4cQxxwU+rTTGT8DPToBcIrwxkKouo22iwZ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiHpx72c0kfnP/W6pb1De7TW3Nw3bLhd1stqGAmEPn3JjZY3ZJgUo+L0l/oK9fxw1
         Nx0RcRRa6v4VYJoxMf/Bs8HkLoL8GM/QtWsAD21sxRiyuAmuVvJNgvh/VdGWqV0qRU
         wkZvDEu8ZTglqacQJFnIHiSN6DZseUthyPYFvH04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 115/285] clk: mediatek: Fix memory leaks on probe
Date:   Tue, 12 Apr 2022 08:29:32 +0200
Message-Id: <20220412062946.985380939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 7a688c91d3fd54c53e7a9edd6052cdae98dd99d8 ]

Handle the error branches to free memory where required.

Addresses-Coverity-ID: 1491825 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20220115183059.GA10809@elementary
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8192.c | 36 +++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8192.c b/drivers/clk/mediatek/clk-mt8192.c
index cbc7c6dbe0f4..79ddb3cc0b98 100644
--- a/drivers/clk/mediatek/clk-mt8192.c
+++ b/drivers/clk/mediatek/clk-mt8192.c
@@ -1236,9 +1236,17 @@ static int clk_mt8192_infra_probe(struct platform_device *pdev)
 
 	r = mtk_clk_register_gates(node, infra_clks, ARRAY_SIZE(infra_clks), clk_data);
 	if (r)
-		return r;
+		goto free_clk_data;
+
+	r = of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	if (r)
+		goto free_clk_data;
+
+	return r;
 
-	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+free_clk_data:
+	mtk_free_clk_data(clk_data);
+	return r;
 }
 
 static int clk_mt8192_peri_probe(struct platform_device *pdev)
@@ -1253,9 +1261,17 @@ static int clk_mt8192_peri_probe(struct platform_device *pdev)
 
 	r = mtk_clk_register_gates(node, peri_clks, ARRAY_SIZE(peri_clks), clk_data);
 	if (r)
-		return r;
+		goto free_clk_data;
+
+	r = of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	if (r)
+		goto free_clk_data;
 
-	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	return r;
+
+free_clk_data:
+	mtk_free_clk_data(clk_data);
+	return r;
 }
 
 static int clk_mt8192_apmixed_probe(struct platform_device *pdev)
@@ -1271,9 +1287,17 @@ static int clk_mt8192_apmixed_probe(struct platform_device *pdev)
 	mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
 	r = mtk_clk_register_gates(node, apmixed_clks, ARRAY_SIZE(apmixed_clks), clk_data);
 	if (r)
-		return r;
+		goto free_clk_data;
 
-	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	r = of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+	if (r)
+		goto free_clk_data;
+
+	return r;
+
+free_clk_data:
+	mtk_free_clk_data(clk_data);
+	return r;
 }
 
 static const struct of_device_id of_match_clk_mt8192[] = {
-- 
2.35.1



