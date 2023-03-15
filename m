Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25A6BA650
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 05:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCOEmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 00:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCOEmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 00:42:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2BF4608E
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 21:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=+fm5gg8/Uq1/hUSLsqOYKZ0U8+Rw/L1J+vCsy9qYulw=; b=PNMDtgDfbAKs7C81TxBZ7XX2IW
        vQYJN7bIcIcaqYIfNAYJNfsPJYgAMzBhcAQdu7HAk6CzE0MLJgU4Yq9VMj01zEV7obc/6+vU2rGbA
        QnV5EK3cgHvMqyUhG4v2DK5X6jguWC5CzFkFZ7g4GE1iahvvWqaCaMmEk7fesaHYcOiKASIH8I6bW
        1dUYUL89JoCsQeKyJ0w1xdk2Gwrhe8h4ND/oCvj66s8e4Ds7UFIpy7FQgxS1dHAS64J4ABN/pWU6f
        t1GDgQQkZO9aM1Cctd3kpTAefO23JazZSwEmWe2z1wBTVJTQZJta9AdB98sV1CRr0rfon4MplE3TD
        iL7hRT6g==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pcIxb-00CIsX-2K;
        Wed, 15 Mar 2023 04:41:59 +0000
Message-ID: <79fbd52a-9eff-d1d8-e607-41ff52261ad4@infradead.org>
Date:   Tue, 14 Mar 2023 21:41:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 073/211] swiotlb: mark swiotlb_memblock_alloc() as
 __init
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
        linux-mm@kvack.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20230310133718.689332661@linuxfoundation.org>
 <20230310133721.005935440@linuxfoundation.org>
 <2e14e654-e4f1-8c4a-a0ac-60f5e036659a@amd.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <2e14e654-e4f1-8c4a-a0ac-60f5e036659a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/14/23 01:54, Alexey Kardashevskiy wrote:
> 
> 
> On 11/3/23 00:37, Greg Kroah-Hartman wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> [ Upstream commit 9b07d27d0fbb7f7441aa986859a0f53ec93a0335 ]
>>
>> swiotlb_memblock_alloc() calls memblock_alloc(), which calls
>> (__init) memblock_alloc_try_nid(). However, swiotlb_membloc_alloc()
>> can be marked as __init since it is only called by swiotlb_init_remap(),
>> which is already marked as __init. This prevents a modpost build
>> warning/error:
>>
>> WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
>> WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
>>
>> This fixes the build warning/error seen on ARM64, PPC64, S390, i386,
>> and x86_64.
> 
> Did you do something special in your config to get these warnings? Or it is your toolchain? I tested with whatever comes with Ubuntu2210 and Fedora36 and neither printed the warning and I want to see those :-/ Thanks,
> 

I have no idea how I got these build warnings.  I am using gcc-12.2.0.
I don't know what .config file settings that I used.

I just tried about 6 different ARCH builds without this patch applied and I
cannot recreate the build warnings/errors.

Sorry I couldn't help you with this.

> 
>>
>> Fixes: 8d58aa484920 ("swiotlb: reduce the swiotlb buffer size on allocation failure")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Alexey Kardashevskiy <aik@amd.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: iommu@lists.linux.dev
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   kernel/dma/swiotlb.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
>> index a34c38bbe28f1..ef3bc3a5bbed3 100644
>> --- a/kernel/dma/swiotlb.c
>> +++ b/kernel/dma/swiotlb.c
>> @@ -300,7 +300,8 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>>       return;
>>   }
>>   -static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
>> +static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
>> +        unsigned int flags,
>>           int (*remap)(void *tlb, unsigned long nslabs))
>>   {
>>       size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
> 

-- 
~Randy
