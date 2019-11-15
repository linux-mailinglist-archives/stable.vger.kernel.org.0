Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF2FD64B
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfKOGX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfKOGWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:06 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4672073B;
        Fri, 15 Nov 2019 06:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798925;
        bh=DWo7/IphT8u7wf9QRV79/gzz+1CgWd5RK3LExMVZ8Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omVE/i4BDER1CsFP8n5/H1gLLSdh6V3b8SdhbIqym1yfbljx2K5g74zzsNHiBmiwy
         ubNwcNsNp5WVPp92iJQoj2xzAod0QbqXkfYP8gSE3PGMV3YoQeaMf7UNr1z58Bp7xE
         urzt/3MqOcwgPRGI20uZI+qpkg28AHRv1rxxwX48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bpetkov@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 14/31] x86/tsx: Add config options to set tsx=on|off|auto
Date:   Fri, 15 Nov 2019 14:20:43 +0800
Message-Id: <20191115062015.626684228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit db616173d787395787ecc93eef075fa975227b10 upstream.

There is a general consensus that TSX usage is not largely spread while
the history shows there is a non trivial space for side channel attacks
possible. Therefore the tsx is disabled by default even on platforms
that might have a safe implementation of TSX according to the current
knowledge. This is a fair trade off to make.

There are, however, workloads that really do benefit from using TSX and
updating to a newer kernel with TSX disabled might introduce a
noticeable regressions. This would be especially a problem for Linux
distributions which will provide TAA mitigations.

Introduce config options X86_INTEL_TSX_MODE_OFF, X86_INTEL_TSX_MODE_ON
and X86_INTEL_TSX_MODE_AUTO to control the TSX feature. The config
setting can be overridden by the tsx cmdline options.

 [ bp: Text cleanups from Josh. ]

Suggested-by: Borislav Petkov <bpetkov@suse.de>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 4.9: adjust doc filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig          |   45 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/tsx.c |   22 ++++++++++++++++------
 2 files changed, 61 insertions(+), 6 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1755,6 +1755,51 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+choice
+	prompt "TSX enable mode"
+	depends on CPU_SUP_INTEL
+	default X86_INTEL_TSX_MODE_OFF
+	help
+	  Intel's TSX (Transactional Synchronization Extensions) feature
+	  allows to optimize locking protocols through lock elision which
+	  can lead to a noticeable performance boost.
+
+	  On the other hand it has been shown that TSX can be exploited
+	  to form side channel attacks (e.g. TAA) and chances are there
+	  will be more of those attacks discovered in the future.
+
+	  Therefore TSX is not enabled by default (aka tsx=off). An admin
+	  might override this decision by tsx=on the command line parameter.
+	  Even with TSX enabled, the kernel will attempt to enable the best
+	  possible TAA mitigation setting depending on the microcode available
+	  for the particular machine.
+
+	  This option allows to set the default tsx mode between tsx=on, =off
+	  and =auto. See Documentation/kernel-parameters.txt for more
+	  details.
+
+	  Say off if not sure, auto if TSX is in use but it should be used on safe
+	  platforms or on if TSX is in use and the security aspect of tsx is not
+	  relevant.
+
+config X86_INTEL_TSX_MODE_OFF
+	bool "off"
+	help
+	  TSX is disabled if possible - equals to tsx=off command line parameter.
+
+config X86_INTEL_TSX_MODE_ON
+	bool "on"
+	help
+	  TSX is always enabled on TSX capable HW - equals the tsx=on command
+	  line parameter.
+
+config X86_INTEL_TSX_MODE_AUTO
+	bool "auto"
+	help
+	  TSX is enabled on TSX capable HW that is believed to be safe against
+	  side channel attacks- equals the tsx=auto command line parameter.
+endchoice
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -73,6 +73,14 @@ static bool __init tsx_ctrl_is_supported
 	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
 }
 
+static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_TAA))
+		return TSX_CTRL_DISABLE;
+
+	return TSX_CTRL_ENABLE;
+}
+
 void __init tsx_init(void)
 {
 	char arg[5] = {};
@@ -88,17 +96,19 @@ void __init tsx_init(void)
 		} else if (!strcmp(arg, "off")) {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
 		} else if (!strcmp(arg, "auto")) {
-			if (boot_cpu_has_bug(X86_BUG_TAA))
-				tsx_ctrl_state = TSX_CTRL_DISABLE;
-			else
-				tsx_ctrl_state = TSX_CTRL_ENABLE;
+			tsx_ctrl_state = x86_get_tsx_auto_mode();
 		} else {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
 			pr_err("tsx: invalid option, defaulting to off\n");
 		}
 	} else {
-		/* tsx= not provided, defaulting to off */
-		tsx_ctrl_state = TSX_CTRL_DISABLE;
+		/* tsx= not provided */
+		if (IS_ENABLED(CONFIG_X86_INTEL_TSX_MODE_AUTO))
+			tsx_ctrl_state = x86_get_tsx_auto_mode();
+		else if (IS_ENABLED(CONFIG_X86_INTEL_TSX_MODE_OFF))
+			tsx_ctrl_state = TSX_CTRL_DISABLE;
+		else
+			tsx_ctrl_state = TSX_CTRL_ENABLE;
 	}
 
 	if (tsx_ctrl_state == TSX_CTRL_DISABLE) {


