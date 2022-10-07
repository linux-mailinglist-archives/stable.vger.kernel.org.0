Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6DC5F7298
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 03:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJGBov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 21:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiJGBou (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 21:44:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D7314D30;
        Thu,  6 Oct 2022 18:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665107087; x=1696643087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Fs3FGSpDMneExo+IDXFzUA3FQKcmBRvaSI4o4deHzJc=;
  b=eUUnaBU9YtGnb++MflraX1vkbXgknM9Q9X8NgA/EtrHwHs1AIN6vbEKx
   ivsSZa9FeT2yQwMoxuAWkHVvnXt6RXUBkPzEjcCIzvBWkBV29vplP8YGV
   oup9ZYCYTVVmhQ9lcIlaDLkN30mQuUIdU/MSQuc5k3yEwSmaaHEqJYgf4
   V+ixLZ5/t2Huu6xCTL5J/nwEL+L+vplViN/T3J7JdNrqix+XvGfm8nMO5
   Hbfv7Enx/KHyUoBGU1rWqwY9JICavXc3FMVuQQ/ap7+CTFsu2d67A3FUY
   1kOpYmWovjsDaP90I1X6EHXxapB4rl7RmBKXE8HyhhWchMR1FDbJCsJM4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="283993153"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="283993153"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:44:46 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="655852881"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="655852881"
Received: from spvenkat-mobl.amr.corp.intel.com (HELO desk) ([10.209.50.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:44:45 -0700
Date:   Thu, 6 Oct 2022 18:44:43 -0700
From:   "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Suraj Jitindar Singh <surajjs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@suse.de" <bp@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Message-ID: <20221007014443.flhhnzrtdmcsst3x@desk>
References: <20221005220227.1959-1-surajjs@amazon.com>
 <11ebe489-0734-28af-07a4-f658709cfd9e@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11ebe489-0734-28af-07a4-f658709cfd9e@citrix.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 02:42:10AM +0000, Andrew Cooper wrote:
>On 05/10/2022 23:02, Suraj Jitindar Singh wrote:
>> == Solution ==
>>
>> The WRMSR instruction can be used as a speculation barrier and a serialising
>> instruction. Use this on the VM exit path instead to ensure that a CALL
>> instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
>> before the prediction of a following unbalanced RET.
>
>While both of these sentences are true statements, you've missed the
>necessary safety property.
>
>One CALL has to retire before *any* RET can execute.
>
>There are several ways the frontend can end up eventually consuming the
>bad RSB entry; they all stem from an execute (not prediction) of the
>next RET instruction.
>
>As to the change, ...
>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c9b49a09e6b5..fdcd8e10c2ab 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7049,8 +7049,13 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>
>... out of context above this hunk is:
>
>    if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
>        return;
>
>meaning that there is a return instruction which is programmatically
>reachable ahead of the WRMSR.
>
>Whether it is speculatively reachable depends on whether the frontend
>can see through the _static_cpu_has(), as well as
>X86_FEATURE_MSR_SPEC_CTRL never becoming compile time evaluable.

In this case wouldn't _static_cpu_has() be runtime patched to a JMP
(<+8> below) or a NOP? RET (at <+13>) should not be reachable even
speculatively. What am I missing?

Dump of assembler code for function vmx_spec_ctrl_restore_host:

   arch/x86/kvm/vmx/vmx.c:
                 u64 hostval = this_cpu_read(x86_spec_ctrl_current);
   		<+0>:     mov    %gs:0x7e022e60(%rip),%r8        # 0x1ad48 <x86_spec_ctrl_current>

   ./arch/x86/include/asm/cpufeature.h:
                 asm_volatile_goto(
   		<+8>:     jmp    <vmx_spec_ctrl_restore_host+14>
   		<+10>:    nopl   (%rax)
   		<+13>:    ret

   arch/x86/kvm/vmx/vmx.c:
                 if (flags & VMX_RUN_SAVE_SPEC_CTRL)
   		<+14>:    and    $0x2,%esi
   		<+17>:    je     <vmx_spec_ctrl_restore_host+40>
   [...]
