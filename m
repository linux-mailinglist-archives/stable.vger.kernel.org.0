Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC24C2117F0
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgGBBXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgGBBXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5252320B80;
        Thu,  2 Jul 2020 01:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653026;
        bh=OGAKdSZ8VrrAKRK37I5vA2jSCvJPF1tOH1IbD7gGY10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xphRXpJtICTGFsPyIbYPqoiO7CLCzUx51jkuIvgpeMurOvROCfAcMdq17fqkvp7RM
         KFs8cAQpx7iMwyXgV1CLHfdRMo3Q2HGoCenseQWUlM7ytfJnNN1vn4SAK5Ik/Qrn/f
         BuOdPtYIRysO9qmAZ1J6IIfAt6uaFzKKWJ7aOdSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 41/53] ARM: imx6: add missing put_device() call in imx6q_suspend_init()
Date:   Wed,  1 Jul 2020 21:21:50 -0400
Message-Id: <20200702012202.2700645-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 4845446036fc9c13f43b54a65c9b757c14f5141b ]

if of_find_device_by_node() succeed, imx6q_suspend_init() doesn't have a
corresponding put_device(). Thus add a jump target to fix the exception
handling for this function implementation.

Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/pm-imx6.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index dd34dff137626..40c74b4c4d730 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -493,14 +493,14 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
-		goto put_node;
+		goto put_device;
 	}
 
 	ocram_base = gen_pool_alloc(ocram_pool, MX6Q_SUSPEND_OCRAM_SIZE);
 	if (!ocram_base) {
 		pr_warn("%s: unable to alloc ocram!\n", __func__);
 		ret = -ENOMEM;
-		goto put_node;
+		goto put_device;
 	}
 
 	ocram_pbase = gen_pool_virt_to_phys(ocram_pool, ocram_base);
@@ -523,7 +523,7 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 	ret = imx6_pm_get_base(&pm_info->mmdc_base, socdata->mmdc_compat);
 	if (ret) {
 		pr_warn("%s: failed to get mmdc base %d!\n", __func__, ret);
-		goto put_node;
+		goto put_device;
 	}
 
 	ret = imx6_pm_get_base(&pm_info->src_base, socdata->src_compat);
@@ -570,7 +570,7 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 		&imx6_suspend,
 		MX6Q_SUSPEND_OCRAM_SIZE - sizeof(*pm_info));
 
-	goto put_node;
+	goto put_device;
 
 pl310_cache_map_failed:
 	iounmap(pm_info->gpc_base.vbase);
@@ -580,6 +580,8 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 	iounmap(pm_info->src_base.vbase);
 src_map_failed:
 	iounmap(pm_info->mmdc_base.vbase);
+put_device:
+	put_device(&pdev->dev);
 put_node:
 	of_node_put(node);
 
-- 
2.25.1

