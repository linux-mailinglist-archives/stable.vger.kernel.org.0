Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465C51F14CC
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 10:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgFHI5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 04:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgFHI5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 04:57:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD60C08C5C3;
        Mon,  8 Jun 2020 01:57:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jiDaO-0003uX-Ch; Mon, 08 Jun 2020 10:56:52 +0200
Date:   Mon, 8 Jun 2020 10:56:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel test robot <lkp@intel.com>,
        Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_pipapo: Disable preemption before getting
 per-CPU pointer
Message-ID: <20200608085652.GP28263@breakpoint.cc>
References: <45861d795de2db1494b40bb2cc13bb36b4dacf72.1591606165.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45861d795de2db1494b40bb2cc13bb36b4dacf72.1591606165.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> The lkp kernel test robot reports, with CONFIG_DEBUG_PREEMPT enabled:
[..]

> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 8b5acc6910fd..8c04388296b0 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1242,7 +1242,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
>  	}
>  
> -	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
> +	if (!*get_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
> +		put_cpu_ptr(m->scratch);
> +
>  		err = pipapo_realloc_scratch(m, bsize_max);
>  		if (err)
>  			return err;
> @@ -1250,6 +1252,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  		this_cpu_write(nft_pipapo_scratch_index, false);

Won't that mean that this_cpu_write() can occur on a different CPU than
the get_cpu_ptr() ptr check was done on?
