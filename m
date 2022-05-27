Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C61535996
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 08:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiE0GtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 02:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiE0GtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 02:49:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C0B941A8;
        Thu, 26 May 2022 23:49:10 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L8b4Z3QVBzDqT6;
        Fri, 27 May 2022 14:49:02 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 14:49:08 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 27 May
 2022 14:49:08 +0800
Message-ID: <fd69f464-4cc9-859e-d38d-bda85e6b33a6@huawei.com>
Date:   Fri, 27 May 2022 14:49:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] locking/csd_lock: change csdlock_debug from
 early_param to __setup
Content-Language: en-US
To:     <paulmck@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arch@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <stable@vger.kernel.org>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <namit@vmware.com>, <gor@linux.ibm.com>,
        <rdunlap@infradead.org>, <mingo@kernel.org>, <jgross@suse.com>,
        <gregkh@linuxfoundation.org>, <mpe@ellerman.id.au>
References: <20220510094639.106661-1-chenzhongjin@huawei.com>
 <9b3e61b8-ecab-08ff-a3b6-83d6862ead77@huawei.com>
 <20220518011101.GK1790663@paulmck-ThinkPad-P17-Gen-1>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220518011101.GK1790663@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022/5/18 9:11, Paul E. McKenney wrote:
> On Tue, May 17, 2022 at 11:22:04AM +0800, Chen Zhongjin wrote:
>> On 2022/5/10 17:46, Chen Zhongjin wrote:
>>> csdlock_debug uses early_param and static_branch_enable() to enable
>>> csd_lock_wait feature, which triggers a panic on arm64 with config:
>>> CONFIG_SPARSEMEM=y
>>> CONFIG_SPARSEMEM_VMEMMAP=n
>>>
>>> With CONFIG_SPARSEMEM_VMEMMAP=n, __nr_to_section is called in
>>> static_key_enable() and returns NULL which makes NULL dereference
>>> because mem_section is initialized in sparse_init() which is later
>>> than parse_early_param() stage.
>>>
>>> For powerpc this is also broken, because early_param stage is
>>> earlier than jump_label_init() so static_key_enable won't work.
>>> powerpc throws an warning: "static key 'xxx' used before call
>>> to jump_label_init()".
>>>
>>> Thus, early_param is too early for csd_lock_wait to run
>>> static_branch_enable(), so changes it to __setup to fix these.
>>>
>>> Fixes: 8d0968cc6b8f ("locking/csd_lock: Add boot parameter for controlling CSD lock debugging")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Chen jingwen <chenjingwen6@huawei.com>
>>> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
>>> ---
>>> Change v3 -> v4:
>>> Fix title and description because this fix is also applied
>>> to powerpc.
>>> For more detailed arm64 bug report see:
>>> https://lore.kernel.org/linux-arm-kernel/e8715911-f835-059d-27f8-cc5f5ad30a07@huawei.com/t/
>>>
>>> Change v2 -> v3:
>>> Add module name in title
>>>
>>> Change v1 -> v2:
>>> Fix return 1 for __setup
>>> ---
>>>  kernel/smp.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/smp.c b/kernel/smp.c
>>> index 65a630f62363..381eb15cd28f 100644
>>> --- a/kernel/smp.c
>>> +++ b/kernel/smp.c
>>> @@ -174,9 +174,9 @@ static int __init csdlock_debug(char *str)
>>>  	if (val)
>>>  		static_branch_enable(&csdlock_debug_enabled);
>>>  
>>> -	return 0;
>>> +	return 1;
>>>  }
>>> -early_param("csdlock_debug", csdlock_debug);
>>> +__setup("csdlock_debug=", csdlock_debug);
>>>  
>>>  static DEFINE_PER_CPU(call_single_data_t *, cur_csd);
>>>  static DEFINE_PER_CPU(smp_call_func_t, cur_csd_func);
>>
>> Ping for review. Thanks！
> 
> I have pulled it into -rcu for testing and further review.  It might
> well need to go through some other path, though.
>> 								Thanx, Paul
> .

So did it have any result? Do we have any idea to fix that except delaying the
set timing? I guess that maybe not using static_branch can work for this, but it
still needs to be evaluated for performance influence of not enabled situation.

Best,
Chen

