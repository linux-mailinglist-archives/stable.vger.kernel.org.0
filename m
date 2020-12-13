Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8362D90AD
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 21:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgLMU6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbgLMU6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Dec 2020 15:58:22 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30274C0613CF;
        Sun, 13 Dec 2020 12:57:42 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so5385520pjg.1;
        Sun, 13 Dec 2020 12:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+C7df/JhpDNOhvRuvCv8MZFRD0LpPBGsO24mPtK2tQI=;
        b=JAssQKBLdQSUpXX1qdsRhJs56Z8/S+6oAKAbc2F2UTnmO2I+q7uRH9uRh4kOH21iAu
         /RyV5qbTL3/JHc4nWUw6rUycYHRekYUz26ozaJTKdun9or8Jn3ihWkW4HWXRirHD/RAm
         Bbsa12k6y8jSu5N/XXdY4KEQINEtcq2Hhz6/gUW9AA0/zEtIA/9N6apB5ZLhh5oINcp6
         J0s66SmiAsEB+r3QWzQw4NCzqABm2x/uWZN0/zWdfYMK3vHC4pDYVuZX3n4W04xHqH4a
         jV3jwPifpbjlwWQrr0FHxTpwmXU1VBwzhzy21Hb9lY6JIQ6uNQ3lFXB7309yQV78olIj
         jPYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+C7df/JhpDNOhvRuvCv8MZFRD0LpPBGsO24mPtK2tQI=;
        b=Fa/W1iW65+hGVBqLl/t5cfWCOG3Zwf5SB/N8tPyY0E7Iv6cmxmFlXcWGsdEYx3EOvS
         jhHYYae3bO52c5D+nROaE4x6VuX3BV/lnnCgq2a0dfn3JZGnS0XcLkxu330Bcs4zFm5s
         jjHiz0lMJfag0DYgiAT1tt9+NX81AjEADyrJ1OcOQ38StHV/BS0oH5HJng6Vh71vcevV
         mG4lPqyuw+ZOqeS1NKua23kcIZEwsHuLFRr9V+hdmEREoZjgCAJDm4kXTCK2e473kmak
         6UYYxkvGZgLswPfnCsBIdv07oJ/oq0JfRBNF50hhjOFPcPSF6YlBOBH23DRnhYY6HllF
         5+Ng==
X-Gm-Message-State: AOAM531BDrlNXg93D9n8O8OsR18iSUXDpEcN/fjuR1ielylVsnwblWzH
        LHuF5F8OV8f/sRI8ozA+TqKt8ha+fH4mgfsw
X-Google-Smtp-Source: ABdhPJxlNQ9tZOYsryjlZNee15dnRjN02bQG+zSlcPfd2KePaHUVhVXhFDGFhfxyCkac3knOhN+0fQ==
X-Received: by 2002:a17:90b:3698:: with SMTP id mj24mr21767123pjb.149.1607893061404;
        Sun, 13 Dec 2020 12:57:41 -0800 (PST)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id 37sm14173930pjz.41.2020.12.13.12.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:57:40 -0800 (PST)
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
Date:   Sun, 13 Dec 2020 12:57:26 -0800
Message-Id: <149477f8d5d5a76c624766cb8cbdfdb3fa416ee8.1607893019.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.29.2
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
Resending since I wasn't subscribed to dri-devel

 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index 542dcf7eddd6..ce044db8c97e 100644
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
2.29.2

