Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC5A36393A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhDSCDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 22:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhDSCDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 22:03:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA6EC06174A;
        Sun, 18 Apr 2021 19:03:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u15so8327270plf.10;
        Sun, 18 Apr 2021 19:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPSD3xSDTnWh+Nz3+j4qm9HcpmcWDhRQcIMOD/a1Rz4=;
        b=g9nR0Kbn42QWboT8F+6HxD6U3d0etIiPNbzLS/QlrD4hcH3iJ7r2KuKR8wqfYk1cYx
         gvggLBh2tmd/kffs8WPwAZImhvYs3tMOulBU217tAPhFwZDktxbLk4qL1zSSpIHJKRyI
         EWUjhp1OeyzR5NyRODiA/rXgilfjzroi9Uuo7Rcbcr7N4+neFh3WuMNt+d/lNWtLHQfi
         /UoZKxYxh/R03LJ+Wyc4ANAolRCDzKN/pCRbfSbL5asjPQlvWzPtH90EYQ6halOqKIQG
         pYYckbYvEuFrSgpGT+uw1xcI6ahBFH/2SD8OWAU06pN4xXPh8uGLhs/YlxT25ibL+2rV
         OcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPSD3xSDTnWh+Nz3+j4qm9HcpmcWDhRQcIMOD/a1Rz4=;
        b=CNNYTfGNWFxJEQ4df/s8IYeTFssHhgG6Wq4gEzzxvuScKgyiz60ZP/IfXEBK+hnyVq
         WshSReuJmeIeHRax0h4RsMrh6dbYxPUoT9iJU9Z3Pna9tUHp+3HYERTxdyqwXNCzVhFH
         N8EK0+wx6V6fbLnivj4b6K0cLt1UHqmmrEW0k4nqAljpVQu6kxz9Nz1Wxli9+j+tGTPk
         GlVW2EZ+MNpdoWf+C1826zR1ZLbzIRoO8jJT8kGjTLFT1bFafivD4XStx93ipMSRz6qP
         yX9EBJGAw0PiVa0xORVH5pgDxS9HliYqY7N/wqrzWF0XupdLJDoq9aJKrG8w+98GjxDF
         WiEw==
X-Gm-Message-State: AOAM530ndfIn2VtSg172hgbzXbTNTuvTg+vQXZi0NSPx97ffxScPULHB
        Rgz6WgmoPjl5EfIGDEGs+Q4TH3ZyCfqZH2Hm
X-Google-Smtp-Source: ABdhPJwUK8c2110qQsGdlilhEVH6RNovspU3KzWKZqoF2+bgUFBln1/xQm3+prddHRsNE4KE+2EMDA==
X-Received: by 2002:a17:90a:ff02:: with SMTP id ce2mr22236666pjb.217.1618797788273;
        Sun, 18 Apr 2021 19:03:08 -0700 (PDT)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id kk9sm61753pjb.23.2021.04.18.19.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 19:03:07 -0700 (PDT)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Sandy Huang <hjc@rock-chips.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [RESEND PATCH] drm/rockchip: dsi: remove extra component_del() call
Date:   Sun, 18 Apr 2021 19:03:04 -0700
Message-Id: <201385acb0eeb5dfb037afdc6a94bfbcdab97f99.1618797778.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index 24a71091759c..8cc81d5b82f0 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -243,7 +243,6 @@ struct dw_mipi_dsi_rockchip {
 	struct dw_mipi_dsi *dmd;
 	const struct rockchip_dw_dsi_chip_data *cdata;
 	struct dw_mipi_dsi_plat_data pdata;
-	int devcnt;
 };
 
 struct dphy_pll_parameter_map {
@@ -1121,9 +1120,6 @@ static int dw_mipi_dsi_rockchip_remove(struct platform_device *pdev)
 {
 	struct dw_mipi_dsi_rockchip *dsi = platform_get_drvdata(pdev);
 
-	if (dsi->devcnt == 0)
-		component_del(dsi->dev, &dw_mipi_dsi_rockchip_ops);
-
 	dw_mipi_dsi_remove(dsi->dmd);
 
 	return 0;
-- 
2.30.0

