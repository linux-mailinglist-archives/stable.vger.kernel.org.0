Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3D1102DE2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKSVCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 16:02:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54581 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfKSVCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 16:02:07 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iXAdI-0003Cu-Uw; Tue, 19 Nov 2019 22:01:57 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 9E2EA1C19F3;
        Tue, 19 Nov 2019 22:01:56 +0100 (CET)
Date:   Tue, 19 Nov 2019 21:01:56 -0000
From:   "tip-bot2 for Jan Beulich" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/xen/32: Make xen_iret_crit_fixup() independent
 of frame layout
Cc:     Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        Stable Team <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <32d8713d-25a7-84ab-b74b-aa3e88abce6b@suse.com>
References: <32d8713d-25a7-84ab-b74b-aa3e88abce6b@suse.com>
MIME-Version: 1.0
Message-ID: <157419731656.12247.16875129077517271756.tip-bot2@tip-bot2>
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

Commit-ID:     29b810f5a5ec127d3143770098e05981baa3eb77
Gitweb:        https://git.kernel.org/tip/29b810f5a5ec127d3143770098e05981baa3eb77
Author:        Jan Beulich <jbeulich@suse.com>
AuthorDate:    Mon, 11 Nov 2019 15:32:12 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 19 Nov 2019 21:58:28 +01:00

x86/xen/32: Make xen_iret_crit_fixup() independent of frame layout

Now that SS:ESP always get saved by SAVE_ALL, this also needs to be
accounted for in xen_iret_crit_fixup(). Otherwise the old_ax value gets
interpreted as EFLAGS, and hence VM86 mode appears to be active all the
time, leading to random "vm86_32: no user_vm86: BAD" log messages alongside
processes randomly crashing.

Since following the previous model (sitting after SAVE_ALL) would further
complicate the code _and_ retain the dependency of xen_iret_crit_fixup() on
frame manipulations done by entry_32.S, switch things around and do the
adjustment ahead of SAVE_ALL.

Fixes: 3c88c692c287 ("x86/stackframe/32: Provide consistent pt_regs")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Stable Team <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/32d8713d-25a7-84ab-b74b-aa3e88abce6b@suse.com


---
 arch/x86/entry/entry_32.S | 22 +++++--------
 arch/x86/xen/xen-asm_32.S | 66 +++++++++++++-------------------------
 2 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 3f847d8..019dbac 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1341,11 +1341,6 @@ END(spurious_interrupt_bug)
 
 #ifdef CONFIG_XEN_PV
 ENTRY(xen_hypervisor_callback)
-	pushl	$-1				/* orig_ax = -1 => not a system call */
-	SAVE_ALL
-	ENCODE_FRAME_POINTER
-	TRACE_IRQS_OFF
-
 	/*
 	 * Check to see if we got the event in the critical
 	 * region in xen_iret_direct, after we've reenabled
@@ -1353,16 +1348,17 @@ ENTRY(xen_hypervisor_callback)
 	 * iret instruction's behaviour where it delivers a
 	 * pending interrupt when enabling interrupts:
 	 */
-	movl	PT_EIP(%esp), %eax
-	cmpl	$xen_iret_start_crit, %eax
+	cmpl	$xen_iret_start_crit, (%esp)
 	jb	1f
-	cmpl	$xen_iret_end_crit, %eax
+	cmpl	$xen_iret_end_crit, (%esp)
 	jae	1f
