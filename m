Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D8829AF4A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755254AbgJ0OJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755249AbgJ0OJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F10122202;
        Tue, 27 Oct 2020 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807739;
        bh=im07X5bQ//tsJMhCK1PENZV9aoX81rAwg1WHZpYgZhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zU8JWuBtkeIuPreT9hDH7BP6fxNe0zvFaTv20TA5KCBYkCQk0k2Qf35HG2NDNmJy
         9eZIFV9bedXlxhuTiabZG7uvEey6a2YsGOy16MQl3Gw2IeUBGyiFbwdC/y1KbbzuF5
         FIIb95tMjrRQn+d/8yNG2Us9oX4e/9PXaNfkMf9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/191] x86/fpu: Allow multiple bits in clearcpuid= parameter
Date:   Tue, 27 Oct 2020 14:47:58 +0100
Message-Id: <20201027134910.834774223@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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
index dc96e7f10ebcd..0a59fcf934f43 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -552,7 +552,7 @@
 			loops can be debugged more effectively on production
 			systems.
 
-	clearcpuid=BITNUM [X86]
+	clearcpuid=BITNUM[,BITNUM...] [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
 			numbers. Note the Linux specific bits are not necessarily
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 6abd83572b016..9692ccc583bb3 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -249,9 +249,9 @@ static void __init fpu__init_system_ctx_switch(void)
  */
 static void __init fpu__init_parse_early_param(void)
 {
-	char arg[32];
+	char arg[128];
 	char *argptr = arg;
-	int bit;
+	int arglen, res, bit;
 
 	if (cmdline_find_option_bool(boot_command_line, "no387"))
 		setup_clear_cpu_cap(X86_FEATURE_FPU);
@@ -271,12 +271,26 @@ static void __init fpu__init_parse_early_param(void)
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



