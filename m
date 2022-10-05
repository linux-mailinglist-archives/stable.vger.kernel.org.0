Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34D85F5D48
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 01:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJEXpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 19:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJEXpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 19:45:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6CE3AE58;
        Wed,  5 Oct 2022 16:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665013536; x=1696549536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RaUYcwQGnWtyL4YdEtWWSVHb+tZ4OaJxFPhXTQo15fI=;
  b=OATsYPwV8GB1X2+FMXRUosmX5C196Swy+NmJ9wWUwvimCxhCemfny9zJ
   21/u1wIHXu+6r8QtRMD1CFvyFrAx9IB0G6XzF3o73UOOdQxXucdcA7fYD
   tM+8rj1mFQXQWoVF7votnwd6rj5bdwH1NMts2GjZhYB4TrU+5AZ0saBNo
   3OlgrLZNw5Ft9IMqeUTs4fUPgMxCL93urk29Tw5yXYhx5fdp4iWITI0gN
   lHHjn05S/fcCMZ3dFjqLEu0/AaqSZp2l4qs/Nc3DU4wNMHkdhVYK7gpW1
   MuKn9Bn12O01CWSvO51J5dxm/j8vzKl+X7FQgTfKvixmU1dYFwqCSUt4z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="389589881"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="389589881"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 16:45:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="713627051"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="713627051"
Received: from cmbrown1-mobl.amr.corp.intel.com (HELO desk) ([10.212.186.202])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 16:45:35 -0700
Date:   Wed, 5 Oct 2022 16:45:33 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Suraj Jitindar Singh <surajjs@amazon.com>, kvm@vger.kernel.org,
        sjitindarsingh@gmail.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@suse.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        daniel.sneddon@linux.intel.com, benh@kernel.crashing.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Message-ID: <20221005234533.cr4jpzsb3cprlc2c@desk>
References: <20221005220227.1959-1-surajjs@amazon.com>
 <CALMp9eTU9s+2fZ809bfOWYoGXsiziQOxCM-5Ly0JF2HeSEkwhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALMp9eTU9s+2fZ809bfOWYoGXsiziQOxCM-5Ly0JF2HeSEkwhA@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 04:24:54PM -0700, Jim Mattson wrote:
>On Wed, Oct 5, 2022 at 3:03 PM Suraj Jitindar Singh <surajjs@amazon.com> wrote:
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
>Okay. I see how this almost meets the requirements. But this WRMSR is
>conditional, which means that there's a speculative path through this
>code that ends up at the unbalanced RET without executing the WRMSR.

Agree. I was just about to post this.
