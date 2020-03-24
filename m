Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6773F190EE4
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgCXNPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgCXNPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:15:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC039206F6;
        Tue, 24 Mar 2020 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055743;
        bh=bX0nVfN/TeCkwAQSkAb92VURqb0P0SUE2xUDDSS2voo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMvkFeGkqt1++1LBJ+neJi7kMmUJPsQ+GoQlMRaPZUa9YDCLLaE1KvzLX+CzXZWk0
         QkIz395SvLxpty1xSC99T1TEaBQ5j9xleho9A/NKSsgKUS8G0MrIvB4oR3YdYc3AlX
         lKmBgqbIveMfWjXhyb9FT/y+pHvpk85GBTL/CILQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/102] drm/exynos: dsi: propagate error value and silence meaningless warning
Date:   Tue, 24 Mar 2020 14:10:07 +0100
Message-Id: <20200324130808.095853377@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 0a9d1e3f3f038785ebc72d53f1c409d07f6b4ff5 ]

Properly propagate error value from devm_regulator_bulk_get() and don't
confuse user with meaningless warning about failure in getting regulators
in case of deferred probe.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 6926cee91b367..2767408c4750e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1750,8 +1750,9 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(dsi->supplies),
 				      dsi->supplies);
 	if (ret) {
-		dev_info(dev, "failed to get regulators: %d\n", ret);
-		return -EPROBE_DEFER;
+		if (ret != -EPROBE_DEFER)
+			dev_info(dev, "failed to get regulators: %d\n", ret);
+		return ret;
 	}
 
 	dsi->clks = devm_kcalloc(dev,
-- 
2.20.1



