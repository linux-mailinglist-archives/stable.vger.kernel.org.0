Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174D713EC27
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbgAPRof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405851AbgAPRof (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69AE24763;
        Thu, 16 Jan 2020 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196674;
        bh=lk3FVBU4uC8MX9Fd58BWPUzIhSu9tVPZz+az2+3aBhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNGHNvAZzXiYiQTu0XHt6WLHuaUKY/i6yLprVI6mdYfJ83wIChteP/EazPOl10+jm
         oeEU3Ll9ovkV4kRKLdH+1GlEJSjWHFTvQAMiuDv9KqdV+gbTWIl9jF7mzUJ3M0iWJr
         lKm5dZkt+D5RZRZj12uLey8lPED/Ed5963RIzBIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 074/174] ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
Date:   Thu, 16 Jan 2020 12:41:11 -0500
Message-Id: <20200116174251.24326-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 9ee8578d953023cc57e7e736ae48502c707c0210 ]

Since commit 1c459de1e645 ("ARM: pxa: ssp: use devm_ functions")
kfree, iounmap, clk_put etc are not needed anymore in remove path.

Fixes: 1c459de1e645 ("ARM: pxa: ssp: use devm_ functions")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
[ commit message spelling fix ]
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/plat-pxa/ssp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index 6748827c2ec8..b6b0979e3cf9 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -231,18 +231,12 @@ static int pxa_ssp_probe(struct platform_device *pdev)
 
 static int pxa_ssp_remove(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct ssp_device *ssp;
 
 	ssp = platform_get_drvdata(pdev);
 	if (ssp == NULL)
 		return -ENODEV;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	clk_put(ssp->clk);
-
 	mutex_lock(&ssp_lock);
 	list_del(&ssp->node);
 	mutex_unlock(&ssp_lock);
-- 
2.20.1

