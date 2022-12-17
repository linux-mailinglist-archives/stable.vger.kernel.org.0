Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86B364F73A
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 03:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLQC7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 21:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQC7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 21:59:10 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8608EBF4F;
        Fri, 16 Dec 2022 18:59:09 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYrD73c80zqT0r;
        Sat, 17 Dec 2022 10:54:47 +0800 (CST)
Received: from [10.174.151.185] (10.174.151.185) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 17 Dec 2022 10:59:07 +0800
Subject: Re: [PATCH 1/2] mm/uffd: Fix pte marker when fork() without fork
 event
To:     Peter Xu <peterx@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     Andrea Arcangeli <aarcange@redhat.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, <stable@vger.kernel.org>
References: <20221214200453.1772655-1-peterx@redhat.com>
 <20221214200453.1772655-2-peterx@redhat.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <eeedfdcb-2f9a-86fb-ab62-32cdfaf5d289@huawei.com>
Date:   Sat, 17 Dec 2022 10:59:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20221214200453.1772655-2-peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.151.185]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/15 4:04, Peter Xu wrote:
> When fork(), dst_vma is not guaranteed to have VM_UFFD_WP even if src may
> have it and has pte marker installed.  The warning is improper along with
> the comment.  The right thing is to inherit the pte marker when needed, or
> keep the dst pte empty.
> 
> A vague guess is this happened by an accident when there's the prior patch
> to introduce src/dst vma into this helper during the uffd-wp feature got
> developed and I probably messed up in the rebase, since if we replace
> dst_vma with src_vma the warning & comment it all makes sense too.
> 
> Hugetlb did exactly the right here (copy_hugetlb_page_range()).  Fix the
> general path.
> 
> Reproducer:
> 
> https://github.com/xupengfe/syzkaller_logs/blob/main/221208_115556_copy_page_range/repro.c
> 
> Cc: <stable@vger.kernel.org> # 5.19+
> Fixes: c56d1b62cce8 ("mm/shmem: handle uffd-wp during fork()")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216808
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Looks good to me. Thanks.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks,
Miaohe Lin

