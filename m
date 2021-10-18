Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75EB431CBF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhJRNoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233363AbhJRNmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D2F861439;
        Mon, 18 Oct 2021 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564056;
        bh=tKdSaJ4ky4rkcucRDq96qoY0E2exYgCClISb3PmPDUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7biSQsIXLf2t8nmBx1dD3GDvFFGcxKdjgRKsks1SzPGZj47WCZfF1NCiudXUiCJb
         wndu0J4MKBITHEGjS+sflkCEMh13CCH7GC+KosbacfrecipjKFhkq3liXAaCjJdm5V
         EMRqhcMN/KVPwBI7cvwOwqjkiAAw+uqORXCuERtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH 5.10 015/103] csky: dont let sigreturn play with priveleged bits of status register
Date:   Mon, 18 Oct 2021 15:23:51 +0200
Message-Id: <20211018132335.209394743@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit fbd63c08cdcca5fb1315aca3172b3c9c272cfb4f upstream.

csky restore_sigcontext() blindly overwrites regs->sr with the value
it finds in sigcontext.  Attacker can store whatever they want in there,
which includes things like S-bit.  Userland shouldn't be able to set
that, or anything other than C flag (bit 0).

Do the same thing other architectures with protected bits in flags
register do - preserve everything that shouldn't be settable in
user mode, picking the rest from the value saved is sigcontext.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/csky/kernel/signal.c
+++ b/arch/csky/kernel/signal.c
@@ -52,10 +52,14 @@ static long restore_sigcontext(struct pt
 	struct sigcontext __user *sc)
 {
 	int err = 0;
+	unsigned long sr = regs->sr;
 
 	/* sc_pt_regs is structured the same as the start of pt_regs */
 	err |= __copy_from_user(regs, &sc->sc_pt_regs, sizeof(struct pt_regs));
 
+	/* BIT(0) of regs->sr is Condition Code/Carry bit */
+	regs->sr = (sr & ~1) | (regs->sr & 1);
+
 	/* Restore the floating-point state. */
 	err |= restore_fpu_state(sc);
 


