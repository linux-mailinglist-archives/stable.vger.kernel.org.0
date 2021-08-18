Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65A3F0935
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhHRQfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 12:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhHRQfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 12:35:44 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C171C0617AD
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 09:35:09 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so864147ooa.11
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 09:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=FsOxk8xEX3Y2k9eBNIFeNmSd4j8BBkPPy3JPmJxj3/A=;
        b=U6Cdj7fZ/XePCbSUaZ7pv7n0S7sZkSrrOrA9PbU1L8v/HM8wLDGFAtzaqmhZeRCQga
         j1SiL+lfuclQI80WNGXNb0vfYzs3GYQj/RJ4tWupVUBJHspqZqwi9kU88AP6qTfMHIDg
         /vIsALWorZO51q+BwrYTeQspOrHLJ5bBrTfawtFk3TR1fTrpcuMJTjXy2KumNBCw3k3X
         bIIAVYo2uhL/IO/3MbQK6Wh0OQd+7F+Rb9lhAvbbSrQa4EvJwpTW+rgsD/KHC5i+Jk8A
         ffiUGP1m/lge6y90sUevzKZJtzTSL9d2yvVoskChXQCqkKBDR2kx5Fxpapho1Hi2TfG9
         wvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=FsOxk8xEX3Y2k9eBNIFeNmSd4j8BBkPPy3JPmJxj3/A=;
        b=lx54tmapDmauiPAoXo3P4SmHSqld4LMbPEfubnF+wLyxm8WfsqInLiNNSbBBXKIeh+
         ciAgrJ4Qaei/vLN3592NYoUi5uL+3GZR9aNHVPq1uVslOCP5fnXdrvz0jhdB7CYzfG1f
         IuLcGHyl9txFKcP4MnXFzxZYkLTQLGd1hmZHpbmgBrUjP8ESDr80iYGjvgnCElePgRC8
         3M/Tkj15SigMy1H47jTWo5ORwEoe/961JdMEW44ElQCrYjUy5rkx6Ic1j6o787qNoyz1
         E9jJL7wduEgJOLciCJivj6O5qSyBFTV2OqqMnZDnVu++Pf/+Jy+PxBuE99+9zdr0aGKM
         6vSw==
X-Gm-Message-State: AOAM530JLgA9ZwZrFKUzWDAOPI7kU+s/AIpbWciuW0JTfPwL4a5vLh8O
        n9D0cRQt8qiDMiIlTLiWEpbr4Q==
X-Google-Smtp-Source: ABdhPJxVQCjOlNDLHatSHn/5DyaB1NIFWcKsb6VB8oS9/r0EckuXMuKL0P7R99uExi1pgZo6aBpaYQ==
X-Received: by 2002:a4a:3393:: with SMTP id q141mr1269993ooq.48.1629304508535;
        Wed, 18 Aug 2021 09:35:08 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id k21sm98571ots.53.2021.08.18.09.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 09:35:07 -0700 (PDT)
Date:   Wed, 18 Aug 2021 09:34:51 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Remove bogus VM_BUG_ON
In-Reply-To: <20210818144932.940640-1-willy@infradead.org>
Message-ID: <2197941-297c-f820-aa57-fb5167794fb1@google.com>
References: <20210818144932.940640-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 Aug 2021, Matthew Wilcox (Oracle) wrote:

> It is not safe to check page->index without holding the page lock.
> It can be changed if the page is moved between the swap cache and the
> page cache for a shmem file, for example.  There is a VM_BUG_ON below
> which checks page->index is correct after taking the page lock.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")

I don't mind that VM_BUG_ON_PAGE() being removed, but question whether
this Fixes anything, and needs to go to stable. Or maybe it's just that
the shmem example is wrong - moving shmem from page to swap cache does
not change page->index. Or maybe you have later changes in your tree
which change that and do require this. Otherwise, I'll have to worry
why my testing has missed it for six months.

Hugh

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/filemap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d1458ecf2f51..34de0b14aaa9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2033,17 +2033,16 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  	XA_STATE(xas, &mapping->i_pages, start);
>  	struct page *page;
>  
>  	rcu_read_lock();
>  	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
>  		if (!xa_is_value(page)) {
>  			if (page->index < start)
>  				goto put;
> -			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
>  			if (page->index + thp_nr_pages(page) - 1 > end)
>  				goto put;
>  			if (!trylock_page(page))
>  				goto put;
>  			if (page->mapping != mapping || PageWriteback(page))
>  				goto unlock;
>  			VM_BUG_ON_PAGE(!thp_contains(page, xas.xa_index),
>  					page);
> -- 
> 2.30.2
