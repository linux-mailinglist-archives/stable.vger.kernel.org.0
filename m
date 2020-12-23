Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13D22E149C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgLWClY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgLWCXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2973F2313F;
        Wed, 23 Dec 2020 02:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690185;
        bh=1Z2xeE+FnzBDMyXOFEAoZYKo8qjmxghSfR+XpgDDBdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSAn0E7ztPmpy4rXvbMNfgMscL59mPanSvG7s2YRZXMXeiT1bZClq/i1mWZjUTZAd
         7fmfP4/ln8GEwK3nK2TsrXadLcNu9fkLn8V9+X1fxmyhvmrOcgpwSaAKIofmi0W33C
         EtnJHl5j0kfrmQBNnNK6DkvWU8dlcnTivOLMcTU2DCJJ4D40t7CVONxJWN3UuIV1O0
         J4ZLbfqjw+lx58BypGMrVXoEMUQKw4gAOM/zzasuz0PUu6f2HyyhtLfQ+Z/HU2c973
         SLYwfukkUUFCy1FoWe4fGtOOT9RwMQ6R4QEVJ+Cpxu+Lt/FzRgNixPNHymqfUYWLn0
         9bzZLt9wlzg6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/66] mips: cm: add missing iounmap() on error in mips_cm_probe()
Date:   Tue, 22 Dec 2020 21:21:56 -0500
Message-Id: <20201223022253.2793452-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 2673ecf9586551c5bcee499c1cc1949f6f7cc9a1 ]

Add the missing iounmap() of iounmap(mips_gcr_base) before
return from mips_cm_probe() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/mips-cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index 50d3d74001cbe..aedd353b9b925 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -228,6 +228,7 @@ int mips_cm_probe(void)
 	if ((base_reg & CM_GCR_BASE_GCRBASE) != addr) {
 		pr_err("GCRs appear to have been moved (expected them at 0x%08lx)!\n",
 		       (unsigned long)addr);
+		iounmap(mips_gcr_base);
 		mips_gcr_base = NULL;
 		return -ENODEV;
 	}
-- 
2.27.0

