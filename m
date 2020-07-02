Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98174211933
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgGBBcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgGBB0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C6620CC7;
        Thu,  2 Jul 2020 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653179;
        bh=Q2MQEtr+CSaJZHSeQwOckpdV+3WWIi2j7jMMtoNTEXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guNcNZeae5G2wQEHCflFvn1TJBwbEJWRwWO0071EkU0edSw/HHLm9wOqsIyebyZk8
         p0x22MgovN74xojaVwNuYqjZX/6LR6IBxp6E26KHWWlqwjqYdV7nWOjBrCDrZlFXh/
         gjHJI9K3zrh4QKzhyW8Omwi6q9OC94beEgwIG8Uw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/27] drm/tegra: hub: Do not enable orphaned window group
Date:   Wed,  1 Jul 2020 21:25:51 -0400
Message-Id: <20200702012615.2701532-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
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
index bb97cad1eb699..b08ce1125996d 100644
--- a/drivers/gpu/drm/tegra/hub.c
+++ b/drivers/gpu/drm/tegra/hub.c
@@ -143,7 +143,9 @@ int tegra_display_hub_prepare(struct tegra_display_hub *hub)
 	for (i = 0; i < hub->soc->num_wgrps; i++) {
 		struct tegra_windowgroup *wgrp = &hub->wgrps[i];
 
-		tegra_windowgroup_enable(wgrp);
+		/* Skip orphaned window group whose parent DC is disabled */
+		if (wgrp->parent)
+			tegra_windowgroup_enable(wgrp);
 	}
 
 	return 0;
@@ -160,7 +162,9 @@ void tegra_display_hub_cleanup(struct tegra_display_hub *hub)
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

