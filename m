Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D247AD10
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhLTOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbhLTOq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:46:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C292CC08E9BF;
        Mon, 20 Dec 2021 06:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82290B80EE3;
        Mon, 20 Dec 2021 14:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E5C36AE7;
        Mon, 20 Dec 2021 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011426;
        bh=gJ30C+0+M4xaoc52uiuC4aC7ELxW962R9YQTbLcjfUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxVY6+MLQ1MHapc8ixE5eE9bnZ+nQG0RHCidHSLQ0tOoXjpu916q+rOnVHP41YXEc
         2vuy2s88xkLPGqM1DjmccA2txB0vVc9r4QXpO+mfGQDmGUyQFXmburToQ5lcI1z74z
         nvSz3OvZfZB7lLLFeYBvYGra8qlewatic6KzWz28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <quic_mdtipton@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/71] clk: Dont parent clks until the parent is fully registered
Date:   Mon, 20 Dec 2021 15:34:06 +0100
Message-Id: <20211220143026.271470026@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit 54baf56eaa40aa5cdcd02b3c20d593e4e1211220 ]

Before commit fc0c209c147f ("clk: Allow parents to be specified without
string names") child clks couldn't find their parent until the parent
clk was added to a list in __clk_core_init(). After that commit, child
clks can reference their parent clks directly via a clk_hw pointer, or
they can lookup that clk_hw pointer via DT if the parent clk is
registered with an OF clk provider.

The common clk framework treats hw->core being non-NULL as "the clk is
registered" per the logic within clk_core_fill_parent_index():

	parent = entry->hw->core;
	/*
	 * We have a direct reference but it isn't registered yet?
	 * Orphan it and let clk_reparent() update the orphan status
	 * when the parent is registered.
	 */
	if (!parent)

Therefore we need to be extra careful to not set hw->core until the clk
is fully registered with the clk framework. Otherwise we can get into a
situation where a child finds a parent clk and we move the child clk off
the orphan list when the parent isn't actually registered, wrecking our
enable accounting and breaking critical clks.

Consider the following scenario:

  CPU0                                     CPU1
  ----                                     ----
  struct clk_hw clkBad;
  struct clk_hw clkA;

  clkA.init.parent_hws = { &clkBad };

  clk_hw_register(&clkA)                   clk_hw_register(&clkBad)
   ...                                      __clk_register()
					     hw->core = core
					     ...
   __clk_register()
    __clk_core_init()
     clk_prepare_lock()
     __clk_init_parent()
      clk_core_get_parent_by_index()
       clk_core_fill_parent_index()
        if (entry->hw) {
	 parent = entry->hw->core;

At this point, 'parent' points to clkBad even though clkBad hasn't been
fully registered yet. Ouch! A similar problem can happen if a clk
controller registers orphan clks that are referenced in the DT node of
another clk controller.

Let's fix all this by only setting the hw->core pointer underneath the
clk prepare lock in __clk_core_init(). This way we know that
clk_core_fill_parent_index() can't see hw->core be non-NULL until the
clk is fully registered.

Fixes: fc0c209c147f ("clk: Allow parents to be specified without string names")
Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Link: https://lore.kernel.org/r/20211109043438.4639-1-quic_mdtipton@quicinc.com
[sboyd@kernel.org: Reword commit text, update comment]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 6ff87cd867121..e4e1b4e94a67b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3299,6 +3299,14 @@ static int __clk_core_init(struct clk_core *core)
 
 	clk_prepare_lock();
 
+	/*
+	 * Set hw->core after grabbing the prepare_lock to synchronize with
+	 * callers of clk_core_fill_parent_index() where we treat hw->core
+	 * being NULL as the clk not being registered yet. This is crucial so
+	 * that clks aren't parented until their parent is fully registered.
+	 */
+	core->hw->core = core;
+
 	ret = clk_pm_runtime_get(core);
 	if (ret)
 		goto unlock;
@@ -3452,8 +3460,10 @@ static int __clk_core_init(struct clk_core *core)
 out:
 	clk_pm_runtime_put(core);
 unlock:
-	if (ret)
+	if (ret) {
 		hlist_del_init(&core->child_node);
+		core->hw->core = NULL;
+	}
 
 	clk_prepare_unlock();
 
@@ -3699,7 +3709,6 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 	core->num_parents = init->num_parents;
 	core->min_rate = 0;
 	core->max_rate = ULONG_MAX;
-	hw->core = core;
 
 	ret = clk_core_populate_parent_map(core, init);
 	if (ret)
@@ -3717,7 +3726,7 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 		goto fail_create_clk;
 	}
 
-	clk_core_link_consumer(hw->core, hw->clk);
+	clk_core_link_consumer(core, hw->clk);
 
 	ret = __clk_core_init(core);
 	if (!ret)
-- 
2.33.0



