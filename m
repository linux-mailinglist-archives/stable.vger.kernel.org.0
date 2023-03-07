Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028B16AEB99
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjCGRqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjCGRqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:46:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C89A54D9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E55D0B819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3CFC433EF;
        Tue,  7 Mar 2023 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210878;
        bh=Lm82ebFm2qYNzcZJIZnTcs+9rXjIc8uyrsa6jIsuAdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyWhwAymU0nKoQVuUnHPlQN2I330EDerJKdesGSn9+jHKsMQEwzZWO0A2mBz+zW2A
         Hfjl+q8SAkDnzOz0FbLhxqTd/oor5qRzjZdXG9AFSlNfnh+YrqQXSsT7aMMpD6KPNx
         Hh+lxlna5VwL0Vi4g6paWk+X5Ek8NV3asac1ZYJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baoquan He <bhe@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0683/1001] s390/kfence: fix page fault reporting
Date:   Tue,  7 Mar 2023 17:57:35 +0100
Message-Id: <20230307170051.241741031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d9c2cf67b9cfd643ba85d51bc865a89a92e4f979 ]

Baoquan He reported lots of KFENCE reports when /proc/kcore is read,
e.g. with crash or even simpler with dd:

 BUG: KFENCE: invalid read in copy_from_kernel_nofault+0x5e/0x120
 Invalid read at 0x00000000f4f5149f:
  copy_from_kernel_nofault+0x5e/0x120
  read_kcore+0x6b2/0x870
  proc_reg_read+0x9a/0xf0
  vfs_read+0x94/0x270
  ksys_read+0x70/0x100
  __do_syscall+0x1d0/0x200
  system_call+0x82/0xb0

The reason for this is that read_kcore() simply reads memory that might
have been unmapped by KFENCE with copy_from_kernel_nofault(). Any fault due
to pages being unmapped by KFENCE would be handled gracefully by the fault
handler (exception table fixup).

However the s390 fault handler first reports the fault, and only afterwards
would perform the exception table fixup. Most architectures have this in
reversed order, which also avoids the false positive KFENCE reports when an
unmapped page is accessed.

Therefore change the s390 fault handler so it handles exception table
fixups before KFENCE page faults are reported.

Reported-by: Baoquan He <bhe@redhat.com>
Tested-by: Baoquan He <bhe@redhat.com>
Acked-by: Alexander Potapenko <glider@google.com>
Link: https://lore.kernel.org/r/20230213183858.1473681-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 49 +++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 9649d9382e0ae..8e84ed2bb944e 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -96,6 +96,20 @@ static enum fault_type get_fault_type(struct pt_regs *regs)
 	return KERNEL_FAULT;
 }
 
+static unsigned long get_fault_address(struct pt_regs *regs)
+{
+	unsigned long trans_exc_code = regs->int_parm_long;
+
+	return trans_exc_code & __FAIL_ADDR_MASK;
+}
+
+static bool fault_is_write(struct pt_regs *regs)
+{
+	unsigned long trans_exc_code = regs->int_parm_long;
+
+	return (trans_exc_code & store_indication) == 0x400;
+}
+
 static int bad_address(void *p)
 {
 	unsigned long dummy;
@@ -228,15 +242,26 @@ static noinline void do_sigsegv(struct pt_regs *regs, int si_code)
 			(void __user *)(regs->int_parm_long & __FAIL_ADDR_MASK));
 }
 
-static noinline void do_no_context(struct pt_regs *regs)
+static noinline void do_no_context(struct pt_regs *regs, vm_fault_t fault)
 {
+	enum fault_type fault_type;
+	unsigned long address;
+	bool is_write;
+
 	if (fixup_exception(regs))
 		return;
+	fault_type = get_fault_type(regs);
+	if ((fault_type == KERNEL_FAULT) && (fault == VM_FAULT_BADCONTEXT)) {
+		address = get_fault_address(regs);
+		is_write = fault_is_write(regs);
+		if (kfence_handle_page_fault(address, is_write, regs))
+			return;
+	}
 	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice.
 	 */
-	if (get_fault_type(regs) == KERNEL_FAULT)
+	if (fault_type == KERNEL_FAULT)
 		printk(KERN_ALERT "Unable to handle kernel pointer dereference"
 		       " in virtual kernel address space\n");
 	else
@@ -255,7 +280,7 @@ static noinline void do_low_address(struct pt_regs *regs)
 		die (regs, "Low-address protection");
 	}
 
-	do_no_context(regs);
+	do_no_context(regs, VM_FAULT_BADACCESS);
 }
 
 static noinline void do_sigbus(struct pt_regs *regs)
@@ -286,28 +311,28 @@ static noinline void do_fault_error(struct pt_regs *regs, vm_fault_t fault)
 		fallthrough;
 	case VM_FAULT_BADCONTEXT:
 	case VM_FAULT_PFAULT:
-		do_no_context(regs);
+		do_no_context(regs, fault);
 		break;
 	case VM_FAULT_SIGNAL:
 		if (!user_mode(regs))
-			do_no_context(regs);
+			do_no_context(regs, fault);
 		break;
 	default: /* fault & VM_FAULT_ERROR */
 		if (fault & VM_FAULT_OOM) {
 			if (!user_mode(regs))
-				do_no_context(regs);
+				do_no_context(regs, fault);
 			else
 				pagefault_out_of_memory();
 		} else if (fault & VM_FAULT_SIGSEGV) {
 			/* Kernel mode? Handle exceptions or die */
 			if (!user_mode(regs))
-				do_no_context(regs);
+				do_no_context(regs, fault);
 			else
 				do_sigsegv(regs, SEGV_MAPERR);
 		} else if (fault & VM_FAULT_SIGBUS) {
 			/* Kernel mode? Handle exceptions or die */
 			if (!user_mode(regs))
-				do_no_context(regs);
+				do_no_context(regs, fault);
 			else
 				do_sigbus(regs);
 		} else
@@ -334,7 +359,6 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum fault_type type;
-	unsigned long trans_exc_code;
 	unsigned long address;
 	unsigned int flags;
 	vm_fault_t fault;
@@ -351,9 +375,8 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 		return 0;
 
 	mm = tsk->mm;
-	trans_exc_code = regs->int_parm_long;
-	address = trans_exc_code & __FAIL_ADDR_MASK;
-	is_write = (trans_exc_code & store_indication) == 0x400;
+	address = get_fault_address(regs);
+	is_write = fault_is_write(regs);
 
 	/*
 	 * Verify that the fault happened in user space, that
@@ -364,8 +387,6 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	type = get_fault_type(regs);
 	switch (type) {
 	case KERNEL_FAULT:
-		if (kfence_handle_page_fault(address, is_write, regs))
-			return 0;
 		goto out;
 	case USER_FAULT:
 	case GMAP_FAULT:
-- 
2.39.2



