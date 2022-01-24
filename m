Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E0849975B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448558AbiAXVNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59838 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377366AbiAXVIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A76B3B812A5;
        Mon, 24 Jan 2022 21:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC848C340E7;
        Mon, 24 Jan 2022 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058488;
        bh=jwjFmACAnwdgTPgiXQNtUaCkXKpEKBIBAWq4GBFnCFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uafc5laLJhTuj55KZLRMaeo5bC4pnPCJiMCI6CqWbTo87mCSOUwnEkREhMED+FEmX
         +ip5pAE0id8gUNqaXIGfROJwmbuXoQUdjY3eQInGiiUixnyKr0jumCt4FloIhtsLtq
         HmZyjHicLK7oZOaLMKIYBw9FKcMiPJnkKXyiTOKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0298/1039] drm/tegra: gr2d: Explicitly control module reset
Date:   Mon, 24 Jan 2022 19:34:47 +0100
Message-Id: <20220124184135.315889632@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 271fca025a6d43f1c18a48543c5aaf31a31e4694 ]

As of commit 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling
clocks"), module resets are no longer automatically deasserted when the
module clock is enabled. To make sure that the gr2d module continues to
work, we need to explicitly control the module reset.

Fixes: 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling clocks")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gr2d.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index de288cba39055..ba3722f1b8651 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -4,9 +4,11 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/reset.h>
 
 #include "drm.h"
 #include "gem.h"
@@ -19,6 +21,7 @@ struct gr2d_soc {
 struct gr2d {
 	struct tegra_drm_client client;
 	struct host1x_channel *channel;
+	struct reset_control *rst;
 	struct clk *clk;
 
 	const struct gr2d_soc *soc;
@@ -208,6 +211,12 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (!syncpts)
 		return -ENOMEM;
 
+	gr2d->rst = devm_reset_control_get(dev, NULL);
+	if (IS_ERR(gr2d->rst)) {
+		dev_err(dev, "cannot get reset\n");
+		return PTR_ERR(gr2d->rst);
+	}
+
 	gr2d->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(gr2d->clk)) {
 		dev_err(dev, "cannot get clock\n");
@@ -220,6 +229,14 @@ static int gr2d_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(gr2d->rst);
+	if (err < 0) {
+		dev_err(dev, "failed to deassert reset: %d\n", err);
+		goto disable_clk;
+	}
+
 	INIT_LIST_HEAD(&gr2d->client.base.list);
 	gr2d->client.base.ops = &gr2d_client_ops;
 	gr2d->client.base.dev = dev;
@@ -234,8 +251,7 @@ static int gr2d_probe(struct platform_device *pdev)
 	err = host1x_client_register(&gr2d->client.base);
 	if (err < 0) {
 		dev_err(dev, "failed to register host1x client: %d\n", err);
-		clk_disable_unprepare(gr2d->clk);
-		return err;
+		goto assert_rst;
 	}
 
 	/* initialize address register map */
@@ -245,6 +261,13 @@ static int gr2d_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gr2d);
 
 	return 0;
+
+assert_rst:
+	(void)reset_control_assert(gr2d->rst);
+disable_clk:
+	clk_disable_unprepare(gr2d->clk);
+
+	return err;
 }
 
 static int gr2d_remove(struct platform_device *pdev)
@@ -259,6 +282,12 @@ static int gr2d_remove(struct platform_device *pdev)
 		return err;
 	}
 
+	err = reset_control_assert(gr2d->rst);
+	if (err < 0)
+		dev_err(&pdev->dev, "failed to assert reset: %d\n", err);
+
+	usleep_range(2000, 4000);
+
 	clk_disable_unprepare(gr2d->clk);
 
 	return 0;
-- 
2.34.1



