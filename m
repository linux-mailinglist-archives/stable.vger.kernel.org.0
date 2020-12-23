Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE382E1593
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgLWCuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729520AbgLWCV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35622225AA;
        Wed, 23 Dec 2020 02:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690077;
        bh=1Z2xeE+FnzBDMyXOFEAoZYKo8qjmxghSfR+XpgDDBdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enDZRBW8CulfSkgZVwkGy2VOT09GG1hDx1f4PKuPS1nSxjwW78ojZmt1tB5qJIQcI
         yH1/tqSRjicZU8omuNtsZB3EUiBuOQW3Yh1biwuGe8FSuFhO67DfLJ/o+aTNaFnLzf
         45JBvDT09jzEd70saF09ebvRmpY+AU6OyohuSzs8B5kPZvWo/cIDZc/V4oTO942NSl
         oQ+qlON1BH+YOuz5ojbhlcAHfx+/caPbdq3XJmXMcCYitLMjsf53ztYK+YQ+HZ8VXL
         ElPPfVeL0W9MAErHi0PvBeXKSsJdt0fRJ1+DZMgpSkVEmUh1RjymJRGIgSrAao5ssM
         FvmcBKrYUA7EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/87] mips: cm: add missing iounmap() on error in mips_cm_probe()
Date:   Tue, 22 Dec 2020 21:19:47 -0500
Message-Id: <20201223022103.2792705-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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

