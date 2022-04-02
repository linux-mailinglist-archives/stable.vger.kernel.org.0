Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9FC4EFDF7
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 04:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiDBCiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 22:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDBCiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 22:38:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E06F18460F;
        Fri,  1 Apr 2022 19:37:01 -0700 (PDT)
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KVh3C1kL4zgYK5;
        Sat,  2 Apr 2022 10:35:19 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 2 Apr 2022 10:36:59 +0800
Received: from [10.174.179.19] (10.174.179.19) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 2 Apr 2022 10:36:59 +0800
Message-ID: <6900c697-2eaa-9e91-4d37-7a11c71d021f@huawei.com>
Date:   Sat, 2 Apr 2022 10:36:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/2] hugetlb: Fix hugepages_setup when deal with
 pernode
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, <mike.kravetz@oracle.com>,
        <akpm@linux-foundation.org>, <yaozhenguo1@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20220401101232.2790280-1-liupeng256@huawei.com>
 <20220401101232.2790280-2-liupeng256@huawei.com>
 <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
From:   "liupeng (DM)" <liupeng256@huawei.com>
In-Reply-To: <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.19]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022/4/1 18:43, David Hildenbrand wrote:
> On 01.04.22 12:12, Peng Liu wrote:
>> Hugepages can be specified to pernode since "hugetlbfs: extend
>> the definition of hugepages parameter to support node allocation",
>> but the following problem is observed.
>>
>> Confusing behavior is observed when both 1G and 2M hugepage is set
>> after "numa=off".
>>   cmdline hugepage settings:
>>    hugepagesz=1G hugepages=0:3,1:3
>>    hugepagesz=2M hugepages=0:1024,1:1024
>>   results:
>>    HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
>>    HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages
>>
>> Furthermore, confusing behavior can be also observed when invalid
>> node behind valid node.
>>
>> To fix this, hugetlb_hstate_alloc_pages should be called even when
>> hugepages_setup going to invalid.
> Shouldn't we bail out if someone requests node-specific allocations but
> we are not running with NUMA?
>
> What's the result after your change?
>
>> Cc: <stable@vger.kernel.org>
> I am not sure if this is really stable material.

This change will make 1G-huge-page consistent with 2M-huge-page when
an invalid node is configured. After this patch, all per node huge pages
will allocate until an invalid node.

Thus, the basic question is "what will lead to an invalid node".
1) Some debugging and test cases as Mike suggested.
2) When part of physical memory or cpu is broken and bios not report
the node with physical damage, but still use the original grub.

