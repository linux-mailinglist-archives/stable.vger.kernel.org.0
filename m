Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96C25B7F22
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 04:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiINC6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 22:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiINC6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 22:58:38 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283696AA29
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 19:58:37 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MS4jY3TRNzHntL;
        Wed, 14 Sep 2022 10:56:33 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 10:58:35 +0800
Received: from [10.67.110.146] (10.67.110.146) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 10:58:34 +0800
Subject: Re: Backport patch "mm: fix missing handler for __GFP_NOWARN" to
 linux-5.10.y
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
References: <38acddc1-143c-469e-c918-93b5589068c9@huawei.com>
 <Yxwv/82jkMjew4ZN@kroah.com>
 <164a48a0-b27f-7b0c-cf7e-b2c2cb75b78f@huawei.com>
 <YyBqfVDuSJ3K6tTg@kroah.com>
From:   Ye Weihua <yeweihua4@huawei.com>
Message-ID: <f1cc4244-94c8-1d97-6e27-344bb34cf1d5@huawei.com>
Date:   Wed, 14 Sep 2022 10:58:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YyBqfVDuSJ3K6tTg@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.67.110.146]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022/9/13 19:33, Greg KH wrote:
> On Tue, Sep 13, 2022 at 10:21:38AM +0800, Ye Weihua wrote:
>> On 2022/9/10 14:34, Greg KH wrote:
>>> On Fri, Sep 09, 2022 at 11:40:07AM +0800, Ye Weihua wrote:
>>>> The following patch is required to be patched in linux-5.10.y:
>>>>
>>>>
>>>>       3f913fc5f974 mm: fix missing handler for __GFP_NOWARN
>>>>
>>>>
>>>> Commit 6b9dbedbe349 ("tty: fix deadlock caused by calling printk() under
>>>> tty_port->lock")
>>>>
>>>> was backported to linux-5.10.y. But __GFP_NOWARN flag is still not check in
>>>> fail_dump(), and
>>>>
>>>> deadlock issues still occur.
>>>>
>>> What about all of the other stable kernel trees that the tty patch was
>>> backported to?  Do they also need the mm change as well?  That would
>>> include 4.9.y, 4.14.y, 4.19.y, 5.4.y, 5.10.y, and 5.15.y.
>> I checked the branches and found that the status of each branch was the
>> same. That is, the commit 6b9dbedbe349 ("tty: fix deadlock caused by calling
>> printk() under tty_port->lock") was backported but the commit 3f913fc5f974
>> ("mm: fix missing handler for __GFP_NOWARN") was not. Therefore, the problem
>> occurred in all branches. The commit "mm: fix missing handler for
>> __GFP_NOWARN" should be backported to 4.9.y, 4.14.y, 4.19.y, 5.4.y, 5.10.y,
>> and 5.15.y.
> Ok, can you provide a proper backport that has been tested for all of
> these branches as it does not apply cleanly as-is.
>
> Or we can revert the tty patch, which do you think is better?

Ok, I will send a backport for these branches soon. Thank you for the 
reminder.

