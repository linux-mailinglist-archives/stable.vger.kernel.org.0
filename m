Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989801170C7
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 16:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLIPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 10:45:10 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46599 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfLIPpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 10:45:10 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 993b7997;
        Mon, 9 Dec 2019 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=We/tViqcNSYyTT+iqYw0DQdfr
        xM=; b=Q5OawQr1HbUwCMdsIf6cI7Zd1M9bVuMDDY9mupyHdR2oGLBox1ui34uYZ
        Vbkp5g8b4es4z232O7vLpWC41qNeLdoALzyzB4MrvluDYFmoewm1CkbOIW5o0tRg
        VwbJO3LHYf/umnycOD/ex8veKp6FQkwDC3F5V4pAYcFtQG3sAQCfNzNGSafTMd9D
        lmFKoxPkA60aKVoiCcp6whXUTlD7TXP338klIkNa8WPXHcLPXpC53FGjOZetYukw
        NzxQdtkANxUWNQCrNhCz0jOqBpecc0L4y0ZRanmOiq0z2BCYCenmUPmD6B3A/BqX
        4wIdwYKY5WNs9SvPO5FH3X93npmCQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 561349ab (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 9 Dec 2019 14:49:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     x86@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
Date:   Mon,  9 Dec 2019 16:45:05 +0100
Message-Id: <20191209154505.6183-1-Jason@zx2c4.com>
In-Reply-To: <20191203205716.1228-1-Jason@zx2c4.com>
References: <20191203205716.1228-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a follow up of fc5db58539b4 ("x86/quirks: Disable HPET on Intel
Coffe Lake platforms"), which addressed the issue for 8th generation
Coffee Lake. Intel has released Coffee Lake again for 9th generation,
apparently still with the same bug:

clocksource: timekeeping watchdog on CPU3: Marking clocksource 'tsc' as unstable because the skew is too large:
clocksource:                       'hpet' wd_now: 24f422b8 wd_last: 247dea41 mask: ffffffff
clocksource:                       'tsc' cs_now: 144d927c4e cs_last: 140ba6e2a0 mask: ffffffffffffffff
tsc: Marking TSC unstable due to clocksource watchdog
TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
sched_clock: Marking unstable (26553416234, 4203921)<-(26567277071, -9656937)
clocksource: Switched to clocksource hpet

So, we add another quirk for the chipset

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4cba91ec8049..a73f88dd7f86 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -712,6 +712,8 @@ static struct chipset early_qrk[] __initdata = {
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3e20,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}
-- 
2.24.0

