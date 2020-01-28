Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3414B9CA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgA1OU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731162AbgA1OU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:20:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE7821739;
        Tue, 28 Jan 2020 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221256;
        bh=dfvrLCjUuNwlPrEBLjqxka2nipU725v7isZIiKzbVn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbMAICB/scYzExCppyvu1HcfmL4NzvSAlti5srVCWv7sVNgs1SVekykQBOAp36D3S
         TWONJBIyOGQzRO5sqd5RXbZNHqM8DqaAmCsCXWvgckdKnaZ9S08iVfJHusnOKxLj6R
         LFLeySy1q/wiZZBS1Zz+7rwLZ6Lm6MwhKP7laDlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 115/271] ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
Date:   Tue, 28 Jan 2020 15:04:24 +0100
Message-Id: <20200128135901.136665929@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b92673efffffb..97bd43c16cd87 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -230,18 +230,12 @@ static int pxa_ssp_probe(struct platform_device *pdev)
 
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



