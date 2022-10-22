Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483CF6087C5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiJVIFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiJVIEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CE62D446C;
        Sat, 22 Oct 2022 00:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ED65B82E18;
        Sat, 22 Oct 2022 07:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F14C433C1;
        Sat, 22 Oct 2022 07:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425100;
        bh=r+FwyI0dw6wnWyUmx0/wuU+uiVosvkZ0FGImdLGy/tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oP+DdJ0wUIDr8GQLJ2eoW5y4CJlwefDwqpbaaj8tqsfrt3PgKuOMKFjacNijbdqFL
         GP8seGR75wm1NoFPLEi/1gNuQJlbTzj2VtiKUoNsphr4l0tKThXWEJBq75h/zvgec8
         WRoobg09LiIBPRDbNRPnhjbUyw78XxinhqMOR3m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 388/717] clk: tegra: Fix refcount leak in tegra114_clock_init
Date:   Sat, 22 Oct 2022 09:24:27 +0200
Message-Id: <20221022072514.747723901@linuxfoundation.org>
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
index ef718c4b3826..f7405a58877e 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1317,6 +1317,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
-- 
2.35.1



