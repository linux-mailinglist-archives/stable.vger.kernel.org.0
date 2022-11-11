Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722AB624FAF
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 02:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKKBiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 20:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiKKBiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 20:38:01 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548EA51C24;
        Thu, 10 Nov 2022 17:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668130680; x=1699666680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hOsb2zd+9aGqPYDtkVhR22vi8tnc3Ya1+UHhC6DCC0w=;
  b=kdfmv7s9VKFKJ2x0rx3OmExpzET2z/CNlX7l4SsqOwmxImjHyK0bLw++
   Uh1F85ByCvcFof17P4z5KDeB/3e9uaErIFNI2eGk/2LlAQSnKKjhxHQRA
   w3TzL3X+uUoqs11Ztk1O7L84AdVyDvdbs1/TRCPRHWyXo7gVXgfmWPTkQ
   1SJVoUCudZtTgnq2mxCTry+gHxfc5MdY0i/TVcjJYQSF/cKdn2+ovnn4N
   HgnqQxtzuSF7cp9QguFBR5rWQ7g/XZ4zlGbxJYQ9v8jImzNnP05t43BRB
   2drJqzJbJEh9ufF8EypSi4/qam2zIitCZ4eqJwFyO3cUEaggiMlemY3eJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="311499143"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="311499143"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 17:38:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="706374427"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="706374427"
Received: from csalvo-mobl1.amr.corp.intel.com (HELO [10.212.217.97]) ([10.212.217.97])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 17:37:58 -0800
Message-ID: <b41b6a33-7fdc-bd54-8b15-02bf4e713ed7@intel.com>
Date:   Thu, 10 Nov 2022 17:37:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RESEND PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again)
 written by ptrace.
Content-Language: en-US
To:     Kyle Huey <me@kylehuey.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
References: <20221107063807.81774-1-khuey@kylehuey.com>
 <20221107063807.81774-2-khuey@kylehuey.com>
 <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com>
 <CAP045ArEuTmA6DGoVEgeSRd-F+oQCqRaeyzwgdxuCnOP0jgqWA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAP045ArEuTmA6DGoVEgeSRd-F+oQCqRaeyzwgdxuCnOP0jgqWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/22 16:03, Kyle Huey wrote:
> On Tue, Nov 8, 2022 at 10:23 AM Dave Hansen <dave.hansen@intel.com> wrote:
...
>> At a high level, this patch does a *LOT*.  Generally, it's nice when
>> bugfixes can be encapsulted in one patch, but I think there's too much
>> going on here for one patch.
> 
> Ok. How about I break the first part into two pieces, one that changes the
> signatures of copy_uabi_from_kernel_to_xstate() and
> copy_sigframe_from_user_to_xstate(), and one that moves the relevant
> KVM code from fpu_copy_uabi_to_guest_fpstate() to copy_uabi_to_xstate()
> and deals with the edge case behavior of the mask?

Sounds like a good start.  My gut says there's another patch or two that
could be broken out, but that sounds like a reasonable next step.

>>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>>> index 3b28c5b25e12..c273669e8a00 100644
>>> --- a/arch/x86/kernel/fpu/core.c
>>> +++ b/arch/x86/kernel/fpu/core.c
>>> @@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>>>  {
>>>       struct fpstate *kstate = gfpu->fpstate;
>>>       const union fpregs_state *ustate = buf;
>>> -     struct pkru_state *xpkru;
>>> -     int ret;
>>>
>>>       if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
>>>               if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
>>> @@ -406,16 +404,16 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>>>       if (ustate->xsave.header.xfeatures & ~xcr0)
>>>               return -EINVAL;
>>>
>>> -     ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
>>> -     if (ret)
>>> -             return ret;
>>> +     /*
>>> +      * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
>>> +      * in the header.  KVM's odd ABI is to leave PKRU untouched in this
>>> +      * case (all other components are eventually re-initialized).
>>> +      * (Not clear that this is actually necessary for compat).
>>> +      */
>>> +     if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
>>> +             vpkru = NULL;
>>
>> I'm not a big fan of hunks that are part of bugfixes where it is not
>> clear that the hunk is necessary.
> 
> This is necessary to avoid changing KVM's behavior at the same time
> that we change
> ptrace, since KVM doesn't want the same behavior as ptrace.

Your "This is necessary" doesn't really match with "Not clear that this
is actually necessary" from the comment, right?

Rather than claim whether it is necessary or not, maybe just say why
it's there: it's there to preserve wonky KVM behavior.

BTW, I'd love to know if KVM *REALLY* depends on this.  It'd be nice to
kill if not.
>> Would something like this be more clear?
>>
>>         if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
>>                 struct pkru_state *xpkru;
>>
>>                 xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
>>                 *pkru = xpkru->pkru;
>>         } else {
>>                 /*
>>                  * KVM may pass a NULL 'pkru' to indicate
>>                  * that it does not need PKRU updated.
>>                  */
>>                 if (pkru)
>>                         *pkru = 0;
>>         }
> 
> Yeah, Sean Christopherson suggested this (with the else and if
> collapsed into a single level) when I submitted this previously.

I generally agree with Sean, but he's also been guilty of an atrocity or
two over the years.  :)  While I generally like low levels of
indentation I also think my version is much more clear in this case.

