Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB9647B80F
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhLUCDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:03:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbhLUCCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:02:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3865A61355;
        Tue, 21 Dec 2021 02:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6000C36AE8;
        Tue, 21 Dec 2021 02:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052128;
        bh=kJa3F3/9v6+zpr3LL2pnwtBxvxYCsbvi4K8gPRQTjq0=;
        h=From:To:Cc:Subject:Date:From;
        b=NRZMNYXckP0st2SnjjY7VvHyjqt9glt/afvb9b9XLH2GMJRuL0OH9IkbqaXIb3Vfr
         6fIsHeo/0XHxztYIib6JZHLnPrSN8lISnfWYcyUhyYPJoAygTfcqcDMRMXg1+Mc3Rp
         GpjbeSlfAd25FjXCqVutq5Nx406Po0nCWRVMHpMv2zzDQBsZ7S+XKj+HEyaS52lRrM
         nU5VIri0THf/t/JnGg/QK7kK6HvtDzyLdM/YwSqKPEZinjfJA5+t26G0PseeWetpUN
         jtKIruBrk+G0YHXVhfLVBotWRpdhd0uR2TtsMdEdpGlEm6/xy9yyV9+h2r5Hp6zfbq
         TG2mj1XXDi2/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 1/4] ARM: rockchip: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Mon, 20 Dec 2021 21:02:03 -0500
Message-Id: <20211221020206.117771-1-sashal@kernel.org>
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
index 3e7a4b761a953..47b6739937c64 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -194,7 +194,7 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
 	rockchip_boot_fn = virt_to_phys(secondary_startup);
 
 	/* copy the trampoline to sram, that runs during startup of the core */
-	memcpy(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
+	memcpy_toio(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
 	flush_cache_all();
 	outer_clean_range(0, trampoline_sz);
 
-- 
2.34.1

