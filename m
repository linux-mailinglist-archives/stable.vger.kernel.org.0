Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D42E6431
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404254AbgL1Nmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404216AbgL1Nmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A959822A84;
        Mon, 28 Dec 2020 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162919;
        bh=E7nQz5qCYUvqS1g9hnxZBuljdneQ9uDrTbEnVh0Gt1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SedmBfpJZUgEyaVluJHnHHjXhsBq4Rg+COYt1nr9xRKdfDfzBAM+I7tNCsqQbUPkM
         9zsbs0we7a9vKMkr7PHlLerKf1NYLEy3qLp4FG5q9ekWgD+kAhZsyZb96bbI/vm4s5
         YAyWDa69r7Un5OgytPuh98PXFyVn/BRBEcMdW0EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/453] drm/mcde: Fix handling of platform_get_irq() error
Date:   Mon, 28 Dec 2020 13:45:11 +0100
Message-Id: <20201228124940.846746844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit e2dae672a9d5e11856fe30ede63467c65f999a81 ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: 5fc537bfd000 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200827071107.27429-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mcde/mcde_drv.c b/drivers/gpu/drm/mcde/mcde_drv.c
index 16e5fb9ec784d..82946ffcb6d21 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -410,8 +410,8 @@ static int mcde_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		ret = -EINVAL;
+	if (irq < 0) {
+		ret = irq;
 		goto clk_disable;
 	}
 
-- 
2.27.0



