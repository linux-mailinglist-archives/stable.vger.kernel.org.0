Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7520C2CEF86
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 15:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgLDON2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 09:13:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbgLDON2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 09:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607091121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RL2bFLco4OUYyECE8HrwusYryV87A7DYKEYnA7i6ltI=;
        b=JLl/FX8Kj6JviAaV+Suxf2wxkKYYgMmsXD7hCphJn0F4/9Q6eJiz/jz0nvnXXnxfhBZEzP
        wUufF80Odh4F7ZUM0bNi3qlw/5RrxpJ+1/6JgsfKgMuwiCA1qEwZv/9bBsK4KONtoJr4BI
        VGPKgTaQ/bgmFAq6ACIzlVmktHcS5eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-F5bqZjWtNOen7C0M1RJZVA-1; Fri, 04 Dec 2020 09:11:58 -0500
X-MC-Unique: F5bqZjWtNOen7C0M1RJZVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360A4107ACE6;
        Fri,  4 Dec 2020 14:11:57 +0000 (UTC)
Received: from [10.36.114.254] (ovpn-114-254.ams2.redhat.com [10.36.114.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47A7C1964B;
        Fri,  4 Dec 2020 14:11:55 +0000 (UTC)
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
To:     Liu Zixian <liuzixian4@huawei.com>, akpm@linux-foundation.org,
        linmiaohe@huawei.com, louhongxiang@huawei.com, linux-mm@kvack.org
Cc:     hushiyuan@huawei.com, stable@vger.kernel.org
References: <20201203085350.22624-1-liuzixian4@huawei.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
Date:   Fri, 4 Dec 2020 15:11:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203085350.22624-1-liuzixian4@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.12.20 09:53, Liu Zixian wrote:
> On success, mmap should return the begin address of newly mapped area,
> but patch "mm: mmap: merge vma after call_mmap() if possible"
> set vm_start of newly merged vma to return value addr.
> Users of mmap will get wrong address if vma is merged after call_mmap().
> We fix this by moving the assignment to addr before merging vma.
> 
> Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
> Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
> ---
> v2:
> We want to do "addr = vma->vm_start;" unconditionally,
> so move assignment to addr before if(unlikely) block.
> ---
>  mm/mmap.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index d91ecb00d38c..5c8b4485860d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>  		if (error)
>  			goto unmap_and_free_vma;
>  
> +		/* Can addr have changed??
> +		 *
> +		 * Answer: Yes, several device drivers can do it in their
> +		 *         f_op->mmap method. -DaveM
> +		 * Bug: If addr is changed, prev, rb_link, rb_parent should
> +		 *      be updated for vma_link()
> +		 */


Why do we tolerate device drivers doing such stuff at all?
WARN_ON_ONCE() is just as good as BUG_ON() in many environments. If we
support it, then no warning. If we don't support it, then why tolerate it?

Anyhow, unrelated to your patch

Reviewed-by: David Hildenbrand <david@redhat.com>



-- 
Thanks,

David / dhildenb

