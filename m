Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD46E6661
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjDRNve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDRNvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:51:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB88B5582;
        Tue, 18 Apr 2023 06:51:29 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [7.221.188.12])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q14zl6wnWzsRJd;
        Tue, 18 Apr 2023 21:49:55 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 21:51:25 +0800
Subject: Re: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency
 failures
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
 <20230415101158.1648486-2-cuigaosheng1@huawei.com>
 <2023041513-sloppily-external-4c18@gregkh>
 <3f6315cc-4684-2121-3556-0ace47c29b35@huawei.com>
 <2023041809-silicon-backspace-327d@gregkh>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <501026a4-f847-0153-4d15-f1e0278e39d7@huawei.com>
Date:   Tue, 18 Apr 2023 21:51:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2023041809-silicon-backspace-327d@gregkh>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2023/4/18 17:28, Greg KH wrote:
> On Sun, Apr 16, 2023 at 03:22:18PM +0800, cuigaosheng wrote:
>> On 2023/4/15 23:07, Greg KH wrote:
>>> On Sat, Apr 15, 2023 at 06:11:55PM +0800, Gaosheng Cui wrote:
>>>> From: Herbert Xu <herbert@gondor.apana.org.au>
>>>>
>>>> When complex algorithms that depend on other algorithms are built
>>>> into the kernel, the order of registration must be done such that
>>>> the underlying algorithms are ready before the ones on top are
>>>> registered.  As otherwise they would fail during the self-test
>>>> which is required during registration.
>>>>
>>>> In the past we have used subsystem initialisation ordering to
>>>> guarantee this.  The number of such precedence levels are limited
>>>> and they may cause ripple effects in other subsystems.
>>>>
>>>> This patch solves this problem by delaying all self-tests during
>>>> boot-up for built-in algorithms.  They will be tested either when
>>>> something else in the kernel requests for them, or when we have
>>>> finished registering all built-in algorithms, whichever comes
>>>> earlier.
>>>>
>>>> Reported-by: Vladis Dronov <vdronov@redhat.com>
>>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>>>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>>>> ---
>>>>    crypto/algapi.c   | 73 +++++++++++++++++++++++++++++++++--------------
>>>>    crypto/api.c      | 52 +++++++++++++++++++++++++++++----
>>>>    crypto/internal.h | 10 +++++++
>>>>    3 files changed, 108 insertions(+), 27 deletions(-)
>>> What is the git commit id of this, and the other 3 patches, in Linus's
>>> tree?  That is required to have here, as you know.
>>>
>>> thanks,
>>>
>>> greg k-h
>>> .
>> Thanks for taking time to review these patch.
>>
>> These patches are in Linus's tree, reference as follows:
>>    Reference 1: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=adad556efcdd42a1d9e060cbe5f6161cccf1fa28
>>    Reference 2: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cad439fc040efe5f4381e3a7d583c5c200dbc186
>>    Reference 3: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e42dff467ee688fe6b5a083f1837d06e3b27d8c0
>>    Reference 4: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=beaaaa37c664e9afdf2913aee19185d8e3793b50
> Please resend the patches with the git commit id in the changelog
> somewhere, as is normally done (there are thousands of examples on the
> mailing list.)
>
> Also be sure that you are also backporting the patches to newer kernel
> releases so that someone does not upgrade and have a regression (i.e. if
> a patch is also needed in 5.15.y send a backport for that too.)
>
> Thanks,
>
> greg k-h
> .


As I did more testing, I found that the patch set conflicted with SIMD,
so we needed a more appropriate solution to fix it, please ignore this
patch set, thanks.

Thanks for your time again!

