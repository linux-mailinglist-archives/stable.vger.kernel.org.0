Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C240F26B5C7
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgIOXvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgIOOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F89722C9E;
        Tue, 15 Sep 2020 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179846;
        bh=pqkBCZbfXLAK3NI373fRnWPFNbYoVbdXIH8h5Xe3rZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKgCa5i80ltRy9bPMTcii6c4SWxAsqfEHm+lqEtilcwlYzeN+oWJwOp6g+pQZBft1
         Bn7TO5DkYzkCzxJ7z7girisfaNBTr4Ok1CzXIsjwfb6z2iTkSdKd0dHtmsF1eJSBzp
         JMBJNP2yam9g/9e9ocFq9VSULJx/tsZPMm4jexQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 001/177] ARM: OMAP2+: Fix an IS_ERR() vs NULL check in _get_pwrdm()
Date:   Tue, 15 Sep 2020 16:11:12 +0200
Message-Id: <20200915140653.691038767@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit a58cfdba2039ff2d5758840e97a23a2dedecf1e8 ]

The of_clk_get() function returns error pointers, it never returns NULL.

Fixes: 4ea3711aece4 ("ARM: OMAP2+: omap-iommu.c conversion to ti-sysc")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index 54aff33e55e6e..bfa5e1b8dba7f 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -74,7 +74,7 @@ static struct powerdomain *_get_pwrdm(struct device *dev)
 		return pwrdm;
 
 	clk = of_clk_get(dev->of_node->parent, 0);
-	if (!clk) {
+	if (IS_ERR(clk)) {
 		dev_err(dev, "no fck found\n");
 		return NULL;
 	}
-- 
2.25.1



