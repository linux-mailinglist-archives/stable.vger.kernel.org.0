Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D51145DF90
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344878AbhKYRYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbhKYRYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:24:10 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80EC061376
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:11:08 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c3so8341370iob.6
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DRbNy34LFTYJZ4PmJRBEOK4pAtCounE3z5hGbxu2tJw=;
        b=cmSSChLr0hznhgNLogLW3A9kM31FlaOruR25XArlP/11Dum3xcFjZegD3xEnXXlwL2
         EMPTDMwfyV6lf+kVt5X1L3c4SwHY07KSODoUFde9nIQZ1lz+Xe6EZIy8N0plW/OWtaOB
         vOT9FhcwUYMRujhDxOe90pWJsaVLFZGsCQuY6qx0DGDqGkHJ7ORYBBVuPVI0cOh5AwD/
         CnkmAYcq/OHitd0MDrbCIUQUjBQ5AjdRtVwPzt/l9nh/2dSrXwy7POOyr56fJpDmdw6S
         gU6oEUUe9P4H3rQymiuZ0rs4ptDj/SmzXUdVp+LSk9OkWguJ8Wnbs0n9+Q70dZSEpNE3
         2Wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRbNy34LFTYJZ4PmJRBEOK4pAtCounE3z5hGbxu2tJw=;
        b=E5DCk4rFQgp6BrZWdurZsv7fzEqqNGTTX2tbfgXOqDQfGBkA1QmSuy6AABqEHqAQHv
         0cGb604n0BmWyFeHwMkS2/P1l6ZX/iQ2nCJOcVPHJvSLAfJfz5mrJlSRY/g1yQ2lDJEJ
         m1ZPlxrN2OmwAmr3kYjD/ftnapodc/XEfIkBc1nCpTcNzLPHa+UawOLHV56b5JXSBd4F
         h0Izu5RF5SX6SWVSJjq1242d8EGMw1I0enC/+3FkMSFg9fIr/kWWG5uR8sbQvJO0plX2
         lUyZwX6w5+M0HRnuEi8DhtuUeg2eeZ3T4xEzW8TcIM2jYoJwTwfURWmR3EgRmMCgX1xi
         SOiw==
X-Gm-Message-State: AOAM531zK0M6ztscX/xc6JdvRHSSJOJDkGy5evbgfBM1GB+a6OMgZFWg
        4mgXJxRrl7Ehyjy1T5mV3GCcjQ0ay5Dd95X3
X-Google-Smtp-Source: ABdhPJy3qO38k+rwRNWfSIV8GHKZ0b4x3vzXuhrJ8iz4pX7oHJ0jXid6qB4LXMoKKQzmnI4WgdhqXQ==
X-Received: by 2002:a05:6638:2191:: with SMTP id s17mr32430885jaj.67.1637860267798;
        Thu, 25 Nov 2021 09:11:07 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h11sm1998376ili.30.2021.11.25.09.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 09:11:07 -0800 (PST)
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
 <6d6fc76f-880a-938d-64dd-527e6be3009e@kernel.dk>
 <5217de38-d166-de32-c115-fd34399eb234@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1714eba7-dfa7-b08c-dd29-ae4ea616041f@kernel.dk>
Date:   Thu, 25 Nov 2021 10:11:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5217de38-d166-de32-c115-fd34399eb234@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/21 9:35 AM, Stefan Metzmacher wrote:
> Am 25.11.21 um 01:58 schrieb Jens Axboe:
>> On 11/24/21 3:52 PM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>>>>> Looks good to me - Greg, would you mind queueing this up for
>>>>>> 5.14-stable?
>>>>>
>>>>> 5.14 is end-of-life and not getting any more releases (the front page of
>>>>> kernel.org should show that.)
>>>>
>>>> Oh, well I guess that settles that...
>>>>
>>>>> If this needs to go anywhere else, please let me know.
>>>>
>>>> Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
>>>> already has the patch.
>>>
>>> Are 5.11 and 5.13 are affected, these are hwe kernels for ubuntu,
>>> I may need to open a bug for them...
>>
>> Please do, then we can help get the appropriate patches lined up for
>> 5.11/13. They should need the same set, basically what ended up in 5.14
>> plus the one I posted today.
> 
> Ok, I've created https://bugs.launchpad.net/bugs/1952222
> 
> Let's see what happens...

Let me know if I can help, should probably prepare a set for 5.11-stable
and 5.13-stable, but I don't know if the above kernels already have some
patches applied past last stable release of each...

-- 
Jens Axboe

