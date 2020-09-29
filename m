Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B4A27C8BC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbgI2MER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgI2Lhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D152208FE;
        Tue, 29 Sep 2020 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379472;
        bh=KgF/AJpqk+vmKHHC+vNBhLCqFwnLbqJ92CG2r6+ZfDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7Bve0zf4BGJE1kfGgSRbwWuQqMnadzTB6Ef7gvf9vMPr8qkZX/4DEOL7GBRUNryq
         lBxYQ7m12yPAfnQM3PwUqglY68DQJLaatySAsYMhPYGTbpV7CB9F238kYefIz/jAym
         GenJuB+3In2dcr2gBgFofvy41p20ExzDmEJ/PGmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/388] thermal: rcar_thermal: Handle probe error gracefully
Date:   Tue, 29 Sep 2020 12:58:29 +0200
Message-Id: <20200929110019.101605752@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 39056e8a989ef52486e063e34b4822b341e47b0e ]

If the common register memory resource is not available the driver needs
to fail gracefully to disable PM. Instead of returning the error
directly store it in ret and use the already existing error path.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200310114709.1483860-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index d0873de718da9..43f0cd2bd0ae6 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -526,8 +526,10 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 			res = platform_get_resource(pdev, IORESOURCE_MEM,
 						    mres++);
 			common->base = devm_ioremap_resource(dev, res);
-			if (IS_ERR(common->base))
-				return PTR_ERR(common->base);
+			if (IS_ERR(common->base)) {
+				ret = PTR_ERR(common->base);
+				goto error_unregister;
+			}
 
 			idle = 0; /* polling delay is not needed */
 		}
-- 
2.25.1



