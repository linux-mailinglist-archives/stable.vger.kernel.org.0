Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607E163B8AC
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 04:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiK2DSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 22:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiK2DSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 22:18:38 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339B427920;
        Mon, 28 Nov 2022 19:18:37 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NLnWG0ZxHzqSdp;
        Tue, 29 Nov 2022 11:14:34 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 11:18:35 +0800
Message-ID: <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com>
Date:   Tue, 29 Nov 2022 11:18:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
CC:     Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de> <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de> <Y4U18wly7K87fX9v@mit.edu>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <Y4U18wly7K87fX9v@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2022/11/29 6:28, Theodore Ts'o wrote:
> On Tue, Nov 08, 2022 at 02:06:29PM +0000, Luís Henriques wrote:
>>> What makes you believe that?  Look at how s_group_info is initialized
>>> in ext4_mb_alloc_groupinfo() in fs/ext4/mballoc.c.  It's pretty
>>> careful to make sure this is not the case.
>> Right.  I may be missing something, but I don't think we get that far.
>> __ext4_fill_super() will first call ext4_setup_system_zone() (which is
>> where this bug occurs) and only after that ext4_mb_init() will be invoked
>> (which is where ext4_mb_alloc_groupinfo() will eventually be called).
> I finally got around to taking a closer look at this, and I have a
> much better understandign of what is going on.  For more details, and
> a suggested fix, please see:
>
>       https://bugzilla.kernel.org/show_bug.cgi?id=216541#c1
>
> 						- Ted
>
>
Hi Theodore,

In my opinion, the s_journal_inum should not be modified when the file 
system is
mounted, especially after we have successfully loaded and replayed the 
journal with
the current s_journal_inum. Even if the s_journal_inumon the disk is 
modified, we should
use the current one. This is how journal_devnum is handled in 
ext4_load_journal():

          if (!really_read_only && journal_devnum &&
              journal_devnum != le32_to_cpu(es->s_journal_dev)) {
                  es->s_journal_dev = cpu_to_le32(journal_devnum);

                  /* Make sure we flush the recovery flag to disk. */
                  ext4_commit_super(sb);
          }

We can avoid this problem by adding a similar check for journal_inum in 
ext4_load_journal().

-- 
With Best Regards,
Baokun Li

