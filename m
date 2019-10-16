Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD19D8E18
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 12:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfJPKik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 06:38:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39442 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfJPKik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 06:38:40 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iKghC-0001KT-Ol; Wed, 16 Oct 2019 10:38:23 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     hpa@zytor.com, harry.pan@intel.com, feng.tang@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/intel: Disable HPET on Intel Coffe Lake platforms
Date:   Wed, 16 Oct 2019 18:38:16 +0800
Message-Id: <20191016103816.30650-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some Coffee Lake platforms have skewed HPET timer once the SoCs entered
PC10, and marked TSC as unstable clocksource as result.

Harry Pan identified it's a firmware bug [1].

To prevent creating a circular dependency between HPET and TSC, let's
disable HPET on affected platforms.

[1]: https://lore.kernel.org/lkml/20190516090651.1396-1-harry.pan@intel.com/
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203183

Cc: <stable@vger.kernel.org>
Suggested-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 6f6b1d04dadf..4cba91ec8049 100644
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
-- 
2.17.1

