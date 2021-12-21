Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87E47B820
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhLUCEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhLUCCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:02:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383D1C07E5C5;
        Mon, 20 Dec 2021 18:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A17B8110C;
        Tue, 21 Dec 2021 02:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83CC36AE5;
        Tue, 21 Dec 2021 02:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052105;
        bh=1Zi09LysPGvsPv/8d9w6nAFHTkfB3G2bKujERLUMp7E=;
        h=From:To:Cc:Subject:Date:From;
        b=ZzzTZnfyENIAMitcOYpHXOR1iXgbqQaoRysoyvq9jbVvTQ0kGi9yosA8aDa9dqKQg
         s04sXZQ5wteSnvqSmmZAKaPX3+766f3cNjUCxAfRuLYn0krH4HR0n05Sq3jFz9AreY
         yGAjOi3olDyds0Qt/vOWTk2duz8I4Yv3Q70JiIBCBweH5cdjh0+gHGq67Ev72Atg20
         48B03QCDblEF/vQb4dDZg0GxAoGkfN1TTvv8rPjFYZ7JP52IdALJGdmflcsPDlSUld
         x5f2cuwgbwhpK8jLiRi+u3rDvLQjtFg1N1PE4DEfwBmDItg8hVJ/e4BrdPJesu0XPS
         rk2czg6yI0jMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/9] ARM: rockchip: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Mon, 20 Dec 2021 21:01:15 -0500
Message-Id: <20211221020123.117380-1-sashal@kernel.org>
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
index ecec340ca3457..bb69e6e6defe8 100644
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

