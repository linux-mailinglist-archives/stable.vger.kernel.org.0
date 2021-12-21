Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915A847B705
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhLUB57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhLUB56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A477C06173E;
        Mon, 20 Dec 2021 17:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9704B61355;
        Tue, 21 Dec 2021 01:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2697AC36AEC;
        Tue, 21 Dec 2021 01:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051877;
        bh=Lrz4hRBiMCBvp7sbl+owa5QpcCfbEP43ybDCr9Z1Gbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMbyAVo9JLGd2eBTokxinSiynNZh/9eExbFyWblmQcyYgWFZbXhLjtLKZlHs5e1wp
         pD5uesfs/jxE0PivChtFw7YIqtwLvFSdGX+4GILetW6IjTFs65jgCHFBy/VbJk9JHD
         L19dJ4Ed89jHdNyIYU3ezvfiDPbx55Jyk++0OCd//kMeenCST3/uCne/R05+U0YE2j
         +91nrZiwraP+JWt6wX3aWu14mkYolO4Name46mPrHaPD4clAb3q1wibfL6escZhWeT
         siwtaPMbxK10u0V51pLXH66dibS1aviLTC3FB/5CfOMMnRrYJtVxeGq0dowCrbDEaP
         2Lz9/AJOBSGMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 03/29] ARM: rockchip: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Mon, 20 Dec 2021 20:57:24 -0500
Message-Id: <20211221015751.116328-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@suse.de>

[ Upstream commit 423e85e97aaf69e5198bbec6811e3825c8b5019a ]

This fixes a potential kernel panic on memcpy when FORTIFY_SOURCE
is enabled. Because memory is iomem use appropriate function for
accessing it.

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20211116084616.24811-1-iivanov@suse.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-rockchip/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index d60856898d97a..5ec58d004b7de 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -189,7 +189,7 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
 	rockchip_boot_fn = __pa_symbol(secondary_startup);
 
 	/* copy the trampoline to sram, that runs during startup of the core */
-	memcpy(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
+	memcpy_toio(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
 	flush_cache_all();
 	outer_clean_range(0, trampoline_sz);
 
-- 
2.34.1

