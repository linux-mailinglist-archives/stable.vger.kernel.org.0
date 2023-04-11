Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983596DD0AB
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 06:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDKEJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 00:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDKEJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 00:09:22 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C723519BE;
        Mon, 10 Apr 2023 21:09:20 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PwXLx4KXqznbKw;
        Tue, 11 Apr 2023 12:05:45 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 12:09:18 +0800
Message-ID: <f58a438f-12e2-b3e2-2397-88a56e29d2b3@huawei.com>
Date:   Tue, 11 Apr 2023 12:09:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] writeback, cgroup: fix null-ptr-deref write in
 bdi_split_work_to_wbs
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <brauner@kernel.org>, <jack@suse.cz>, <tj@kernel.org>,
        <dennis@kernel.org>, <adilger.kernel@dilger.ca>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>, <houtao1@huawei.com>,
        <stable@vger.kernel.org>, Baokun Li <libaokun1@huawei.com>
References: <20230410130826.1492525-1-libaokun1@huawei.com>
 <20230410205317.dcb186166b9603eeb876dfda@linux-foundation.org>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <20230410205317.dcb186166b9603eeb876dfda@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/4/11 11:53, Andrew Morton wrote:
> On Mon, 10 Apr 2023 21:08:26 +0800 Baokun Li <libaokun1@huawei.com> wrote:
>
>> ...
>>
>> To solve this problem, percpu_ref_exit() is called under RCU protection
>> to avoid race between cgwb_release_workfn() and bdi_split_work_to_wbs().
>> Moreover, replace wb_get() with wb_tryget() in bdi_split_work_to_wbs(),
>> and skip the current wb if wb_tryget() fails because the wb has already
>> been shutdown.
>>
>> Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
>> Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
> Two Fixes: is awkward.  The Fixes: serves a guide to which kernel
> versions should be patched, but those two commits are six years apart.
>
> So... how far back should this fix be backported?
This issue was introduced in v4.3-rc7 by commit b817525a4a80 
("writeback: bdi_writeback iteration
must not skip dying ones"), so anything that has this commit 
incorporated is problematic.

Another fix tag patch invalidates a previously unintentional fix, and 
then the problem becomes more
easily reproducible. This fix tag can actually be removed, and is added 
here so that people who see
the patch will know what happened.

-- 
With Best Regards,
Baokun Li
.
