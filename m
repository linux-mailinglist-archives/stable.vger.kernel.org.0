Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741A810BBDA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfK0VOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732454AbfK0VOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:14:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840DC2176D;
        Wed, 27 Nov 2019 21:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889274;
        bh=LHQ1OkJDYI81o3N36y48xQv1xUq5HJATWqh6lea2GhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6FJwSNHNp+xzwgPSptMTTv8zwgcCL//kHvunrADTz89nNhtiKc7OyE2dqMVrrjW/
         XaY9Y+k1leWx48L023DZLvAJl6LqnKzTeyrwpfUPnah9JPle9S2FLMUyLluzGgVy39
         IsJn1Vo70rf0Wc/g/l5wfLbJXJoLrErfv0TAcVvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 14/66] x86/xen/32: Make xen_iret_crit_fixup() independent of frame layout
Date:   Wed, 27 Nov 2019 21:32:09 +0100
Message-Id: <20191127202649.493713710@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 29b810f5a5ec127d3143770098e05981baa3eb77 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |   22 +++++---------
 arch/x86/xen/xen-asm_32.S |   70 +++++++++++++++++-----------------------------
 2 files changed, 35 insertions(+), 57 deletions(-)

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
-
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
-
+	movl 4*4(%esp), %eax		/* load outer EAX */
+	ret $4*4			/* discard nested EIP, CS, and EFLAGS as
+					 * well as the just restored EAX */
+
+1:
+	ret $3*4			/* discard nested EIP, CS, and EFLAGS */
+
+2:
+	ret
+END(xen_iret_crit_fixup)


