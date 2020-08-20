Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1349224BA2D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgHTMBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbgHTKAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FCFE208DB;
        Thu, 20 Aug 2020 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917604;
        bh=VV39/e+5QHHtPRI8mr7TPAiaSliMBkOT1PdczhdxBf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKAP9NjB4jJhefLbf4WUONrLCcimxvpo7P7VtqV+tYgy2nctE1FRFt9En+jUC/Nrf
         e0IKg1JtlTQDxJ/AspWtX29eoNNaR5bh3nfJn7T3YHcRcIOZ1fVl1NITiMZHymYSvK
         4g7+pR+22VFLXmtppGI2wiznSHRUzm3o6ojQDUWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yu kuai <yukuai3@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 089/212] ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()
Date:   Thu, 20 Aug 2020 11:21:02 +0200
Message-Id: <20200820091606.844090402@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8ba0e2e5ad97c..0efac1404418e 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -411,13 +411,13 @@ static void __init at91_pm_sram_init(void)
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
@@ -425,12 +425,17 @@ static void __init at91_pm_sram_init(void)
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
 
 static const struct of_device_id atmel_pmc_ids[] __initconst = {
-- 
2.25.1



