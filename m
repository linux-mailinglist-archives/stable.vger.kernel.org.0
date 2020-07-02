Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34A221195F
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgGBBeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgGBBZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:25:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A820520C56;
        Thu,  2 Jul 2020 01:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653132;
        bh=PicvQyCmYjbabjebAGQywoanKUquUwhTmz7YPtq97PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsrYzcm6lGSXW9KlfV0FRyEFczRuWPU7C7q0GYgAheFFpgAhwzrvEYsmor/0PN6ZP
         rsbTaW6OdtIs/nInB2JyuXQNAAnwUgRHr5YY1H05H5kgvFsQhJvRrq/MjVNM35LsAW
         1h7N7u1GddLreigST9oFE3UAMckU0+natiow7WlM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/40] drm/tegra: hub: Do not enable orphaned window group
Date:   Wed,  1 Jul 2020 21:23:27 -0400
Message-Id: <20200702012402.2701121-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012402.2701121-1-sashal@kernel.org>
References: <20200702012402.2701121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicoleotsuka@gmail.com>

[ Upstream commit ef4e417eb3ec7fe657928f10ac1d2154d8a5fb38 ]

Though the unconditional enable/disable code is not a final solution,
we don't want to run into a NULL pointer situation when window group
doesn't link to its DC parent if the DC is disabled in Device Tree.

So this patch simply adds a check to make sure that window group has
a valid parent before running into tegra_windowgroup_enable/disable.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/hub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/hub.c b/drivers/gpu/drm/tegra/hub.c
index 839b49c40e514..767fb440a79d9 100644
--- a/drivers/gpu/drm/tegra/hub.c
+++ b/drivers/gpu/drm/tegra/hub.c
@@ -141,7 +141,9 @@ int tegra_display_hub_prepare(struct tegra_display_hub *hub)
 	for (i = 0; i < hub->soc->num_wgrps; i++) {
 		struct tegra_windowgroup *wgrp = &hub->wgrps[i];
 
-		tegra_windowgroup_enable(wgrp);
+		/* Skip orphaned window group whose parent DC is disabled */
+		if (wgrp->parent)
+			tegra_windowgroup_enable(wgrp);
 	}
 
 	return 0;
@@ -158,7 +160,9 @@ void tegra_display_hub_cleanup(struct tegra_display_hub *hub)
 	for (i = 0; i < hub->soc->num_wgrps; i++) {
 		struct tegra_windowgroup *wgrp = &hub->wgrps[i];
 
-		tegra_windowgroup_disable(wgrp);
+		/* Skip orphaned window group whose parent DC is disabled */
+		if (wgrp->parent)
+			tegra_windowgroup_disable(wgrp);
 	}
 }
 
-- 
2.25.1

