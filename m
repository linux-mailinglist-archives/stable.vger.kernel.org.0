Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E75127C86
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLTO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:29:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbfLTO35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:29:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBE4206CB;
        Fri, 20 Dec 2019 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852196;
        bh=DaKcY2ZpqbDstz9wKYKjtF3MBp5yvPnCH85aOptTh+g=;
        h=From:To:Cc:Subject:Date:From;
        b=pd69Fkx3rDQ1+5mFJx9W0sSYc63XiA6PYX0lhklgJ2u/dscvGoe98DFCoHIKfGUQP
         /oEZXBukDQZt1fc5ovGeDcPr8Wx1dmHl2Cn5KUXqc24eIoBcx9SAdN9zrhqJYxtxBy
         yhLYqCtDFqNKmDfAcZ00Z5so2OhB9emI9VNZZWFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 01/52] drm/mcde: dsi: Fix invalid pointer dereference if panel cannot be found
Date:   Fri, 20 Dec 2019 09:29:03 -0500
Message-Id: <20191220142954.9500-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit c131280c03bd1c225c2e64e9ef75873ffca3d96e ]

The "panel" pointer is not reset to NULL if of_drm_find_panel()
returns an error. Therefore we later assume that a panel was found,
and try to dereference the error pointer, resulting in:

    mcde-dsi a0351000.dsi: failed to find panel try bridge (4294966779)
    Unable to handle kernel paging request at virtual address fffffe03
    PC is at drm_panel_bridge_add.part.0+0x10/0x5c
    LR is at mcde_dsi_bind+0x120/0x464
    ...

Reset "panel" to NULL to avoid this problem.
Also change the format string of the error to %ld to print
the negative errors correctly. The crash above then becomes:

    mcde-dsi a0351000.dsi: failed to find panel try bridge (-517)
    mcde-dsi a0351000.dsi: no panel or bridge
    ...

Fixes: 5fc537bfd000 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191118130252.170324-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_dsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mcde/mcde_dsi.c b/drivers/gpu/drm/mcde/mcde_dsi.c
index f9c9e32b299c9..35bb825d19188 100644
--- a/drivers/gpu/drm/mcde/mcde_dsi.c
+++ b/drivers/gpu/drm/mcde/mcde_dsi.c
@@ -935,11 +935,13 @@ static int mcde_dsi_bind(struct device *dev, struct device *master,
 	for_each_available_child_of_node(dev->of_node, child) {
 		panel = of_drm_find_panel(child);
 		if (IS_ERR(panel)) {
-			dev_err(dev, "failed to find panel try bridge (%lu)\n",
+			dev_err(dev, "failed to find panel try bridge (%ld)\n",
 				PTR_ERR(panel));
+			panel = NULL;
+
 			bridge = of_drm_find_bridge(child);
 			if (IS_ERR(bridge)) {
-				dev_err(dev, "failed to find bridge (%lu)\n",
+				dev_err(dev, "failed to find bridge (%ld)\n",
 					PTR_ERR(bridge));
 				return PTR_ERR(bridge);
 			}
-- 
2.20.1

