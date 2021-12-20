Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70CD47AF20
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbhLTPJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhLTPHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69034C0254FE;
        Mon, 20 Dec 2021 06:53:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 080E2611B8;
        Mon, 20 Dec 2021 14:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E520BC36AE8;
        Mon, 20 Dec 2021 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012022;
        bh=RVYIv7Rf853WrMef9HEjthsVOiNDF7GH87tdtRkwTnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ky68bpzzBPdFyu9d+4CHmZKdY33MA1QaZPJvsvSggt0/Kj+5xaBZYmp1kiRAEhUSU
         PQcwDrTwXnxKZjOrWkacGmTp/uXV1xvf5NLhdi9yWJiItjORo6Jj/akQlIYbqMVad4
         0RTkt/JfZXGVexAYhqBy+Ou/AZFP1dKcW3bcI/hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <quic_mdtipton@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/177] clk: Dont parent clks until the parent is fully registered
Date:   Mon, 20 Dec 2021 15:33:22 +0100
Message-Id: <20211220143041.849386107@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
index 65508eb89ec99..a277fd4f2f0a6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3415,6 +3415,14 @@ static int __clk_core_init(struct clk_core *core)
 
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
@@ -3579,8 +3587,10 @@ static int __clk_core_init(struct clk_core *core)
 out:
 	clk_pm_runtime_put(core);
 unlock:
-	if (ret)
+	if (ret) {
 		hlist_del_init(&core->child_node);
+		core->hw->core = NULL;
+	}
 
 	clk_prepare_unlock();
 
@@ -3844,7 +3854,6 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 	core->num_parents = init->num_parents;
 	core->min_rate = 0;
 	core->max_rate = ULONG_MAX;
-	hw->core = core;
 
 	ret = clk_core_populate_parent_map(core, init);
 	if (ret)
@@ -3862,7 +3871,7 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 		goto fail_create_clk;
 	}
 
-	clk_core_link_consumer(hw->core, hw->clk);
+	clk_core_link_consumer(core, hw->clk);
 
 	ret = __clk_core_init(core);
 	if (!ret)
-- 
2.33.0



