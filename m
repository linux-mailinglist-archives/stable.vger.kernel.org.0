Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F272E3988
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388721AbgL1NYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388754AbgL1NYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3BD52076D;
        Mon, 28 Dec 2020 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161836;
        bh=omeGwpKob5krkYf00FuukKZDGrFgRZLhv+qccT7cFTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0WFycbC/6WomUyfeiLkOQkPG3fV7Bq7LuXiaHxJ+69UIacYNzDd5gHqcTr2P2l9U
         cXdnqhI7poaxGBHy5gPku7UqnhK6F6cc/TU5mBvVIxy3fYF2uiwF6MYNG77GvLWFWJ
         ohGe3B9v4Ma0iRew9YVFQejPs0TiCuSJnn8o5B4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/346] drm/tve200: Fix handling of platform_get_irq() error
Date:   Mon, 28 Dec 2020 13:46:58 +0100
Message-Id: <20201228124924.568494183@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index ac344ddb23bc8..f93384c232066 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -223,8 +223,8 @@ static int tve200_probe(struct platform_device *pdev)
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



