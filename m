Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED0A15C694
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgBMQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgBMPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:37 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06BD324691;
        Thu, 13 Feb 2020 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607473;
        bh=ACjKYz9A2d8Fi5hQbocr4bi/V9Cmxvl3mDGZ6dQiI0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRBokUDaFc8xLEg2O3NjOgYMvgH7fNIDcvXBMYM8n1nI7ULorYyJRCymIOJ+UFgBk
         nAPS1XNHd0CtXkZnYBECrI7Dl2/xJWwPDKvmPerFQxrI1YA+2qrMeTzApmNnS9JQU9
         kUH7H2daHf3u3BZboB9x8DIvd01HYf7/zcEpi+sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 003/173] x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR
Date:   Thu, 13 Feb 2020 07:18:26 -0800
Message-Id: <20200213151932.921960415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 5efc6fa9044c3356d6046c6e1da6d02572dbed6b ]

/proc/cpuinfo currently reports Hardware Lock Elision (HLE) feature to
be present on boot cpu even if it was disabled during the bootup. This
is because cpuinfo_x86->x86_capability HLE bit is not updated after TSX
state is changed via the new MSR IA32_TSX_CTRL.

Update the cached HLE bit also since it is expected to change after an
update to CPUID_CLEAR bit in MSR IA32_TSX_CTRL.

Fixes: 95c5824f75f3 ("x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2529b99546294c893dfa1c89e2b3e46da3369a59.1578685425.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/tsx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 3e20d322bc98b..032509adf9de9 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -115,11 +115,12 @@ void __init tsx_init(void)
 		tsx_disable();
 
 		/*
-		 * tsx_disable() will change the state of the
-		 * RTM CPUID bit.  Clear it here since it is now
-		 * expected to be not set.
+		 * tsx_disable() will change the state of the RTM and HLE CPUID
+		 * bits. Clear them here since they are now expected to be not
+		 * set.
 		 */
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
 	} else if (tsx_ctrl_state == TSX_CTRL_ENABLE) {
 
 		/*
@@ -131,10 +132,10 @@ void __init tsx_init(void)
 		tsx_enable();
 
 		/*
-		 * tsx_enable() will change the state of the
-		 * RTM CPUID bit.  Force it here since it is now
-		 * expected to be set.
+		 * tsx_enable() will change the state of the RTM and HLE CPUID
+		 * bits. Force them here since they are now expected to be set.
 		 */
 		setup_force_cpu_cap(X86_FEATURE_RTM);
+		setup_force_cpu_cap(X86_FEATURE_HLE);
 	}
 }
-- 
2.20.1



