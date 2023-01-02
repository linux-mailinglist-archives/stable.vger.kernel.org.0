Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6765AD40
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 06:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjABFlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 00:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjABFlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 00:41:24 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203BE1153
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 21:41:22 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id az7so1061496wrb.5
        for <stable@vger.kernel.org>; Sun, 01 Jan 2023 21:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvJuMP+L/v0VaSUSwJcVqo54T4tBiI2lngCqwC2iFRY=;
        b=jdE+clNc/4TDQB8whIIyEl2ZSBNq5czPHTE9de0nJW2ABylXLDESIP47gOK+ETeBfV
         yPv9YmhZfMp4/MO/t/Pd9AQwbdpkYiy0yZQaHx9AyWss5NyTwJwp0l00YR6RZCdXyqXD
         7SaBlPu7Ct7rtHLV/zsIPdbZ6xmYILCwB+BJEhh+4Z2LHT9aerKZsfXbyxImb4HdF2Cr
         nmNSBvEcfroDdKaWzt1qBqoHyk5fNsHXLQjxl7Trd4q+b7ga53d21CxebVeiGubzl5vF
         WDG3+6HoQ9TniYJqiNx994VeG57FVOK+kcayF90vvY5Lpd/DHiv/9xeCzQy0hQVdpSAc
         7nCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvJuMP+L/v0VaSUSwJcVqo54T4tBiI2lngCqwC2iFRY=;
        b=z/XWzKHyJIMssQtigylNs5uXrzAU93mz1MifEcxNqr8Gx2hBVNJg+NZPrFSAfn85ls
         S872i90gkO8yTAXaHWSK+vUoIT0AZosWCqlbj8gL5EuaT81CpCLOsRizORRHgE0+HRAG
         +VYyEsNKeWZ1W3JEJcOkSwZt7kZlVDw6fZmQ0BW2CzcVP1CG4Nl/vt+No+ONhp3bRV92
         epkJ//Q80IHCgpAX2S5oxxmikGGZp0oDR9yH2xbcPyPFVKurUS5wcGTm/LkIBwtP+inf
         uro/xgkuDOi2e3n2lycLhev69EeuXF15qa+tHVQKLJw0mjqilCJxEnbEpKRc8otZ93Y8
         ZoUA==
X-Gm-Message-State: AFqh2kqtwJ+iFwm2QON5xPo5CTz6YvD/nQFNtt4qLNuBxQbFb9r1yPQ9
        vrhVDXJn42TynVKETmEU9u5kGg==
X-Google-Smtp-Source: AMrXdXs5EtV/UCpCmjN/PveRZ2nIvMPUeyMOlaloRrFdNtQBaE+E7PWBC6E4sF4JfGAlP/qwF7FfhA==
X-Received: by 2002:a5d:5908:0:b0:279:4938:eb98 with SMTP id v8-20020a5d5908000000b002794938eb98mr18309009wrd.11.1672638080618;
        Sun, 01 Jan 2023 21:41:20 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.242])
        by smtp.gmail.com with ESMTPSA id l17-20020adfe9d1000000b0024165454262sm27106850wrn.11.2023.01.01.21.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 21:41:20 -0800 (PST)
Message-ID: <f66ff338-f3ec-e7a3-5698-250b97511982@linaro.org>
Date:   Mon, 2 Jan 2023 07:41:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
 <Y66LkPumQjHC2U7d@sol.localdomain>
 <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
 <Y69E9DMEk+yEFDNQ@sol.localdomain>
Content-Language: en-US
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <Y69E9DMEk+yEFDNQ@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 30.12.2022 22:07, Eric Biggers wrote:
> On Fri, Dec 30, 2022 at 01:42:45PM +0200, Tudor Ambarus wrote:
>>
>> Seems that __ext4_iget() is not called on writes.
> 
> It is called when the inode is first accessed.  Usually that's when the file is
> opened.

Okay, thanks.

> 
> So the question is why didn't it validate the inode's extent header, or
> alternatively how did the inode's extent header get corrupted afterwards.
> 
>> You can find below the sequence of calls that leads to the bug.
> 
> A stack trace is not a reproducer.  Things must have happened before that point.
> 

I will try to dig more to understand what's happening. If you like to
take a look into the reproducer, here it is:
https://syzkaller.appspot.com/text?tag=ReproC&x=17beb560480000

The reproducer was used for Android 5.15 and the bug is reported at [1],
but as I mentioned earlier, using the same reproducer and config I hit
the bug on v6.2-rc1 as well.

Thanks for the help.
ta

[1] 
https://syzkaller.appspot.com/bug?id=be6e90ce70987950e6deb3bac8418344ca8b96cd
