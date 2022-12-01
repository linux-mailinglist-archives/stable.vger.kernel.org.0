Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B9B63E9CF
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 07:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiLAGUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 01:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAGUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 01:20:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AB7AB001;
        Wed, 30 Nov 2022 22:20:11 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NN5Wf65c3zHwP3;
        Thu,  1 Dec 2022 14:19:26 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 14:20:09 +0800
Message-ID: <f898b4d4-f1b2-ffc6-4859-39cc99459cce@huawei.com>
Date:   Thu, 1 Dec 2022 14:20:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
To:     Theodore Ts'o <tytso@mit.edu>
CC:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de> <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de> <Y4U18wly7K87fX9v@mit.edu>
 <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com> <Y4Zy2HHOmak3k637@mit.edu>
 <a448e298-dffd-e2f5-79b9-3997a4f53c92@huawei.com> <Y4guSv6wHI1i+3Cz@mit.edu>
Content-Language: en-US
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <Y4guSv6wHI1i+3Cz@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/1 12:32, Theodore Ts'o wrote:
> On Wed, Nov 30, 2022 at 11:20:11AM +0800, Baokun Li wrote:
>>> If we can protect against the problem by adding a check that has other
>>> value as well (such as making usre that when ext4_iget fetches a
>>> special inode, we enforce that i_links_couint must be > 0), maybe
>>> that's worth it.
>> Yes, but some special inodes allow i_links_couint to be zero,
>> such as the uninitialized boot load inode.
> That's a good point; but the only time when a special inode can
> validly have a zero i_links_count is when it has no blocks associated
> to it.  Otherwise, when the file system releases the inode using
> iput() when the file system is unmounted, all of the blocks will get
> released when the inode is evicted.  So we can have ext4_iget() allow
> fetching an inode if i_blocks[] is zeros.  But if it has any blocks
> and i_links_count is non-zero, something must be terribly wrong with
> that inode.
>
> Cheers,
>
> 					- Ted
>
Totally agree! That sounds good!

-- 
With Best Regards,
Baokun Li
.
