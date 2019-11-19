Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BB9101854
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfKSGHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbfKSFdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1570621823;
        Tue, 19 Nov 2019 05:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141592;
        bh=lxoQO1EoauxQvVrXhOgcjT27wnFtW9WZsPTLQMG3sWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBUvRoi/LJ19rMEvPDB115nv5hLBeMfmekcwRODEZaj4pxtGM6F+RcKLZnEic2JO2
         jC3d+oWYcIArTKlQ+1x6QS4NhV9CLIbBIZ8C9lMEY0OG0EUUSxtmCk11XSPEDC4oiy
         sf1fMW3Om3jkx/0jkEwIcbXqieSadV0MT2kcs3ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Modra <amodra@gmail.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/422] powerpc/vdso: Correct call frame information
Date:   Tue, 19 Nov 2019 06:16:49 +0100
Message-Id: <20191119051412.331584367@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 75cff3f336b3a..afd516b572f86 100644
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
index afbad2ac31472..1f324c28705bc 100644
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -169,6 +169,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
 	 */
 99:
 	li	r0,__NR_clock_gettime
+  .cfi_restore lr
 	sc
 	blr
   .cfi_endproc
-- 
2.20.1



