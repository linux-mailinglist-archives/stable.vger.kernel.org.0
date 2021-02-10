Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB9316D35
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhBJRr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:47:59 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33188 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhBJRrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 12:47:31 -0500
Date:   Wed, 10 Feb 2021 17:45:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612979157;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=newQk4QZWZs5sOpaNHe8ulmPWEeiE+1KGZAGfvZ62Og=;
        b=4nF+wdQhQmAIJZ0v/9ZC1UVi/Yoh0vwpyPI4U6v8aj/Ez0xnR7TBNIr1ycXjTuw83wEVyv
        wFnEbKJ3F6HQll5v6OLQHkrGWVFL8Kj0mO0cZRmVdWFoxjOfMJoCoBAf1XkpKVmK4cD239
        pi8H0DpjWfqp48DpSB4tLv0+NGct4bSUUf6YOXpSEHAMkgldRwFyCV5wmIhT3eolipiJBd
        dWVqg5aRKFWcGDk6N1WOwF1u2xKGLWsQdNXaOQ5DkzM6lwMZAn5WBwnwFCeXdDIySUb+EO
        gV9WpOpn/YqXQobxDKmVRR+w641kayWEPwMi0esxH/8pFxEnjipK+umPze+gDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612979157;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=newQk4QZWZs5sOpaNHe8ulmPWEeiE+1KGZAGfvZ62Og=;
        b=1sDk4fV5kevx94s4OpMGHega9r00RHH+x6W/0pMcPkJwomRWS7J1+w5JEPlGTLicAJO2NM
        dI5dUxDjjKvvDvDQ==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/mm] x86/fault: Fix AMD erratum #91 errata fixup for user code
Cc:     Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <b91f7f92f3367d2d3a88eec3b09c6aab1b2dc8ef.1612924255.git.luto@kernel.org>
References: <b91f7f92f3367d2d3a88eec3b09c6aab1b2dc8ef.1612924255.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <161297915681.23325.3596910072184499475.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/mm branch of tip:

Commit-ID:     35f1c89b0cce247bf0213df243ed902989b1dcda
Gitweb:        https://git.kernel.org/tip/35f1c89b0cce247bf0213df243ed902989b1dcda
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Tue, 09 Feb 2021 18:33:33 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 10 Feb 2021 13:11:41 +01:00

x86/fault: Fix AMD erratum #91 errata fixup for user code

The recent rework of probe_kernel_address() and its conversion to
get_kernel_nofault() inadvertently broke is_prefetch(). Before this
change, probe_kernel_address() was used as a sloppy "read user or
kernel memory" helper, but it doesn't do that any more. The new
get_kernel_nofault() reads *kernel* memory only, which completely broke
is_prefetch() for user access.

Adjust the code to the correct accessor based on access mode. The
manual address bounds check is no longer necessary, since the accessor
helpers (get_user() / get_kernel_nofault()) do the right thing all by
themselves. As a bonus, by using the correct accessor, the open-coded
address bounds check is not needed anymore.

 [ bp: Massage commit message. ]

Fixes: eab0c6089b68 ("maccess: unify the probe kernel arch hooks")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/b91f7f92f3367d2d3a88eec3b09c6aab1b2dc8ef.1612924255.git.luto@kernel.org
---
 arch/x86/mm/fault.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f1f1b5a..441c3e9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
  * 32-bit mode:
  *
  *   Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
- *   Check that here and ignore it.
+ *   Check that here and ignore it.  This is AMD erratum #91.
  *
  * 64-bit mode:
  *
@@ -83,11 +83,7 @@ check_prefetch_opcode(struct pt_regs *regs, unsigned char *instr,
 #ifdef CONFIG_X86_64
 	case 0x40:
 		/*
-		 * In AMD64 long mode 0x40..0x4F are valid REX prefixes
-		 * Need to figure out under what instruction mode the
-		 * instruction was issued. Could check the LDT for lm,
-		 * but for now it's good enough to assume that long
-		 * mode only uses well known segments or kernel.
+		 * In 64-bit mode 0x40..0x4F are valid REX prefixes
 		 */
 		return (!user_mode(regs) || user_64bit_mode(regs));
 #endif
@@ -127,20 +123,31 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
 	instr = (void *)convert_ip_to_linear(current, regs);
 	max_instr = instr + 15;
 
-	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE_MAX)
-		return 0;
+	/*
+	 * This code has historically always bailed out if IP points to a
+	 * not-present page (e.g. due to a race).  No one has ever
+	 * complained about this.
+	 */
+	pagefault_disable();
 
 	while (instr < max_instr) {
 		unsigned char opcode;
 
-		if (get_kernel_nofault(opcode, instr))
-			break;
+		if (user_mode(regs)) {
+			if (get_user(opcode, instr))
+				break;
+		} else {
+			if (get_kernel_nofault(opcode, instr))
+				break;
+		}
 
 		instr++;
 
 		if (!check_prefetch_opcode(regs, instr, opcode, &prefetch))
 			break;
 	}
+
+	pagefault_enable();
 	return prefetch;
 }
 
