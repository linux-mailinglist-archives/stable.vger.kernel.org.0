Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545A3F937B
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLPAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 10:00:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34644 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfKLPAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 10:00:48 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iUXes-00057x-Vi; Tue, 12 Nov 2019 16:00:43 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 9E0FF1C0084;
        Tue, 12 Nov 2019 16:00:42 +0100 (CET)
Date:   Tue, 12 Nov 2019 15:00:42 -0000
From:   "tip-bot2 for Kai-Heng Feng" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/quirks: Disable HPET on Intel Coffe Lake platforms
Cc:     Feng Tang <feng.tang@intel.com>,
        "Kai-Heng Feng" <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191016103816.30650-1-kai.heng.feng@canonical.com>
References: <20191016103816.30650-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Message-ID: <157357084220.29376.9594483484255734151.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     fc5db58539b49351e76f19817ed1102bf7c712d0
Gitweb:        https://git.kernel.org/tip/fc5db58539b49351e76f19817ed1102bf7c712d0
Author:        Kai-Heng Feng <kai.heng.feng@canonical.com>
AuthorDate:    Wed, 16 Oct 2019 18:38:16 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 12 Nov 2019 15:55:20 +01:00

x86/quirks: Disable HPET on Intel Coffe Lake platforms

Some Coffee Lake platforms have a skewed HPET timer once the SoCs entered
PC10, which in consequence marks TSC as unstable because HPET is used as
watchdog clocksource for TSC.

Harry Pan tried to work around it in the clocksource watchdog code [1]
thereby creating a circular dependency between HPET and TSC. This also
ignores the fact, that HPET is not only unsuitable as watchdog clocksource
on these systems, it becomes unusable in general.

Disable HPET on affected platforms.

Suggested-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203183
Link: https://lore.kernel.org/lkml/20190516090651.1396-1-harry.pan@intel.com/ [1]
Link: https://lkml.kernel.org/r/20191016103816.30650-1-kai.heng.feng@canonical.com
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 6f6b1d0..4cba91e 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -710,6 +710,8 @@ static struct chipset early_qrk[] __initdata = {
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}
