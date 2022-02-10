Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36864B0DF1
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 13:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiBJMxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 07:53:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbiBJMxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 07:53:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7166D1026;
        Thu, 10 Feb 2022 04:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED1061DCC;
        Thu, 10 Feb 2022 12:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE8AC004E1;
        Thu, 10 Feb 2022 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644497627;
        bh=Sj8DWq94LOKTBM0ypVNljY/FQe/q5/1ffqBT+QjXKsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nqLLEdK01Ls4G9UhwGNLKFP2ED7XDuwawFhl64Aal59FMAGnTN6bg54QVqVxEp+3n
         vfdLYXzwTJ9C3myyptw2qrYxUB0EbyRCJL54k4nBWTIkIHJjNDXRguCeTvNJZ+BcBR
         rDvOeJkfp5v6S39D8dzpoPDPzklGzEIkUCmOEOzs=
Date:   Thu, 10 Feb 2022 13:53:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org,
        wsd_upstream@mediatek.com,
        Eason-YH Lin <eason-yh.lin@mediatek.com>,
        Kobe-CP Wu <kobe-cp.wu@mediatek.com>,
        Jeff-CC Hsu <jeff-cc.hsu@mediatek.com>
Subject: Re: [PATCH] lockdep: Correct lock_classes index mapping
Message-ID: <YgUK134eEhCXOsgk@kroah.com>
References: <20220210105011.21712-1-cheng-jui.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210105011.21712-1-cheng-jui.wang@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 06:50:11PM +0800, Cheng Jui Wang wrote:
> A kernel exception was hit when trying to dump /proc/lockdep_chains after
> lockdep report "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!":
> 
> Unable to handle kernel paging request at virtual address 00054005450e05c3
> ...
> 00054005450e05c3] address between user and kernel address ranges
> ...
> pc : [0xffffffece769b3a8] string+0x50/0x10c
> lr : [0xffffffece769ac88] vsnprintf+0x468/0x69c
> ...
>  Call trace:
>   string+0x50/0x10c
>   vsnprintf+0x468/0x69c
>   seq_printf+0x8c/0xd8
>   print_name+0x64/0xf4
>   lc_show+0xb8/0x128
>   seq_read_iter+0x3cc/0x5fc
>   proc_reg_read_iter+0xdc/0x1d4
> 
> The cause of the problem is the function lock_chain_get_class() will
> shift lock_classes index by 1, but the index don't need to be shifted
> anymore since commit 01bb6f0af992 ("locking/lockdep: Change the range of
> class_idx in held_lock struct") already change the index to start from
> 0.
> 
> The lock_classes[-1] located at chain_hlocks array. When printing
> lock_classes[-1] after the chain_hlocks entries are modified, the
> exception happened.
> 
> The output of lockdep_chains are incorrect due to this problem too.
> 
> Fixes: f611e8cf98ec ("lockdep: Take read/write status in consideration when generate chainkey")
> 
> Signed-off-by: Cheng Jui Wang <cheng-jui.wang@mediatek.com>
> ---
>  kernel/locking/lockdep.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 4a882f83aeb9..f8a0212189ca 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3462,7 +3462,7 @@ struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i)
>  	u16 chain_hlock = chain_hlocks[chain->base + i];
>  	unsigned int class_idx = chain_hlock_class_idx(chain_hlock);
>  
> -	return lock_classes + class_idx - 1;
> +	return lock_classes + class_idx;
>  }
>  
>  /*
> @@ -3530,7 +3530,7 @@ static void print_chain_keys_chain(struct lock_chain *chain)
>  		hlock_id = chain_hlocks[chain->base + i];
>  		chain_key = print_chain_key_iteration(hlock_id, chain_key);
>  
> -		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id) - 1);
> +		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id));
>  		printk("\n");
>  	}
>  }
> -- 
> 2.18.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
