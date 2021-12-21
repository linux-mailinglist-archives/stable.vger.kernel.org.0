Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3071747B7DC
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhLUCCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:02:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35038 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbhLUCBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:01:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D66C4B810FE;
        Tue, 21 Dec 2021 02:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF53C36AE8;
        Tue, 21 Dec 2021 02:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052067;
        bh=76il5XRxViuJjb6Phr/54g/UhjGw3hTdCoX9B/GwxnA=;
        h=From:To:Cc:Subject:Date:From;
        b=BUo+GyZ8TDqwN4iBLrByIXk/RHLQzzdHly+YZBqvo3r0lSx24VRPYdgWn618n8RrN
         0wbAZQhwpGgPmKaxI4sWTvVKHBAOIu2ivFFRaC3VcBqvSMvTrZtnPmmHRt0TYQ70Zk
         pGlpCI0bykjRQySlgWZzCnoIV3byMbj1dirfQ2+EfugIoKJbZnLmnClCSBA2UQ54Jo
         9tr9gPKJ79l9+6Hg11FbmGeDPKJ49ButqMjDm3e2vdZs6H6dhGFp8Nf7wUM5vPtlvV
         uZmTmZ/jDEOspp/nLe8A/jkHY4jLg9KwD9XqOOf/EkvDzrEybhjBygv38IgwiMkZ3w
         KboguwY7XcWxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/11] ARM: rockchip: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Mon, 20 Dec 2021 21:00:20 -0500
Message-Id: <20211221020030.117225-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index 51984a40b097f..fb233a8f0bf54 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -198,7 +198,7 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
 	rockchip_boot_fn = __pa_symbol(secondary_startup);
 
 	/* copy the trampoline to sram, that runs during startup of the core */
-	memcpy(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
+	memcpy_toio(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
 	flush_cache_all();
 	outer_clean_range(0, trampoline_sz);
 
-- 
2.34.1

