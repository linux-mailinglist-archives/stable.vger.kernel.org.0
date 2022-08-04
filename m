Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC9589B9C
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiHDMVf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Aug 2022 08:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239722AbiHDMVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 08:21:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA42566115
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 05:21:24 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lz76d6brNzjXdN;
        Thu,  4 Aug 2022 20:18:17 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 20:21:21 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Thu, 4 Aug 2022 20:21:21 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "xuqiang (M)" <xuqiang36@huawei.com>
Subject: Re: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Topic: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Index: AQHYp/hdYJD7UJyWWUS8XlpsXQHo6Q==
Date:   Thu, 4 Aug 2022 12:21:21 +0000
Message-ID: <db905e93cc3242438820a144c44a1496@huawei.com>
References: <20220804111539.96424-1-chenjun102@huawei.com>
 <20220804111539.96424-3-chenjun102@huawei.com> <YuuyebRA0slDJVwx@kroah.com>
 <26cfcda29c38417e83ecd4e0e35297c3@huawei.com> <Yuu2+08EZ/ZwggJj@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.43]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/8/4 20:09, Greg KH 写道:
> On Thu, Aug 04, 2022 at 12:01:57PM +0000, chenjun (AM) wrote:
>> 在 2022/8/4 19:50, Greg KH 写道:
>>> On Thu, Aug 04, 2022 at 11:15:38AM +0000, Chen Jun wrote:
>>>> From: Helge Deller <deller@gmx.de>
>>>>
>>>> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
>>>>
>>>> We need to prevent that users configure a screen size which is smaller than the
>>>> currently selected font size. Otherwise rendering chars on the screen will
>>>> access memory outside the graphics memory region.
>>>>
>>>> This patch adds a new function fbcon_modechange_possible() which
>>>> implements this check and which later may be extended with other checks
>>>> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
>>>> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
>>>> for a too small screen size.
>>>>
>>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>>> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>> Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
>>>> [sudip: adjust context]
>>>
>>> Who is "sudip" here?
>>
>> Em..I misunderstood the meaning "sudip". I just mean I made some
>> contextual adjustments.
> 
> Then please use your name here when you resend them >
>>> And the Link: line wasn't in the original commit, where did that come
>>> from?
>>>
>>
>> The mainline commit appears to be from this link. Should I remove the link?
> 
> It is odd to see fields that are not in the upstream commit be added
> without any explaination (i.e. it's not an obvious signed-off-by
> addition), which is why I asked where it came from.
> 
> We can add these, but for some reason the upstream maintainer did not
> when applying it to their trees, so it's up to you if you want to dig up
> the information like this or not, it's not a trivial task at times.
> 
> thanks,
> 
> greg k-h
> 

Very thanks for your opinion.
I will sent v3.

-- 
Regards
Chen Jun
