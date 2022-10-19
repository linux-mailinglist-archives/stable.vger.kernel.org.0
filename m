Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A186041BB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiJSKr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiJSKqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EC311F48B;
        Wed, 19 Oct 2022 03:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F253B82440;
        Wed, 19 Oct 2022 08:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E29CC433C1;
        Wed, 19 Oct 2022 08:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169948;
        bh=mgfxMUrqtSlUZHIjEaaKuLvZ8O/qKzLSst2rHPmyHgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OerNXwzjif7td4HsVbOdtW9klXGaOhtdyMt40EkYj8JURINlew1rTajrh6Y15Iv9T
         wlWUsdsLly+Kxoh50TsqmtXlrwwl+0XmjcrwtjwBtsgL0L2+zRbzCqyuGWza87lPAY
         RLn73Cku1iSegNyryoIEaBKpmK/D5lpvTfkf4hD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 469/862] clk: st: Hold reference returned by of_get_parent()
Date:   Wed, 19 Oct 2022 10:29:16 +0200
Message-Id: <20221019083310.695992944@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 429973306f860470cbbb8402c8c53143b450faba ]

We should hold the reference returned by of_get_parent() and use it
to call of_node_put() for refcount balance.

Fixes: 3efe64ef5186 ("clk: st: clkgen-fsyn: search reg within node or parent")
Fixes: 810251b0d36a ("clk: st: clkgen-mux: search reg within node or parent")

Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220628142416.169808-1-windhl@126.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/st/clkgen-fsyn.c | 5 ++++-
 drivers/clk/st/clkgen-mux.c  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 582a22c04919..d820292a381d 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -987,6 +987,7 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 	const char *pll_name, *clk_parent_name;
 	void __iomem *reg;
 	spinlock_t *lock;
+	struct device_node *parent_np;
 
 	/*
 	 * First check for reg property within the node to keep backward
@@ -994,7 +995,9 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 	 */
 	reg = of_iomap(np, 0);
 	if (!reg) {
-		reg = of_iomap(of_get_parent(np), 0);
+		parent_np = of_get_parent(np);
+		reg = of_iomap(parent_np, 0);
+		of_node_put(parent_np);
 		if (!reg) {
 			pr_err("%s: Failed to get base address\n", __func__);
 			return;
diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index ee39af7a0b72..596e939ad905 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -56,6 +56,7 @@ static void __init st_of_clkgen_mux_setup(struct device_node *np,
 	void __iomem *reg;
 	const char **parents;
 	int num_parents = 0;
+	struct device_node *parent_np;
 
 	/*
 	 * First check for reg property within the node to keep backward
@@ -63,7 +64,9 @@ static void __init st_of_clkgen_mux_setup(struct device_node *np,
 	 */
 	reg = of_iomap(np, 0);
 	if (!reg) {
-		reg = of_iomap(of_get_parent(np), 0);
+		parent_np = of_get_parent(np);
+		reg = of_iomap(parent_np, 0);
+		of_node_put(parent_np);
 		if (!reg) {
 			pr_err("%s: Failed to get base address\n", __func__);
 			return;
-- 
2.35.1



