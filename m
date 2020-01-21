Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DC6143FD6
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAUOms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 09:42:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36518 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUOms (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 09:42:48 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so1610318pgc.3;
        Tue, 21 Jan 2020 06:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ho6/jrDBRa+qlME4ElhlvhhdyNa7g2+wumSYNnk2HpM=;
        b=jsNBVquhp9YEvTIbGj344GhZmUkGmUViStGkA5XLwF7n40ZvK1NwgWc8TcH38238P5
         pgyY1t/pEaTfvbQ7Urrhg98WDKF5cWSwb4ycylm2Bkm9q/u/Rd92iBdoDlhrXl63e4wE
         J/9YGad6moCGPu43D5IgDiZJ2bXn+oeGvTZYdUu5unudQJFgWTl9hwN6vBUGpQq0IxoV
         zb2V7qgp9wY0yF7VlcMPxJiPFa/JgOAk+6xaCYgYdAwhKTm4gRx0fjEljGKVh4xl/iAi
         WbvY2AHttYXA5Opr3bTBt4vOXJpYAkTSOjh3NpLKC8qwgW70YzMcHI5dM73+tJLU0tf8
         v0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ho6/jrDBRa+qlME4ElhlvhhdyNa7g2+wumSYNnk2HpM=;
        b=XOhiyh5AO72G/NH2xf8qYjo4zY2pViImvrNVLWpn88B9dHRNGIy2w59UFzq/X9eVWM
         Qi0zJnfjbbwqeejx78phaphcGxohS/5sL1G6P1LCoCNEW2qhbcfVs5F2f93aCKkYKEPb
         qbbj+TAC2RAcQPisO9py/0OwQAcC3BFvlUSs30GSh2LT3VfZ2/CPN2JU2jRLCwSV8+zw
         oPlv3t6tukGoJB2W4g3+NXHJX/ql35CRlHWu+W5ZfCqtUrsGb+I9jRmUaq7ethmFOhdL
         ZkUS8vg5zn/idjUgmNofRqL0gk2NQNLjF9gd1EQaGDIoylLuE8APq1HVTKL2xTFHqcF8
         mCgg==
X-Gm-Message-State: APjAAAWB0y+KZ8E6/SV+5hWg4MBE23UuSs1qY7vYZMIVl8Q4XIjRAjwl
        2aHMcUD7fIOITFZkvJz+6HM=
X-Google-Smtp-Source: APXvYqwMKEAnNSX+TGWzB787XPcY6RFZ3bCX7/tned/Kkuel9gMZ2ZNOfaOl0ntGU4XjiYQaJiF5fw==
X-Received: by 2002:a62:1684:: with SMTP id 126mr4902444pfw.234.1579617767699;
        Tue, 21 Jan 2020 06:42:47 -0800 (PST)
Received: from localhost.localdomain ([106.206.23.174])
        by smtp.googlemail.com with ESMTPSA id x22sm44055441pgc.2.2020.01.21.06.42.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 06:42:47 -0800 (PST)
From:   Vipul Kumar <vipulk0511@gmail.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     <linux-kernel@vger.kernel.org>, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Vipul Kumar <vipulk0511@gmail.com>, x86@kernel.org,
        Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
Date:   Tue, 21 Jan 2020 20:11:57 +0530
Message-Id: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vipul Kumar <vipul_kumar@mentor.com>

commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE
flags on Intel Atom SoCs"), is setting TSC_KNOWN_FREQ and TSC_RELIABLE
flags for Soc's which is causing time drift on Valleyview/Bay trail Soc.

This patch introduces a new macro to skip these flags.

Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
Cc: stable@vger.kernel.org
---
Changes in V2:
- Added linux-stable along with kernel version in CC

Changes in V3:
- Intead of cpuid-level, used macro to skip the flags

Tested-on: SIEMENS-IPC227E board
---
 arch/x86/Kconfig          | 10 ++++++++++
 arch/x86/kernel/tsc_msr.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5e89499..f6c175d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1155,6 +1155,16 @@ config X86_THERMAL_VECTOR
 	def_bool y
 	depends on X86_MCE_INTEL
 
+config X86_FEATURE_TSC_UNKNOWN_FREQ
+	bool "Support to skip tsc known frequency flag"
+	help
+	  Include support to skip X86_FEATURE_TSC_KNOWN_FREQ flag
+
+	  X86_FEATURE_TSC_KNOWN_FREQ flag is causing time-drift on Valleyview/
+	  Baytrail SoC.
+	  By selecting this option, user can skip X86_FEATURE_TSC_KNOWN_FREQ
+	  flag to use refine tsc freq calibration.
+
 source "arch/x86/events/Kconfig"
 
 config X86_LEGACY_VM86
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index e0cbe4f..60c3a4a 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -112,6 +112,10 @@ unsigned long cpu_khz_from_msr(void)
 	lapic_timer_period = (freq * 1000) / HZ;
 #endif
 
+#ifdef CONFIG_X86_FEATURE_TSC_UNKNOWN_FREQ
+	return res;
+#endif
+
 	/*
 	 * TSC frequency determined by MSR is always considered "known"
 	 * because it is reported by HW.
-- 
1.9.1

