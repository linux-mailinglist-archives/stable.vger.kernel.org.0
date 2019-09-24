Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAABD01B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391024AbfIXQls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387883AbfIXQls (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:41:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5885214AF;
        Tue, 24 Sep 2019 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343307;
        bh=JJiAr0U+y5fK3GJTz/G2EY+1qfyIBZP/h1D8Vy3Euz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ubed0fei0sVyT65EoNcGl98TW5U5ab6fteJYCRgkYx65ZfJ6Mq1hMMNdu2sn0bdhK
         nFwsMzyY9oS1fPKLC6FC8zkZRAwPKovGOaKepi9Min1aApm7mkEymuw5lt3seCyVob
         6wqpr+l2H021tquwaQrDNl35PzJJ8hAII5OMFahk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 02/87] drm/mcde: Fix uninitialized variable
Date:   Tue, 24 Sep 2019 12:40:18 -0400
Message-Id: <20190924164144.25591-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit ca5be902a87ddccc88144f2dea21b5f0814391ef ]

We need to handle the case when of_drm_find_bridge() returns
NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618115245.13915-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mcde/mcde_drv.c b/drivers/gpu/drm/mcde/mcde_drv.c
index baf63fb6850a4..a810568c76df7 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -319,7 +319,7 @@ static int mcde_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct drm_device *drm;
 	struct mcde *mcde;
-	struct component_match *match;
+	struct component_match *match = NULL;
 	struct resource *res;
 	u32 pid;
 	u32 val;
@@ -485,6 +485,10 @@ static int mcde_probe(struct platform_device *pdev)
 		}
 		put_device(p);
 	}
+	if (!match) {
+		dev_err(dev, "no matching components\n");
+		return -ENODEV;
+	}
 	if (IS_ERR(match)) {
 		dev_err(dev, "could not create component match\n");
 		ret = PTR_ERR(match);
-- 
2.20.1

