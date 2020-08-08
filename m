Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C2823FA27
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgHHXlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgHHXlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:41:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D842F20658;
        Sat,  8 Aug 2020 23:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930064;
        bh=7Z67yiuQegVjWrCGGCo7BKtRbYxNROfYlA/TcJ0SUjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHIvV8vLsnv13AZs5tquGDWnerIiixWWW2YBIiJAfEfFbYt+mNHtRSjbpzgfLFQfX
         54ROTbghvWhq4Q4fPgJBCNClIiiYJdvh16Hk8zS9kbkhPVMw5N0fPIMmw+SOeAz/gr
         B07i0B+cs4RqBXCoqULePMSg7cYPaXsLbQMPuzq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 4/5] ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()
Date:   Sat,  8 Aug 2020 19:40:52 -0400
Message-Id: <20200808234054.3619873-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808234054.3619873-1-sashal@kernel.org>
References: <20200808234054.3619873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit f87a4f022c44e5b87e842a9f3e644fba87e8385f ]

if of_find_device_by_node() succeed, at91_pm_sram_init() doesn't have
a corresponding put_device(). Thus add a jump target to fix the exception
handling for this function implementation.

Fixes: d2e467905596 ("ARM: at91: pm: use the mmio-sram pool to access SRAM")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200604123301.3905837-1-yukuai3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 84eefbc2b4f93..5923f2ca510be 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -393,13 +393,13 @@ static void __init at91_pm_sram_init(void)
 	sram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!sram_pool) {
 		pr_warn("%s: sram pool unavailable!\n", __func__);
-		return;
+		goto out_put_device;
 	}
 
 	sram_base = gen_pool_alloc(sram_pool, at91_pm_suspend_in_sram_sz);
 	if (!sram_base) {
 		pr_warn("%s: unable to alloc sram!\n", __func__);
-		return;
+		goto out_put_device;
 	}
 
 	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
@@ -407,12 +407,17 @@ static void __init at91_pm_sram_init(void)
 					at91_pm_suspend_in_sram_sz, false);
 	if (!at91_suspend_sram_fn) {
 		pr_warn("SRAM: Could not map\n");
-		return;
+		goto out_put_device;
 	}
 
 	/* Copy the pm suspend handler to SRAM */
 	at91_suspend_sram_fn = fncpy(at91_suspend_sram_fn,
 			&at91_pm_suspend_in_sram, at91_pm_suspend_in_sram_sz);
+	return;
+
+out_put_device:
+	put_device(&pdev->dev);
+	return;
 }
 
 static void __init at91_pm_init(void)
-- 
2.25.1

