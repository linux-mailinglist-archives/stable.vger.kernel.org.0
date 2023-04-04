Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497476D6D16
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 21:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDDT0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 15:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbjDDT0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 15:26:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851782D79;
        Tue,  4 Apr 2023 12:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21A6663913;
        Tue,  4 Apr 2023 19:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CBFC433D2;
        Tue,  4 Apr 2023 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680636361;
        bh=MGYgQ5Bh2P8Cc6or0I+ZKDCXT0ChcvmEjyPmkuyY6ZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gk0Oo0mSm++qDOHDzArLm/6KLAml4dXxc378kuLNpp6WlwW34I9ux+4rdH+D3wGfI
         /dsm74lRZT89ok+cPVq1VZ/vXmLAeBHXBn+WSwv1LlwPrDNwZZYPAYhtORxC4tmSWF
         BhRGjlOi6THsS1hSj5RHhhvb9gQLNciLUwiCKZBY=
Date:   Tue, 4 Apr 2023 12:26:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc:     bagasdotme@gmail.com, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff
 and get_swap_pages()
Message-Id: <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
In-Reply-To: <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
        <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  4 Apr 2023 23:47:16 +0800 Rongwei Wang <rongwei.wang@linux.alibaba.com> wrote:

> The si->lock must be held when deleting the si from
> the available list.
>
> ...
>
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -679,6 +679,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
>  {
>  	int nid;
>  
> +	assert_spin_locked(&p->lock);
>  	for_each_node(nid)
>  		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
>  }
> @@ -2434,8 +2435,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  		spin_unlock(&swap_lock);
>  		goto out_dput;
>  	}
> -	del_from_avail_list(p);
>  	spin_lock(&p->lock);
> +	del_from_avail_list(p);
>  	if (p->prio < 0) {
>  		struct swap_info_struct *si = p;
>  		int nid;

So we have

swap_avail_lock
swap_info_struct.lock
swap_cluster_info.lock

Is the ranking of these three clearly documented somewhere?


Did you test this with lockdep fully enabled?


I'm thinking that Aaron's a2468cc9bfdff ("swap: choose swap device
according to numa node") is the appropriate Fixes: target - do you
agree?


These functions use identifier `p' for the swap_info_struct*, whereas
most other code uses the much more sensible `si'.  That's just rude. 
But we shouldn't change that within this fix.

