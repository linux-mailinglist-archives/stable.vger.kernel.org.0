Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F4256390
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 01:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH1X7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 19:59:49 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39397 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgH1X7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 19:59:48 -0400
Received: by mail-pj1-f66.google.com with SMTP id s2so280172pjr.4
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 16:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WziFzy0mfIhNVjHu+MhHHDukksW7Q5B3x38ptCX1DtQ=;
        b=OjuJXl8O+scCiI/kcZ/wF10WHqiI8l3KgBfa+VvrPZuXQACyWw5+LVSJAP3I57ln0v
         PgSApRjWcBn30igGETl27ivSwHro8bkIMaLV6DOpXU4nqbISt/Z05OI8DrizeVrh5/bP
         59R324mE85/gd/8RjyYhUH2/vq9JtNz3KJlchSxHVxxEXINk99SiD0CE2/SfcV6p299m
         WNDOA5qzRtCyHyJryHcCFJ3nKHmI+BOEKZJIV2o787n+VTMVw3GQtpn4tGiRPeekouCv
         lM5gtGd2yvQbeNB37k8CoaPl9P7etL703uhdUYg12BWRi+xR2AVvGuntUMPw4AVMJMcE
         +5mA==
X-Gm-Message-State: AOAM532bX4ozhHc3CDHaGVvsuJasP3rwDsQ3tl1HniSR2hnqSQ8Gjexu
        IpSnu/uOuyuz01xHjaLWFFc=
X-Google-Smtp-Source: ABdhPJzklbH/I1vgnWTb4LZef7zTWIRLyWmJeXAizMb/jYOaS7dNZaQF06HLFbXG2vVZDWBSuxXwJg==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr980052plc.284.1598659188040;
        Fri, 28 Aug 2020 16:59:48 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:b43d:4be3:4cfb:fd9e? ([2601:647:4802:9070:b43d:4be3:4cfb:fd9e])
        by smtp.gmail.com with ESMTPSA id d131sm546927pgc.88.2020.08.28.16.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 16:59:47 -0700 (PDT)
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <741ec2a7-7a38-9432-33fb-58227bf1f1f1@grimberg.me>
Date:   Fri, 28 Aug 2020 16:59:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a73cd06b-b319-d55f-1465-4263e08900ae@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> This is indeed a regression.
>>
>> Perhaps we should also revert:
>> 12a0b6622107 ("nvme: don't hold nvmf_transports_rwsem for more than 
>> transport lookups")
>>
>> Which inherently caused this by removing the serialization of
>> .create_ctrl()...
> 
> no, I believe the patch on the semaphore is correct. Otherwise - things 
> can be blocked a long time.. a minute (1 cmd timeout) or even multiple 
> minutes in the case where a command failure in core layers effectively 
> gets ignored and thus doesn't cause the error path in the transport. 
> There can be multiple /dev/nvme-fabrics commands stacked up that can 
> make the delays look much longer to the last guy.
> 
> as far as creation vs teardown... yeah, not fun, but there are other 
> ways to deal with it. FC: I got rid of the separate create/reconnect 
> threads a while ago thus the return-control-while-reconnecting behavior, 
> so I've had to deal with it.  It's one area it'd be nice to see some 
> convergence in implementation again between transports.

Doesn't fc have a bug there? in create_ctrl after flushing the
connect_work, what is telling it if delete is running in with it
(or that it already ran...)
