Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D145BD51
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245132AbhKXMhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343907AbhKXMfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84C6C61078;
        Wed, 24 Nov 2021 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756482;
        bh=Zy38W5CTpAEf7I4j0dbwM7jDtaDo09QRwcXNRYFKqro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSlToPkquqj4ZqDNDuogtb0DP+o1bZBjagppUn0uANR7YRiJRXeLHl+/qRcb4VWmR
         12PP1aVcZXY9TM6ioX5sgwPOxipD8Mm1YmUIhW8kgqJue9IxcS0nWFLhU0/jhHqwKC
         6xM85sRlX4a9vjYMnV38pr4Mqc2uADs2m2Ntbphw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/251] ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
Date:   Wed, 24 Nov 2021 12:55:43 +0100
Message-Id: <20211124115713.758655697@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 50e0b45a22dba..77fd4446b5fc8 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -757,7 +757,7 @@ config CPU_BIG_ENDIAN
 config CPU_ENDIAN_BE8
 	bool
 	depends on CPU_BIG_ENDIAN
-	default CPU_V6 || CPU_V6K || CPU_V7
+	default CPU_V6 || CPU_V6K || CPU_V7 || CPU_V7M
 	help
 	  Support for the BE-8 (big-endian) mode on ARMv6 and ARMv7 processors.
 
-- 
2.33.0



