Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC744A224
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbhKIBQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242878AbhKIBO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7CD1610A2;
        Tue,  9 Nov 2021 01:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419953;
        bh=f3goWkIl2SxeAHIEjXf1JM0ql4jX1tMGWMOabFRzUHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSf5wlGJ07fTW4H0D5u/YvsX54lJYw8wNiKj2yFCwZDgaerheItJ0RB/BKywv6HD/
         tWTuhJ60xJ9/j+HGFNkNu6wgBGPTcbNpY3Fho1lbrHRnXFzCWhbhx/Q/W5XdO0c7tx
         9/q8wQKuY7QeUMSI8XWVlLuV9ydoBM7uOIDEcuLT9ImT5FigAhOzOEmucyZ/0EwSas
         qResyOEtYLyJqq544EmaOJJDIu55LcbxxUe8hhmLFwBTAlgrSz1tcpGnODHMRnRYeP
         Oj+da1Ckn8bKsb0UU4Ty2677K2tCL3fJcLM4a8OQAPN3/CxYDOfG7ikgsQFCWPY3kA
         dQRF/zCHXy99w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-ia64@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Chris Down <chris@chrisdown.name>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 21/47] ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
Date:   Mon,  8 Nov 2021 12:50:05 -0500
Message-Id: <20211108175031.1190422-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c15b5fc054c3d6c97e953617605235c5cb8ce979 ]

When CONFIG_PRINTK is not set, the CMPXCHG_BUGCHECK() macro calls
_printk(), but _printk() is a static inline function, not available
as an extern.
Since the purpose of the macro is to print the BUGCHECK info,
make this config option depend on PRINTK.

Fixes multiple occurrences of this build error:

../include/linux/printk.h:208:5: error: static declaration of '_printk' follows non-static declaration
  208 | int _printk(const char *s, ...)
      |     ^~~~~~~
In file included from ../arch/ia64/include/asm/cmpxchg.h:5,
../arch/ia64/include/uapi/asm/cmpxchg.h:146:28: note: previous declaration of '_printk' with type 'int(const char *, ...)'
  146 |                 extern int _printk(const char *fmt, ...);

Cc: linux-ia64@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/Kconfig.debug b/arch/ia64/Kconfig.debug
index 1371efc9b0055..637ac79c29b6d 100644
--- a/arch/ia64/Kconfig.debug
+++ b/arch/ia64/Kconfig.debug
@@ -39,7 +39,7 @@ config DISABLE_VHPT
 
 config IA64_DEBUG_CMPXCHG
 	bool "Turn on compare-and-exchange bug checking (slow!)"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && PRINTK
 	help
 	  Selecting this option turns on bug checking for the IA-64
 	  compare-and-exchange instructions.  This is slow!  Itaniums
-- 
2.33.0

