Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A086F47C8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388993AbfKHLwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390586AbfKHLrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5A7218AE;
        Fri,  8 Nov 2019 11:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213625;
        bh=fCHwIOGu3unDcLR2KdVSgi3LcxKQ2gDJuYvU66MMI3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuF3IvBgvvCpjOno+OZ2ZMssAh7bz7eTB9cbKVL9ihEgBDD9ET46lGx5Gy7xcY0E/
         qkup5hCNps8+GPIOw+HpO/VpurTwDRw1p22McM53yDz1nj4jI4VMWjUWBkBb4+MrBG
         +tNnWGZYGm0Vknr/fywf5DcjFL+xH3ZijACns5Hk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Modra <amodra@gmail.com>, Reza Arbab <arbab@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 53/64] powerpc/vdso: Correct call frame information
Date:   Fri,  8 Nov 2019 06:45:34 -0500
Message-Id: <20191108114545.15351-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Modra <amodra@gmail.com>

[ Upstream commit 56d20861c027498b5a1112b4f9f05b56d906fdda ]

Call Frame Information is used by gdb for back-traces and inserting
breakpoints on function return for the "finish" command.  This failed
when inside __kernel_clock_gettime.  More concerning than difficulty
debugging is that CFI is also used by stack frame unwinding code to
implement exceptions.  If you have an app that needs to handle
asynchronous exceptions for some reason, and you are unlucky enough to
get one inside the VDSO time functions, your app will crash.

What's wrong:  There is control flow in __kernel_clock_gettime that
reaches label 99 without saving lr in r12.  CFI info however is
interpreted by the unwinder without reference to control flow: It's a
simple matter of "Execute all the CFI opcodes up to the current
address".  That means the unwinder thinks r12 contains the return
address at label 99.  Disabuse it of that notion by resetting CFI for
the return address at label 99.

Note that the ".cfi_restore lr" could have gone anywhere from the
"mtlr r12" a few instructions earlier to the instruction at label 99.
I put the CFI as late as possible, because in general that's best
practice (and if possible grouped with other CFI in order to reduce
the number of CFI opcodes executed when unwinding).  Using r12 as the
return address is perfectly fine after the "mtlr r12" since r12 on
that code path still contains the return address.

__get_datapage also has a CFI error.  That function temporarily saves
lr in r0, and reflects that fact with ".cfi_register lr,r0".  A later
use of r0 means the CFI at that point isn't correct, as r0 no longer
contains the return address.  Fix that too.

Signed-off-by: Alan Modra <amodra@gmail.com>
Tested-by: Reza Arbab <arbab@linux.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso32/datapage.S     | 1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S | 1 +
 arch/powerpc/kernel/vdso64/datapage.S     | 1 +
 arch/powerpc/kernel/vdso64/gettimeofday.S | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/vdso32/datapage.S b/arch/powerpc/kernel/vdso32/datapage.S
index 3745113fcc652..2a7eb5452aba7 100644
--- a/arch/powerpc/kernel/vdso32/datapage.S
+++ b/arch/powerpc/kernel/vdso32/datapage.S
@@ -37,6 +37,7 @@ data_page_branch:
 	mtlr	r0
 	addi	r3, r3, __kernel_datapage_offset-data_page_branch
 	lwz	r0,0(r3)
+  .cfi_restore lr
 	add	r3,r0,r3
 	blr
   .cfi_endproc
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index 6b2b69616e776..7b341b86216c2 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -139,6 +139,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
 	 */
 99:
 	li	r0,__NR_clock_gettime
+  .cfi_restore lr
 	sc
 	blr
   .cfi_endproc
diff --git a/arch/powerpc/kernel/vdso64/datapage.S b/arch/powerpc/kernel/vdso64/datapage.S
index abf17feffe404..bf96686915116 100644
--- a/arch/powerpc/kernel/vdso64/datapage.S
+++ b/arch/powerpc/kernel/vdso64/datapage.S
@@ -37,6 +37,7 @@ data_page_branch:
 	mtlr	r0
 	addi	r3, r3, __kernel_datapage_offset-data_page_branch
 	lwz	r0,0(r3)
+  .cfi_restore lr
 	add	r3,r0,r3
 	blr
   .cfi_endproc
diff --git a/arch/powerpc/kernel/vdso64/gettimeofday.S b/arch/powerpc/kernel/vdso64/gettimeofday.S
index 3820213248836..09b2a49f6dd53 100644
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -124,6 +124,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
 	 */
 99:
 	li	r0,__NR_clock_gettime
+  .cfi_restore lr
 	sc
 	blr
   .cfi_endproc
-- 
2.20.1

