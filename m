Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6445C9E0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhKXQZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348664AbhKXQZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 11:25:35 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10FBC06175C
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:22:17 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m9so4019976iop.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GX8R3seDFFcTdZihLtId/pnOciYQhUcd/QvMkMeTn0U=;
        b=DglVO79AH9SiBHPmRRSXep1ayYTA1xohiCwaqJCQUNZ8p/x9rKrshGgBrOLoRDcZNJ
         GL8BDy0i21ONyGEzFfwRHGSo3f8XgeaewArssJCdKr7dVMUViE3Z6ozOo4AtxTx51CeO
         Nr5qKSnv+tVtvDew8mhBDpP6SGhcKa5WBX1SXjDlrEJSv/208IEEXRqBaWg9I+a+UHDZ
         q0Ap+U07FiVMboSZxOrliOUKsP1KYasMDCmV5vTuH5slebDki5THECSAtr4gk+15rsfg
         LHHgi7lR7Avs9GG9HLdQf9u5jA2T+RVmSPgRT5attze3tqViJnpZo+/im6rqsTzBpWuQ
         byKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GX8R3seDFFcTdZihLtId/pnOciYQhUcd/QvMkMeTn0U=;
        b=242xC6QH9CdXONsnCK/TGttWj5VW2SNm2w8szqyylFZsEhcHBluNfSKwuJhtRdJjTp
         RMXR6kM45fFqEzXnqlR7PKvJipQhCUDz5wkMRfI/i7ugtBXJgQpbED8zDYEwA3GEoNvz
         g4AG+T8A5aOqYylk9rVOqOD9eDraK0mxkIKEVq6y6VbjSTRnex9vTP3eI2K0TP1jMyyB
         DbKZ/KI7tOxpXJqkmV7fob/jl2Hqd0FvLQmT98TOsfCCtgo9WQGGZ7AKHc5eqlddz7eK
         +fDuBBw0W1uaucESfz9KsApMoPI/QHD0RBLKfeyMqPXCOQLtjEeKAE2cuPSa/bhIppc7
         WHHg==
X-Gm-Message-State: AOAM530OMC3HnPZcmXfx4dISxk5CLNrXYoBP57xwTpULUoKhUe3Pohz7
        mphG0+IkOOn70iUbPZj6ZBq1hjILPfBvS3tC
X-Google-Smtp-Source: ABdhPJwBSGybvTA8tEQhbGJ0d4B5Ph2RKqURV9Kz5Vz8p6UP0uWNL1rPJfuu1v2UzNQZfpC0QNIUvg==
X-Received: by 2002:a05:6602:2ac5:: with SMTP id m5mr15784015iov.156.1637770936957;
        Wed, 24 Nov 2021 08:22:16 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v62sm175257iof.31.2021.11.24.08.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 08:22:16 -0800 (PST)
Subject: Re: uring regression - lost write request
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
Date:   Wed, 24 Nov 2021 09:22:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YZ5lvtfqsZEllUJq@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/21 9:18 AM, Greg Kroah-Hartman wrote:
> On Wed, Nov 24, 2021 at 09:10:25AM -0700, Jens Axboe wrote:
>> On 11/24/21 8:28 AM, Jens Axboe wrote:
>>> On 11/23/21 8:27 PM, Daniel Black wrote:
>>>> On Mon, Nov 15, 2021 at 7:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 11/14/21 1:33 PM, Daniel Black wrote:
>>>>>> On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> Alright, give this one a go if you can. Against -git, but will apply to
>>>>>>> 5.15 as well.
>>>>>>
>>>>>>
>>>>>> Works. Thank you very much.
>>>>>>
>>>>>> https://jira.mariadb.org/browse/MDEV-26674?page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel&focusedCommentId=205599#comment-205599
>>>>>>
>>>>>> Tested-by: Marko Mäkelä <marko.makela@mariadb.com>
>>>>>
>>>>> The patch is already upstream (and in the 5.15 stable queue), and I
>>>>> provided 5.14 patches too.
>>>>
>>>> Jens,
>>>>
>>>> I'm getting the same reproducer on 5.14.20
>>>> (https://bugzilla.redhat.com/show_bug.cgi?id=2018882#c3) though the
>>>> backport change logs indicate 5.14.19 has the patch.
>>>>
>>>> Anything missing?
>>>
>>> We might also need another patch that isn't in stable, I'm attaching
>>> it here. Any chance you can run 5.14.20/21 with this applied? If not,
>>> I'll do some sanity checking here and push it to -stable.
>>
>> Looks good to me - Greg, would you mind queueing this up for
>> 5.14-stable?
> 
> 5.14 is end-of-life and not getting any more releases (the front page of
> kernel.org should show that.)

Oh, well I guess that settles that...

> If this needs to go anywhere else, please let me know.

Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
already has the patch.

-- 
Jens Axboe

