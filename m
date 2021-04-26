Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39D36AE8D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhDZHpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhDZHoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED893613C1;
        Mon, 26 Apr 2021 07:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422825;
        bh=czNKm0mqDxsUeA3xKoBQNmTrg6kgyI/Wl2LfDy6++18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZ0j/8fmPEDjgw7TKlbnczWftkAqqCu0BkPlpWouXjwppCCWDdLE7ATGebQQKnE8d
         IKdWYN24WmiX3fDmn2mIEtahAUZbDY1AoWON0bsQAAceyDYDHK3oScsf8SaG8/AEHZ
         ueAhZ8/Bf48dbqLYV0HbghCr3LFF5RCnareW4t9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Guo Ren <guoren@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/36] csky: change a Kconfig symbol name to fix e1000 build error
Date:   Mon, 26 Apr 2021 09:30:15 +0200
Message-Id: <20210426072819.910686915@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d199161653d612b8fb96ac51bfd5b2d2782ecef3 ]

e1000's #define of CONFIG_RAM_BASE conflicts with a Kconfig symbol in
arch/csky/Kconfig.

The symbol in e1000 has been around longer, so change arch/csky/ to use
DRAM_BASE instead of RAM_BASE to remove the conflict.  (although e1000
is also a 2-line change)

Link: https://lkml.kernel.org/r/20210411055335.7111-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Guo Ren <guoren@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/Kconfig            | 2 +-
 arch/csky/include/asm/page.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
index 268fad5f51cf..7bf0a617e94c 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -292,7 +292,7 @@ config FORCE_MAX_ZONEORDER
 	int "Maximum zone order"
 	default "11"
 
-config RAM_BASE
+config DRAM_BASE
 	hex "DRAM start addr (the same with memory-section in dts)"
 	default 0x0
 
diff --git a/arch/csky/include/asm/page.h b/arch/csky/include/asm/page.h
index 9b98bf31d57c..16878240ef9a 100644
--- a/arch/csky/include/asm/page.h
+++ b/arch/csky/include/asm/page.h
@@ -28,7 +28,7 @@
 #define SSEG_SIZE	0x20000000
 #define LOWMEM_LIMIT	(SSEG_SIZE * 2)
 
-#define PHYS_OFFSET_OFFSET (CONFIG_RAM_BASE & (SSEG_SIZE - 1))
+#define PHYS_OFFSET_OFFSET (CONFIG_DRAM_BASE & (SSEG_SIZE - 1))
 
 #ifndef __ASSEMBLY__
 
-- 
2.30.2



