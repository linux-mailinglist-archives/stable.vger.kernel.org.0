Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9ACD5A5917
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 04:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiH3CEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 22:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiH3CEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 22:04:01 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE557A53E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:04:00 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MGrCn17mfzHnWv;
        Tue, 30 Aug 2022 10:02:13 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 10:03:58 +0800
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: avoid corrupting page->mapping
 in" failed to apply to 5.15-stable tree
To:     Axel Rasmussen <axelrasmussen@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <166175868922875@kroah.com>
 <CAJHvVcjuncHE_eG5aqxJTmtSeB0_z8DKssb34JzoSAgid0j2Fw@mail.gmail.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0c525090-4beb-9a94-301a-6da077eef5e5@huawei.com>
Date:   Tue, 30 Aug 2022 10:03:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAJHvVcjuncHE_eG5aqxJTmtSeB0_z8DKssb34JzoSAgid0j2Fw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/8/30 2:10, Axel Rasmussen wrote:
> On Mon, Aug 29, 2022 at 12:38 AM <gregkh@linuxfoundation.org> wrote:
>>
>>
>> The patch below does not apply to the 5.15-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> I'm in favor of applying this to 5.15. I can send a backport, unless
> someone else was already planning to do it (don't want to duplicate
> effort)?

That's very kind of you. Thanks for doing this.

Thanks,
Miaohe Lin

> 
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From ab74ef708dc51df7cf2b8a890b9c6990fac5c0c6 Mon Sep 17 00:00:00 2001
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> Date: Tue, 12 Jul 2022 21:05:42 +0800
>> Subject: [PATCH] mm/hugetlb: avoid corrupting page->mapping in
>>  hugetlb_mcopy_atomic_pte
>>
>> In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
>> cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
>> for them mistakenly because they're not vm_shared.  This will corrupt the
>> page->mapping used by page cache code.
>>
>> Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
>> Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: Axel Rasmussen <axelrasmussen@google.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 2480ba627aa5..e070b8593b37 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6041,7 +6041,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
>>         if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
>>                 goto out_release_unlock;
>>
>> -       if (vm_shared) {
>> +       if (page_in_pagecache) {
>>                 page_dup_file_rmap(page, true);
>>         } else {
>>                 ClearHPageRestoreReserve(page);
>>
> .
> 

