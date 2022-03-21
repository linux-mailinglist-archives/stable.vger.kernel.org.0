Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610914E2C5E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 16:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbiCUPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 11:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244949AbiCUPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 11:35:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7203313FAB;
        Mon, 21 Mar 2022 08:34:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2F847210EE;
        Mon, 21 Mar 2022 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647876850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VNyX+fb8O+Otr4c7FYr7v/jIn4CB8StYw4c40MavmeE=;
        b=Ru+P1yK2Jw1QXzAyhjr0RARsHnQE7zJV28GEnbEs4xJuTY3Xf5qtvm/QzeTKVVyypizHIj
        uwJd/qnMAsrfNC1aXFENGw4LABp31GnpyUUfUQDpMqoJdGXPRstyzHVslVCOrBll2SAkmo
        0BfBq2jRMc1eqVe0T+AsJsJOXmz90QY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 76B2CA3B87;
        Mon, 21 Mar 2022 15:34:09 +0000 (UTC)
Date:   Mon, 21 Mar 2022 16:34:08 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     akpm@linux-foundation.org, surenb@google.com, vbabka@suse.cz,
        rientjes@google.com, sfr@canb.auug.org.au, edgararriaga@google.com,
        minchan@kernel.org, nadav.amit@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <Yjia8AzhgWh4KPbp@dhcp22.suse.cz>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 11-03-22 20:59:06, Charan Teja Kalla wrote:
> The process_madvise() system call is expected to skip holes in vma
> passed through 'struct iovec' vector list.

Where is this assumption coming from? From the man page I can see:
: The advice might be applied to only a part of iovec if one of its
: elements points to an invalid memory region in the remote
: process.  No further elements will be processed beyond that
: point.  

> But do_madvise, which
> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> holes, despite the VMA is processed.
> Thus process_madvise() should treat ENOMEM as expected and consider the
> VMA passed to as processed and continue processing other vma's in the
> vector list. Returning -ENOMEM to user, despite the VMA is processed,
> will be unable to figure out where to start the next madvise.

I am not sure I follow. With your previous patch and -ENOMEM from
do_madvise you get the the answer you are looking for, no?
With this applied you are loosing the information that some of the iters
are not mapped or has a hole. Which might be a useful information
especially when processing on remote tasks which are free to manipulate
their address spaces.

> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> ---
> Changes in V2:
>   -- Fixed handling of ENOMEM by process_madvise().
>   -- Patch doesn't exist in V1.
> 
>  mm/madvise.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index e97e6a9..14fb76d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1426,9 +1426,16 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>  
>  	while (iov_iter_count(&iter)) {
>  		iovec = iov_iter_iovec(&iter);
> +		/*
> +		 * do_madvise returns ENOMEM if unmapped holes are present
> +		 * in the passed VMA. process_madvise() is expected to skip
> +		 * unmapped holes passed to it in the 'struct iovec' list
> +		 * and not fail because of them. Thus treat -ENOMEM return
> +		 * from do_madvise as valid and continue processing.
> +		 */
>  		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
>  					iovec.iov_len, behavior);
> -		if (ret < 0)
> +		if (ret < 0 && ret != -ENOMEM)
>  			break;
>  		iov_iter_advance(&iter, iovec.iov_len);
>  	}
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
