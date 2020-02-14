Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09715EEFA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389486AbgBNQCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389086AbgBNQCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D39A217F4;
        Fri, 14 Feb 2020 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696173;
        bh=rya72cDI956HviiwG0v5mNpwy6n2E3LyPKsA3FCHJ8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DvhycjqY6fnViB8cgJmSGwVNMVCeVWW5XEmiARMdBjERzGznckfgJZG3lcXhF2O6
         EciWi0muadYSsBEluPxAOlxaeAcbH/lS9VCyK1XADlEhMyQPUXnwoHzCxSvRjnr5Ua
         tusAImhO5NqfLTcVUP20d+R6ToTx5yLRE2pKyb1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Rik van Riel <riel@surriel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 046/459] x86/fpu: Deactivate FPU state after failure during state load
Date:   Fri, 14 Feb 2020 10:54:56 -0500
Message-Id: <20200214160149.11681-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit bbc55341b9c67645d1a5471506370caf7dd4a203 ]

In __fpu__restore_sig(), fpu_fpregs_owner_ctx needs to be reset if the
FPU state was not fully restored. Otherwise the following may happen (on
the same CPU):

  Task A                     Task B               fpu_fpregs_owner_ctx
  *active*                                        A.fpu
  __fpu__restore_sig()
                             ctx switch           load B.fpu
                             *active*             B.fpu
  fpregs_lock()
  copy_user_to_fpregs_zeroing()
    copy_kernel_to_xregs() *modify*
    copy_user_to_xregs() *fails*
  fpregs_unlock()
                            ctx switch            skip loading B.fpu,
                            *active*              B.fpu

In the success case, fpu_fpregs_owner_ctx is set to the current task.

In the failure case, the FPU state might have been modified by loading
the init state.

In this case, fpu_fpregs_owner_ctx needs to be reset in order to ensure
that the FPU state of the following task is loaded from saved state (and
not skipped because it was the previous state).

Reset fpu_fpregs_owner_ctx after a failure during restore occurred, to
ensure that the FPU state for the next task is always loaded.

The problem was debugged-by Yu-cheng Yu <yu-cheng.yu@intel.com>.

 [ bp: Massage commit message. ]

Fixes: 5f409e20b7945 ("x86/fpu: Defer FPU state load until return to userspace")
Reported-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191220195906.plk6kpmsrikvbcfn@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/signal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 0071b794ed193..400a05e1c1c51 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -352,6 +352,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			fpregs_unlock();
 			return 0;
 		}
+		fpregs_deactivate(fpu);
 		fpregs_unlock();
 	}
 
@@ -403,6 +404,8 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 	}
 	if (!ret)
 		fpregs_mark_activate();
+	else
+		fpregs_deactivate(fpu);
 	fpregs_unlock();
 
 err_out:
-- 
2.20.1

