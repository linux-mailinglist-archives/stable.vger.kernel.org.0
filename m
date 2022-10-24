Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FBA60BB47
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJXUyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiJXUxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:53:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D8E168E56;
        Mon, 24 Oct 2022 12:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8BD4612C5;
        Mon, 24 Oct 2022 12:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F5EC433C1;
        Mon, 24 Oct 2022 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612883;
        bh=8ggShBhGOJwKpgRbOmOgbcjHdyJf4iISNtbQntcg8Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AV8cy3V1Hs9cGE1JEJGidht2aydcztQ4VlriWhXA0Cf86PFJlUJ+JRqyyYvL+cYCs
         WrJE4KA/ewg88X3KSan6jdIxhTB5QJuCsWeH72mPb4ZkxJFR9KsPUsXPqELjf4vhnz
         fMJ30HMmjQXlW0Hxsl5epxiBKAwM9yOJYi8geLKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/229] clk: tegra: Fix refcount leak in tegra114_clock_init
Date:   Mon, 24 Oct 2022 13:30:43 +0200
Message-Id: <20221024113003.018607937@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit db16a80c76ea395766913082b1e3f939dde29b2c ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 2cb5efefd6f7 ("clk: tegra: Implement clocks for Tegra114")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220523143834.7587-1-linmq006@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra114.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 625d11091330..1e5025c127bd 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1348,6 +1348,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
-- 
2.35.1



