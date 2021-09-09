Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47C3404A67
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhIILqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240096AbhIILo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:44:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E605F611BD;
        Thu,  9 Sep 2021 11:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187751;
        bh=UZWytWGmXwex4+/1vb6H6PHBd6Zm9qo4AOXiHRecuTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMGmPaUjg9Zrn+I63BEkTcfasCFlFL2lFEfc5T0SPv/8XrHiv2eJITmNkjjmJ6pCh
         BE8sB/ybN81HdGU5mkm5VP8ERvS+URvCwCwYIotsmvEcCEu9y4BMSFDURMAJmIc8Wi
         PzVq5FntYtY3xecUZBEgZKSybOTQ+Cyql08EwWhgzlXvl9o8OQuc1hdvtFgri7usPv
         20fzt4LCZwZKCWQ02+L1oyT2Ssbg+cO1oCs/rreUhTx0TocfBw5XwoxuVgVOKTH7/z
         trcTcWowwGEXnOUIcq8j/yZ0E+9dzu5tJX3riNgAAVmho4JqxQbd8b/x28oDXm/PSn
         BN9z55bXeGlpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabio Estevam <festevam@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 066/252] drm/bridge: nwl-dsi: Avoid potential multiplication overflow on 32-bit
Date:   Thu,  9 Sep 2021 07:38:00 -0400
Message-Id: <20210909114106.141462-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 873995f0a741..6002404ffcb9 100644
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

