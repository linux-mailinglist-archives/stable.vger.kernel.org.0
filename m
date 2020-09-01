Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396802596F1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgIAQIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgIAPjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 11:39:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C24C061245
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 08:39:04 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o16so811161pjr.2
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RRYvOyhoaQLRQoFkDFrEsXiZ7Zuv9koBevcFN6f7MdA=;
        b=fb4BLgz31jdUT+jWAnohNdHQUwUJHxaFUJt0+J/RU5BfLmW2fBf7g1HNkJyalHzIsh
         +yIjNhMhHBR2fimg4rDDSLiHuGeltYKKuhkBwlic4kPNOmCz2LDdDGqvDrI2s/HWsh+5
         D2oKM4a3iwbdfb59An1vtscw4AddW1xUYG/Nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RRYvOyhoaQLRQoFkDFrEsXiZ7Zuv9koBevcFN6f7MdA=;
        b=EL8b9ynZ7zvvsEqsskv0PzuH+2+YunfP1SiDemtsgvGJOtrsSAdQYX9CuwYC7Tmmol
         yauKxclAtaob9LiBBenu2FrBkbPatqYCpv2JlZhFcOUM3FeYSeQfbbuwPNI1d4+fE1JV
         RMfKDUqq66slsIR5VYe2g4SrRXmScTPolPEJO8bpLeS5bcGqCAZTyXKVC8zhohyXia3h
         v+dvxKvzlFNDUFoFBzm2E81w8TVJ0x2jezIXqcz/PBLANCRB1w9UjwH8V0yC3Q04bO8M
         MIHE2PCZwO81cVkauxefEIXXhZP5Krb0EXn+kfvVq+1NJU4t+XHrm7huHE2lHvK77HO+
         85uQ==
X-Gm-Message-State: AOAM532ibp0FKYQQNGSv5Q5ps0+jEus0jthVF1fPnhjFv6G+3q6Azfvz
        PZ3ITAGBx31gZjfV6F4fckAbvw==
X-Google-Smtp-Source: ABdhPJyuz29Q+A2EIyORe/+mF4K2G3GRqfvu/UuqUbugW3UoA4t0xljuSeaKWLOccqV8dP30q6tVBQ==
X-Received: by 2002:a17:902:6841:: with SMTP id f1mr1897802pln.228.1598974744061;
        Tue, 01 Sep 2020 08:39:04 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id d15sm2424063pfr.143.2020.09.01.08.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 08:39:03 -0700 (PDT)
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with teardown
 flow
To:     Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org
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
From:   James Smart <james.smart@broadcom.com>
Message-ID: <f7d0c08f-2a34-fffa-7962-d0641bc579fd@broadcom.com>
Date:   Tue, 1 Sep 2020 08:39:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <4aaad97e-03b5-5c22-af8e-ae7624e78991@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/31/2020 4:15 PM, Sagi Grimberg wrote:
>
>>>>> This is indeed a regression.
>>>>>
>>>>> Perhaps we should also revert:
>>>>> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more 
>>>>> than transport lookups")
>>>>>
>>>>> Which inherently caused this by removing the serialization of
>>>>> .create_ctrl()...
>>>>
>>>> no, I believe the patch on the semaphore is correct. Otherwise - 
>>>> things can be blocked a long time.. a minute (1 cmd timeout) or 
>>>> even multiple minutes in the case where a command failure in core 
>>>> layers effectively gets ignored and thus doesn't cause the error 
>>>> path in the transport. There can be multiple /dev/nvme-fabrics 
>>>> commands stacked up that can make the delays look much longer to 
>>>> the last guy.
>>>>
>>>> as far as creation vs teardown... yeah, not fun, but there are 
>>>> other ways to deal with it. FC: I got rid of the separate 
>>>> create/reconnect threads a while ago thus the 
>>>> return-control-while-reconnecting behavior, so I've had to deal 
>>>> with it.  It's one area it'd be nice to see some convergence in 
>>>> implementation again between transports.
>>>
>>> Doesn't fc have a bug there? in create_ctrl after flushing the
>>> connect_work, what is telling it if delete is running in with it
>>> (or that it already ran...)
>>
>> I guess I don't understand what the bug is you are thinking about. 
>> Maybe there's a short period that the ctrl ptr is perhaps freed, thus 
>> the pointer shouldn't be used - but I don't see it as almost 
>> everything is simply looking at  the value of the pointer, not 
>> dereferencing it.
>
> I'm referring to nvme_fc_init_ctrl, if delete happens while it
> is waiting in flush_delayed_work(&ctrl->connect_work); won't you
> dereference and return a controller that is possibly already
> deleted/freed?

ok - that matches my "short period" and it is possible as there's one 
immediate printf that may dereference the ptr. After that, it's 
comparisons of the pointer value.  I can move the printf to avoid the 
issue.  That window's rather small.


>
>> I do have a bug or two  with delete association fighting with 
>> create_association - but it's mainly due to nvme_fc_error_recovery 
>> not the delete routine. I've reworked this area after seeing your 
>> other patches and will be posting after some more testing.  But no 
>> reason for synchronizing all ctrl creates.
>
> Is it that big of an issue? it should fail rather quickly shouldn't it?

not sure what you are asking.   if it's how long to fail the creation of 
a new association - it's at least 60s (an admin command timeout).

-- james

