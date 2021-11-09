Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8344A3DC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbhKIBbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243220AbhKIB1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D1F61A80;
        Tue,  9 Nov 2021 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420213;
        bh=IYdtnigu4aWmkhgRXz9+qN9cyxh8qymPil0T/Dmv0nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2ay2xrxbReIdCFeuVBLUGrzwAQ0j926Ex5Hr16TGnMqejncegsidwlP3zP72WovC
         lVIiY/21j/Vytxtcf4RmFLNpU8b9eDm7MF2LlxJbHdBQ6bTG2DAu4Z6m9Rw39f9RVZ
         +/Gz0sR3Z99CUMVtBraM8Y10yA+9ukb2xRArUafw8sx6c+ggiTtOP9q6uDa9c7DLm6
         CbZMbFoFS6MxqlwxmHqIpTbaaCzzjHePA9Rch13vOkTFqVPutO7YMaIYMzjSiLTR8p
         HaMOQXCeoeyZP0wzgw3YN5RsPCopaNR0fOFzNMTJyARWlOkKj+sMqLhL+lAGCJZswL
         Aw+xxXZnqut0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        ndesaulniers@google.com, wangkefeng.wang@huawei.com,
        u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 28/30] ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
Date:   Mon,  8 Nov 2021 20:09:16 -0500
Message-Id: <20211109010918.1192063-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 345dac33f58894a56d17b92a41be10e16585ceff ]

When configuring the kernel for big-endian, we set either BE-8 or BE-32
based on the CPU architecture level. Until linux-4.4, we did not have
any ARMv7-M platform allowing big-endian builds, but now i.MX/Vybrid
is in that category, adn we get a build error because of this:

arch/arm/kernel/module-plts.c: In function 'get_module_plt':
arch/arm/kernel/module-plts.c:60:46: error: implicit declaration of function '__opcode_to_mem_thumb32' [-Werror=implicit-function-declaration]

This comes down to picking the wrong default, ARMv7-M uses BE8
like ARMv7-A does. Changing the default gets the kernel to compile
and presumably works.

https://lore.kernel.org/all/1455804123-2526139-2-git-send-email-arnd@arndb.de/

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 71115afb71a05..f46089b24588f 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -724,7 +724,7 @@ config CPU_BIG_ENDIAN
 config CPU_ENDIAN_BE8
 	bool
 	depends on CPU_BIG_ENDIAN
-	default CPU_V6 || CPU_V6K || CPU_V7
+	default CPU_V6 || CPU_V6K || CPU_V7 || CPU_V7M
 	help
 	  Support for the BE-8 (big-endian) mode on ARMv6 and ARMv7 processors.
 
-- 
2.33.0

