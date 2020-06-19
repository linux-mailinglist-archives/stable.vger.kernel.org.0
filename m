Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55E201797
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395445AbgFSQkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395444AbgFSQkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 12:40:40 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A1EC06174E;
        Fri, 19 Jun 2020 09:40:40 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jmK4C-0003r7-LU; Fri, 19 Jun 2020 18:40:36 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 0CC871C0085;
        Fri, 19 Jun 2020 18:40:36 +0200 (CEST)
Date:   Fri, 19 Jun 2020 16:40:35 -0000
From:   "tip-bot2 for Matt Fleming" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/asm/64: Align start of __clear_user() loop to 16-bytes
Cc:     Matt Fleming <matt@codeblueprint.co.uk>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200618102002.30034-1-matt@codeblueprint.co.uk>
References: <20200618102002.30034-1-matt@codeblueprint.co.uk>
MIME-Version: 1.0
Message-ID: <159258483578.16989.3987549539950250015.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     bb5570ad3b54e7930997aec76ab68256d5236d94
Gitweb:        https://git.kernel.org/tip/bb5570ad3b54e7930997aec76ab68256d5236d94
Author:        Matt Fleming <matt@codeblueprint.co.uk>
AuthorDate:    Thu, 18 Jun 2020 11:20:02 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 19 Jun 2020 18:32:11 +02:00

x86/asm/64: Align start of __clear_user() loop to 16-bytes

x86 CPUs can suffer severe performance drops if a tight loop, such as
the ones in __clear_user(), straddles a 16-byte instruction fetch
window, or worse, a 64-byte cacheline. This issues was discovered in the
SUSE kernel with the following commit,

  1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")

which increased the code object size from 10 bytes to 15 bytes and
caused the 8-byte copy loop in __clear_user() to be split across a
64-byte cacheline.

Aligning the start of the loop to 16-bytes makes this fit neatly inside
a single instruction fetch window again and restores the performance of
__clear_user() which is used heavily when reading from /dev/zero.

Here are some numbers from running libmicro's read_z* and pread_z*
microbenchmarks which read from /dev/zero:

  Zen 1 (Naples)

  libmicro-file
                                        5.7.0-rc6              5.7.0-rc6              5.7.0-rc6
                                                    revert-1153933703d9+               align16+
  Time mean95-pread_z100k       9.9195 (   0.00%)      5.9856 (  39.66%)      5.9938 (  39.58%)
  Time mean95-pread_z10k        1.1378 (   0.00%)      0.7450 (  34.52%)      0.7467 (  34.38%)
  Time mean95-pread_z1k         0.2623 (   0.00%)      0.2251 (  14.18%)      0.2252 (  14.15%)
  Time mean95-pread_zw100k      9.9974 (   0.00%)      6.0648 (  39.34%)      6.0756 (  39.23%)
  Time mean95-read_z100k        9.8940 (   0.00%)      5.9885 (  39.47%)      5.9994 (  39.36%)
  Time mean95-read_z10k         1.1394 (   0.00%)      0.7483 (  34.33%)      0.7482 (  34.33%)

Note that this doesn't affect Haswell or Broadwell microarchitectures
which seem to avoid the alignment issue by executing the loop straight
out of the Loop Stream Detector (verified using perf events).

Fixes: 1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://lkml.kernel.org/r/20200618102002.30034-1-matt@codeblueprint.co.uk
---
 arch/x86/lib/usercopy_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index fff28c6..b0dfac3 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 	asm volatile(
 		"	testq  %[size8],%[size8]\n"
 		"	jz     4f\n"
+		"	.align 16\n"
 		"0:	movq $0,(%[dst])\n"
 		"	addq   $8,%[dst]\n"
 		"	decl %%ecx ; jnz   0b\n"
