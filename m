Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9F1D08C
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfENUZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfENUZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 16:25:05 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4410321726;
        Tue, 14 May 2019 20:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557865505;
        bh=V8lGZOijGGroDQlnNtg2WHMwlbIFGtORUHrj5N/6N5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKe0Vn5rSFeLvnBCMcdBjQAKWYOEpXQK9RMljVhjjKEiZA6Gmpj4B6Re7H5B1bEtK
         knwD7OfJ7ZtvkeCzHuOZu1FPMSbgWSCn0AhBBq7VGhCXqRWIN8zg23VPYMDyTlK3p4
         6hRgRJfoTUiuqiTHJChgQeWeNQvTuwjge//9L4UM=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>
Subject: [PATCH 1/2] x86/speculation/mds: Revert CPU buffer clear on double fault exit
Date:   Tue, 14 May 2019 13:24:39 -0700
Message-Id: <ac97612445c0a44ee10374f6ea79c222fe22a5c4.1557865329.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1557865329.git.luto@kernel.org>
References: <cover.1557865329.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The double fault ESPFIX path doesn't return to user mode at all --
it returns back to the kernel by simulating a #GP fault.
prepare_exit_to_usermode() will run on the way out of
general_protection before running user code.

Cc: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jon Masters <jcm@redhat.com>
Fixes: 04dcbdb80578 ("x86/speculation/mds: Clear CPU buffers on exit to user")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 Documentation/x86/mds.rst | 7 -------
 arch/x86/kernel/traps.c   | 8 --------
 2 files changed, 15 deletions(-)

diff --git a/Documentation/x86/mds.rst b/Documentation/x86/mds.rst
index 534e9baa4e1d..0dc812bb9249 100644
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -158,13 +158,6 @@ Mitigation points
      mitigated on the return from do_nmi() to provide almost complete
      coverage.
 
-   - Double fault (#DF):
-
-     A double fault is usually fatal, but the ESPFIX workaround, which can
-     be triggered from user space through modify_ldt(2) is a recoverable
-     double fault. #DF uses the paranoid exit path, so explicit mitigation
-     in the double fault handler is required.
-
    - Machine Check Exception (#MC):
 
      Another corner case is a #MC which hits between the CPU buffer clear
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7de466eb960b..8b6d03e55d2f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -58,7 +58,6 @@
 #include <asm/alternative.h>
 #include <asm/fpu/xstate.h>
 #include <asm/trace/mpx.h>
-#include <asm/nospec-branch.h>
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
@@ -368,13 +367,6 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 		regs->ip = (unsigned long)general_protection;
 		regs->sp = (unsigned long)&gpregs->orig_ax;
 
-		/*
-		 * This situation can be triggered by userspace via
-		 * modify_ldt(2) and the return does not take the regular
-		 * user space exit, so a CPU buffer clear is required when
-		 * MDS mitigation is enabled.
-		 */
-		mds_user_clear_cpu_buffers();
 		return;
 	}
 #endif
-- 
2.21.0

