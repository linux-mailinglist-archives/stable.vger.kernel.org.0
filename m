Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6569C9FC
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjBTLjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBTLjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:39:02 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCEF35AC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:39:00 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vc6o5S0_1676893136;
Received: from 30.240.112.34(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Vc6o5S0_1676893136)
          by smtp.aliyun-inc.com;
          Mon, 20 Feb 2023 19:38:57 +0800
Message-ID: <229b741a-5fa4-4886-800e-445ff7471b87@linux.alibaba.com>
Date:   Mon, 20 Feb 2023 19:38:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH 0/6] hwpoison, shmem, hugetlb: fix data loss issue 5.10.y
To:     Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Language: en-US
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/24 AM3:54, Mike Kravetz wrote:
> This is a request for adding the following patches to stable 5.10.y.
> 
> Poisoned shmem and hugetlb pages are removed from the pagecache.
> Subsequent access to the offset in the file results in a NEW zero
> filled page.  Application code does not get notified of the data
> loss, and the only 'clue' is a message in the system log.  Data
> loss has been experienced by real users.
> 
> This was addressed upstream.  Most commits were marked for backports,
> but some were not.  This was discussed here [1] and here [2].
> 
> Patches apply cleanly to v5.4.224 and pass tests checking for this
> specific data loss issue.  LTP mm tests show no regressions.
> 
> All patches except 4 "mm: hwpoison: handle non-anonymous THP correctly"
> required a small bit of change to apply correctly: mostly for context.
> 
> linux-mm Cc'ed as it would be great to get at least an ACK from others
> familiar with this issue.
> 
> [1] https://lore.kernel.org/linux-mm/Y2UTUNBHVY5U9si2@monkey/
> [2] https://lore.kernel.org/stable/20221114131403.GA3807058@u2004/
> 
> James Houghton (1):
>   hugetlbfs: don't delete error page from pagecache
> 
> Yang Shi (5):
>   mm: hwpoison: remove the unnecessary THP check
>   mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
>   mm: hwpoison: refactor refcount check handling
>   mm: hwpoison: handle non-anonymous THP correctly
>   mm: shmem: don't truncate page if memory failure happens
> 
>  fs/hugetlbfs/inode.c       |  13 ++--
>  include/linux/page-flags.h |  23 ++++++
>  mm/huge_memory.c           |   2 +
>  mm/hugetlb.c               |   4 +
>  mm/memory-failure.c        | 153 ++++++++++++++++++++++++-------------
>  mm/memory.c                |   9 +++
>  mm/page_alloc.c            |   4 +-
>  mm/shmem.c                 |  51 +++++++++++--
>  8 files changed, 191 insertions(+), 68 deletions(-)
> 

Hi, folks

Thank you for your effort. Data loss will break the data consistency of
end users and it is critical to notify users.

I tried to apply this patch set to 5.10.168 stable release[1] and run
mm_regression[3] test cases following steps[4] provided by Naoya. All
four cases passed.

	#./run.sh project summary -p
	Project Name: debug
	PASS mm/hwpoison/shmem_link/link-hard.auto3
	PASS mm/hwpoison/shmem_link/link-sym.auto3
	PASS mm/hwpoison/shmem_rw/thp-always.auto3
	PASS mm/hwpoison/shmem_rw/thp-never.auto3
	Progress: 4 / 4 (100%)

Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>

Cheers,
Shuai

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tag/?h=v5.10.168
[2] https://github.com/nhoriguchi/mm_regression
[3] https://lore.kernel.org/stable/20221116235842.GA62826@u2004/
