Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A629B63C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797154AbgJ0PVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797144AbgJ0PVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F0A20657;
        Tue, 27 Oct 2020 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812109;
        bh=dEldMgnZTCIzZ1Zh52EVtedfksIUyT/q4ZLdb6Y2hxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj4S0UfFY9qED6ZTsUyhXkMa1XjtP1PE1kLdXj8cdeeHXHa4Ay5jtzJdsq2cdogld
         6EIHi0ONokshU8GhenqJ2Ax9sYCluH2hRXidbtiAtrceHdYg1GdL7x+fVQKanScVaE
         p1xRivSYGCpFip+1SWdZ8JrUNkbnF/aPdD9EVWMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 095/757] x86/fpu: Allow multiple bits in clearcpuid= parameter
Date:   Tue, 27 Oct 2020 14:45:45 +0100
Message-Id: <20201027135455.004084066@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 0a4bb5e5507a585532cc413125b921c8546fc39f ]

Commit

  0c2a3913d6f5 ("x86/fpu: Parse clearcpuid= as early XSAVE argument")

changed clearcpuid parsing from __setup() to cmdline_find_option().
While the __setup() function would have been called for each clearcpuid=
parameter on the command line, cmdline_find_option() will only return
the last one, so the change effectively made it impossible to disable
more than one bit.

Allow a comma-separated list of bit numbers as the argument for
clearcpuid to allow multiple bits to be disabled again. Log the bits
being disabled for informational purposes.

Also fix the check on the return value of cmdline_find_option(). It
returns -1 when the option is not found, so testing as a boolean is
incorrect.

Fixes: 0c2a3913d6f5 ("x86/fpu: Parse clearcpuid= as early XSAVE argument")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200907213919.2423441-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/x86/kernel/fpu/init.c                    | 30 ++++++++++++++-----
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a1068742a6df1..ffe864390c5ac 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -577,7 +577,7 @@
 			loops can be debugged more effectively on production
 			systems.
 
-	clearcpuid=BITNUM [X86]
+	clearcpuid=BITNUM[,BITNUM...] [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
 			numbers. Note the Linux specific bits are not necessarily
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 61ddc3a5e5c2b..f8ff895aaf7e1 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -243,9 +243,9 @@ static void __init fpu__init_system_ctx_switch(void)
  */
 static void __init fpu__init_parse_early_param(void)
 {
-	char arg[32];
+	char arg[128];
 	char *argptr = arg;
-	int bit;
+	int arglen, res, bit;
 
 #ifdef CONFIG_X86_32
 	if (cmdline_find_option_bool(boot_command_line, "no387"))
@@ -268,12 +268,26 @@ static void __init fpu__init_parse_early_param(void)
 	if (cmdline_find_option_bool(boot_command_line, "noxsaves"))
 		setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 
-	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
-				sizeof(arg)) &&
-	    get_option(&argptr, &bit) &&
-	    bit >= 0 &&
-	    bit < NCAPINTS * 32)
-		setup_clear_cpu_cap(bit);
+	arglen = cmdline_find_option(boot_command_line, "clearcpuid", arg, sizeof(arg));
+	if (arglen <= 0)
+		return;
+
+	pr_info("Clearing CPUID bits:");
+	do {
+		res = get_option(&argptr, &bit);
+		if (res == 0 || res == 3)
+			break;
+
+		/* If the argument was too long, the last bit may be cut off */
+		if (res == 1 && arglen >= sizeof(arg))
+			break;
+
+		if (bit >= 0 && bit < NCAPINTS * 32) {
+			pr_cont(" " X86_CAP_FMT, x86_cap_flag(bit));
+			setup_clear_cpu_cap(bit);
+		}
+	} while (res == 2);
+	pr_cont("\n");
 }
 
 /*
-- 
2.25.1



