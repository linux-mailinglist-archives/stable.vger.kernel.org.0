Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D5E2233
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 19:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbfJWR5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 13:57:55 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56119 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbfJWR5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 13:57:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Tg.GgAY_1571853465;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg.GgAY_1571853465)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 01:57:48 +0800
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
To:     Matthew Wilcox <willy@infradead.org>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
 <20191023172420.GB2963@bombadil.infradead.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <792ea136-4fa0-c87b-9399-5ca47c501c9c@linux.alibaba.com>
Date:   Wed, 23 Oct 2019 10:57:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20191023172420.GB2963@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/23/19 10:24 AM, Matthew Wilcox wrote:
> On Thu, Oct 24, 2019 at 01:05:04AM +0800, Yang Shi wrote:
>> +	return map_count >= 0 &&
>> +	       map_count == atomic_read(&head[1].compound_mapcount);
>>   }
> I didn't like Hugh's duplicate definition either.  May I suggest:

Thanks, Willy. It is fine to me. Will take it in v3.

>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2f2199a51941..3d0efd937d2b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -695,11 +695,6 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
>   
>   extern void kvfree(const void *addr);
>   
> -static inline atomic_t *compound_mapcount_ptr(struct page *page)
> -{
> -	return &page[1].compound_mapcount;
> -}
> -
>   static inline int compound_mapcount(struct page *page)
>   {
>   	VM_BUG_ON_PAGE(!PageCompound(page), page);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 2222fa795284..270aa8fd2800 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -221,6 +221,11 @@ struct page {
>   #endif
>   } _struct_page_alignment;
>   
> +static inline atomic_t *compound_mapcount_ptr(struct page *page)
> +{
> +	return &page[1].compound_mapcount;
> +}
> +
>   /*
>    * Used for sizing the vmemmap region on some architectures
>    */

