Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA0200BE2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgFSOjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387968AbgFSOjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C762070A;
        Fri, 19 Jun 2020 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577543;
        bh=xgCu3WtvZsZ1pBuh68rAkgwUoDM9qwBDw56mAhtC16Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrL2umlirUYS3T8QPpdNDuAnBMv0b97lDdI/niQgQcYlTeV9g2+jsJFCk6yWCuBvn
         kFDJuiGoJz8972P4t7H8bmh6YVkEDUVkuNh+Qq+OZXenIX0Ber2qoPwqw928/AMv5h
         JtVEfBktCIOTVWiJofFnR88OfQuLd5cb9z6Fatpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.4 092/101] sparc32: fix register window handling in genregs32_[gs]et()
Date:   Fri, 19 Jun 2020 16:33:21 +0200
Message-Id: <20200619141618.786511043@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit cf51e129b96847f969bfb8af1ee1516a01a70b39 upstream.

It needs access_process_vm() if the traced process does not share
mm with the caller.  Solution is similar to what sparc64 does.
Note that genregs32_set() is only ever called with pos being 0
or 32 * sizeof(u32) (the latter - as part of PTRACE_SETREGS
handling).

Cc: stable@kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/kernel/ptrace_32.c |  230 ++++++++++++++++++------------------------
 1 file changed, 99 insertions(+), 131 deletions(-)

--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -45,82 +45,79 @@ enum sparc_regset {
 	REGSET_FP,
 };
 
