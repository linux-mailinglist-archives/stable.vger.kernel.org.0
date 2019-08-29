Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA18A25B8
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfH2Sb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfH2SOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C76C23429;
        Thu, 29 Aug 2019 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102473;
        bh=pq9bQ5wT6Ve5WC5CTmr2kRFot80lY7XVeGuKxFWObXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiZxnt8pGXR7qQ2mLS8nK/w5SSsgQOgW4IFpHIsvXKu+dA+kGgMQ0xGUtwxFJ6TU8
         XUV669GHlriLFrKDyJXdMknAqxZkHm7yhfxTZtnak0tkTDOV0PQfNcDN8YLaKAwiqT
         T0n2mlfArt1m/E9kcL+M0igCgHyUA9C4S6umHkaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>, Taniya Das <tdas@codeaurora.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 37/76] clk: Fix falling back to legacy parent string matching
Date:   Thu, 29 Aug 2019 14:12:32 -0400
Message-Id: <20190829181311.7562-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 4f8c6aba37da199155a121c6cdc38505a9eb0259 ]

Calls to clk_core_get() will return ERR_PTR(-EINVAL) if we've started
migrating a clk driver to use the DT based style of specifying parents
but we haven't made any DT updates yet. This happens when we pass a
non-NULL value as the 'name' argument of of_parse_clkspec(). That
function returns -EINVAL in such a situation, instead of -ENOENT like we
expected. The return value comes back up to clk_core_fill_parent_index()
which proceeds to skip calling clk_core_lookup() because the error
pointer isn't equal to -ENOENT, it's -EINVAL.

Furthermore, we blindly overwrite the error pointer returned by
clk_core_get() with NULL when there isn't a legacy .name member
specified in the parent map. This isn't too bad right now because we
don't really care to differentiate NULL from an error, but in the future
we should only try to do a legacy lookup if we know we might find
something. This way DT lookups that fail don't try to lookup based on
strings when there isn't any string to match, hiding the error from DT
parsing.

Fix both these problems so that clk provider drivers can use the new
style of parent mapping without having to also update their DT at the
same time. This patch is based on an earlier patch from Taniya Das which
checked for -EINVAL in addition to -ENOENT return values from
clk_core_get().

Fixes: 601b6e93304a ("clk: Allow parents to be specified via clkspec index")
Cc: Taniya Das <tdas@codeaurora.org>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Reported-by: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190813214147.34394-1-sboyd@kernel.org
Tested-by: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 87b410d6e51de..498cd7bbe8984 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -324,6 +324,25 @@ static struct clk_core *clk_core_lookup(const char *name)
 	return NULL;
 }
 
+#ifdef CONFIG_OF
+static int of_parse_clkspec(const struct device_node *np, int index,
+			    const char *name, struct of_phandle_args *out_args);
+static struct clk_hw *
+of_clk_get_hw_from_clkspec(struct of_phandle_args *clkspec);
+#else
+static inline int of_parse_clkspec(const struct device_node *np, int index,
+				   const char *name,
+				   struct of_phandle_args *out_args)
+{
+	return -ENOENT;
+}
+static inline struct clk_hw *
+of_clk_get_hw_from_clkspec(struct of_phandle_args *clkspec)
+{
+	return ERR_PTR(-ENOENT);
+}
+#endif
+
 /**
  * clk_core_get - Find the clk_core parent of a clk
  * @core: clk to find parent of
@@ -355,8 +374,9 @@ static struct clk_core *clk_core_lookup(const char *name)
  *      };
  *
  * Returns: -ENOENT when the provider can't be found or the clk doesn't
- * exist in the provider. -EINVAL when the name can't be found. NULL when the
- * provider knows about the clk but it isn't provided on this system.
+ * exist in the provider or the name can't be found in the DT node or
+ * in a clkdev lookup. NULL when the provider knows about the clk but it
+ * isn't provided on this system.
  * A valid clk_core pointer when the clk can be found in the provider.
  */
 static struct clk_core *clk_core_get(struct clk_core *core, u8 p_index)
@@ -367,17 +387,19 @@ static struct clk_core *clk_core_get(struct clk_core *core, u8 p_index)
 	struct device *dev = core->dev;
 	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct device_node *np = core->of_node;
+	struct of_phandle_args clkspec;
 
-	if (np && (name || index >= 0))
-		hw = of_clk_get_hw(np, index, name);
-
-	/*
-	 * If the DT search above couldn't find the provider or the provider
-	 * didn't know about this clk, fallback to looking up via clkdev based
-	 * clk_lookups
-	 */
-	if (PTR_ERR(hw) == -ENOENT && name)
+	if (np && (name || index >= 0) &&
+	    !of_parse_clkspec(np, index, name, &clkspec)) {
+		hw = of_clk_get_hw_from_clkspec(&clkspec);
+		of_node_put(clkspec.np);
+	} else if (name) {
+		/*
+		 * If the DT search above couldn't find the provider fallback to
+		 * looking up via clkdev based clk_lookups.
+		 */
 		hw = clk_find_hw(dev_id, name);
+	}
 
 	if (IS_ERR(hw))
 		return ERR_CAST(hw);
@@ -401,7 +423,7 @@ static void clk_core_fill_parent_index(struct clk_core *core, u8 index)
 			parent = ERR_PTR(-EPROBE_DEFER);
 	} else {
 		parent = clk_core_get(core, index);
-		if (IS_ERR(parent) && PTR_ERR(parent) == -ENOENT)
+		if (IS_ERR(parent) && PTR_ERR(parent) == -ENOENT && entry->name)
 			parent = clk_core_lookup(entry->name);
 	}
 
-- 
2.20.1

