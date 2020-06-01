Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594721EA479
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgFANMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgFANMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:12:02 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA68C061A0E;
        Mon,  1 Jun 2020 06:12:02 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jfkEM-000793-6s; Mon, 01 Jun 2020 15:11:54 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B182D1C04DD;
        Mon,  1 Jun 2020 15:11:48 +0200 (CEST)
Date:   Mon, 01 Jun 2020 13:11:48 -0000
From:   "tip-bot2 for Michael Ellerman" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] clocksource/drivers/timer-microchip-pit64b: Select
 CONFIG_TIMER_OF
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.6+@tip-bot2.tec.linutronix.de,
        kbuild test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200426124356.3929682-1-mpe@ellerman.id.au>
References: <20200426124356.3929682-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Message-ID: <159101710857.17951.10091411980553462232.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     25259f7a5de2de9d67793dc584b15c83a3134c93
Gitweb:        https://git.kernel.org/tip/25259f7a5de2de9d67793dc584b15c83a3134c93
Author:        Michael Ellerman <mpe@ellerman.id.au>
AuthorDate:    Sun, 26 Apr 2020 22:43:56 +10:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Mon, 27 Apr 2020 08:59:50 +02:00

clocksource/drivers/timer-microchip-pit64b: Select CONFIG_TIMER_OF

This driver is an OF driver, it depends on OF, and uses
TIMER_OF_DECLARE, so it should select CONFIG_TIMER_OF.

Without CONFIG_TIMER_OF enabled this can lead to warnings such as:

  powerpc-linux-ld: warning: orphan section `__timer_of_table' from
  `drivers/clocksource/timer-microchip-pit64b.o' being placed in
  section `__timer_of_table'.

Because TIMER_OF_TABLES in vmlinux.lds.h doesn't emit anything into
the linker script when CONFIG_TIMER_OF is not enabled.

Fixes: 625022a5f160 ("clocksource/drivers/timer-microchip-pit64b: Add Microchip PIT64B support")
Cc: stable@vger.kernel.org # v5.6+
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200426124356.3929682-1-mpe@ellerman.id.au
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index f2142e6..f225c27 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -709,6 +709,7 @@ config MICROCHIP_PIT64B
 	bool "Microchip PIT64B support"
 	depends on OF || COMPILE_TEST
 	select CLKSRC_MMIO
+	select TIMER_OF
 	help
 	  This option enables Microchip PIT64B timer for Atmel
 	  based system. It supports the oneshot, the periodic
