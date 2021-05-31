Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D723969C7
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 00:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhEaWsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 18:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbhEaWsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 18:48:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E29C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 15:46:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622501206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=vdWugfCVaCa8FN1pCfo+3u7jINL6vcDVB1whXhb5oM8=;
        b=l5cW2fujMnnm4wp/dUrnaNVtrnbBCFgI7lDIgsLZQhayU9qfCdzUzsuxSUQY5f9lZYq9RM
        DrcRr7/87I4bHClBHR/yhAIPuYYNLJuULDMooE6s05ptHzh8xwXbZJ8+qXdIAbNz4C3Sl5
        sHPWwy00JfHbQWzvHNTmLGPOp6FAK3NyCcemFJ6yH5rTWn425BZc5XEGApQAmwMzQSNo9h
        qqieWgQr37iu69D+ntawnAMH8/ycyfaSmHu25nOigaPYqaXvY43BDgvuPPdoY6xGqlyjxV
        6VkjWfSxjAmc3BKYtZFezZtSd+8x9edHVziAGrfdxuAhXQTe9uNpCI9rGfWCJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622501206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=vdWugfCVaCa8FN1pCfo+3u7jINL6vcDVB1whXhb5oM8=;
        b=/OWbTl4QCyIATnQWCMouOg98e8Men7GGRuhdhhqZ8+kwSYDJZHMIKB8rqNB2Imdv15loH8
        iwksBIwTRxeou0DA==
To:     Andy Lutomirski <luto@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <71af931b-4328-44b9-8b03-7c155ee8b2d2@www.fastmail.com>
Date:   Tue, 01 Jun 2021 00:46:45 +0200
Message-ID: <878s3u34iy.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31 2021 at 12:30, Andy Lutomirski wrote:
> On Mon, May 31, 2021, at 11:56 AM, Thomas Gleixner wrote:
>> And of course there is:
>>=20
>> __fpu__restore_sig()
>>=20
>> 	if (!buf) {
>>                 fpu__clear_user_states(fpu);
>>                 return 0;
>>         }
>>=20
>> and
>>=20
>> handle_signal()
>>=20
>>    if (!failed)
>>       fpu__clear_user_states(fpu);
>
> This looks okay.

Looks okay is meh... That other stuff obviously looked okay as well...

That FPU code is an unpenetrable mess.

> Really there are two callers of fpu__clear_all() that are special:
>
> execve: Just in case some part of the xstate buffer mode that=E2=80=99s
> supposed to be invariant got corrupted or in case there is some side
> channel that can leak the INIT-but-not-zeroed contents of a state to
> user code, we should really wipe the memory completely across
> privilege boundaries.
>
> __fpu__restore_sig: the utterly daft copy from user space needs
> special recovery.
>
> Maybe the right solution is to rename it. Instead of fpu__clear_all(),
> how about fpu__wipe_and_reset()?

The right solution is to just use copy_user_to_xstate() unconditionally.

That fixes the issue even without cleaning up that fpu_clear() mess
which we want to do nevertheless.

I have a similar fix for the related xstateregs_set() trainwreck, but
that really needs to allocate a buffer because it's operating on a
different task contrary to signal handling.

I'm too tired now to test the xstateregs_set() muck, but if you want to
have a look:

     https://tglx.de/~tglx/patches.tar

Thanks,

        tglx
---
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -112,8 +112,4 @@ void copy_supervisor_to_kernel(struct xr
 void copy_dynamic_supervisor_to_kernel(struct xregs_state *xstate, u64 mas=
k);
 void copy_kernel_to_dynamic_supervisor(struct xregs_state *xstate, u64 mas=
k);
=20
-
-/* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
-int validate_user_xstate_header(const struct xstate_header *hdr);
-
 #endif
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -405,14 +405,7 @@ static int __fpu__restore_sig(void __use
 	if (use_xsave() && !fx_only) {
 		u64 init_bv =3D xfeatures_mask_user() & ~user_xfeatures;
=20
-		if (using_compacted_format()) {
-			ret =3D copy_user_to_xstate(&fpu->state.xsave, buf_fx);
-		} else {
-			ret =3D __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
-
-			if (!ret && state_size > offsetof(struct xregs_state, header))
-				ret =3D validate_user_xstate_header(&fpu->state.xsave.header);
-		}
+		ret =3D copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		if (ret)
 			goto err_out;
=20
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -515,7 +515,7 @@ int using_compacted_format(void)
 }
=20
 /* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
-int validate_user_xstate_header(const struct xstate_header *hdr)
+static int validate_user_xstate_header(const struct xstate_header *hdr)
 {
 	/* No unknown or supervisor features may be set */
 	if (hdr->xfeatures & ~xfeatures_mask_user())

