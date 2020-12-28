Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850922E3C2F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407679AbgL1N7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407684AbgL1N7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21BE02064B;
        Mon, 28 Dec 2020 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163966;
        bh=+edES7jz8nep5jY75VEaLuUjwmi94DKALngqGFtezi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3lpDN+y/Y/Q9/BK/678ntQl14vuKF+QhYGsswq7gpDPPIA6DMsaJbR3LjuAnEMzr
         LvoPiRB0MylsL5pkx1qSz1252Tx/IZvgWs2lEqYi3G1MOD/2bFHIU8VoxvzAh0Lp39
         pY9sKE2yQ6OV8RyTm2+FpkM0g71yNe+enwBoe1zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/717] drm/tve200: Fix handling of platform_get_irq() error
Date:   Mon, 28 Dec 2020 13:40:04 +0100
Message-Id: <20201228125021.288843512@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 77bb5aaf2bb8180e7d1bb70b4df306f511707a7d ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: 179c02fe90a4 ("drm/tve200: Add new driver for TVE200")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200827071107.27429-2-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tve200/tve200_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tve200/tve200_drv.c b/drivers/gpu/drm/tve200/tve200_drv.c
index c3aa39bd38ecd..b5259cb1383fc 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -200,8 +200,8 @@ static int tve200_probe(struct platform_device *pdev)
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



