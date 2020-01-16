Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A60F13E971
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405000AbgAPRhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgAPRht (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:37:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B6E246BB;
        Thu, 16 Jan 2020 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196269;
        bh=RWIpyYV2IZnnvLeNB3e+att7PsbnyepJ/57t61uI6Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJah1n52NlryBaU4+vpwsl4GFFDC9CYrNa/Lk838sn55R/QYxNqWuY05H65DZCNVp
         gYHuprTMeChkmyNgT9gA2xEA5j++n4avgnF5vpmw1VkQHoKtkzP0jp8hOPQheKIUbR
         cX1tpoTXgqXZldnLZfOBKxpmKsgVxhMIe9emsV5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ley Foon Tan <ley.foon.tan@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        nios2-dev@lists.rocketboards.org
Subject: [PATCH AUTOSEL 4.9 091/251] nios2: ksyms: Add missing symbol exports
Date:   Thu, 16 Jan 2020 12:34:00 -0500
Message-Id: <20200116173641.22137-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0f8ed994575429d6042cf5d7ef70081c94091587 ]

Building nios2:allmodconfig fails as follows (each symbol is only listed
once).

ERROR: "__ashldi3" [drivers/md/dm-writecache.ko] undefined!
ERROR: "__ashrdi3" [fs/xfs/xfs.ko] undefined!
ERROR: "__ucmpdi2" [drivers/media/i2c/adv7842.ko] undefined!
ERROR: "__lshrdi3" [drivers/md/dm-zoned.ko] undefined!
ERROR: "flush_icache_range" [drivers/misc/lkdtm/lkdtm.ko] undefined!
ERROR: "empty_zero_page" [drivers/md/dm-mod.ko] undefined!

The problem is seen with gcc 7.3.0.

Export the missing symbols.

Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/nios2_ksyms.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/nios2/kernel/nios2_ksyms.c b/arch/nios2/kernel/nios2_ksyms.c
index bf2f55d10a4d..4e704046a150 100644
--- a/arch/nios2/kernel/nios2_ksyms.c
+++ b/arch/nios2/kernel/nios2_ksyms.c
@@ -9,12 +9,20 @@
 #include <linux/export.h>
 #include <linux/string.h>
 
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+
 /* string functions */
 
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memmove);
 
+/* memory management */
+
+EXPORT_SYMBOL(empty_zero_page);
+EXPORT_SYMBOL(flush_icache_range);
+
 /*
  * libgcc functions - functions that are used internally by the
  * compiler...  (prototypes are not correct though, but that
@@ -31,3 +39,7 @@ DECLARE_EXPORT(__udivsi3);
 DECLARE_EXPORT(__umoddi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__ucmpdi2);
+DECLARE_EXPORT(__lshrdi3);
+DECLARE_EXPORT(__ashldi3);
+DECLARE_EXPORT(__ashrdi3);
-- 
2.20.1

