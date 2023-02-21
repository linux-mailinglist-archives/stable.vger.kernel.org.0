Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6907869E06C
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 13:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjBUMbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 07:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjBUMbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 07:31:00 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992552943F
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:30:29 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PLdpt51h1z16Nlb;
        Tue, 21 Feb 2023 20:27:50 +0800 (CST)
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Feb 2023 20:30:18 +0800
Message-ID: <c815410b-dc86-dbaa-161f-3267d816c3f7@huawei.com>
Date:   Tue, 21 Feb 2023 20:30:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <peterz@infradead.org>, <keescook@chromium.org>,
        <sethjenkins@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, <bp@suse.de>,
        <stable@vger.kernel.org>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
 <Y/RzDvXr/iGpHl+f@kroah.com>
 <e2fea1a1-982d-20c8-d92c-bc4ed4d1d711@huawei.com>
 <Y/SDj9kdYrwoSYHh@kroah.com>
 <2c56661c-d2ca-d1b0-da69-89a5e1f3e67f@huawei.com>
 <Y/SfsU6rS0qraYhk@kroah.com>
From:   Tong Tiangen <tongtiangen@huawei.com>
In-Reply-To: <Y/SfsU6rS0qraYhk@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2023/2/21 18:40, Greg KH 写道:
> On Tue, Feb 21, 2023 at 05:19:42PM +0800, Tong Tiangen wrote:
>>
>>
>> 在 2023/2/21 16:40, Greg KH 写道:
>>> On Tue, Feb 21, 2023 at 03:46:27PM +0800, Tong Tiangen wrote:
>>>>
>>>>
>>>> 在 2023/2/21 15:30, Greg KH 写道:
>>>>> On Tue, Feb 21, 2023 at 03:19:05PM +0800, Tong Tiangen wrote:
>>>>>> Hi peter:
>>>>>>
>>>>>> Do you have any plans to backport this patch[1] to the stable branch of the
>>>>>> lower version, such as 4.19.y ?
>>>>>
>>>>> Why?  That is a new feature for 6.2 why would it be needed to fix
>>>>> anything in really old kernels?
>>>>
>>>> Hi Greg:
>>>>
>>>> This patch fix CVE-2023-0597[1],
>>>
>>> The kernel developers do not care about CVEs as they are almost always
>>> invalid and do not mean anything,
>>
>> Ok, thanks.
>>
>>
>>> sorry.  It is well known that, companies like Red Hat use them to make
>>> up for broken internal engineering policies.
>>
>> Yeah, For company's internal engineering policies, the CVE with certain
>> impact must be repaired.
> 
> So you are letting an opaque US government agency, and random third
> party companies, dictate your company's internal engineering policies
> and resource allocations?  That feels very very odd and ripe for abuse.
> 
> Also note that MITRE refuses to allocate CVEs for many real kernel
> issues for unknown reasons, (i.e. they reject all of my requests), so
> you are getting only a small subset of real issues here.
> 
> Also, how do you handle revocation of CVEs that are obviously invalid
> and/or don't actually do anything (like this one?)
> 
>>> Are you sure this really is a valid problem that must be fixed in older
>>> kernels?
>>>
>>>> this CVE report a flaw possibility of memory leak. And this is
>>>> important for some products using this stable version.
>>>
>>> What exact memory leak are you referring to?
>>
>> Sorry for Inaccurate description, the memory leak means: a potential
>> security risk of kernel memory information disclosure caused by no
>> randomization of the exception stacks.
> 
> And are you sure this can really happen?  Have you proven this?
> 
> And why is this really an issue, KASR is a known-week-defense and almost
> useless against local attacks.
> 
> Anyway, please provide working patches if you think this really is an
> issue.
> 
> And please revisit your company's policies, they do not seem very sane :)

Hi Greg:

Thanks for these very useful suggestions and we will revisit our policies :)

Thanks,
Tong
.

> 
> thanks,
> 
> greg k-h
> .
