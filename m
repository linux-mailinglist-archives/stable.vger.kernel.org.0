Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F2BCA8A3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391642AbfJCQaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391639AbfJCQ37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB282133F;
        Thu,  3 Oct 2019 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120198;
        bh=9fwelzb4gaRs6F+woif6HxRJvfWAzWKdIXQYj+jKX5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSDIbc5R11Ao02XVbyw8iJLfRijVhrzS4yrjUBQLehBlzV9hDcfcggbrKBG9QDFt4
         oR7c9j3WKWPY1aX5bD30E+qZWa5L2+xfcsxOgap96QIYppbHQEN5It/q5RtOoEAhCd
         OA8wDQOLDtWZB+SdluSY4H23vVrkeluYpV9Pg6O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 134/313] ARM: at91: move platform-specific asm-offset.h to arch/arm/mach-at91
Date:   Thu,  3 Oct 2019 17:51:52 +0200
Message-Id: <20191003154546.094722616@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 9fac85a6db8999922f2cd92dfe2e83e063b31a94 ]

<generated/at91_pm_data-offsets.h> is only generated and included by
arch/arm/mach-at91/, so it does not need to reside in the globally
visible include/generated/.

I renamed it to arch/arm/mach-at91/pm_data-offsets.h since the prefix
'at91_' is just redundant in mach-at91/.

My main motivation of this change is to avoid the race condition for
the parallel build (-j) when CONFIG_IKHEADERS is enabled.

When it is enabled, all the headers under include/ are archived into
kernel/kheaders_data.tar.xz and exposed in the sysfs.

In the parallel build, we have no idea in which order files are built.

 - If at91_pm_data-offsets.h is built before kheaders_data.tar.xz,
   the header will be included in the archive. Probably nobody will
   use it, but it is harmless except that it will increase the archive
   size needlessly.

 - If kheaders_data.tar.xz is built before at91_pm_data-offsets.h,
   the header will not be included in the archive. However, in the next
   build, the archive will be re-generated to include the newly-found
   at91_pm_data-offsets.h. This is not nice from the build system point
   of view.

 - If at91_pm_data-offsets.h and kheaders_data.tar.xz are built at the
   same time, the corrupted header might be included in the archive,
   which does not look nice either.

This commit fixes the race.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20190823024346.591-1-yamada.masahiro@socionext.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/.gitignore   | 1 +
 arch/arm/mach-at91/Makefile     | 5 +++--
 arch/arm/mach-at91/pm_suspend.S | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-at91/.gitignore

diff --git a/arch/arm/mach-at91/.gitignore b/arch/arm/mach-at91/.gitignore
new file mode 100644
index 0000000000000..2ecd6f51c8a95
--- /dev/null
+++ b/arch/arm/mach-at91/.gitignore
@@ -0,0 +1 @@
+pm_data-offsets.h
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 31b61f0e1c077..de64301dcff25 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -19,9 +19,10 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
 endif
 
-include/generated/at91_pm_data-offsets.h: arch/arm/mach-at91/pm_data-offsets.s FORCE
+$(obj)/pm_data-offsets.h: $(obj)/pm_data-offsets.s FORCE
 	$(call filechk,offsets,__PM_DATA_OFFSETS_H__)
 
-arch/arm/mach-at91/pm_suspend.o: include/generated/at91_pm_data-offsets.h
+$(obj)/pm_suspend.o: $(obj)/pm_data-offsets.h
 
 targets += pm_data-offsets.s
+clean-files += pm_data-offsets.h
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index c751f047b1166..ed57c879d4e17 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -10,7 +10,7 @@
 #include <linux/linkage.h>
 #include <linux/clk/at91_pmc.h>
 #include "pm.h"
-#include "generated/at91_pm_data-offsets.h"
+#include "pm_data-offsets.h"
 
 #define	SRAMC_SELF_FRESH_ACTIVE		0x01
 #define	SRAMC_SELF_FRESH_EXIT		0x00
-- 
2.20.1



