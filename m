Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A63445D296
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 02:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346395AbhKYBvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 20:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346733AbhKYBtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 20:49:50 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD13C07E5E4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:58:23 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e144so5485964iof.3
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RLrd8YvXFk/NH6B4UNPf4BvxkmXNi5tB4hYOVCt3QC8=;
        b=xEYNVeKKngvVNXvxCecrhrF+dhCpI3JNYai0l9KnKgihJ0I01EUyn6342gfDHpPJIF
         /7q6wV2REhOJuHIb/lYLaWYERAKShYlGUyeC58Z4EhKW5k35o1PRcvba04e+kRFBUZLR
         GYYaVnPqgy0bVSbkIpRJx93kpqiqNwhtywyejvwyJ51PLSjA/jqcNOxItHGNkoaxuuqN
         5/TC5bAM75Yn0/SKiua018lB0Bbqxr2ffGz09uLiOkS2BEkaMIXtM3JiG9VfyLrL0Tc2
         eI1FDQifw26dYMM24XJlT0vZCnRwvcbdevwhW6CKZXtGH2W0fwWIaiauk7CVXbzaMuy+
         7Xfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RLrd8YvXFk/NH6B4UNPf4BvxkmXNi5tB4hYOVCt3QC8=;
        b=ev3BnmZMk9l7uOYrSXtGBjPC20Qm5NYOaTda1nFFLPCWR4KLEkRJxjyn6wwbF2U2wA
         f4s2xxt33FZEtcrV8DZy6PiSf0X24h7BRJWaLMRiB3MTQqqZFsg69GZb8R8T2AY5pC6R
         bl1edLK5bnwhlNIyhDiXPevnja+YK9KziPtdmJfqMjkg8wRMQrdbc51gw63oOb1zB5gr
         rt5ia5bn67kFvEQuMckFhxXaRtaVChlnhjvVELRqb3CNkrQ9Jz/rlXvCFoaXnmZDB4Ph
         +3QSzsRvnqUDMn56pV8AACe8KMUeey3j2beI00jFQfttS3gr2smflj0scFA/6dUZ+0QQ
         fYyA==
X-Gm-Message-State: AOAM5339uRI6meWMdaLWPHonOgz99QtmBFVpxbYwxSFvAjJucsFjPz1N
        05D76xVJh8XJU6e6CJot6zlXJsSy7gQSRA8D
X-Google-Smtp-Source: ABdhPJz5Il1xVb0xmrNpKE0GpQPqF5TiX+oAopQgozeU43W9y6HIqvacoAyp9oBIWo5k1qKNrwcjWg==
X-Received: by 2002:a05:6602:493:: with SMTP id y19mr20188734iov.126.1637801902921;
        Wed, 24 Nov 2021 16:58:22 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s3sm859302ilv.61.2021.11.24.16.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 16:58:22 -0800 (PST)
Subject: Re: uring regression - lost write request
To:     Stefan Metzmacher <metze@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel Black <daniel@mariadb.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org
References: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
 <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk>
 <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk> <YZ5lvtfqsZEllUJq@kroah.com>
 <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
 <96d6241f-7bf0-cefe-947e-ee03d83fb828@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d6fc76f-880a-938d-64dd-527e6be3009e@kernel.dk>
Date:   Wed, 24 Nov 2021 17:58:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <96d6241f-7bf0-cefe-947e-ee03d83fb828@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/21 3:52 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>>> Looks good to me - Greg, would you mind queueing this up for
>>>> 5.14-stable?
>>>
>>> 5.14 is end-of-life and not getting any more releases (the front page of
>>> kernel.org should show that.)
>>
>> Oh, well I guess that settles that...
>>
>>> If this needs to go anywhere else, please let me know.
>>
>> Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
>> already has the patch.
> 
> Are 5.11 and 5.13 are affected, these are hwe kernels for ubuntu,
> I may need to open a bug for them...

Please do, then we can help get the appropriate patches lined up for
5.11/13. They should need the same set, basically what ended up in 5.14
plus the one I posted today.

-- 
Jens Axboe

