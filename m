Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A663CCD6DE
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfJFRjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfJFRjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14F132080F;
        Sun,  6 Oct 2019 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383581;
        bh=JJiAr0U+y5fK3GJTz/G2EY+1qfyIBZP/h1D8Vy3Euz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv7a+4y8peWBwCQ6mIRjKp5ihLBeSXt5ivc6T9LTKwMiXCaFmXibpy76Mw5nTDsff
         /tt4MPtlxA/pn43bTa8Na0KjQU0F6s3oH2Bjo2XKILIQxVcwTVg7pXJY9nRANuuLdP
         BQsVvg4zO624fmuhT46znQ6NSzA18p7Ie0r0RJgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 002/166] drm/mcde: Fix uninitialized variable
Date:   Sun,  6 Oct 2019 19:19:28 +0200
Message-Id: <20191006171213.003375227@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



