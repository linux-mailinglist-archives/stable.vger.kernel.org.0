Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2F45BA0A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbhKXMHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242115AbhKXMG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FC160FDA;
        Wed, 24 Nov 2021 12:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755399;
        bh=KleTAuiYN08CCakSJryb9oz0+fFiyLC9ruYBaQfpj4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8Av3oT6MuQgnaccv7gPWHuUwbUijZIk2UyWc1xJ29bMDxweDxlMBWIiWLi3xs/vw
         DzFzwzT78BpcmPOLtg+9e8GD/IWwwt+LkO5lSnB+rgw3TpxOhswa5KU34xzXxa83gD
         tNXHYacvKNm8YK7da4lZoZBLDkc+KDuuyl2Y/mg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-ia64@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Chris Down <chris@chrisdown.name>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 054/162] ia64: dont do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
Date:   Wed, 24 Nov 2021 12:55:57 +0100
Message-Id: <20211124115700.088361475@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



