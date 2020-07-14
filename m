Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D521FC51
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgGNTIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgGNSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8866D21D6C;
        Tue, 14 Jul 2020 18:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752626;
        bh=PicvQyCmYjbabjebAGQywoanKUquUwhTmz7YPtq97PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfJYhmH5ANs6gjxv1QZ7k5XtqtVX9gisrLvw71iJkWKAM2EiW5lXpoLF1zXqHgyfp
         yvW4mCEtw+8knDWLfXXQ9BO1PAvGvsfSaI6V3m9e8NdQu6cR0D9TNPyV+Ly91ocXmr
         Q+BoyaPEqYk7PfjPqArbkAlRSUU3GSit3RyqpceU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/109] drm/tegra: hub: Do not enable orphaned window group
Date:   Tue, 14 Jul 2020 20:43:12 +0200
Message-Id: <20200714184105.971715226@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



