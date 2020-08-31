Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A17258453
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 01:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgHaXPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 19:15:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55479 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgHaXP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 19:15:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id a65so977733wme.5
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 16:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=seRWaFKsJJwnBdgycHCuz2a6iCNGF+LkQ7CY/HVXfsU=;
        b=GUu2pp6eeAlhzwKX6JOzaCCsNE4wNcPsDiQ0VetrZMV+a3+ce7HFoZcUWgvlMjjhXL
         sq6nzrBthgLO39kJHRy97pmCYVsUWgdB93rtaWptJqP4u3P8SowYfstMtALSTr26dmj8
         OK3FmCdoDnMQHpbP6xpO7aFif8bcs3JQdNwAGzonNgF2V0mmeCcbayQIsk1wN9dxzKvA
         8YaIxlggx4lcipw37wTkRsQ2KYqEMjP2F55DNMxoN5uXRyMjhCFkPfWMxv22n6vQ206A
         L98B3V5X14paWxF9xWpdceky4sZtoiKUeL4fBG0NScDhc5ilhGqint5P6wcwh5uwDIly
         xMiw==
X-Gm-Message-State: AOAM531UnNXxc0M50A1KSKJanCQHSbO/c5gwbwvtp3YFOE9KVCqSClFl
        dF15/ndQttQr9o9NMKUGNo0=
X-Google-Smtp-Source: ABdhPJwjeTo1bu3yF5TVq02iSWppnI2TlBLv8tK8HdAUqLvuxHKeYPAgicSq6kx2aC+RS5mJPdtfhg==
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr1371306wmh.152.1598915727686;
        Mon, 31 Aug 2020 16:15:27 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:70b6:3990:a389:c0d1? ([2601:647:4802:9070:70b6:3990:a389:c0d1])
        by smtp.gmail.com with ESMTPSA id v24sm16254240wrd.6.2020.08.31.16.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:15:26 -0700 (PDT)
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <4aaad97e-03b5-5c22-af8e-ae7624e78991@grimberg.me>
Date:   Mon, 31 Aug 2020 16:15:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7f43e9db-974a-5e98-76a6-ed2f3bd0dc92@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>> This is indeed a regression.
>>>>
>>>> Perhaps we should also revert:
>>>> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more than 
>>>> transport lookups")
>>>>
>>>> Which inherently caused this by removing the serialization of
>>>> .create_ctrl()...
>>>
>>> no, I believe the patch on the semaphore is correct. Otherwise - 
>>> things can be blocked a long time.. a minute (1 cmd timeout) or even 
>>> multiple minutes in the case where a command failure in core layers 
>>> effectively gets ignored and thus doesn't cause the error path in the 
>>> transport. There can be multiple /dev/nvme-fabrics commands stacked 
>>> up that can make the delays look much longer to the last guy.
>>>
>>> as far as creation vs teardown... yeah, not fun, but there are other 
>>> ways to deal with it. FC: I got rid of the separate create/reconnect 
>>> threads a while ago thus the return-control-while-reconnecting 
>>> behavior, so I've had to deal with it.  It's one area it'd be nice to 
>>> see some convergence in implementation again between transports.
>>
>> Doesn't fc have a bug there? in create_ctrl after flushing the
>> connect_work, what is telling it if delete is running in with it
>> (or that it already ran...)
> 
> I guess I don't understand what the bug is you are thinking about. Maybe 
> there's a short period that the ctrl ptr is perhaps freed, thus the 
> pointer shouldn't be used - but I don't see it as almost everything is 
> simply looking at  the value of the pointer, not dereferencing it.

I'm referring to nvme_fc_init_ctrl, if delete happens while it
is waiting in flush_delayed_work(&ctrl->connect_work); won't you
dereference and return a controller that is possibly already
deleted/freed?

> I do have a bug or two  with delete association fighting with 
> create_association - but it's mainly due to nvme_fc_error_recovery not 
> the delete routine. I've reworked this area after seeing your other 
> patches and will be posting after some more testing.  But no reason for 
> synchronizing all ctrl creates.

Is it that big of an issue? it should fail rather quickly shouldn't it?
