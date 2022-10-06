Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79CB5F5DB2
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 02:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiJFA0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 20:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJFA0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 20:26:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BF082776;
        Wed,  5 Oct 2022 17:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665016007; x=1696552007;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=/XNHa027Ea7qpJ+BjWibHtSiU7d/RKZbxzBKrlNWOl8=;
  b=Onml+VZnDIDBNsGACLhEAq4GV6N+kTMYdHkUvzjIMnRUmwPp5xcU4IwK
   1xl0nAOqY/zgg8qaoYjwMovw2gvGGsh9ChtMBijtgBdDPihyyJFNW8C3I
   Amdqab0lrUtXeeRjn3qf3pNvUa3b7C3idyF3aQLIHydaKAQC80Bz4NFzJ
   P7mMu21dDoCFZpv0IYved5ve9p0liU9z8SROoHEFPdJ68YqvaoQwQQqnp
   /BX63YZu6pM4sxVCu6E7F65HUo8JXi+sU9AiOBs799ADFQrl5JAKrTRI4
   +O751FW8ynImHdq/yYMdtBYbSQEJyoue5DVYzZROU8cprHSy/ymbtSCiO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="389596375"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="389596375"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 17:26:46 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="749962775"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="749962775"
Received: from rholt1-mobl.amr.corp.intel.com (HELO [10.254.107.106]) ([10.254.107.106])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 17:26:45 -0700
Message-ID: <684c8ef6-bf69-e31e-fb3e-d3beca52fd15@linux.intel.com>
Date:   Wed, 5 Oct 2022 17:26:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     kvm@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@suse.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
        benh@kernel.crashing.org, stable@vger.kernel.org
References: <20221005220227.1959-1-surajjs@amazon.com>
 <CALMp9eThzv+5UBPtm77nvD_b48hHD7O1QLni7a+x9zAPicFk4Q@mail.gmail.com>
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
In-Reply-To: <CALMp9eThzv+5UBPtm77nvD_b48hHD7O1QLni7a+x9zAPicFk4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/22 16:46, Jim Mattson wrote:
> On Wed, Oct 5, 2022 at 3:03 PM Suraj Jitindar Singh <surajjs@amazon.com> wrote:
>>
>> tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
>> ensure a call instruction retires before a following unbalanced RET. Replace
>> this with a WRMSR serialising instruction which has a lower performance
>> penalty.
>>
>> == Background ==
>>
>> eIBRS (enhanced indirect branch restricted speculation) is used to prevent
>> predictor addresses from one privilege domain from being used for prediction
>> in a higher privilege domain.
>>
>> == Problem ==
>>
>> On processors with eIBRS protections there can be a case where upon VM exit
>> a guest address may be used as an RSB prediction for an unbalanced RET if a
>> CALL instruction hasn't yet been retired. This is termed PBRSB (Post-Barrier
>> Return Stack Buffer).
>>
>> A mitigation for this was introduced in:
>> (2b1299322016731d56807aa49254a5ea3080b6b3 x86/speculation: Add RSB VM Exit protections)
>>
>> This mitigation [1] has a ~1% performance impact on VM exit compared to without
>> it [2].
>>
>> == Solution ==
>>
>> The WRMSR instruction can be used as a speculation barrier and a serialising
>> instruction. Use this on the VM exit path instead to ensure that a CALL
>> instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
>> before the prediction of a following unbalanced RET.
>>
>> This mitigation [3] has a negligible performance impact.
>>
>> == Testing ==
>>
>> Run the outl_to_kernel kvm-unit-tests test 200 times per configuration which
>> counts the cycles for an exit to kernel mode.
>>
>> [1] With existing mitigation:
>> Average: 2026 cycles
>> [2] With no mitigation:
>> Average: 2008 cycles
>> [3] With proposed mitigation:
>> Average: 2008 cycles
>>
>> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  arch/x86/include/asm/nospec-branch.h | 7 +++----
>>  arch/x86/kvm/vmx/vmenter.S           | 3 +--
>>  arch/x86/kvm/vmx/vmx.c               | 5 +++++
>>  3 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
>> index c936ce9f0c47..e5723e024b47 100644
>> --- a/arch/x86/include/asm/nospec-branch.h
>> +++ b/arch/x86/include/asm/nospec-branch.h
>> @@ -159,10 +159,9 @@
>>    * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
>>    * monstrosity above, manually.
>>    */
>> -.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=ALT_NOT(X86_FEATURE_ALWAYS)
>> -       ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
>> -               __stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
>> -               __stringify(__FILL_ONE_RETURN), \ftr2
>> +.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
>> +       ALTERNATIVE "jmp .Lskip_rsb_\@", \
>> +               __stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr
>>
>>  .Lskip_rsb_\@:
>>  .endm
>> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
>> index 6de96b943804..eb82797bd7bf 100644
>> --- a/arch/x86/kvm/vmx/vmenter.S
>> +++ b/arch/x86/kvm/vmx/vmenter.S
>> @@ -231,8 +231,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
>>          * single call to retire, before the first unbalanced RET.
>>           */
>>
>> -       FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
>> -                          X86_FEATURE_RSB_VMEXIT_LITE
>> +       FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
>>
>>
>>         pop %_ASM_ARG2  /* @flags */
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c9b49a09e6b5..fdcd8e10c2ab 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7049,8 +7049,13 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>>          * For legacy IBRS, the IBRS bit always needs to be written after
>>          * transitioning from a less privileged predictor mode, regardless of
>>          * whether the guest/host values differ.
>> +        *
>> +        * For eIBRS affected by Post Barrier RSB Predictions a serialising
>> +        * instruction (wrmsr) must be executed to ensure a call instruction has
>> +        * retired before the prediction of a following unbalanced ret.
>>          */
>>         if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
>> +           cpu_feature_enabled(X86_FEATURE_RSB_VMEXIT_LITE) ||
>>             vmx->spec_ctrl != hostval)
>>                 native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
> 
> Better, I think, would be to leave the condition alone and put an
> LFENCE on the 'else' path:
> 
>          if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
>              vmx->spec_ctrl != hostval)
>                  native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
>         else
>                 rmb();
> 
> When the guest and host have different IA32_SPEC_CTRL values, you get
> the serialization from the WRMSR. Otherwise, you get it from the
> cheaper LFENCE.
In this case systems that don't suffer from PBRSB (i.e. don've have
X86_FEATURE_RSB_VMEXIT_LITE set) would be doing a barrier for no reason.  We're
just trading performance on vulnerable systems for a performance hit on systems
that aren't vulnerable.
> 
> This is still more convoluted than having the mitigation in one place.
Agreed.

