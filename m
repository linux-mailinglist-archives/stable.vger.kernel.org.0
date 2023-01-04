Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4052C65CB66
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 02:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjADB1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 20:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjADB1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 20:27:39 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F52013F28;
        Tue,  3 Jan 2023 17:27:37 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NmsPS2MRmzRqZJ;
        Wed,  4 Jan 2023 09:26:04 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 09:27:35 +0800
Message-ID: <98dd7fd9-6060-b13a-96d4-9be91c477278@huawei.com>
Date:   Wed, 4 Jan 2023 09:27:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 1/2] ima: use the lsm policy update notifier
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <paul@paul-moore.com>, <linux-integrity@vger.kernel.org>,
        <luhuaxin1@huawei.com>
References: <20230103022011.15741-1-guozihua@huawei.com>
 <20230103022011.15741-2-guozihua@huawei.com>
 <a93e895499a32160298b19636ab3157c541aee88.camel@linux.ibm.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <a93e895499a32160298b19636ab3157c541aee88.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/4 2:50, Mimi Zohar wrote:
> On Tue, 2023-01-03 at 10:20 +0800, GUO Zihua wrote:
>> From: Janne Karhunen <janne.karhunen@gmail.com>
>>
>> [ Upstream commit b169424551930a9325f700f502802f4d515194e5 ]
>>
>> This patch is backported to resolve the issue of IMA ignoreing LSM part of
>> an LSM based rule. As the LSM notifier chain was an atomic notifier
>> chain, we'll not be able to call synchronize_rcu() within our notifier
>> handling function. Instead, we call the call_rcu() function to resolve
>> the freeing issue. To do that, we would needs to include a rcu_head
>> member in our rule, as well as wrap the call to ima_lsm_free_rule() into
>> a rcu_callback_t type callback function.
>>
>> Original patch message is as follows:
>>
>> commit b169424551930a9325f700f502802f4d515194e5
>> Author: Janne Karhunen <janne.karhunen@gmail.com>
>> Date:   Fri Jun 14 15:20:15 2019 +0300
>>
>>   Don't do lazy policy updates while running the rule matching,
>>   run the updates as they happen.
>>
>>   Depends on commit f242064c5df3 ("LSM: switch to blocking policy update
>>                                   notifiers")
>>
>>   Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
>>   Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>>
>> Cc: stable@vger.kernel.org #4.19.y
>> Signed-off-by: GUO Zihua <guozihua@huawei.com>
> 
> There was quite a bit of discussion regarding converting the atomic
> notifier to blocking, but this backport doesn't make that change.
> 
> Refer to 
> https://lore.kernel.org/linux-integrity/CAHC9VhS=GsEVUmxtiV64o8G6i2nJpkzxzpyTADgN-vhV8pzZbg@mail.gmail.com/
Well it seems that the bug mentioned here is still valid on 4.19.y.
Which is worrying. I'll try backporting the blocking notifier change as
well.
> 
> Mimi
> 

-- 
Best
GUO Zihua

