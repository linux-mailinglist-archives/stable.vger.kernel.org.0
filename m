Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE584B5DD4
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiBNWld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:41:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiBNWlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:41:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F667A994;
        Mon, 14 Feb 2022 14:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644878484; x=1676414484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Eef639z1xq1nQFQJLCBg8R/waHFd3R5JFPWOOIPMLo=;
  b=M/bQXUrnEfWHI91W6PbS5ByqapJydUCf1nMLMogAcxHBT1X2hYm6gUnb
   BeHTbFdi/OXuqob++AWMI+jatvU9dvuLkhbsGoJC6qC8BEcTc92jPbqOE
   eb1xcEbfHlfSClTs/DZAEpLClICJ9pKhXrCS5GPMNY/7yY9DUeytQ+JBJ
   9zdj3bDjGmUtouiYFPQwBSkH8so/QJq40809LY9mBwW3/Lk5Lc529oDfZ
   EqS8NvJG5xuIUj4Kgja20tuDVbCjMScVQRUG92RuyFEckgWb2g5uzA/EB
   Md3VWUyXy61OD369TsvRKKXLSRRLLN1jcv6FfQl3TNrPkEW1z9LGHhhhM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="247793088"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="247793088"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 14:41:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="632387331"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.212.244.212])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 14:41:23 -0800
Date:   Mon, 14 Feb 2022 14:41:21 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YgqToxbGQluNHABF@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.02.2022 18:38, Borislav Petkov wrote:
>On Wed, Feb 09, 2022 at 01:04:36PM -0800, Pawan Gupta wrote:
>> tsx_clear_cpuid() uses MSR_TSX_FORCE_ABORT to clear CPUID.RTM and
>> CPUID.HLE. Not all CPUs support MSR_TSX_FORCE_ABORT, alternatively use
>> MSR_IA32_TSX_CTRL when supported.
>>
>> Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>
><--- I'm assuming this needs to be
>
>Cc: <stable@vger.kernel.org>
>
>?

Yes, this needs to be backported to a few kernels that have the commit
293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts").
Once this is reviewed, I will send a separate email to stable@ with the
list of stable kernels.

>> @@ -106,13 +110,11 @@ void __init tsx_init(void)
>>  	int ret;
>>
>>  	/*
>> -	 * Hardware will always abort a TSX transaction if both CPUID bits
>> -	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
>> -	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
>> -	 * here.
>> +	 * Hardware will always abort a TSX transaction when CPUID
>> +	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
>> +	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
>>  	 */
>> -	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
>> -	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
>> +	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
>
>So you test here X86_FEATURE_RTM_ALWAYS_ABORT and tsx_clear_cpuid()
>tests it again. Simplify I guess.

X86_FEATURE_RTM_ALWAYS_ABORT is the precondition for
MSR_TFA_TSX_CPUID_CLEAR bit to exist. For current callers of
tsx_clear_cpuid() this condition is met, and test for
X86_FEATURE_RTM_ALWAYS_ABORT can be removed. But, all the future callers
must also have this check, otherwise the MSR write will fault. 

>>  		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
>>  		tsx_clear_cpuid();
>>  		setup_clear_cpu_cap(X86_FEATURE_RTM);
>
>Also, here you clear X86_FEATURE_RTM and X86_FEATURE_HLE but the other
>caller of tsx_clear_cpuid() - init_intel() - doesn't clear those bits.
>Why?

Calling setup_clear_cpu_cap() by boot CPU is sufficient to clear these
bits for secondary CPUs. Moreover, init_intel() is also called during
cpu hotplug, clearing cached CPUID bits will not be safe after boot.

>IOW, can we concentrate the whole tsx_clear_cpuid() logic inside it and
>have callers only call it unconditionally. Then the decision whether
>to disable TSX and clear bits will happen all solely in that function
>instead of being spread around the boot code and being inconsistent.

There are certain cases where this will leave the system in an
inconsistent state, for example smt toggle after a late microcode update
that adds CPUID.RTM_ALWAYS_ABORT=1. During an smt toggle, if we
unconditionally clear CPUID.RTM and CPUID.HLE in init_intel(), half of
the CPUs will report TSX feature and other half will not.

Thanks,
Pawan
