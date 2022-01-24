Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9418A49831F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiAXPJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiAXPJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:09:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F0C06173B;
        Mon, 24 Jan 2022 07:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A85A613C5;
        Mon, 24 Jan 2022 15:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6DAC340E1;
        Mon, 24 Jan 2022 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643036956;
        bh=vsFL6HOQwkNugp0rbGxl+Vo5U1vQl5c5pRrmbvYpdJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v2EEwgMc8oWDl46QXm0Px3et0xbFoOUWFdKwlUCK/EQ8Yg9BMkD1FA9L9R/rASDiW
         WQEnpvf0bYPDa9uFWJ929tlMVIbqtDkGYyPzmBRIvlNWUyE8fg1Pp5nxvOVvZZBEMy
         vP1O7TCl8bhHtsyhl1EF97aTO/wjS/SziQUA7HzA=
Date:   Mon, 24 Jan 2022 16:09:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 5.4.y] Revert "ia64: kprobes: Use generic kretprobe
 trampoline handler"
Message-ID: <Ye7BGfOwNQbPQ37M@kroah.com>
References: <YeEhuGXr2B9r7mer@kroah.com>
 <164225155571.1964629.11131335649262508943.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164225155571.1964629.11131335649262508943.stgit@devnote2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 09:59:16PM +0900, Masami Hiramatsu wrote:
> This reverts commit 77fa5e15c933a1ec812de61ad709c00aa51e96ae.
> 
> Since the upstream commit e792ff804f49720ce003b3e4c618b5d996256a18
> depends on the generic kretprobe trampoline handler, which was
> introduced by commit 66ada2ccae4e ("kprobes: Add generic kretprobe
> trampoline handler") but that is not ported to the stable kernel
> because it is not a bugfix series.
> So revert this commit to fix a build error.
> 
> NOTE: I keep commit a7fe2378454c ("ia64: kprobes: Fix to pass
> correct trampoline address to the handler") on the tree, that seems
> just a cleanup without the original reverted commit, but it would
> be better to use dereference_function_descriptor() macro instead
> of accessing descriptor's field directly.
> 
> Fixes: 77fa5e15c933 ("ia64: kprobes: Use generic kretprobe trampoline handler")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>   Changes in v2:
>    - fix the lack of type casting for dereference_function_descriptor().
> ---
>  arch/ia64/kernel/kprobes.c |   78 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 75 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
> index 8a223d0e4918..fa10d51f6217 100644
> --- a/arch/ia64/kernel/kprobes.c
> +++ b/arch/ia64/kernel/kprobes.c
> @@ -396,10 +396,83 @@ static void kretprobe_trampoline(void)
>  {
>  }
>  
> +/*
> + * At this point the target function has been tricked into
> + * returning into our trampoline.  Lookup the associated instance
> + * and then:
> + *    - call the handler function
> + *    - cleanup by marking the instance as unused
> + *    - long jump back to the original return address
> + */
>  int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
>  {
> -	regs->cr_iip = __kretprobe_trampoline_handler(regs,
> -		dereference_function_descriptor(kretprobe_trampoline), NULL);
> +	struct kretprobe_instance *ri = NULL;
> +	struct hlist_head *head, empty_rp;
> +	struct hlist_node *tmp;
> +	unsigned long flags, orig_ret_address = 0;
> +	unsigned long trampoline_address =
> +		(unsigned long)dereference_function_descriptor(kretprobe_trampoline);
> +
> +	INIT_HLIST_HEAD(&empty_rp);
> +	kretprobe_hash_lock(current, &head, &flags);
> +
> +	/*
> +	 * It is possible to have multiple instances associated with a given
> +	 * task either because an multiple functions in the call path
> +	 * have a return probe installed on them, and/or more than one return
> +	 * return probe was registered for a target function.
> +	 *
> +	 * We can handle this because:
> +	 *     - instances are always inserted at the head of the list
> +	 *     - when multiple return probes are registered for the same
> +	 *       function, the first instance's ret_addr will point to the
> +	 *       real return address, and all the rest will point to
> +	 *       kretprobe_trampoline
> +	 */
> +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
> +		if (ri->task != current)
> +			/* another task is sharing our hash bucket */
> +			continue;
> +
> +		orig_ret_address = (unsigned long)ri->ret_addr;
> +		if (orig_ret_address != trampoline_address)
> +			/*
> +			 * This is the real return address. Any other
> +			 * instances associated with this task are for
> +			 * other calls deeper on the call stack
> +			 */
> +			break;
> +	}
> +
> +	regs->cr_iip = orig_ret_address;
> +
> +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
> +		if (ri->task != current)
> +			/* another task is sharing our hash bucket */
> +			continue;
> +
> +		if (ri->rp && ri->rp->handler)
> +			ri->rp->handler(ri, regs);
> +
> +		orig_ret_address = (unsigned long)ri->ret_addr;
> +		recycle_rp_inst(ri, &empty_rp);
> +
> +		if (orig_ret_address != trampoline_address)
> +			/*
> +			 * This is the real return address. Any other
> +			 * instances associated with this task are for
> +			 * other calls deeper on the call stack
> +			 */
> +			break;
> +	}
> +	kretprobe_assert(ri, orig_ret_address, trampoline_address);
> +
> +	kretprobe_hash_unlock(current, &flags);
> +
> +	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
> +		hlist_del(&ri->hlist);
> +		kfree(ri);
> +	}
>  	/*
>  	 * By returning a non-zero value, we are telling
>  	 * kprobe_handler() that we don't want the post_handler
> @@ -412,7 +485,6 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
>  				      struct pt_regs *regs)
>  {
>  	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
> -	ri->fp = NULL;
>  
>  	/* Replace the return addr with trampoline addr */
>  	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
> 

Now queued up, thanks.

greg k-h
