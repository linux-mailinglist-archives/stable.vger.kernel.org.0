Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DE1364B8D
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbhDSUpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242472AbhDSUon (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0EC2613C0;
        Mon, 19 Apr 2021 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865053;
        bh=z5k/Yw3mIMmrDwp95XRcKjZzM8UMyfFp0EcQmjpQa1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9pxoWd+T3UBBjZvXlfOrmYlMR2xy/Vf74rCbQ+NEblOGedKEK1pg+Vl3FPyahTFH
         eIJJKUWsooV9dpqwRd1vQlGOWR5KFmK5ThwAjQ16h6tDlmYTiyshhveTgMYLIS8FCh
         xpc+KRgp1us5p/kKLo1+7flh8c9m2zxxlBdzFpKAsMmRhwItTirbfZoL72P5H818WQ
         V7Qv1Oe+AQu5219rfpah16dSEyJLRFVtO3fwuSGOhYLj7/mFYAFEt4V9fAAS44dwFA
         X7UFhKcx9O1m9ltIvbNCtG6OAtGhLZdBnWwGIinuI8E1HOoV1GxO9zzrUi2QHIWFcv
         7Lv6sUd07Laxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Guo Ren <guoren@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 19/23] csky: change a Kconfig symbol name to fix e1000 build error
Date:   Mon, 19 Apr 2021 16:43:38 -0400
Message-Id: <20210419204343.6134-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
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
index 89dd2fcf38fa..3b16d081b4d7 100644
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

