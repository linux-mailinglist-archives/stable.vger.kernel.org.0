Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358576B45A5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjCJOfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjCJOfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:35:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10A4F8288
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A2FEB822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D55C4339B;
        Fri, 10 Mar 2023 14:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458925;
        bh=Q+czA8BMcxhFuCShtXTm1UjpwiFvRSyo6OmeTnk4khU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRvltl1522n8VbHm+sSOgjWA8Zbkz3N52o3e7iR5GZnIthlK58nr+xhZSxoEOBLPN
         sIQu8+LaEz2FRHJMltflk8fwxKSz3tXtdfwXmQWGpRL6aLQvQkq/od4C01xv0ctUuA
         xbryJINB1fct5/50BHNvMfOFsihM8eouJe1VtT2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/357] clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()
Date:   Fri, 10 Mar 2023 14:37:27 +0100
Message-Id: <20230310133741.688596331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 79200d5851c8e7179f68a4a6f162d8f1bde4986f ]

In the previous commits that added CLK_OPS_PARENT_ENABLE, support for
this flag was only added to rate change operations (rate setting and
reparent) and disabling unused subtree. It was not added to the
clock gate related operations. Any hardware driver that needs it for
these operations will either see bogus results, or worse, hang.

This has been seen on MT8192 and MT8195, where the imp_ii2_* clk
drivers set this, but dumping debugfs clk_summary would cause it
to hang.

Prepare parent on prepare and enable parent on enable dependencies are
already handled automatically by the core as part of its sequencing.
Whether the case for "enable parent on prepare" should be supported by
this flag or not is not clear, and thus ignored for now.

This change solely fixes the handling of clk_core_is_enabled, i.e.
enabling the parent clock when reading the hardware state. Unfortunately
clk_core_is_enabled is called in a variety of places, sometimes with
the enable clock already held. To avoid deadlocking, the core will
ignore readouts and just return false if CLK_OPS_PARENT_ENABLE is set
but the parent isn't currently enabled.

Fixes: fc8726a2c021 ("clk: core: support clocks which requires parents enable (part 2)")
Fixes: a4b3518d146f ("clk: core: support clocks which requires parents enable (part 1)")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230103092330.494102-1-wenst@chromium.org
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c002f83adf573..1c73668b43755 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -251,6 +251,17 @@ static bool clk_core_is_enabled(struct clk_core *core)
 		}
 	}
 
+	/*
+	 * This could be called with the enable lock held, or from atomic
+	 * context. If the parent isn't enabled already, we can't do
+	 * anything here. We can also assume this clock isn't enabled.
+	 */
+	if ((core->flags & CLK_OPS_PARENT_ENABLE) && core->parent)
+		if (!clk_core_is_enabled(core->parent)) {
+			ret = false;
+			goto done;
+		}
+
 	ret = core->ops->is_enabled(core->hw);
 done:
 	if (core->rpm_enabled)
-- 
2.39.2



