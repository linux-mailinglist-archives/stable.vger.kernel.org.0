Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3593A68B441
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 03:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBFCze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 21:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFCzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 21:55:33 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F98196BD;
        Sun,  5 Feb 2023 18:55:28 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P99mf3gdNzRrpv;
        Mon,  6 Feb 2023 10:53:06 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 6 Feb 2023 10:55:26 +0800
Message-ID: <6cb72764-29a3-73f1-cfe3-9e972d975333@huawei.com>
Date:   Mon, 6 Feb 2023 10:55:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure
 to 4.19
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <paul@paul-moore.com>, <luhuaxin1@huawei.com>
References: <20230201023952.30247-1-guozihua@huawei.com>
 <Y9vw6RhQ6KJ5+E1I@sashalap> <02723ce8-0ad4-7860-b76c-7d2b30710dcf@huawei.com>
 <Y9y7c5sEX5phLybE@kroah.com> <Y9y8cYNR6TnAjnHS@kroah.com>
 <Y9y9tiHoOCkSutJT@kroah.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y9y9tiHoOCkSutJT@kroah.com>
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

On 2023/2/3 15:54, Greg KH wrote:
> On Fri, Feb 03, 2023 at 08:49:05AM +0100, Greg KH wrote:
>> On Fri, Feb 03, 2023 at 08:44:51AM +0100, Greg KH wrote:
>>> On Fri, Feb 03, 2023 at 09:10:13AM +0800, Guozihua (Scott) wrote:
>>>> On 2023/2/3 1:20, Sasha Levin wrote:
>>>>> On Wed, Feb 01, 2023 at 10:39:49AM +0800, GUO Zihua wrote:
>>>>>> This series backports patches in order to resolve the issue discussed
>>>>>> here:
>>>>>> https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/
>>>>>>
>>>>>> This required backporting the non-blocking LSM policy update mechanism
>>>>>> prerequisite patches.
>>>>>
>>>>> Do we not need this on newer kernels? Why only 4.19?
>>>>>
>>>> Hi Sasha.
>>>>
>>>> The issue mentioned in this patch was fixed already in the newer kernel.
>>>> All three patches here are backports from mainline.
>>>
>>> Ok, now queued up, thanks.
>>
>> Nope, I've now dropped them all as you did not include the needed fix up
>> commits as well.  We can not add patches to the stable tree that are
>> known broken, right?
>>
>> How well did you test this?  I see at least 3 missing patches that you
>> should have had in this patch series for it to work properly.
> 
> Ah, you didn't even test this series, as it breaks the build
> as-submitted.
> 
> {sigh}
> 
> In order for us to take this, I think you need to find someone else who
> will validate your patch series _FIRST_ before submitting it to us.  And
> I want their tested-by on them validating that it did actually work (if
> for no other reason than to have someone else be willing to be
> responsible if things go bad.)
> 
> Breaking our builds and forcing me to point out missing patches is not
> how the stable kernel process works in any sane manner.
> 
> greg k-h
Sorry for the burden. Still trying to work out how things are done here.

It seems that when I test it out, it did not build with the allmodconfig
which would report an error. And by the "fixes up commit" I supposed it
mean the commits with the "Fixes" tag points to the three commits I
submitted.

I'll submit a new patch set soon, which would include the following
fixes commits.

Again, sorry for the burden.

-- 
Best
GUO Zihua

