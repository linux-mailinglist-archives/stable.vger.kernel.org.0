Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CD75808F5
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 03:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiGZBOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 21:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbiGZBON (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 21:14:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EC6286EB;
        Mon, 25 Jul 2022 18:14:12 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LsJlc1wYpzkX63;
        Tue, 26 Jul 2022 09:11:40 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 09:14:10 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 09:14:10 +0800
Subject: Re: [PATCH 05/10] ext4: Fix race when reusing xattr blocks
To:     Jan Kara <jack@suse.cz>
CC:     Ted Tso <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        <stable@vger.kernel.org>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-5-jack@suse.cz>
 <0556811b-29f7-799b-66fc-87e4127cb714@huawei.com>
 <20220725152329.xleuy6quqsh2mtkn@quack3>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <aba0cf2a-57c1-699e-5fc8-dd1bddc240c5@huawei.com>
Date:   Tue, 26 Jul 2022 09:14:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20220725152329.xleuy6quqsh2mtkn@quack3>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/7/25 23:23, Jan Kara 写道:

>> So far, we have mb_cache_entry_delete_or_get() and
>> mb_cache_entry_wait_unused(), so used cache entry cannot be concurrently
>> removed. Removing check 'hlist_bl_unhashed(&ce->e_hash_list)' is okay.
>>
>> What's affect of changing the other two checks 'ref >=
>> EXT4_XATTR_REFCOUNT_MAX' and '!ce->e_reusable'? To make code more obvious?
>> eg. To point out the condition of 'ref <= EXT4_XATTR_REFCOUNT_MAX' rather
>> than 'ce->e_reusable', we have checked 'ce->e_reusable' in
>> ext4_xattr_block_cache_find() before?
> 
> Well, ce->e_reusable is set if and only if BHDR(new_bh)->h_refcount <
> EXT4_XATTR_REFCOUNT_MAX. So checking whether the refcount is small enough
> is all that is needed and we don't need the ce->e_reusable check here.
> 

Thanks for replying, I get it, thanks.

