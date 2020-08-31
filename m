Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA794258402
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 00:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHaW0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 18:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHaW0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 18:26:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488A1C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 15:26:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w7so1506770pfi.4
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 15:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AHy1YAS6RlDoUT2N+3NJGboSTZ+DcvCQzUBr7zdupzo=;
        b=NLLP+qDnBsVG5Q31LNRllvP81qOS6ZT1nEh4uMMhTNXvzgUh4BBqGVVGxYHdv/jThk
         FbQkBnhNF/5Let0TU9x5hV/r3EcRmAxnlG9k/ybOXvESLxHwMqVRwKbJI7YHOsM98cF0
         BzxdpjgykKFONfwjf6256DdvgWDvrectKcVzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AHy1YAS6RlDoUT2N+3NJGboSTZ+DcvCQzUBr7zdupzo=;
        b=j2MEQTlev1k0ZLFZFUfKj49nE2gAB33vGuzqEG80/GsCi8XMuK6bBI8gYWqF3cHBUv
         ss/NflF9C3tHfZj7nvQt1gfueol+yQAdhLYj0EwHCNpER958HtrxurrJa5oFUfyFCH5h
         Fgz1pxu1/+zehaku7aK0ABO8nUCHopKDUIb4JnqzU2wnfEeP281my7nxV45LFHbSOxhE
         HUOVPCGNHSpap+B/HAZZKpa2/TYCgZ79/X4sPySQXZx8gquHU2Q8oDjZRF7RiYIc5kDq
         POOI4HIfgXRA0Td2BQDGiq2SKl+aScXMAdcGD2EjQ0/8CXaHLlhCGF8Ls7jiA5zBHI6x
         rhsw==
X-Gm-Message-State: AOAM530AAGfxa/uasleMRWI2an2/3n3oqiBgD4x+N5ZMX2NkE5tqF0Pb
        qrfJvhLeJC73JUlkuT2pixsX3Q==
X-Google-Smtp-Source: ABdhPJz0W8SN3s8UNhDlUaFJJNAYHIq/dDMZ/K6Sx0zTNMY17KmgTKYyfyLimSf6cVGgyanwbW+lEA==
X-Received: by 2002:a63:4b61:: with SMTP id k33mr2809010pgl.195.1598912791532;
        Mon, 31 Aug 2020 15:26:31 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id r2sm4466288pga.94.2020.08.31.15.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 15:26:30 -0700 (PDT)
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
From:   James Smart <james.smart@broadcom.com>
Message-ID: <7f43e9db-974a-5e98-76a6-ed2f3bd0dc92@broadcom.com>
Date:   Mon, 31 Aug 2020 15:26:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <741ec2a7-7a38-9432-33fb-58227bf1f1f1@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/28/2020 4:59 PM, Sagi Grimberg wrote:
>
>>> This is indeed a regression.
>>>
>>> Perhaps we should also revert:
>>> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more than 
>>> transport lookups")
>>>
>>> Which inherently caused this by removing the serialization of
>>> .create_ctrl()...
>>
>> no, I believe the patch on the semaphore is correct. Otherwise - 
>> things can be blocked a long time.. a minute (1 cmd timeout) or even 
>> multiple minutes in the case where a command failure in core layers 
>> effectively gets ignored and thus doesn't cause the error path in the 
>> transport. There can be multiple /dev/nvme-fabrics commands stacked 
>> up that can make the delays look much longer to the last guy.
>>
>> as far as creation vs teardown... yeah, not fun, but there are other 
>> ways to deal with it. FC: I got rid of the separate create/reconnect 
>> threads a while ago thus the return-control-while-reconnecting 
>> behavior, so I've had to deal with it.  It's one area it'd be nice to 
>> see some convergence in implementation again between transports.
>
> Doesn't fc have a bug there? in create_ctrl after flushing the
> connect_work, what is telling it if delete is running in with it
> (or that it already ran...)

I guess I don't understand what the bug is you are thinking about. Maybe 
there's a short period that the ctrl ptr is perhaps freed, thus the 
pointer shouldn't be used - but I don't see it as almost everything is 
simply looking at  the value of the pointer, not dereferencing it.

I do have a bug or two  with delete association fighting with 
create_association - but it's mainly due to nvme_fc_error_recovery not 
the delete routine. I've reworked this area after seeing your other 
patches and will be posting after some more testing.  But no reason for 
synchronizing all ctrl creates.

-- james

