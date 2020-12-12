Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD23A2D8A4C
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 23:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408082AbgLLWYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 17:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgLLWYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 17:24:46 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559BCC0613CF;
        Sat, 12 Dec 2020 14:24:06 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id p4so9534030pfg.0;
        Sat, 12 Dec 2020 14:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtJXBVt7gHI21bYFoZ1JoDV4VjhjgVIaaJDaUSnjM6k=;
        b=pY6anJiq1VYF1jMzjF+dcOuysiwgKQDBjxl4pI8MvZXad/L5wQeiVvdBaxzIBH4eXF
         I0u0mlSOK6Q1WgcgHP4nVk4j5+r9Fe7OHS/lRK5OMbfKq3aPDYcmkDpA2KR5OrRrdHJ5
         kOMhOOGcT5JwrjmDUIutKsPkSxPFJdqC6jG22WHBKp34KLojdw+IeJ9eI2bOfk/NOenP
         ckFJQvY6Nx+gkkerIPwjQn7qOmkWBz2Xpncl37I+ibqgkLWqhTTuA4Xznaikb0/Vs821
         W+sq6zDvupwDluvrcNkKqZ8zrN6TrTapk3X6/IYF27VPMZaUCDKbH2C5j5WRaihImvDq
         fLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtJXBVt7gHI21bYFoZ1JoDV4VjhjgVIaaJDaUSnjM6k=;
        b=EWdm5Raks9aJf0B80+FLu1dJekxht5c4KORQeGc74aOOVOPaPuvLylf0yJ+ENpG++4
         R8Su1cyWBFlqqyP449T43GRuFSJD/sSCbNdGlK4G1rghD2TFgEqx7KUs5OhfJKZZYgUN
         FzbWZuJJv7BF0g0s2oxpavCxgiT6J3wNyyIT4U8ixi2/NqDbCNenxGTfT9CJqvjjM+Rd
         tdf3zlCIMbzZYIbeQJabUDbQMHVhi53Ef6VPjmrw6qUijhe0aJduKp/AyWedJVwChI5n
         8eOU8Dw1YKIO+Nk7/7aAdhTnEzQHd927gA0LS5HCzCo/19myeTdkreJAYyzXDAnEuQWo
         8i1A==
X-Gm-Message-State: AOAM533f1zPZcBE8VDO6FqebcuRhqaoiGM8ncg/phU5YmfNJUHjnP1Sn
        WMSywUAzetlGIjfiMO25qwUhdm1niHDbv7rZ
X-Google-Smtp-Source: ABdhPJzLYLeOuMQKOWMGgFp4pj8D4j+yoysIS0L8UZ95aYc/Z8WmvA33yxJuB5XMv5grTtczBMPB2A==
X-Received: by 2002:aa7:9738:0:b029:19d:dce0:d8e7 with SMTP id k24-20020aa797380000b029019ddce0d8e7mr17276456pfg.14.1607811845359;
        Sat, 12 Dec 2020 14:24:05 -0800 (PST)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id na6sm13244256pjb.12.2020.12.12.14.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 14:24:04 -0800 (PST)
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
Subject: [PATCH] drm/rockchip: dsi: remove extra component_del() call
Date:   Sat, 12 Dec 2020 14:23:55 -0800
Message-Id: <b6fef187969c45c3153d90bfd1cba684b764a225.1607811826.git.tommyhebb@gmail.com>
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

