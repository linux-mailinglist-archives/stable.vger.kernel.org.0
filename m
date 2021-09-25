Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E106417FCF
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 07:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhIYFSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 01:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhIYFSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 01:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397BA610EA;
        Sat, 25 Sep 2021 05:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632547024;
        bh=2nPifVqIq6xS4+2b04wivl+7zS28QpMII0hRXZFD2mY=;
        h=From:To:Cc:Subject:Date:From;
        b=g4YMFKDHiF+PrrXeO5hAycwq2NaxJTJurEYEuJ8lQhnX0cz2u6l1N9WP5wQjU8AC1
         VQ3djwfvCaXIXTZ03flbeV2LOUru5CcfjujHyvyf9XqzOb593IVo3Nhp5hMdvPOmKs
         ngTQPB8BUaHYJWlYcd8e360fKhT3QIVPXAItFgfz6D3lMOe8Q7rYuNBsFzzMguv6TF
         n7jQttUZIn3iXi34QrQD302sKq/MfAi0ad6ZPykp/xJuyo49ixyNuo0VGcn1h0hXk1
         zgBdT3tUE9RoUePTJSxC24bU9TF6v2GIdiitCiRMdiqRcH86qzfgmNLifP2qTawN8u
         bawatllA3YVzQ==
From:   guoren@kernel.org
To:     guoren@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH V2 1/2] csky: don't let sigreturn play with priveleged bits of status register
Date:   Sat, 25 Sep 2021 13:16:46 +0800
Message-Id: <20210925051647.1162829-1-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

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
---
 arch/csky/kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/csky/kernel/signal.c b/arch/csky/kernel/signal.c
index 312f046d452d..6ba3969ec175 100644
--- a/arch/csky/kernel/signal.c
+++ b/arch/csky/kernel/signal.c
@@ -52,10 +52,14 @@ static long restore_sigcontext(struct pt_regs *regs,
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
 
-- 
2.25.1

