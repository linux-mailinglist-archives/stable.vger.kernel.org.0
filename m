Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B872B396831
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhEaS60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhEaS60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:58:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77B6C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 11:56:45 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622487402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2Pu6ejKWB5msdCqEd70HYQYbTLOsOrtztgSLt8OIvs=;
        b=QTaltaUjANtCeNhgVoUwkqUVY9pbFWBo/olXZuAyZAZEo204LyOBE28tvRh1HSXnsFjMN8
        TNgHxVJQqdWrYdBOBfYMqdIautPWrhd32UjFPRyrw916mclkMbCTGF5uyUqHrGVUzc4M8H
        6N4l3a/1hfLcVJocEfWsPN+tu85C+wUdqyl2T561QxiocDGXDOPVZ/tTkILkclKpS7xhfC
        PxKaCPwJjktGEZQZw3k9lvyIuVm3LpdZQ0DiALhSaiQQlHXpJEpRh+lkz9cGNfWAOHusNW
        ZPFmvKVKQs5gaFKfzMxs/FAMr+2H1twaSyfbAcA1HjSjT/o2HX6dFTTdUi5vcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622487402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2Pu6ejKWB5msdCqEd70HYQYbTLOsOrtztgSLt8OIvs=;
        b=Oz/iL25m4HFHKJmSbVZkGQ2cwnUdNJjOpShpV6PbQWbuWNIXl4aW7RjoaCeq1vq8KfCi4Z
        Z8KUCPJ1otnMRaBg==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <871r9n5iit.ffs@nanos.tec.linutronix.de>
References: <cover.1622351443.git.luto@kernel.org> <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org> <871r9n5iit.ffs@nanos.tec.linutronix.de>
Date:   Mon, 31 May 2021 20:56:42 +0200
Message-ID: <87fsy24tqt.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31 2021 at 12:01, Thomas Gleixner wrote:

> On Sat, May 29 2021 at 22:12, Andy Lutomirski wrote:
>>  /*
>> - * Clear the FPU state back to init state.
>> - *
>> - * Called by sys_execve(), by the signal handler code and by various
>> - * error paths.
>> + * Reset current's user FPU states to the init states.  The caller promises
>> + * that current's supervisor states (in memory or CPU regs as appropriate)
>> + * as well as the XSAVE header in memory are intact.
>>   */
>> -static void fpu__clear(struct fpu *fpu, bool user_only)
>> +void fpu__clear_user_states(struct fpu *fpu)
>>  {
>>  	WARN_ON_FPU(fpu != &current->thread.fpu);
>>  
>>  	if (!static_cpu_has(X86_FEATURE_FPU)) {
>
> This can only be safely called if XSAVES is available. So this check is
> bogus as it actually should check for !XSAVES. And if at all it should
> be:
>
>    if (WARN_ON_ONCE(!XSAVES))
>       ....
>
> This is exactly the stuff which causes subtle problems down the road.
>
> I have no idea why you are insisting on having this conditional at the
> call site. It's just an invitation for trouble because someone finds
> this function and calls it unconditionally. And he will miss the
> 'promise' part in the comment as I did.

And of course there is:

__fpu__restore_sig()

	if (!buf) {
                fpu__clear_user_states(fpu);
                return 0;
        }

and

handle_signal()

   if (!failed)
      fpu__clear_user_states(fpu);

which invoke that function unconditionally.

Thanks,

        tglx
