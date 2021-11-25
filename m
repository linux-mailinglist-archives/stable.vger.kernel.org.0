Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939EF45DEC5
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356646AbhKYQwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346102AbhKYQuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 11:50:08 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17383C06139B;
        Thu, 25 Nov 2021 08:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=KZ8p9IqkJMuifV3MoPHGueQyyLNb1ZlJH3HXVXKtYds=; b=22YKaGJiAO8MfCRiOBCwgb0TF7
        zxRB/OnQgaFpdRXtdQcKl9r9TLSTu5Lj/zSi+h+k67sgV2njLo8/0WX4Q9aJtVsy2YyFxOphdQD+4
        em5tSndd/MRNlsBbbd21LtQ7b0H+NZHYl80OBxis9RncITiWkgpnrbFBYlXiuDqPIK3l25Jo97EIk
        EUd4Lzv6fJ7tOT6mEiMW/kICzAD7iuDSo10aUShvGVy7izLLTklDqxx3nVQIqQvidJHY8lqCu+SZZ
        AwuNj9OHu/amsO0hAtxKCstiwDmwyplE0olCIlrP81FwfSkZnUJKQ8ize15/6hiz0kOyq8GFwM9vO
        kX2nrYqf2tjrsdSUfo/EIx2o0pvLHQK9IzSLC+bfWaOA6AK1pfOIVkUCIK8eLvNkeL4zv+9tL2Yw9
        B/1EVhxTO72fHiR0xXnEQflGE9LVcDuevJL4VrhxqkIpPsiDA4NgpvzJeoT4wdpm1GanSCdkAHDCw
        jhPa3Y/Px9g75XQBJJMRcMJT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mqHie-008xAS-Fr; Thu, 25 Nov 2021 16:35:32 +0000
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>,
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
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <5217de38-d166-de32-c115-fd34399eb234@samba.org>
Date:   Thu, 25 Nov 2021 17:35:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6d6fc76f-880a-938d-64dd-527e6be3009e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.11.21 um 01:58 schrieb Jens Axboe:
> On 11/24/21 3:52 PM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>>>> Looks good to me - Greg, would you mind queueing this up for
>>>>> 5.14-stable?
>>>>
>>>> 5.14 is end-of-life and not getting any more releases (the front page of
>>>> kernel.org should show that.)
>>>
>>> Oh, well I guess that settles that...
>>>
>>>> If this needs to go anywhere else, please let me know.
>>>
>>> Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
>>> already has the patch.
>>
>> Are 5.11 and 5.13 are affected, these are hwe kernels for ubuntu,
>> I may need to open a bug for them...
> 
> Please do, then we can help get the appropriate patches lined up for
> 5.11/13. They should need the same set, basically what ended up in 5.14
> plus the one I posted today.

Ok, I've created https://bugs.launchpad.net/bugs/1952222

Let's see what happens...

metze

