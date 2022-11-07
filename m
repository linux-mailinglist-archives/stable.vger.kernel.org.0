Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1E61E877
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 03:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKGCBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 21:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKGCBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 21:01:41 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F72DEB8;
        Sun,  6 Nov 2022 18:01:38 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5Ds12pM8zpWCN;
        Mon,  7 Nov 2022 09:57:57 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:01:34 +0800
Message-ID: <230c5303-2aed-7c36-3147-2c05361067ef@huawei.com>
Date:   Mon, 7 Nov 2022 10:01:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] ext4: fix use-after-free in ext4_ext_shift_extents
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
CC:     <lczerner@redhat.com>, <chengzhihao1@huawei.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <ritesh.list@gmail.com>, <stable@vger.kernel.org>,
        <adilger.kernel@dilger.ca>, <yebin10@huawei.com>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
References: <20220922120434.1294789-1-libaokun1@huawei.com>
 <166450797717.256913.12979997291945870141.b4-ty@mit.edu>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <166450797717.256913.12979997291945870141.b4-ty@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/9/30 11:19, Theodore Ts'o wrote:
> On Thu, 22 Sep 2022 20:04:34 +0800, Baokun Li wrote:
>> If the starting position of our insert range happens to be in the hole
>> between the two ext4_extent_idx, because the lblk of the ext4_extent in
>> the previous ext4_extent_idx is always less than the start, which leads
>> to the "extent" variable access across the boundary, the following UAF is
>> triggered:
>> ==================================================================
>> BUG: KASAN: use-after-free in ext4_ext_shift_extents+0x257/0x790
>> Read of size 4 at addr ffff88819807a008 by task fallocate/8010
>> CPU: 3 PID: 8010 Comm: fallocate Tainted: G            E     5.10.0+ #492
>> Call Trace:
>>   dump_stack+0x7d/0xa3
>>   print_address_description.constprop.0+0x1e/0x220
>>   kasan_report.cold+0x67/0x7f
>>   ext4_ext_shift_extents+0x257/0x790
>>   ext4_insert_range+0x5b6/0x700
>>   ext4_fallocate+0x39e/0x3d0
>>   vfs_fallocate+0x26f/0x470
>>   ksys_fallocate+0x3a/0x70
>>   __x64_sys_fallocate+0x4f/0x60
>>   do_syscall_64+0x33/0x40
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> ==================================================================
>>
>> [...]
> Applied, thanks!
>
> [1/1] ext4: fix use-after-free in ext4_ext_shift_extents
>        (no commit info)
>
> Best regards,

Hi Theodore,

Could you tell me why this patch has been applied, but there is no cmmit 
info,

and the patch cannot be found on any branch?

-- 
With Best Regards,
Baokun Li

