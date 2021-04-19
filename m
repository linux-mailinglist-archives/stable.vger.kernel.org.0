Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1801A364C05
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbhDSUsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242708AbhDSUqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 548A4613EC;
        Mon, 19 Apr 2021 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865110;
        bh=xrFObEm+jU8uwskZzP6GIfhTNZoPvGfhF970h8xK5AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8PhJENtHWAnKxMXnpDqwdHMuPOAESpIHOopK6T3s1zMxpSopBsHAite+mdRctA63
         YLF4RKHP3a25DOWPhiqP3TpIRVm7IkWG/kYEEgC0yNYIS+d9+shrdD/FDiHdEPuK28
         EJIUT/kMLhsFqbmQXt9PMswQWJdJH5H5cvykIHr5TNHe9xVsdvRoSTt2QK12ACVXuW
         L/cFGqhnsa/TDHP0ahvRCRbNvq8r2GJVWHTYu4OqNWPA2DhtsljyaU5tHesHBaj2nn
         sB3IUbYfK2RiNd1i6ml3Cfhi+blwdXIRxKy0qUIwbx91mEP6oKyhvSnvzGmDovugBQ
         /8xxW9B3EEKsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Guo Ren <guoren@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/14] csky: change a Kconfig symbol name to fix e1000 build error
Date:   Mon, 19 Apr 2021 16:44:50 -0400
Message-Id: <20210419204454.6601-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 48b2e1b59119..4f48a2f0513b 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -220,7 +220,7 @@ config FORCE_MAX_ZONEORDER
 	int "Maximum zone order"
 	default "11"
 
-config RAM_BASE
+config DRAM_BASE
 	hex "DRAM start addr (the same with memory-section in dts)"
 	default 0x0
 
diff --git a/arch/csky/include/asm/page.h b/arch/csky/include/asm/page.h
index 9738eacefdc7..62bb307459ca 100644
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

