Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B66F20E74A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404334AbgF2V4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549A02472B;
        Mon, 29 Jun 2020 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444049;
        bh=HqEiHU2rj80Shi+LPfuxmCzWI+NAFjs/6RR6u3kGg4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPCwjQXKpiVkyv1XmYU2lvdS0bsOQUKu8oAJ6JSM3k90OAbRc/FOsTg2ZYel7jXwA
         +338EP+7h4aYYUwyW9cHpR3ABcTIgGOy4CX/eULhuRjIQqCSBM+UAxUR0F69HPp/4r
         gfgSVGSNfxEIl3TnQtahDqa4YJKs9a5md6yWXgfA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 157/265] ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()
Date:   Mon, 29 Jun 2020 11:16:30 -0400
Message-Id: <20200629151818.2493727-158-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 586745f1598ccf71b0a5a6df2222dee0a865954e ]

if of_find_device_by_node() succeed, imx_suspend_alloc_ocram() doesn't
have a corresponding put_device(). Thus add a jump target to fix the
exception handling for this function implementation.

Fixes: 1579c7b9fe01 ("ARM: imx53: Set DDR pins to high impedance when in suspend to RAM.")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/pm-imx5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index f057df813f83a..e9962b48e30cb 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -295,14 +295,14 @@ static int __init imx_suspend_alloc_ocram(
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
-		goto put_node;
+		goto put_device;
 	}
 
 	ocram_base = gen_pool_alloc(ocram_pool, size);
 	if (!ocram_base) {
 		pr_warn("%s: unable to alloc ocram!\n", __func__);
 		ret = -ENOMEM;
-		goto put_node;
+		goto put_device;
 	}
 
 	phys = gen_pool_virt_to_phys(ocram_pool, ocram_base);
@@ -312,6 +312,8 @@ static int __init imx_suspend_alloc_ocram(
 	if (virt_out)
 		*virt_out = virt;
 
+put_device:
+	put_device(&pdev->dev);
 put_node:
 	of_node_put(node);
 
-- 
2.25.1

