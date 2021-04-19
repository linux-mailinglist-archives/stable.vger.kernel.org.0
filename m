Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138DC364BF5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242472AbhDSUro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242627AbhDSUp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A02D613C3;
        Mon, 19 Apr 2021 20:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865104;
        bh=C5hji4FUmPrWScW47HD+P0j3mRsXZ4Sl6LrAKw74j8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSEUxKRJ4GAZI0tDCfQPLmNtbhyt27BMeILkAzLmOM6K4Q4HFnu4fa18x8ycniX2K
         wIE6u3ldIYp0I37IOaBAAAUFnG8v+smmZUxhnhNg5wktQTOK3oZBeDPJ9ApMm0z5Io
         XJ9pjqf6LmMvqNXPDFIssjkXW409BPDjZIzsi8rfnd4ZEr4Py/Y54kcMuJ2gSSw6+F
         P1D4TR6zMYP6SuLdndJB8LiuN8bBD6tPEzpYCLL5LrR5Zidlh/mrW3uUlSI6RAUVqT
         fRaDPFwYDRyeJFnsQkcwKEsZDJ4oEHqK7EkmjMxFIiM5dG5rKHex/GvxWihJqj3Umv
         woTNN9AZAYhWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/14] s390/entry: save the caller of psw_idle
Date:   Mon, 19 Apr 2021 16:44:46 -0400
Message-Id: <20210419204454.6601-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit a994eddb947ea9ebb7b14d9a1267001699f0a136 ]

Currently psw_idle does not allocate a stack frame and does not
save its r14 and r15 into the save area. Even though this is valid from
call ABI point of view, because psw_idle does not make any calls
explicitly, in reality psw_idle is an entry point for controlled
transition into serving interrupts. So, in practice, psw_idle stack
frame is analyzed during stack unwinding. Depending on build options
that r14 slot in the save area of psw_idle might either contain a value
saved by previous sibling call or complete garbage.

  [task    0000038000003c28] do_ext_irq+0xd6/0x160
  [task    0000038000003c78] ext_int_handler+0xba/0xe8
  [task   *0000038000003dd8] psw_idle_exit+0x0/0x8 <-- pt_regs
 ([task    0000038000003dd8] 0x0)
  [task    0000038000003e10] default_idle_call+0x42/0x148
  [task    0000038000003e30] do_idle+0xce/0x160
  [task    0000038000003e70] cpu_startup_entry+0x36/0x40
  [task    0000038000003ea0] arch_call_rest_init+0x76/0x80

So, to make a stacktrace nicer and actually point for the real caller of
psw_idle in this frequently occurring case, make psw_idle save its r14.

  [task    0000038000003c28] do_ext_irq+0xd6/0x160
  [task    0000038000003c78] ext_int_handler+0xba/0xe8
  [task   *0000038000003dd8] psw_idle_exit+0x0/0x6 <-- pt_regs
 ([task    0000038000003dd8] arch_cpu_idle+0x3c/0xd0)
  [task    0000038000003e10] default_idle_call+0x42/0x148
  [task    0000038000003e30] do_idle+0xce/0x160
  [task    0000038000003e70] cpu_startup_entry+0x36/0x40
  [task    0000038000003ea0] arch_call_rest_init+0x76/0x80

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index c544b7a11ebb..5cba1815b8f8 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -993,6 +993,7 @@ ENDPROC(ext_int_handler)
  * Load idle PSW. The second "half" of this function is in .Lcleanup_idle.
  */
 ENTRY(psw_idle)
+	stg	%r14,(__SF_GPRS+8*8)(%r15)
 	stg	%r3,__SF_EMPTY(%r15)
 	larl	%r1,.Lpsw_idle_lpsw+4
 	stg	%r1,__SF_EMPTY+8(%r15)
-- 
2.30.2

