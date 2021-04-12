Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CBE35CD9D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbhDLQhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343741AbhDLQf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF60D613CB;
        Mon, 12 Apr 2021 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244831;
        bh=uAAUyMljlcrTr7L/lCee6dkkMCsypVanYPJhHqDkpug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WliBzPiEk/vmdosDIYzcVIUd9ev85hVXyk4zVn7e2wDEJSfh/kwfFmG5JYvLvPMRk
         QpWQzVFBFVtDGToCyeIVvto3P40vHCopzLcymc2PACtX1HciY1vQGhiXMrdwbHZuM1
         EwVEfB07SG+nj2LsShAOdSFAYGIxONa9YMQHM8cDau4JnixbLV0pqYWl3QSvZIQrM2
         2Zn1QaLF7ceNW03U78gGlCPCjL2jxPauxz5PYmVqufpAL6nOYZvl2d5Xl8SonoiBO0
         3v4/0WQz+yb47LnMYOSj+aaL3pEkYhdm5pFEXcisp6qI7yWCXXzmQnxR8Bj8R/XQPO
         bF9fJZirSw74w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 05/23] ARM: keystone: fix integer overflow warning
Date:   Mon, 12 Apr 2021 12:26:46 -0400
Message-Id: <20210412162704.315783-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 844b85dda2f569943e1e018fdd63b6f7d1d6f08e ]

clang warns about an impossible condition when building with 32-bit
phys_addr_t:

arch/arm/mach-keystone/keystone.c:79:16: error: result of comparison of constant 51539607551 with expression of type 'phys_addr_t' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
            mem_end   > KEYSTONE_HIGH_PHYS_END) {
            ~~~~~~~   ^ ~~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-keystone/keystone.c:78:16: error: result of comparison of constant 34359738368 with expression of type 'phys_addr_t' (aka 'unsigned int') is always true [-Werror,-Wtautological-constant-out-of-range-compare]
        if (mem_start < KEYSTONE_HIGH_PHYS_START ||
            ~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~

Change the temporary variable to a fixed-size u64 to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Link: https://lore.kernel.org/r/20210323131814.2751750-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-keystone/keystone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index 84613abf35a3..79ff5b953431 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -65,7 +65,7 @@ static void __init keystone_init(void)
 static long long __init keystone_pv_fixup(void)
 {
 	long long offset;
-	phys_addr_t mem_start, mem_end;
+	u64 mem_start, mem_end;
 
 	mem_start = memblock_start_of_DRAM();
 	mem_end = memblock_end_of_DRAM();
@@ -78,7 +78,7 @@ static long long __init keystone_pv_fixup(void)
 	if (mem_start < KEYSTONE_HIGH_PHYS_START ||
 	    mem_end   > KEYSTONE_HIGH_PHYS_END) {
 		pr_crit("Invalid address space for memory (%08llx-%08llx)\n",
-		        (u64)mem_start, (u64)mem_end);
+		        mem_start, mem_end);
 		return 0;
 	}
 
-- 
2.30.2

