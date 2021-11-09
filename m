Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1A44A33E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbhKIB01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243317AbhKIBVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C7FB61A50;
        Tue,  9 Nov 2021 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420115;
        bh=KleTAuiYN08CCakSJryb9oz0+fFiyLC9ruYBaQfpj4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4OnlsKMtS8DePD0P15yg0gO96VuG5hQKO3ffkrBegExLA0/OGCHQzs5VjNFzYnfB
         j5FQLWgBi5fPyoo+P7LkpDWnWAj3KKzOGZHrCieU8mKaf3SvRWg2Rk89eMaJU8jEhr
         sPtk2okBM1W8Uvao9hharSKf2SX5FZ2I9dbXvG1UdKHrOG5gb9YZlfXcu14NTqpZUB
         It5h4IDWIAoW3ATMVElcT8SrRc0wp4UTHNw1zZVsiBQgTsroTgr+qjJ1yPjeqR8PAm
         p1cgepJLwBLpfc0B+rt9jl0obU4b+fJ/LMEDfDSQMswFhGAgSVljZ+AQz9u31VBfgt
         2G99ohv/e0saw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-ia64@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Chris Down <chris@chrisdown.name>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 15/33] ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
Date:   Mon,  8 Nov 2021 20:07:49 -0500
Message-Id: <20211109010807.1191567-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index de9d507ba0fd4..ee6c7f75f479d 100644
--- a/arch/ia64/Kconfig.debug
+++ b/arch/ia64/Kconfig.debug
@@ -41,7 +41,7 @@ config DISABLE_VHPT
 
 config IA64_DEBUG_CMPXCHG
 	bool "Turn on compare-and-exchange bug checking (slow!)"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && PRINTK
 	help
 	  Selecting this option turns on bug checking for the IA-64
 	  compare-and-exchange instructions.  This is slow!  Itaniums
-- 
2.33.0

