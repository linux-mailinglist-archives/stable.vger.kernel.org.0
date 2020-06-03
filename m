Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D391ED7FF
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 23:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCVUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 17:20:04 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36521 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCVUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 17:20:04 -0400
Received: by mail-pj1-f68.google.com with SMTP id q24so145128pjd.1
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 14:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IogVIzOEqU4BIVltUdwZ4gLyzFNyt+t7HFKEdmUttDE=;
        b=NBlza5oBP7YvK8MQwfcvb5iLbI7YBkr5DhUhxC7bt/TaJxPCN3dFbRZ0VBPduuvruU
         i0LgNSP3ce4fu+cFsY9uPICZ7jmDM0frSKyqGuL78YZ1jzCx6A1bu1ulT/8keEkMg8+k
         1EFyIHQB5Jp+4nRAqj/5lgJ0h+lR45Y7Y2KoqAmNqOgp938gNvajIG0X6Ja/H+hSXBNh
         9JzqXzgM1YSOrAzdnS+do3vgLxGeFFkTkMX+nL0uG7PLLzk5Bin7rS7jod3w9/yulVp8
         kUNTc/gqpzk9Z26xZuaIp5j5BCUfAoOmh5hhP74dP9ZekbdqOrWiwXPxzH4VsT04ujAu
         1tqQ==
X-Gm-Message-State: AOAM531/5cEEnpYfWVwCU6IiBNMwyzhqJAr1jFzMWuJ/Sc5qDiEJpNVW
        P/Qo0R7ne1zSB/pH8GkZhatv1szncEE=
X-Google-Smtp-Source: ABdhPJzI96khZI6MUjfLHEhIhocT8Ae8UmwhLwb/qfP5S48DT2fsE26bbyhpPadRuuL6FLS70yPFGA==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr1961147pjs.150.1591219203309;
        Wed, 03 Jun 2020 14:20:03 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:5409:1488:6d95:bdff? ([2601:647:4802:9070:5409:1488:6d95:bdff])
        by smtp.gmail.com with ESMTPSA id l25sm2276545pgn.19.2020.06.03.14.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 14:20:02 -0700 (PDT)
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
To:     Christoph Hellwig <hch@lst.de>,
        Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     eduard@hasenleithner.at, kbusch@kernel.org,
        gregkh@linuxfoundation.org, nirranjan@chelsio.com,
        bharat@chelsio.com, stable@vger.kernel.org
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200603130750.GA13511@lst.de> <20200603161717.GA11442@chelsio.com>
 <20200603162338.GA27240@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <6b58318c-fc41-66b9-b4d2-868d832392bb@grimberg.me>
Date:   Wed, 3 Jun 2020 14:20:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603162338.GA27240@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>> Err, why?  Please send an actual bug report with details of your
>>> setup.
>>
>> Hi Christoph,
>>
>> Here is the link describing the issue initially reported for upstream
>> kernel 5.5:
>>
>> https://lore.kernel.org/linux-nvme/CH2PR12MB40053A64681EFA3E6F63FDFBDD2A0@CH2PR12MB4005.namprd12.prod.outlook.com/
>>
>> Issue is later fixed with upstream commit b716e688.
> 
> We are talking about two different things here.  One is the Linux NVMe
> host code that can be used with lots of different controllers.  Many of
> them are PCIe controller, especially cheap ones.
> 
> The other is the Linux NVMe target code.  So if a fix for very common
> PCIe controller trigger a bug in the target code there is no 1:1
> relationship as even if you are talking to a Linux fabrics controller
> it usually runs a different kernel version on a different system.
> 
> That being said you can always backport that fix as well, which probably
> is a good idea as it fixes a real bug.
> 
> Nevermind that nothing in your revert patch indicated it wasn't for
> mainline.

Agree..
