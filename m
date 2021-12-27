Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE064800D8
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhL0PvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbhL0PqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:46:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49A9C08EA4C;
        Mon, 27 Dec 2021 07:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B26CB810C5;
        Mon, 27 Dec 2021 15:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0F8C36AE7;
        Mon, 27 Dec 2021 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619762;
        bh=cVfAfSLgK6M3EURbUJL2kW+nkLRnypqpLgfywTZKuYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUk8ht7Ev2hwQKsHGRmaQzFyit5JGxkOGMLU26uOl/WnfQQmcqN+B0TkC++Dt0uWY
         c3OdgpF+8lhfrwFFZddATPFHo6MSj5JUzBYfKRn2Hu2hgsiBbg7pM7bLaZGLV1UgeA
         CEzMUzO2LBW1sgGSEgydMRZnxp9hkAlzuxpKV+TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/128] platform/x86/intel: Remove X86_PLATFORM_DRIVERS_INTEL
Date:   Mon, 27 Dec 2021 16:30:36 +0100
Message-Id: <20211227151333.540420703@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4f6c131c3c31b9f68470ebd01320d5403d8719bb ]

While introduction of this menu brings a nice view in the configuration tools,
it brought more issues than solves, i.e. it prevents to locate files in the
intel/ subfolder without touching non-related Kconfig dependencies elsewhere.
Drop X86_PLATFORM_DRIVERS_INTEL altogether.

Note, on x86 it's enabled by default and it's quite unlikely anybody wants to
disable all of the modules in this submenu.

Fixes: 8bd836feb6ca ("platform/x86: intel_skl_int3472: Move to intel/ subfolder")
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211222194941.76054-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Makefile      |  2 +-
 drivers/platform/x86/intel/Kconfig | 15 ---------------
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 69690e26bb6d4..2734a771d1f00 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -67,7 +67,7 @@ obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
 obj-$(CONFIG_THINKPAD_LMI)	+= think-lmi.o
 
 # Intel
-obj-$(CONFIG_X86_PLATFORM_DRIVERS_INTEL)		+= intel/
+obj-y				+= intel/
 
 # MSI
 obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
index 0b21468e1bd01..02e4481b384e4 100644
--- a/drivers/platform/x86/intel/Kconfig
+++ b/drivers/platform/x86/intel/Kconfig
@@ -3,19 +3,6 @@
 # Intel x86 Platform Specific Drivers
 #
 
-menuconfig X86_PLATFORM_DRIVERS_INTEL
-	bool "Intel x86 Platform Specific Device Drivers"
-	default y
-	help
-	  Say Y here to get to see options for device drivers for
-	  various Intel x86 platforms, including vendor-specific
-	  drivers. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped
-	  and disabled.
-
-if X86_PLATFORM_DRIVERS_INTEL
-
 source "drivers/platform/x86/intel/atomisp2/Kconfig"
 source "drivers/platform/x86/intel/int1092/Kconfig"
 source "drivers/platform/x86/intel/int33fe/Kconfig"
@@ -167,5 +154,3 @@ config INTEL_UNCORE_FREQ_CONTROL
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called intel-uncore-frequency.
-
-endif # X86_PLATFORM_DRIVERS_INTEL
-- 
2.34.1



