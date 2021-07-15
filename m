Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE883CA933
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhGOTFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243687AbhGOTEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6261861408;
        Thu, 15 Jul 2021 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375635;
        bh=bt7xYdT3o41wmLlK6OKXwu3KBxgrFKysomVDbmPufA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtoynqVQe7GNRDBr03hlUyHeVqBibfv6VdsGEdqbXSxdeENhA62W8zJbgATi+19Kd
         tw4FP6jKhKDVe3E6Hi5+mdfnq8zLknMBd9po8q2FPyRlCwpAa5oHUXPBvqBST78t/M
         Xwobrp7Oon3ld61nYmWXDLYt7OPmgmbm9Dy+8GJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.12 172/242] drm/rockchip: dsi: remove extra component_del() call
Date:   Thu, 15 Jul 2021 20:38:54 +0200
Message-Id: <20210715182623.491971242@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit b354498bbe65c917d521b3b56317ddc9ab217425 upstream.

commit cf6d100dd238 ("drm/rockchip: dsi: add dual mipi support") added
this devcnt field and call to component_del(). However, these both
appear to be erroneous changes left over from an earlier version of the
patch. In the version merged, nothing ever modifies devcnt, meaning
component_del() runs unconditionally and in addition to the
component_del() calls in dw_mipi_dsi_rockchip_host_detach(). The second
call fails to delete anything and produces a warning in dmesg.

If we look at the previous version of the patch[1], however, we see that
it had logic to calculate devcnt and call component_add() in certain
situations. This was removed in v6, and the fact that the deletion code
was not appears to have been an oversight.

[1] https://patchwork.kernel.org/project/dri-devel/patch/20180821140515.22246-8-heiko@sntech.de/

Fixes: cf6d100dd238 ("drm/rockchip: dsi: add dual mipi support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/201385acb0eeb5dfb037afdc6a94bfbcdab97f99.1618797778.git.tommyhebb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -243,7 +243,6 @@ struct dw_mipi_dsi_rockchip {
 	struct dw_mipi_dsi *dmd;
 	const struct rockchip_dw_dsi_chip_data *cdata;
 	struct dw_mipi_dsi_plat_data pdata;
-	int devcnt;
 };
 
 struct dphy_pll_parameter_map {
@@ -1141,9 +1140,6 @@ static int dw_mipi_dsi_rockchip_remove(s
 {
 	struct dw_mipi_dsi_rockchip *dsi = platform_get_drvdata(pdev);
 
-	if (dsi->devcnt == 0)
-		component_del(dsi->dev, &dw_mipi_dsi_rockchip_ops);
-
 	dw_mipi_dsi_remove(dsi->dmd);
 
 	return 0;


