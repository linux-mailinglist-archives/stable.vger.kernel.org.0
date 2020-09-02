Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA225A29A
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 03:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBBX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 21:23:56 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:37662
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726122AbgIBBXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 21:23:55 -0400
Received: from [166.111.139.123] (unknown [166.111.139.123])
        by app-1 (Coremail) with SMTP id DwQGZQDnviIb9E5fYIv8AA--.33306S2;
        Wed, 02 Sep 2020 09:23:39 +0800 (CST)
Subject: Re: [PATCH 4.19 016/125] media: pci: ttpci: av7110: fix possible
 buffer overflow caused by bad DMA value in debiirq()
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150935.368387062@linuxfoundation.org>
 <20200901162512.GA30837@gofer.mess.org> <20200901163523.GA1458104@kroah.com>
 <20200901211626.GA17861@duo.ucw.cz>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <5c177bce-c7f8-6938-45a9-820d7d32e2e0@tsinghua.edu.cn>
Date:   Wed, 2 Sep 2020 09:23:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200901211626.GA17861@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: DwQGZQDnviIb9E5fYIv8AA--.33306S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw17tFyUXr4xWFWUWrWktFb_yoW8XF48pF
        W7KayrKFsYqrZFkryktwnYva40y3WYqryxXr1UZ3yUGwn0qFyayr4xGa13ua4qvrs5Ga4Y
        vF4jqasFg3yDZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfUOMKZDUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/9/2 5:16, Pavel Machek wrote:
> On Tue 2020-09-01 18:35:23, Greg Kroah-Hartman wrote:
>> On Tue, Sep 01, 2020 at 05:25:12PM +0100, Sean Young wrote:
>>> Greg,
>>>
>>> On Tue, Sep 01, 2020 at 05:09:31PM +0200, Greg Kroah-Hartman wrote:
>>>> From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
>>>>
>>>> [ Upstream commit 6499a0db9b0f1e903d52f8244eacc1d4be00eea2 ]
>>>>
>>>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
>>>> to data, and thus data[0] can be modified at any time by malicious
>>>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
>>>> data[0] can be changed into a large number, which may cause buffer
>>>> overflow when the code "av7110->ci_slot[data[0]]" is used.
>>>>
>>>> To fix this possible bug, data[0] is assigned to a local variable, which
>>>> replaces the use of data[0].
>>> See the discussion here:
>>>
>>> https://lkml.org/lkml/2020/8/31/479
>>>
>>> It does not seem worthwhile merging to the stable trees.
>> It doesn't hurt either :)
> Update stable kernel rules.
>
> If "patch does not match description and is pretty obviously useless"
> but "does not hurt" is acceptable for stable tree, people should know.
>
> You are pushing known junk into stable. Stop that.

Sorry for my useless patch...

Recently I submitted a new patch wiith READ_ONCE() to fix the problem 
that Pavel said:
https://lkml.org/lkml/2020/8/30/67

If you think this new patch is still useless, reverting the code is fine 
to me.


Best wishes,
Jia-Ju Bai

