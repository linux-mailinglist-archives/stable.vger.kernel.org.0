Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B681734C30A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 07:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2FeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 01:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230161AbhC2Fdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 01:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8696195E;
        Mon, 29 Mar 2021 05:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616995665;
        bh=GLZptUcUHd16gmgYLTrd+kHb4iLGwLKXGX4UUUm31JM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2NbpdXuTS7uMSuM4rr2MUSFAJVQFOZ/7MC8jUVbdHH+Q0NSi38NEn4PykEt6oK3pI
         DyoBNBfDfGC/dbhMkSr+P7SXLhtXZZZgrNPfoo11JfNd5J3bvBRS0yJK43GaArnJGa
         868YHw1cC5eCSIo9Bx1NPr6e8TdYgdMLj8g4FxBU=
Date:   Mon, 29 Mar 2021 07:27:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     akpm@linux-foundation.org, chenweilong@huawei.com,
        dingtianhong@huawei.com, guohanjun@huawei.com, guro@fb.com,
        hannes@cmpxchg.org, kirill.shutemov@linux.intel.com,
        mhocko@suse.com, npiggin@gmail.com, rui.xiang@huawei.com,
        shakeelb@google.com, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, willy@infradead.org,
        zhouguanghui1@huawei.com, ziy@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: fix 5.10 backport of splitting page memcg
Message-ID: <YGFlTqxgZxlLUm6k@kroah.com>
References: <alpine.LSU.2.11.2103281706200.4623@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2103281706200.4623@eggly.anvils>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 28, 2021 at 05:13:13PM -0700, Hugh Dickins wrote:
> The straight backport of 5.12's e1baddf8475b ("mm/memcg: set memcg when
> splitting page") works fine in 5.11, but turned out to be wrong for 5.10:
> because that relies on a separate flag, which must also be set for the
> memcg to be recognized and uncharged and cleared when freeing. Fix that.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> 
>  mm/memcontrol.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3274,13 +3274,17 @@ void obj_cgroup_uncharge(struct obj_cgro
>  void split_page_memcg(struct page *head, unsigned int nr)
>  {
>  	struct mem_cgroup *memcg = head->mem_cgroup;
> +	int kmemcg = PageKmemcg(head);
>  	int i;
>  
>  	if (mem_cgroup_disabled() || !memcg)
>  		return;
>  
> -	for (i = 1; i < nr; i++)
> +	for (i = 1; i < nr; i++) {
>  		head[i].mem_cgroup = memcg;
> +		if (kmemcg)
> +			__SetPageKmemcg(head + i);
> +	}
>  	css_get_many(&memcg->css, nr - 1);
>  }
>  

Thanks for the fix, now queued up.

greg k-h
