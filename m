Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19E0CA690
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405457AbfJCQo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405452AbfJCQo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:44:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF7E2070B;
        Thu,  3 Oct 2019 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121095;
        bh=ewPq7fQ+Kpl7Nb7d8O0y/srjFnu8XZRUFHNrMK6wO+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5Zl8MPL+uroDcBGg+ntIMiTC4EDaswB2NTh3fEjQHK851wbkHh1RnXAIIkCq/xYE
         s2dpTMFh+MF85oxI5QfqR2teMAFUKMZxEsca1uhehtl2Q71X5npejtduminVGtCKrq
         nVgLQ7IN//zO2KpL43yrFs23Kuzc6YJslZsQ8cCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 153/344] ARM: OMAP2+: move platform-specific asm-offset.h to arch/arm/mach-omap2
Date:   Thu,  3 Oct 2019 17:51:58 +0200
Message-Id: <20191003154555.342665181@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit ccf4975dca233b1d6a74752d6ab35c239edc0d58 ]

<generated/ti-pm-asm-offsets.h> is only generated and included by
arch/arm/mach-omap2/, so it does not need to reside in the globally
visible include/generated/.

I renamed it to arch/arm/mach-omap2/pm-asm-offsets.h since the prefix
'ti-' is just redundant in mach-omap2/.

My main motivation of this change is to avoid the race condition for
the parallel build (-j) when CONFIG_IKHEADERS is enabled.

When it is enabled, all the headers under include/ are archived into
kernel/kheaders_data.tar.xz and exposed in the sysfs.

In the parallel build, we have no idea in which order files are built.

 - If ti-pm-asm-offsets.h is built before kheaders_data.tar.xz,
   the header will be included in the archive. Probably nobody will
   use it, but it is harmless except that it will increase the archive
   size needlessly.

 - If kheaders_data.tar.xz is built before ti-pm-asm-offsets.h,
   the header will not be included in the archive. However, in the next
   build, the archive will be re-generated to include the newly-found
   ti-pm-asm-offsets.h. This is not nice from the build system point
   of view.

 - If ti-pm-asm-offsets.h and kheaders_data.tar.xz are built at the
   same time, the corrupted header might be included in the archive,
   which does not look nice either.

This commit fixes the race.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/.gitignore  | 1 +
 arch/arm/mach-omap2/Makefile    | 5 +++--
 arch/arm/mach-omap2/sleep33xx.S | 2 +-
 arch/arm/mach-omap2/sleep43xx.S | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-omap2/.gitignore

diff --git a/arch/arm/mach-omap2/.gitignore b/arch/arm/mach-omap2/.gitignore
new file mode 100644
index 0000000000000..79a8d6ea71520
--- /dev/null
+++ b/arch/arm/mach-omap2/.gitignore
@@ -0,0 +1 @@
+pm-asm-offsets.h
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 6006505516219..21c6d4bca3c0f 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -223,9 +223,10 @@ obj-y					+= omap_phy_internal.o
 
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
 
-include/generated/ti-pm-asm-offsets.h: arch/arm/mach-omap2/pm-asm-offsets.s FORCE
+$(obj)/pm-asm-offsets.h: $(obj)/pm-asm-offsets.s FORCE
 	$(call filechk,offsets,__TI_PM_ASM_OFFSETS_H__)
 
-$(obj)/sleep33xx.o $(obj)/sleep43xx.o: include/generated/ti-pm-asm-offsets.h
+$(obj)/sleep33xx.o $(obj)/sleep43xx.o: $(obj)/pm-asm-offsets.h
 
 targets += pm-asm-offsets.s
+clean-files += pm-asm-offsets.h
diff --git a/arch/arm/mach-omap2/sleep33xx.S b/arch/arm/mach-omap2/sleep33xx.S
index 68fee339d3f12..dc221249bc22c 100644
--- a/arch/arm/mach-omap2/sleep33xx.S
+++ b/arch/arm/mach-omap2/sleep33xx.S
@@ -6,7 +6,6 @@
  *	Dave Gerlach, Vaibhav Bedia
  */
 
-#include <generated/ti-pm-asm-offsets.h>
 #include <linux/linkage.h>
 #include <linux/platform_data/pm33xx.h>
 #include <linux/ti-emif-sram.h>
@@ -15,6 +14,7 @@
 
 #include "iomap.h"
 #include "cm33xx.h"
+#include "pm-asm-offsets.h"
 
 #define AM33XX_CM_CLKCTRL_MODULESTATE_DISABLED			0x00030000
 #define AM33XX_CM_CLKCTRL_MODULEMODE_DISABLE			0x0003
diff --git a/arch/arm/mach-omap2/sleep43xx.S b/arch/arm/mach-omap2/sleep43xx.S
index c1f4e4852644e..90d2907a2eb27 100644
--- a/arch/arm/mach-omap2/sleep43xx.S
+++ b/arch/arm/mach-omap2/sleep43xx.S
@@ -6,7 +6,6 @@
  *	Dave Gerlach, Vaibhav Bedia
  */
 
-#include <generated/ti-pm-asm-offsets.h>
 #include <linux/linkage.h>
 #include <linux/ti-emif-sram.h>
 #include <linux/platform_data/pm33xx.h>
@@ -19,6 +18,7 @@
 #include "iomap.h"
 #include "omap-secure.h"
 #include "omap44xx.h"
+#include "pm-asm-offsets.h"
 #include "prm33xx.h"
 #include "prcm43xx.h"
 
-- 
2.20.1



