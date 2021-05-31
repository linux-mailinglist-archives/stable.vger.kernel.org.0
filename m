Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B11B39686F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhEaTt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:49:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhEaTt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 15:49:59 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622490498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LLe2c1ZBvpIJhsvuPGedcgNS8ULwbVHNGPlpy85UzmY=;
        b=KJbg+Rc+0oeGbpb9tqa3qVu8eJ2sfpEJlsBIL06U9cHOzTxPzkPsfxo7MIRPj7CPWiR5jF
        94VHpLBbw3LTVIa/50mKTIGEWDYUZcO4/WsEl14FfxqyjcWHjWQQBW5hkotAxYpd+ijqpJ
        KQWpfojSUBi8u6IlOyweo83AjKWY45VUDL2l9t6tSOQBU3S9DcnMHTxaFRKir0lvKkFCDu
        8qqauWtyDj3cdrOKq2iTvrCFfDo5p8bT9tp7t40x7zvnnfpGt+OzfW/AbqRuTxtpiagCSn
        ihcQ+g8LNt3NuB4BIKe9uB1Z8ECDt2NwNDRDlv6JwWMeCireFd0GItVkb6KPig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622490498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LLe2c1ZBvpIJhsvuPGedcgNS8ULwbVHNGPlpy85UzmY=;
        b=C6xhICs/MBF2JrlwdTIydSEkUbhK7T2/9dg4QICmmRiO/RKwye69TBS5P6lz8dQma20d6c
        FJ1+uv1Nwg/lHYAw==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <87fsy24tqt.ffs@nanos.tec.linutronix.de>
References: <cover.1622351443.git.luto@kernel.org> <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org> <871r9n5iit.ffs@nanos.tec.linutronix.de> <87fsy24tqt.ffs@nanos.tec.linutronix.de>
Date:   Mon, 31 May 2021 21:48:17 +0200
Message-ID: <87czt64rcu.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31 2021 at 20:56, Thomas Gleixner wrote:
> On Mon, May 31 2021 at 12:01, Thomas Gleixner wrote:
> __fpu__restore_sig()
>
> 	if (!buf) {
>                 fpu__clear_user_states(fpu);
>                 return 0;
>         }
>
> and
>
> handle_signal()
>
>    if (!failed)
>       fpu__clear_user_states(fpu);
>
> which invoke that function unconditionally.

So we cannot warn there.

This is all wrong and everything should use copy_kernel_to_xstate()
after copying the buffer from user space. But of course allocating
memory there is daft.

There is also xstateregs_set() which invokes fpstate_init() on fail
which means it blows away _ALL_ state including supervisor state.

Even without supervisor state this function is bonkers. If the ptracer
provides a bogus data set then this just invalidates the target tasks
FPU state for no real good reason.

This should just use a kernel buffer.  If the copy from user fails, the
caller gets the EFAULT. If the header is bogus, then
copy_kernel_to_xstate() returns -EINVAL and that's handed back to the
caller. No reason to invalidate anything.

Thanks,

        tglx





