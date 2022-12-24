Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB6655848
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 04:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiLXDlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 22:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiLXDlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 22:41:51 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8193BE0EA;
        Fri, 23 Dec 2022 19:41:49 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nf8rl1vHKzJpRq;
        Sat, 24 Dec 2022 11:37:59 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 24 Dec 2022 11:41:47 +0800
Message-ID: <3a3da3e3-6bab-8aef-0e07-00bef8a13dce@huawei.com>
Date:   Sat, 24 Dec 2022 11:41:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Content-Language: en-US
From:   "Guozihua (Scott)" <guozihua@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>
CC:     <dmitry.kasatkin@gmail.com>, <sds@tycho.nsa.gov>,
        <eparis@parisplace.org>, Greg KH <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>, <selinux@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        <stable@vger.kernel.org>, luhuaxin <luhuaxin1@huawei.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
 <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com>
 <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
 <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com>
 <40cf70a96d2adbff1c0646d3372f131413989854.camel@linux.ibm.com>
 <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com>
 <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
 <CAHC9VhR2mfaVjXz3sBzbkBamt8nE-9aV+jSOs9jH1ESnKvDrvw@mail.gmail.com>
 <fc11076f-1760-edf3-c0e4-8f58d5e0335c@huawei.com>
 <CAHC9VhT0SRWMi2gQKaBPOj1owqUh-24O9L2DyOZ8JDgEr+ZQiQ@mail.gmail.com>
 <381efcb7-604f-7f89-e950-efc142350417@huawei.com>
 <6348a26f165c27c562db48eb39b04417cbe1380c.camel@linux.ibm.com>
 <944ea86a-2e6b-ce95-a6cb-fcf6b30ad78b@huawei.com>
 <578081a5-9ddd-b9bd-002d-f4f14bee79a3@huawei.com>
 <caa37e22-fed4-e3f1-d956-620e9c5ad648@huawei.com>
In-Reply-To: <caa37e22-fed4-e3f1-d956-620e9c5ad648@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/23 16:04, Guozihua (Scott) wrote:
> On 2022/12/21 18:51, Guozihua (Scott) wrote:
>> On 2022/12/20 9:11, Guozihua (Scott) wrote:
>>> On 2022/12/19 21:11, Mimi Zohar wrote:
>>>> On Mon, 2022-12-19 at 15:10 +0800, Guozihua (Scott) wrote:
>>>>> On 2022/12/16 11:04, Paul Moore wrote:
>>>>>> On Thu, Dec 15, 2022 at 9:36 PM Guozihua (Scott) <guozihua@huawei.com> wrote:
>>>>>>> On 2022/12/16 5:04, Paul Moore wrote:
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>> How bad is the backport really?  Perhaps it is worth doing it to see
>>>>>>>> what it looks like?
>>>>>>>>
>>>>>>> It might not be that bad, I'll try to post a version next Monday.
>>>>>>
>>>>>> Thanks for giving it a shot.
>>>>>>
>>>>> When I am trying a partial backport of b16942455193 ("ima: use the lsm
>>>>> policy update notifier"), I took a closer look into it and if we rip off
>>>>> the RCU and the notifier part, there would be a potential UAF issue when
>>>>> multiple processes are calling ima_lsm_update_rule() and
>>>>> ima_match_rules() at the same time. ima_lsm_update_rule() would free the
>>>>> old rule if the new rule is successfully copied and initialized, leading
>>>>> to ima_match_rules() accessing a freed rule.
>>>>>
>>>>> To reserve the mainline solution, we would have to either introduce RCU
>>>>> for rule access, which would work better with notifier mechanism or the
>>>>> same rule would be updated multiple times, or we would have to introduce
>>>>> a lock for LSM based rule update.
>>>>
>>>> Even with the RCU changes, the rules will be updated multiple times. 
>>>> With your "ima: Handle -ESTALE returned by ima_filter_rule_match()"
>>>> patch, upstream makes a single local copy of the rule to avoid updating
>>>> it multiple times.  Without the notifier, it's updating all the rules.
>>> That's true. However, in the mainline solution, we are only making a
>>> local copy of the rule. In 4.19, because of the lazy update mechanism,
>>> we are replacing the rule on the rule list multiple times and is trying
>>> to free the original rule.
>>>>
>>>> Perhaps an atomic variable to detect if the rules are already being
>>>> updated would suffice.  If the atomic variable is set, make a single
>>>> local copy of the rule.
>>> That should do it. I'll send a patch set soon.
>>>
>> Including Huaxin Lu in the loop. Sorry for forgotten about it for quite
>> some time.
>>
>> I tried the backported solution, it seems that it's causing RCU stall.
>> It seems on 4.19.y IMA is already accessing rules through RCU. Still
>> debugging it.
> It seems that after the backport, a NULL pointer deference pops out.
> I'll have to look into it.
> 
It seems that any other means except from a full RCU or locking won't be
able to prevent race condition between policy update and rule match. Any
other suggestions?

-- 
Best
GUO Zihua

