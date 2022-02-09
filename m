Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84274B039E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiBJCzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 21:55:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiBJCzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 21:55:12 -0500
X-Greylist: delayed 5399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 18:55:14 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB862409C
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 18:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=vPnlkbWR5HgIGL04GSDBl0UvRCFHTEXuwzUZuwp1LfE=; b=zblNw58dqdSJhAuts7LK/1qI+H
        QUA188YjLPPeroeIMzrvUK9e3jE4A3JrXlIpHfhGCNgv7T8DQ4jqFZtBp4p8oXI8NqrS4YSpk7QNW
        auVgKOp5dz8vArulC+uigNr/hpoFsqfusVAEOVA5H8Xxws/K96v+o9h7mb265vDOe2naQ35exOUSS
        caW7DPOrZIwXk0LLgx9hEc5EXaJVG2M6ZDZ7cAnJDN3sWx57DPMKxs54vws7TSHLDzbWZ0jXHpxY6
        uJp1lcAM7UvDFnQ3YMcCC/vWRbzSF6ViF/7jd5rvuJbRGrWC9rkOxj7XXbzqVPYsKVNHX2Imyxsh+
        i13kAd3iJs/E6eSk2lYbXMGXMw0TdDLwyVRf0CnCzhInEhIviqp2CcaaX4q7n1FVy4TkfatEmRhJj
        T8YzJ3JC1VEkQUWqJeVKATswx6fnl45C4f2eTnDWSTh497Qd+1z1DUl/WdKgTTQBLKPt5dXUAlr/Y
        xuGTcoH2Mn0C1MPlb8LkKOUd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nHvy7-002zPp-Tj; Wed, 09 Feb 2022 23:01:48 +0000
Message-ID: <e5171c3d-4df7-1e70-ce3e-badcd6ea855d@samba.org>
Date:   Thu, 10 Feb 2022 00:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
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
 <5217de38-d166-de32-c115-fd34399eb234@samba.org>
Subject: Re: uring regression - lost write request
In-Reply-To: <5217de38-d166-de32-c115-fd34399eb234@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Jens,

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

At least for 5.14 the patch is included in

https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/log/?h=Ubuntu-oem-5.14-5.14.0-1023.25

https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/commit/?h=Ubuntu-oem-5.14-5.14.0-1023.25&id=9e2b95e7c9dd103297e6a3ccd98a7bf11ef66921

apt-get install -V -t focal-proposed linux-oem-20.04d linux-tools-oem-20.04d
installs linux-image-5.14.0-1023-oem (5.14.0-1023.25)

Do we have any reproducer I can use to reproduce the problem
and demonstrate the bug if fixed?

Thanks!
metze
