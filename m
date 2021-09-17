Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6574040EFCC
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhIQCsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhIQCsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B9DE60FA0;
        Fri, 17 Sep 2021 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846820;
        bh=Hj2m8sNTz+46nMvsPPI9fdpD/+2VPtdTbfYmLWxHZHM=;
        h=From:To:Cc:Subject:Date:From;
        b=T8Ndbe9alPrAWA49izz5m+WyLf6aqn3bU2JZRlzveipUHAARmr2YlWtz0WctrUSoN
         kWb0whByoV06VZeBrNUrNqxGWJmDGLdDCdco6MnroQ8kV8SPfy7XjnblgrZohfrLIU
         ZuxEbmD7ORzQ45/b2fYSHwDYg4D8EvFAqIoT5M4b7k9FtYe/bQao34bOS2kfbIgcrV
         D3nr0bIVsAkyRBSD0HVUIgB3E4yRmDcGIzGoHSjyc6c5/IQSPBKkgg1BUJMZLm7xCO
         OfP3fjB/l13wCpp3rl8WqoAV+BgLdSV6b+S7jKnUUn+8HhMMP1PKybIG+1Hl5rMUJy
         Xso3Ttwan8vMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     x86@kernel.org
Cc:     jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, paulmck@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] x86/intel: Disable HPET on another Intel Coffee Lake platform
Date:   Thu, 16 Sep 2021 19:46:48 -0700
Message-Id: <20210917024648.1383476-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Lenovo T490s with i7-8665U had been marking TSC as unstable
since v5.13, resulting in very sluggish desktop experience...

Kernel logs show:

  clocksource: timekeeping watchdog on CPU3: hpet read-back delay of 316000ns, attempt 4, marking unstable
  tsc: Marking TSC unstable due to clocksource watchdog
  TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
  sched_clock: Marking unstable (14539801827657, -530891666)<-(14539319241737, -48307500)
  clocksource: Checking clocksource tsc synchronization from CPU 3 to CPUs 0-2,6-7.
  clocksource: Switched to clocksource hpet

I have a 8086:3e34 bridge, also known as "Host bridge: Intel
Corporation Coffee Lake HOST and DRAM Controller (rev 0c)".
Add it to the list.

We should perhaps consider applying this quirk more widely.
The Intel documentation does not list my device [1], but
linuxhw [2] does, and it seems to list a few more bridges
we do not currently cover (3e31, 3ecc, 3e35, 3e0f).

[1] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/8th-gen-core-family-datasheet-vol-2.pdf
[2] https://github.com/linuxhw/DevicePopulation/blob/master/README.md

Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: - add the dmesg output
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 38837dad46e6..7d2de04f8750 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -716,6 +716,8 @@ static struct chipset early_qrk[] __initdata = {
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x3e20,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3e34,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_INTEL, 0x8a12,
-- 
2.31.1

