Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E44B250748
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHXSSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:18:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:50505 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHXSSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 14:18:03 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 07OIHSLx029771;
        Mon, 24 Aug 2020 13:17:28 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 07OIHQLo029770;
        Mon, 24 Aug 2020 13:17:26 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 24 Aug 2020 13:17:26 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Guohua Zhong <zhongguohua1@huawei.com>
Cc:     christophe.leroy@csgroup.eu, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        nixiaoming@huawei.com, paulus@samba.org, stable@vger.kernel.org,
        wangle6@huawei.com
Subject: Re: =?utf-8?B?UmXvvJpSZQ==?=
        =?utf-8?Q?=3A?= [PATCH] powerpc: Fix a bug in __div64_32 if divisor is zero
Message-ID: <20200824181726.GR28786@gate.crashing.org>
References: <20200823001101.GO28786@gate.crashing.org> <20200824115407.55896-1-zhongguohua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824115407.55896-1-zhongguohua1@huawei.com>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 07:54:07PM +0800, Guohua Zhong wrote:
> >> Yet, I have noticed that there is no checking of 'base' in these functions.
> >> But I am not sure how to check is better.As we know that the result is 
> >> undefined when divisor is zero. It maybe good to print error and dump stack.
> >>  Let the process to know that the divisor is zero by sending SIGFPE. 
> 
> > That is now what the PowerPC integer divide insns do: they just leave
> > the result undefined (and they can set the overflow flag then, but no
> > one uses that).
> 
> OK ,So just keep the patch as below. If this patch looks good for you, please
> help to review. I will send the new patch later.
> 
> Thanks for your reply.
> 
> diff --git a/arch/powerpc/boot/div64.S b/arch/powerpc/boot/div64.S
> index 4354928ed62e..1d3561cf16fa 100644
> --- a/arch/powerpc/boot/div64.S
> +++ b/arch/powerpc/boot/div64.S
> @@ -13,8 +13,10 @@
> 
>         .globl __div64_32
>         .globl __div64_32
>  __div64_32:
> + cmplwi      r4,0    # check if divisor r4 is zero
>         lwz     r5,0(r3)        # get the dividend into r5/r6
>         lwz     r6,4(r3)
> + beq 5f                      # jump to label 5 if r4(divisor) is zero

Just "beqlr".

This instruction scheduling hurts all CPUs that aren't 8xx, fwiw (but
likely only in the case where r4 *is* zero, so who cares :-) )

So...  What is the *goal* of this patch?  It looks like the routine
would not get into a loop if r4 is 0, just return the wrong result?
But, it *always* will, there *is* no right result?

No caller should call it with zero as divisor ever, so in that sense,
checking for it in the division routine is just pure wasted work.


Segher
