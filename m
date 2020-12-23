Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42B2E1DFB
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgLWPd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A637F23343;
        Wed, 23 Dec 2020 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737565;
        bh=IEtk3MrL4cfF0oLmIg4TjHu6d/ubqCEYorrr+CJEuLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lu/ykf32vfPcqMlvOM7ZDNsO7OAC8M1D9b7demgjmNQLZEjYtjzXUG3B/Psss1ufm
         sRqf6INF+7wCkKEek+MV6+ukLvjc+HLHC0Dhfg+i8vUWa5LyKMytkvqYDfN9XZw5d3
         JRg2+gSb/UzXxMo8Gjbxs8Cni/VbZmPN1+bdH+Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 02/40] x86/split-lock: Avoid returning with interrupts enabled
Date:   Wed, 23 Dec 2020 16:33:03 +0100
Message-Id: <20201223150515.682569814@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

commit e14fd4ba8fb47fcf5f244366ec01ae94490cd86a upstream.

When a split lock is detected always make sure to disable interrupts
before returning from the trap handler.

The kernel exit code assumes that all exits run with interrupts
disabled, otherwise the SWAPGS sequence can race against interrupts and
cause recursing page faults and later panics.

The problem will only happen on CPUs with split lock disable
functionality, so Icelake Server, Tiger Lake, Snow Ridge, Jacobsville.

Fixes: ca4c6a9858c2 ("x86/traps: Make interrupt enable/disable symmetric in C code")
Fixes: bce9b042ec73 ("x86/traps: Disable interrupts in exc_aligment_check()") # v5.8+
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/traps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -299,11 +299,12 @@ DEFINE_IDTENTRY_ERRORCODE(exc_alignment_
 	local_irq_enable();
 
 	if (handle_user_split_lock(regs, error_code))
-		return;
+		goto out;
 
 	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
 		error_code, BUS_ADRALN, NULL);
 
+out:
 	local_irq_disable();
 }
 


