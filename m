Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CA23B0E03
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 22:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhFVUFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 16:05:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60070 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhFVUFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 16:05:21 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624392183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kWNqlp3mLshPgoUIhLKTrHadasQj28TXnMWf/enRenE=;
        b=yRANQKPv0g2ljSHJ53f4KliQgRkLJyIc/a1YzROZm5CXd6TmBdLfVVhEO3yn+YbuKpRNsh
        UGDplhyzms9/kv+BkN6lHLbAE3kl9Ooq1qVo1mBK30CmUvRSs/MfWsr4u8GoT0OvEyePWX
        LeHat93Wi3H3mdppSgqJD8BUBp6yQMHvNce5h97/Bn//PkoYAYpRw22Jkr9FEckaCR01dB
        mKQ1Z4qlQt8oOHTCldVPiZoIx9Uod14qD6dvCV2YECX+QZUPEOj+p+swwjFr3o+nVH7XCw
        1hyxdNTgHkOLWWoaJpPYplc2/E0ui5F5eAErYQua2tcWAMoxfadYjjno8hrlxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624392183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kWNqlp3mLshPgoUIhLKTrHadasQj28TXnMWf/enRenE=;
        b=XMdB0Yek5KgIMWul9MMVUXYP3lU6ngaZfiuznqujaGYu4Zxnq6T1NIMhvwbayqhZNrbB6I
        CHJ9Qq/g7SvEQMBg==
To:     Greg KH <gregkh@linuxfoundation.org>, Borislav Petkov <bp@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal restore failures" failed to apply to 4.4-stable tree
In-Reply-To: <YNG4q++kHwWtVupg@kroah.com>
References: <162427273275124@kroah.com> <YNDQHgGztJAWO2H+@zn.tnic> <YNG4q++kHwWtVupg@kroah.com>
Date:   Tue, 22 Jun 2021 22:03:03 +0200
Message-ID: <878s31ekg8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22 2021 at 12:17, Greg KH wrote:

> On Mon, Jun 21, 2021 at 07:45:02PM +0200, Borislav Petkov wrote:
>> On Mon, Jun 21, 2021 at 12:52:12PM +0200, gregkh@linuxfoundation.org wrote:
>> > 
>> > The patch below does not apply to the 4.4-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> 
>> Ok, how's this below?
>> 
>> It should at least capture the gist of what this commit is trying to
>> achieve as the FPU mess has changed substantially since 4.4 so I'm
>> really cautious here not to break any existing setups.
>> 
>> I've boot-tested this in a VM but Greg, I'd appreciate running it
>> through some sort of stable testing framework if you're using one.
>
> This applied to 4.4.y and 4.9.y, but we still need a 4.14.y and 4.19.y
> version if at all possible.

Everything is possible :)

---
Subject: x86/fpu: Reset state for all signal restore failures
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed Jun  9 21:18:00 2021 +0200

From: Thomas Gleixner <tglx@linutronix.de>

commit efa165504943f2128d50f63de0c02faf6dcceb0d upstream

If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
function just returns but does not clear the FPU state as it does for all
other fatal failures.

Clear the FPU state for these failures as well.

Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de

---
 arch/x86/kernel/fpu/signal.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)
---
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -281,15 +281,21 @@ static int __fpu__restore_sig(void __use
 		return 0;
 	}
 
-	if (!access_ok(VERIFY_READ, buf, size))
-		return -EACCES;
+	if (!access_ok(VERIFY_READ, buf, size)) {
+		ret = -EACCES;
+		goto out_err;
+	}
 
 	fpu__initialize(fpu);
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		ret = fpregs_soft_set(current, NULL,
+				      0, sizeof(struct user_i387_ia32_struct),
+				      NULL, buf) != 0;
+		if (ret)
+			goto out_err;
+		return 0;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
@@ -349,6 +355,7 @@ static int __fpu__restore_sig(void __use
 		fpu__restore(fpu);
 		local_bh_enable();
 
+		/* Failure is already handled */
 		return err;
 	} else {
 		/*
@@ -356,13 +363,14 @@ static int __fpu__restore_sig(void __use
 		 * state to the registers directly (with exceptions handled).
 		 */
 		user_fpu_begin();
-		if (copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only)) {
-			fpu__clear(fpu);
-			return -1;
-		}
+		if (!copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only))
+			return 0;
+		ret = -1;
 	}
 
-	return 0;
+out_err:
+	fpu__clear(fpu);
+	return ret;
 }
 
 static inline int xstate_sigframe_size(void)
