Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1355939A934
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhFCRbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFCRbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42F596108E;
        Thu,  3 Jun 2021 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622741406;
        bh=llvjpn94Mq/0bBFmfUQXNoQsqLHPIas8SBwQkn5JSiI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nAhc+KLhUgxxZc7r2vzg12qBQkePZerJV3fPOF3D30yv+zXUwWa3/TNiCfyxV5O0o
         I7VthY0Ns3AgKPNnipqyFAPKYeLC2wcV3Ey+stQGqcmJGgjej+Vov+dUnp/2CVsDx0
         VQu0qs0BrdQsYjfyng8hSnew6Zya/Sj8KrdXRbgmLSdbAam7TK1/a+ZCKr54/DET6Y
         z3Wo4UU9drzRh5oZ6HS3Vgqdwrsm8CPiRetCYxyOJoha4K/9XPaUJNfSpyuu+ETd9J
         KYXe9n3HmQq3oexxGjASqjepokvk/sDzuT/4bM1aqjM4SL4WiedHhuCbpdrR84Zu9Y
         g1lzw15vwbqNA==
Subject: Re: [patch 3/8] x86/fpu: Invalidate FPU state after a failed XRSTOR
 from a user buffer
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
References: <20210602095543.149814064@linutronix.de>
 <20210602101618.627715436@linutronix.de> <YLeedfdsnsKqcbGx@zn.tnic>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <6220f2da-1d5b-843c-fa82-58a28fbcdd6b@kernel.org>
Date:   Thu, 3 Jun 2021 10:30:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLeedfdsnsKqcbGx@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/21 8:06 AM, Borislav Petkov wrote:
> On Wed, Jun 02, 2021 at 11:55:46AM +0200, Thomas Gleixner wrote:
>> From: Andy Lutomirski <luto@kernel.org>
>>
>> If XRSTOR fails due to sufficiently complicated paging errors (e.g.
>> concurrent TLB invalidation),
> 
> I can't connect "concurrent TLB invalidation" to "sufficiently
> complicated paging errors". Can you elaborate pls?

Think "complex microarchitectural conditions".

How about:

As far as I can tell, both Intel and AMD consider it to be
architecturally valid for XRSTOR to fail with #PF but nonetheless change
user state.  The actual conditions under which this might occur are
unclear [1], but it seems plausible that this might be triggered if one
sibling thread unmaps a page and invalidates the shared TLB while
another sibling thread is executing XRSTOR on the page in question.

__fpu__restore_sig() can execute XRSTOR while the hardware registers are
preserved on behalf of a different victim task (using the
fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
modify the registers.  If this happens, then there is a window in which
__fpu__restore_sig() could schedule out and the victim task could
schedule back in without reloading its own FPU registers.  This would
result in part of the FPU state that __fpu__restore_sig() was attempting
to load leaking into the victim task's user-visible state.

Invalidate preserved FPU registers on XRSTOR failure to prevent this
situation from corrupting any state.

[1] Frequent readers of the errata lists might imagine "complex
microarchitectural conditions".

>> +			 * failed.  In the event that the ucode was
>> +			 * unfriendly and modified the registers at all, we
>> +			 * need to make sure that we aren't corrupting an
>> +			 * innocent non-current task's registers.
>> +			 */
>> +			__cpu_invalidate_fpregs_state();
>> +		} else {
>> +			/*
>> +			 * As above, we may have just clobbered current's
>> +			 * user FPU state.  We will either successfully
>> +			 * load it or clear it below, so no action is
>> +			 * required here.
>> +			 */
>> +		}
> 
> I'm wondering if that comment can simply be above the TIF_NEED_FPU_LOAD
> testing, standalone, instead of having it in an empty else? And then get
> rid of that else.

I'm fine either way.