+static int regwindow32_get(struct task_struct *target,
+			   const struct pt_regs *regs,
+			   u32 *uregs)
+{
+	unsigned long reg_window = regs->u_regs[UREG_I6];
+	int size = 16 * sizeof(u32);
+
+	if (target == current) {
+		if (copy_from_user(uregs, (void __user *)reg_window, size))
+			return -EFAULT;
+	} else {
+		if (access_process_vm(target, reg_window, uregs, size,
+				      FOLL_FORCE) != size)
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int regwindow32_set(struct task_struct *target,
+			   const struct pt_regs *regs,
+			   u32 *uregs)
+{
+	unsigned long reg_window = regs->u_regs[UREG_I6];
+	int size = 16 * sizeof(u32);
+
+	if (target == current) {
+		if (copy_to_user((void __user *)reg_window, uregs, size))
+			return -EFAULT;
+	} else {
+		if (access_process_vm(target, reg_window, uregs, size,
+				      FOLL_FORCE | FOLL_WRITE) != size)
+			return -EFAULT;
+	}
+	return 0;
+}
+
 static int genregs32_get(struct task_struct *target,
 			 const struct user_regset *regset,
 			 unsigned int pos, unsigned int count,
 			 void *kbuf, void __user *ubuf)
 {
 	const struct pt_regs *regs = target->thread.kregs;
-	unsigned long __user *reg_window;
-	unsigned long *k = kbuf;
-	unsigned long __user *u = ubuf;
-	unsigned long reg;
+	u32 uregs[16];
+	int ret;
 
 	if (target == current)
 		flush_user_windows();
 
-	pos /= sizeof(reg);
-	count /= sizeof(reg);
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs->u_regs,
+				  0, 16 * sizeof(u32));
+	if (ret || !count)
+		return ret;
 
-	if (kbuf) {
-		for (; count > 0 && pos < 16; count--)
-			*k++ = regs->u_regs[pos++];
-
-		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
-		reg_window -= 16;
-		for (; count > 0 && pos < 32; count--) {
-			if (get_user(*k++, &reg_window[pos++]))
-				return -EFAULT;
-		}
-	} else {
-		for (; count > 0 && pos < 16; count--) {
-			if (put_user(regs->u_regs[pos++], u++))
-				return -EFAULT;
-		}
-
-		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
-		reg_window -= 16;
-		for (; count > 0 && pos < 32; count--) {
-			if (get_user(reg, &reg_window[pos++]) ||
-			    put_user(reg, u++))
-				return -EFAULT;
-		}
-	}
-	while (count > 0) {
-		switch (pos) {
-		case 32: /* PSR */
-			reg = regs->psr;
-			break;
-		case 33: /* PC */
-			reg = regs->pc;
-			break;
-		case 34: /* NPC */
-			reg = regs->npc;
-			break;
-		case 35: /* Y */
-			reg = regs->y;
-			break;
-		case 36: /* WIM */
-		case 37: /* TBR */
-			reg = 0;
-			break;
-		default:
-			goto finish;
-		}
-
-		if (kbuf)
-			*k++ = reg;
-		else if (put_user(reg, u++))
+	if (pos < 32 * sizeof(u32)) {
+		if (regwindow32_get(target, regs, uregs))
 			return -EFAULT;
-		pos++;
-		count--;
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  uregs,
+					  16 * sizeof(u32), 32 * sizeof(u32));
+		if (ret || !count)
+			return ret;
 	}
-finish:
-	pos *= sizeof(reg);
-	count *= sizeof(reg);
 
-	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
-					38 * sizeof(reg), -1);
+	uregs[0] = regs->psr;
+	uregs[1] = regs->pc;
+	uregs[2] = regs->npc;
+	uregs[3] = regs->y;
+	uregs[4] = 0;	/* WIM */
+	uregs[5] = 0;	/* TBR */
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  uregs,
+				  32 * sizeof(u32), 38 * sizeof(u32));
 }
 
 static int genregs32_set(struct task_struct *target,
@@ -129,82 +126,53 @@ static int genregs32_set(struct task_str
 			 const void *kbuf, const void __user *ubuf)
 {
 	struct pt_regs *regs = target->thread.kregs;
-	unsigned long __user *reg_window;
-	const unsigned long *k = kbuf;
-	const unsigned long __user *u = ubuf;
-	unsigned long reg;
+	u32 uregs[16];
+	u32 psr;
+	int ret;
 
 	if (target == current)
 		flush_user_windows();
 
-	pos /= sizeof(reg);
-	count /= sizeof(reg);
-
-	if (kbuf) {
-		for (; count > 0 && pos < 16; count--)
-			regs->u_regs[pos++] = *k++;
-
-		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
-		reg_window -= 16;
-		for (; count > 0 && pos < 32; count--) {
-			if (put_user(*k++, &reg_window[pos++]))
-				return -EFAULT;
-		}
-	} else {
-		for (; count > 0 && pos < 16; count--) {
-			if (get_user(reg, u++))
-				return -EFAULT;
-			regs->u_regs[pos++] = reg;
-		}
-
-		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
-		reg_window -= 16;
-		for (; count > 0 && pos < 32; count--) {
-			if (get_user(reg, u++) ||
-			    put_user(reg, &reg_window[pos++]))
-				return -EFAULT;
-		}
-	}
-	while (count > 0) {
-		unsigned long psr;
-
-		if (kbuf)
-			reg = *k++;
-		else if (get_user(reg, u++))
-			return -EFAULT;
-
-		switch (pos) {
-		case 32: /* PSR */
-			psr = regs->psr;
-			psr &= ~(PSR_ICC | PSR_SYSCALL);
-			psr |= (reg & (PSR_ICC | PSR_SYSCALL));
-			regs->psr = psr;
-			break;
-		case 33: /* PC */
-			regs->pc = reg;
-			break;
-		case 34: /* NPC */
-			regs->npc = reg;
-			break;
-		case 35: /* Y */
-			regs->y = reg;
-			break;
-		case 36: /* WIM */
-		case 37: /* TBR */
-			break;
-		default:
-			goto finish;
-		}
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 regs->u_regs,
+				 0, 16 * sizeof(u32));
+	if (ret || !count)
+		return ret;
 
-		pos++;
-		count--;
+	if (pos < 32 * sizeof(u32)) {
+		if (regwindow32_get(target, regs, uregs))
+			return -EFAULT;
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					 uregs,
+					 16 * sizeof(u32), 32 * sizeof(u32));
+		if (ret)
+			return ret;
+		if (regwindow32_set(target, regs, uregs))
+			return -EFAULT;
+		if (!count)
+			return 0;
 	}
-finish:
-	pos *= sizeof(reg);
-	count *= sizeof(reg);
-
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &psr,
+				 32 * sizeof(u32), 33 * sizeof(u32));
+	if (ret)
+		return ret;
+	regs->psr = (regs->psr & ~(PSR_ICC | PSR_SYSCALL)) |
+		    (psr & (PSR_ICC | PSR_SYSCALL));
+	if (!count)
+		return 0;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->pc,
+				 33 * sizeof(u32), 34 * sizeof(u32));
+	if (ret || !count)
+		return ret;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->y,
+				 34 * sizeof(u32), 35 * sizeof(u32));
+	if (ret || !count)
+		return ret;
 	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 38 * sizeof(reg), -1);
+					 35 * sizeof(u32), 38 * sizeof(u32));
 }
 
 static int fpregs32_get(struct task_struct *target,


