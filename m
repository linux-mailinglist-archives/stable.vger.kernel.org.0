Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6C134BAD
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgAHTqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43672 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730452AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006on-BH; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dn6-Bv; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nicolas Pitre" <nico@fluxnic.net>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:31 +0000
Message-ID: <lsq.1578512578.909514941@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 33/63] ARM: 8510/1: rework ARM_CPU_SUSPEND dependencies
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

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 1b9bdf5c1661873a10e193b8cbb803a87fe5c4a1 upstream.

The code enabled by the ARM_CPU_SUSPEND config option is used by
kernel subsystems for purposes that go beyond system suspend so its
config entry should be augmented to take more default options into
account and avoid forcing its selection to prevent dependencies
override.

To achieve this goal, this patch reworks the ARM_CPU_SUSPEND config
entry and updates its default config value (by adding the BL_SWITCHER
option to it) and its dependencies (ARCH_SUSPEND_POSSIBLE), so that the
symbol is still selected by default by the subsystems requiring it and
at the same time enforcing the dependencies correctly.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1486,7 +1486,6 @@ config BIG_LITTLE
 config BL_SWITCHER
 	bool "big.LITTLE switcher support"
 	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU && ARM_GIC
-	select ARM_CPU_SUSPEND
 	select CPU_PM
 	help
 	  The big.LITTLE "switcher" provides the core functionality to
@@ -2201,7 +2200,8 @@ config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
 config ARM_CPU_SUSPEND
-	def_bool PM_SLEEP
+	def_bool PM_SLEEP || BL_SWITCHER
+	depends on ARCH_SUSPEND_POSSIBLE
 
 config ARCH_HIBERNATION_POSSIBLE
 	bool

