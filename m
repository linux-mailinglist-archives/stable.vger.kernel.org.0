Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD140E348
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244557AbhIPQqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344057AbhIPQoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A918B61A55;
        Thu, 16 Sep 2021 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809543;
        bh=6dNN8OQPe/wsB34uoI/ICMKD2qSsK5yWqTj8ezysK4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmY7+sfVY2xy75hhNwMbo93rNIvArg5eDlj342+Dr8BiQcWwscc+UnYWi5//Z365g
         OsjaexZdazrGiw/BdGV1emiRbkK7slSwbiGEwZCjYtk5Z2J7Odex7LzDXQB+bpvIy4
         cYjs/SRz902ed22MXDrsylYyralFtqStD6ETvdWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabio Estevam <festevam@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 193/380] drm/bridge: nwl-dsi: Avoid potential multiplication overflow on 32-bit
Date:   Thu, 16 Sep 2021 17:59:10 +0200
Message-Id: <20210916155810.634706308@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 47956bc86ee4e8530cac386a04f62a6095f7afbe ]

As nwl_dsi.lanes is u32, and NSEC_PER_SEC is 1000000000L, the second
multiplication in

    dsi->lanes * 8 * NSEC_PER_SEC

will overflow on a 32-bit platform.  Fix this by making the constant
unsigned long long, forcing 64-bit arithmetic.

As iMX8 is arm64, this driver is currently used on 64-bit platforms
only, where long is 64-bit, so this cannot happen.  But the issue will
start to happen when the driver is reused for a 32-bit SoC (e.g.
i.MX7ULP), or when code is copied for a new driver.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/ebb82941a86b4e35c4fcfb1ef5a5cfad7c1fceab.1626255956.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index c65ca860712d..6cac2e58cd15 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -196,7 +196,7 @@ static u32 ps2bc(struct nwl_dsi *dsi, unsigned long long ps)
 	u32 bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
 
 	return DIV64_U64_ROUND_UP(ps * dsi->mode.clock * bpp,
-				  dsi->lanes * 8 * NSEC_PER_SEC);
+				  dsi->lanes * 8ULL * NSEC_PER_SEC);
 }
 
 /*
-- 
2.30.2