-
-	jmp	xen_iret_crit_fixup
-
-ENTRY(xen_do_upcall)
-1:	mov	%esp, %eax
+	call	xen_iret_crit_fixup
+1:
+	pushl	$-1				/* orig_ax = -1 => not a system call */
+	SAVE_ALL
+	ENCODE_FRAME_POINTER
+	TRACE_IRQS_OFF
+	mov	%esp, %eax
 	call	xen_evtchn_do_upcall
 #ifndef CONFIG_PREEMPTION
 	call	xen_maybe_preempt_hcall
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index c15db06..392e033 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -126,10 +126,9 @@ hyper_iret:
 	.globl xen_iret_start_crit, xen_iret_end_crit
 
 /*
- * This is called by xen_hypervisor_callback in entry.S when it sees
+ * This is called by xen_hypervisor_callback in entry_32.S when it sees
  * that the EIP at the time of interrupt was between
- * xen_iret_start_crit and xen_iret_end_crit.  We're passed the EIP in
- * %eax so we can do a more refined determination of what to do.
+ * xen_iret_start_crit and xen_iret_end_crit.
  *
  * The stack format at this point is:
  *	----------------
@@ -138,34 +137,23 @@ hyper_iret:
  *	 eflags		}  outer exception info
  *	 cs		}
  *	 eip		}
- *	---------------- <- edi (copy dest)
- *	 eax		:  outer eax if it hasn't been restored
  *	----------------
- *	 eflags		}  nested exception info
- *	 cs		}   (no ss/esp because we're nested
- *	 eip		}    from the same ring)
- *	 orig_eax	}<- esi (copy src)
- *	 - - - - - - - -
- *	 fs		}
- *	 es		}
- *	 ds		}  SAVE_ALL state
- *	 eax		}
- *	  :		:
- *	 ebx		}<- esp
+ *	 eax		:  outer eax if it hasn't been restored
  *	----------------
+ *	 eflags		}
+ *	 cs		}  nested exception info
+ *	 eip		}
+ *	 return address	: (into xen_hypervisor_callback)
  *
- * In order to deliver the nested exception properly, we need to shift
- * everything from the return addr up to the error code so it sits
- * just under the outer exception info.  This means that when we
- * handle the exception, we do it in the context of the outer
- * exception rather than starting a new one.
+ * In order to deliver the nested exception properly, we need to discard the
+ * nested exception frame such that when we handle the exception, we do it
+ * in the context of the outer exception rather than starting a new one.
  *
- * The only caveat is that if the outer eax hasn't been restored yet
- * (ie, it's still on stack), we need to insert its value into the
- * SAVE_ALL state before going on, since it's usermode state which we
- * eventually need to restore.
+ * The only caveat is that if the outer eax hasn't been restored yet (i.e.
+ * it's still on stack), we need to restore its value here.
  */
 ENTRY(xen_iret_crit_fixup)
+	pushl %ecx
 	/*
 	 * Paranoia: Make sure we're really coming from kernel space.
 	 * One could imagine a case where userspace jumps into the
@@ -176,32 +164,26 @@ ENTRY(xen_iret_crit_fixup)
 	 * jump instruction itself, not the destination, but some
 	 * virtual environments get this wrong.
 	 */
-	movl PT_CS(%esp), %ecx
+	movl 3*4(%esp), %ecx		/* nested CS */
 	andl $SEGMENT_RPL_MASK, %ecx
 	cmpl $USER_RPL, %ecx
+	popl %ecx
 	je 2f
 
-	lea PT_ORIG_EAX(%esp), %esi
-	lea PT_EFLAGS(%esp), %edi
-
 	/*
 	 * If eip is before iret_restore_end then stack
 	 * hasn't been restored yet.
 	 */
-	cmp $iret_restore_end, %eax
+	cmpl $iret_restore_end, 1*4(%esp)
 	jae 1f
 
-	movl 0+4(%edi), %eax		/* copy EAX (just above top of frame) */
-	movl %eax, PT_EAX(%esp)
+	movl 4*4(%esp), %eax		/* load outer EAX */
+	ret $4*4			/* discard nested EIP, CS, and EFLAGS as
+					 * well as the just restored EAX */
 
-	lea ESP_OFFSET(%edi), %edi	/* move dest up over saved regs */
-
-	/* set up the copy */
-1:	std
-	mov $PT_EIP / 4, %ecx		/* saved regs up to orig_eax */
-	rep movsl
-	cld
-
-	lea 4(%edi), %esp		/* point esp to new frame */
-2:	jmp xen_do_upcall
+1:
+	ret $3*4			/* discard nested EIP, CS, and EFLAGS */
 
+2:
+	ret
+END(xen_iret_crit_fixup)
