Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7E41330EC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgAGU4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgAGU4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3902B2081E;
        Tue,  7 Jan 2020 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430574;
        bh=hgVZmdjmoaFFQFb3gUYdr4Lz0gk+Zd7/7MRIZfKlTOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nD+8Cj+mqJo7TX2zjtB0FNVKIhkG/30NlfStQq/zwhjL5F01a/dp5xoJbKU72mYKz
         z1Ac7mL6RZjFjIouBK9w2xiFovXdHM46vXm1k7UlftnwONVW/A1cgeOo0xqn8m1gWV
         Xc5+QPPZOWxyFKBJzAwaC5jDnYZ1rI3FaotTGVaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/191] drm/mcde: dsi: Fix invalid pointer dereference if panel cannot be found
Date:   Tue,  7 Jan 2020 21:52:01 +0100
Message-Id: <20200107205333.084061484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f9c9e32b299c..35bb825d1918 100644
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



