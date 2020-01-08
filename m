Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A05134BF8
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgAHTsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43646 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730446AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oa-00; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dmX-07; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Nicolas Pitre" <nico@linaro.org>
Date:   Wed, 08 Jan 2020 19:43:24 +0000
Message-ID: <lsq.1578512578.238449191@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 26/63] ARM: 8458/1: bL_switcher: add GIC dependency
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 6c044fecdf78be3fda159a5036bb33700cdd5e59 upstream.

It is not possible to build the bL_switcher code if the GIC
driver is disabled, because it relies on calling into some
gic specific interfaces, and that would result in this build
error:

arch/arm/common/built-in.o: In function `bL_switch_to':
:(.text+0x1230): undefined reference to `gic_get_sgir_physaddr'
:(.text+0x1244): undefined reference to `gic_send_sgi'
:(.text+0x1268): undefined reference to `gic_migrate_target'
arch/arm/common/built-in.o: In function `bL_switcher_enable.part.4':
:(.text.unlikely+0x2f8): undefined reference to `gic_get_cpu_id'

This adds a Kconfig dependency to ensure we only build the big-little
switcher if the GIC driver is present as well.

Almost all ARMv7 platforms come with a GIC anyway, but it is possible
to build a kernel that disables all platforms.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1485,7 +1485,7 @@ config BIG_LITTLE
 
 config BL_SWITCHER
 	bool "big.LITTLE switcher support"
-	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU
+	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU && ARM_GIC
 	select ARM_CPU_SUSPEND
 	select CPU_PM
 	help

