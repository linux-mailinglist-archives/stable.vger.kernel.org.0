Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA94B7788
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbiBORNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:13:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiBORNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:13:07 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DE7119F7A;
        Tue, 15 Feb 2022 09:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644945177; x=1676481177;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=NgaNvbLh/5PNCAekVCyte5+CqdZYMQ6Cb7Fvz6rUpBA=;
  b=hGxfzI+qH+2nBbvtKpBoIipw7EvobynCdMjJu4lBuCpQVAHQsNr6G/qw
   xVh4Hk592PGTai6CrUxcQMwhm139jnHDza+Kf6PDVDaRjJQIhh2O+EChh
   0j3Lo0aEc3sQJskZnNF2h9X91kXDDrS6S/LnguIc0KwuNlcI9LABJAYMc
   dfJlEGd5MR/3DbX/8mSukJ5vo5bh4NfnxcNlAns3TUOcej2EWeaCesEzt
   TWt/TBQVSOxl6UrFF0QcGlfpQ7dzZur/lLzv4dDkbej97siycToV3bwVZ
   NGYKebIyouQNWYB4W5Sqy98MHn3hEH2UzrF9D1PI0DdNyk5l22Rk8INVU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="336830818"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="336830818"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:07:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="775934195"
Received: from tngodup-mobl.amr.corp.intel.com (HELO [10.209.32.98]) ([10.209.32.98])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:07:50 -0800
Message-ID: <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
Date:   Tue, 15 Feb 2022 09:07:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20220215153644.3654582-1-bgeffon@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
In-Reply-To: <20220215153644.3654582-1-bgeffon@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/22 07:36, Brian Geffon wrote:
> There are two issues with PKRU handling prior to 5.13. 

Are you sure both of these issues were introduced by 0cecca9d03c?  I'm
surprised that the get_xsave_addr() issue is not older.

Should this be two patches?

> The first is that when eagerly switching PKRU we check that current

Don't forget to write in imperative mood.  No "we's", please.

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html

This goes for changelogs and comments too.

> is not a kernel thread as kernel threads will never use PKRU. It's
> possible that this_cpu_read_stable() on current_task (ie.
> get_current()) is returning an old cached value. By forcing the read
> with this_cpu_read() the correct task is used. Without this it's
> possible when switching from a kernel thread to a userspace thread
> that we'll still observe the PF_KTHREAD flag and never restore the
> PKRU. And as a result this issue only occurs when switching from a
> kernel thread to a userspace thread, switching from a non kernel
> thread works perfectly fine because all we consider in that situation
> is the flags from some other non kernel task and the next fpu is
> passed in to switch_fpu_finish().

It makes *sense* that there would be a place in the context switch code
where 'current' is wonky, but I never realized this.  This seems really
fragile, but *also* trivially detectable.

Is the PKRU code really the only code to use 'current' in a buggy way
like this?

> The second issue is when using write_pkru() we only write to the
> xstate when the feature bit is set because get_xsave_addr() returns
> NULL when the feature bit is not set. This is problematic as the CPU
> is free to clear the feature bit when it observes the xstate in the
> init state, this behavior seems to be documented a few places throughout
> the kernel. If the bit was cleared then in write_pkru() we would happily
> write to PKRU without ever updating the xstate, and the FPU restore on
> return to userspace would load the old value agian.


						^ again

It's probably worth noting that the AMD init tracker is a lot more
aggressive than Intel's.  On Intel, I think XRSTOR is the only way to
get back to the init state.  You're obviously hitting this on AMD.

It's also *very* unlikely that PKRU gets back to a value of 0.  I think
we added a selftest for this case in later kernels.

That helps explain why this bug hung around for so long.

> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> index 03b3de491b5e..540bda5bdd28 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
>  	 * PKRU state is switched eagerly because it needs to be valid before we
>  	 * return to userland e.g. for a copy_to_user() operation.
>  	 */
> -	if (!(current->flags & PF_KTHREAD)) {
> +	if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {

This really deserves a specific comment.

>  		/*
>  		 * If the PKRU bit in xsave.header.xfeatures is not set,
>  		 * then the PKRU component was in init state, which means
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 9e71bf86d8d0..aa381b530de0 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
>  	if (!boot_cpu_has(X86_FEATURE_OSPKE))
>  		return;
>  
> -	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> -
>  	/*
>  	 * The PKRU value in xstate needs to be in sync with the value that is
>  	 * written to the CPU. The FPU restore on return to userland would
>  	 * otherwise load the previous value again.
>  	 */
>  	fpregs_lock();
> -	if (pk)
> -		pk->pkru = pkru;
> +	/*
> +	 * The CPU is free to clear the feature bit when the xstate is in the
> +	 * init state. For this reason, we need to make sure the feature bit is
> +	 * reset when we're explicitly writing to pkru. If we did not then we
> +	 * would write to pkru and it would not be saved on a context switch.
> +	 */
> +	current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;

I don't think we need to describe how the init optimization works again.
 I'm also not sure it's worth mentioning context switches here.  It's a
wider problem than that.  Maybe:

	/*
	 * All fpregs will be XRSTOR'd from this buffer before returning
	 * to userspace.  Ensure that XRSTOR does not init PKRU and that
	 * get_xsave_addr() will work.
	 */

> +	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> +	BUG_ON(!pk);

A BUG_ON() a line before a NULL pointer dereference doesn't tend to do
much good.

> +	pk->pkru = pkru;
>  	__write_pkru(pkru);
>  	fpregs_unlock();
>  }

