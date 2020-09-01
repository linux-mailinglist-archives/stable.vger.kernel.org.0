Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAF525A11B
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgIAWBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:01:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35996 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgIAWBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 18:01:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id p37so1438412pgl.3
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 15:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Usj/YrrYooLFBIiEKYdngINfSiSPMYMA+NEAbatcIM=;
        b=SpH8ODIIztcrtj/kYWW6XeyyKqONn2FHfACELBj+wYof6nQm3Hr2vEv7Tr/anjD8xB
         KIg2nUXvWLapnDUaiuUACK+8u2LGeEk1xsUiEbsd4gx1y1v6n/PdQGHfk9qJEVlJYmG3
         jZKpXKUC/o6iXwpM4RUiVKyLjOKYnmJD1ZBhrkzCcs/QVbpT70SwHWvh9Dhg+lLXBY+Q
         BZ8Jr1/UfFqoqJEGOEhjyeiKuKGBkx3IefHA3KVEgTdD8m75ohKyP3N0fUs4Ts6v0BfR
         D4aUsb/ASZKV9XaydhiDTNi1rSx2saNPNM0km3a8dNDsKeGUsJZKx3MK05BmISdk+Pch
         7wAg==
X-Gm-Message-State: AOAM533Q5awsO1hHJIMm/8Ma2ytqHR19d0ifA6gWTCwE9OuWXbLuO7Qd
        YojsjBfJQKhDTrjjBQb+IXM=
X-Google-Smtp-Source: ABdhPJyJVERwgPjzzt/aocsS1WdB0fk1euLPdtFD/GBVuYfnrWc9rN0D2etp2qHL261lyQ2CQXkmfA==
X-Received: by 2002:a62:82c3:: with SMTP id w186mr210319pfd.287.1598997681066;
        Tue, 01 Sep 2020 15:01:21 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:61c1:4660:c489:2347? ([2601:647:4802:9070:61c1:4660:c489:2347])
        by smtp.gmail.com with ESMTPSA id p9sm3167195pgb.48.2020.09.01.15.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:01:20 -0700 (PDT)
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with teardown
 flow
To:     James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org
Cc:     Israel Rukshin <israelr@mellanox.com>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200828190150.34455-1-james.smart@broadcom.com>
 <0867c437-1521-c0c9-d7fa-6a615d88105a@grimberg.me>
 <a73cd06b-b319-d55f-1465-4263e08900ae@broadcom.com>
 <741ec2a7-7a38-9432-33fb-58227bf1f1f1@grimberg.me>
 <7f43e9db-974a-5e98-76a6-ed2f3bd0dc92@broadcom.com>
 <4aaad97e-03b5-5c22-af8e-ae7624e78991@grimberg.me>
 <f7d0c08f-2a34-fffa-7962-d0641bc579fd@broadcom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <7e78b2e6-d103-23a1-a9ab-d12336a9c089@grimberg.me>
Date:   Tue, 1 Sep 2020 15:01:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f7d0c08f-2a34-fffa-7962-d0641bc579fd@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>>>> This is indeed a regression.
>>>>>>
>>>>>> Perhaps we should also revert:
>>>>>> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more 
>>>>>> than transport lookups")
>>>>>>
>>>>>> Which inherently caused this by removing the serialization of
>>>>>> .create_ctrl()...
>>>>>
>>>>> no, I believe the patch on the semaphore is correct. Otherwise - 
>>>>> things can be blocked a long time.. a minute (1 cmd timeout) or 
>>>>> even multiple minutes in the case where a command failure in core 
>>>>> layers effectively gets ignored and thus doesn't cause the error 
>>>>> path in the transport. There can be multiple /dev/nvme-fabrics 
>>>>> commands stacked up that can make the delays look much longer to 
>>>>> the last guy.
>>>>>
>>>>> as far as creation vs teardown... yeah, not fun, but there are 
>>>>> other ways to deal with it. FC: I got rid of the separate 
>>>>> create/reconnect threads a while ago thus the 
>>>>> return-control-while-reconnecting behavior, so I've had to deal 
>>>>> with it.  It's one area it'd be nice to see some convergence in 
>>>>> implementation again between transports.
>>>>
>>>> Doesn't fc have a bug there? in create_ctrl after flushing the
>>>> connect_work, what is telling it if delete is running in with it
>>>> (or that it already ran...)
>>>
>>> I guess I don't understand what the bug is you are thinking about. 
>>> Maybe there's a short period that the ctrl ptr is perhaps freed, thus 
>>> the pointer shouldn't be used - but I don't see it as almost 
>>> everything is simply looking at  the value of the pointer, not 
>>> dereferencing it.
>>
>> I'm referring to nvme_fc_init_ctrl, if delete happens while it
>> is waiting in flush_delayed_work(&ctrl->connect_work); won't you
>> dereference and return a controller that is possibly already
>> deleted/freed?
> 
> ok - that matches my "short period" and it is possible as there's one 
> immediate printf that may dereference the ptr. After that, it's 
> comparisons of the pointer value.  I can move the printf to avoid the 
> issue.  That window's rather small.

But you also return back &ctrl->ctrl, that is another dereference, and
what will make ctrl to be an ERR_PTR?

Anyway, we should probably come up with something more robust...

>>> I do have a bug or two  with delete association fighting with 
>>> create_association - but it's mainly due to nvme_fc_error_recovery 
>>> not the delete routine. I've reworked this area after seeing your 
>>> other patches and will be posting after some more testing.  But no 
>>> reason for synchronizing all ctrl creates.
>>
>> Is it that big of an issue? it should fail rather quickly shouldn't it?
> 
> not sure what you are asking.   if it's how long to fail the creation of 
> a new association - it's at least 60s (an admin command timeout).

That's the worst case (admin command timeout), but is it the most common
case?

Would making the timeouts shorter in the initial connect make sense?
Just throwing out ideas...
