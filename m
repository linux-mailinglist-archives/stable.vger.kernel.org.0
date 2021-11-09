Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E981944A2E0
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbhKIBWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242244AbhKIBTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F5261B04;
        Tue,  9 Nov 2021 01:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420077;
        bh=Zy38W5CTpAEf7I4j0dbwM7jDtaDo09QRwcXNRYFKqro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IED0ivkZAPCEPguncS7qTj+4avmxtrqLx5NOvIeRyOqPn6XuPFO5zGfMSSr/UAEzH
         hUiGP+0mfun479CfHf5UYJVE/sYgMT+6NtfOWFu7zaap6WkzazUAQ9T5+TxdnCxepZ
         aG8/0lQ9VGhnufq+plxwC1AF+Uqv/XyI/xJPl3OqFNuW7WlHPwXA4smc61oX+nYGg7
         fuSfiXvmdd5Iga7Nz+gWRWpfndhVPMiciXo9F7ggM6s36y5kb3smzdGLzwVAVoG9yy
         kIJsoEHfwMIJKpLgjIgGzWGFZlLt/DW4uO9XQz55C+ytQnVNQFcba8INRvkeZhq+5n
         qrxUPGNPQtizw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        ndesaulniers@google.com, u.kleine-koenig@pengutronix.de,
        ardb@kernel.org, wangkefeng.wang@huawei.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 35/39] ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
Date:   Mon,  8 Nov 2021 20:06:45 -0500
Message-Id: <20211109010649.1191041-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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

