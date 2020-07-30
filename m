Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A67232D7F
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgG3ILO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbgG3ILJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62532075F;
        Thu, 30 Jul 2020 08:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096668;
        bh=4PIK3txsItU6RK1rxjj0QPH/Qr9nof33HTpuGYpGiww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4qL2SeVrrQjgqrobKIx2L6PkMDNXFHn1nejXdAy2JlGWMFUhyvPvOdb9loS6/Bh1
         nyZRHGEQMza2G21/o47R0VrQQJJ7fjxo+gOMb1E9JeT2syu2FfOwZrzFaWl9UGTodO
         Dj89ZBrHOJMiEANmXA6dmxN5iHRy5sYZgmVljLzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/54] x86/fpu: Disable bottom halves while loading FPU registers
Date:   Thu, 30 Jul 2020 10:04:54 +0200
Message-Id: <20200730074421.942105266@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 68239654acafe6aad5a3c1dc7237e60accfebc03 ]

The sequence

  fpu->initialized = 1;		/* step A */
  preempt_disable();		/* step B */
  fpu__restore(fpu);
  preempt_enable();

in __fpu__restore_sig() is racy in regard to a context switch.

For 32bit frames, __fpu__restore_sig() prepares the FPU state within
fpu->state. To ensure that a context switch (switch_fpu_prepare() in
particular) does not modify fpu->state it uses fpu__drop() which sets
fpu->initialized to 0.

After fpu->initialized is cleared, the CPU's FPU state is not saved
to fpu->state during a context switch. The new state is loaded via
fpu__restore(). It gets loaded into fpu->state from userland and
ensured it is sane. fpu->initialized is then set to 1 in order to avoid
fpu__initialize() doing anything (overwrite the new state) which is part
of fpu__restore().

A context switch between step A and B above would save CPU's current FPU
registers to fpu->state and overwrite the newly prepared state. This
looks like a tiny race window but the Kernel Test Robot reported this
back in 2016 while we had lazy FPU support. Borislav Petkov made the
link between that report and another patch that has been posted. Since
the removal of the lazy FPU support, this race goes unnoticed because
the warning has been removed.

Disable bottom halves around the restore sequence to avoid the race. BH
need to be disabled because BH is allowed to run (even with preemption
disabled) and might invoke kernel_fpu_begin() by doing IPsec.

 [ bp: massage commit message a bit. ]

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kvm ML <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Cc: x86-ml <x86@kernel.org>
Link: http://lkml.kernel.org/r/20181120102635.ddv3fvavxajjlfqk@linutronix.de
Link: https://lkml.kernel.org/r/20160226074940.GA28911@pd.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/signal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 31fad2cbd734b..8fc842dae3b39 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -317,10 +317,10 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			sanitize_restored_xstate(tsk, &env, xfeatures, fx_only);
 		}
 
+		local_bh_disable();
 		fpu->fpstate_active = 1;
-		preempt_disable();
 		fpu__restore(fpu);
-		preempt_enable();
+		local_bh_enable();
 
 		return err;
 	} else {
-- 
2.25.1



