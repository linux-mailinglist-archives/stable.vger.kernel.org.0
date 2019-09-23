Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DC8BB3C8
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 14:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394241AbfIWMdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 08:33:11 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34257 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394195AbfIWMdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 08:33:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id p10so12692952edq.1;
        Mon, 23 Sep 2019 05:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CZY+m6XziiuUFC3vgwK1PNVySRnzhKJCHOLL5oruBzU=;
        b=drJzkdvGslYwupMEMUo7tkam6+wlcF8mmd7vvon3Bny/m9zpNEu9AwCg2ThZ/0PQDD
         wn0mVVTWX6jHgXAG6GSuNpvngnRRIfgapW1LnvM6/nuHh1H+mtSVFGNSuxVafUqGEJYV
         jizPG6pn7VDPnax8qqT4gMaG85yh7a963/wRKcpIA34w4es9XVOjYgpixbPLAwOeOOiT
         NxLjNcfpWhnAmFYxQoQBxnDjmm8irYQj+I4pKgKJ0D5iT/f2+bIJh1mgGU95KKX6V1c7
         nYbzhB3cJAG2//GDry04vIk6rq4ZZfk2hMNv5T9qWnq6TxyGkt6vbNm2pg5mI/UXe+8T
         ENWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZY+m6XziiuUFC3vgwK1PNVySRnzhKJCHOLL5oruBzU=;
        b=ONIa+G36avbmBRwzY7RLFZRBgUXot80JIi+xsakEs5F6X9Ktqur/+Zb5nNEgahw0DX
         SWdYg0y3c5EIQevZWLeppXTKG+zxRRSvN0rZoud7PlX7cde+q5heVhlISjCw9pkZOarZ
         krTytNOwXEKIxTCVmFJELf5i1fJs1m2++WBUxrEgPkdSOSgy7p5Cy0Q5ZD1LXLQ+WoWs
         SswA98VODfXU9WNLYaSz2q9mU1kbW5/+L/vkbFkyT+cvDFiLoCBo+Kb05oL4gu2+UNy4
         J5vDvugf0cIQbmFqKcP6/bB1rvg7EVIqQCLMGLInLIhYQiOSAi5f5Gn9WqE4U91tiVIy
         BRCg==
X-Gm-Message-State: APjAAAWaO1suMSsg/zOS4OZB2O6cIPw+RdlqMbJNLvIkZ2hPjHJnmExS
        FagtV1jOO0ZpOG9mQWz0HCjQ5img
X-Google-Smtp-Source: APXvYqwkqIo5m2ZEhcs4rT8Tce+0N6S8DY4mikk/PVvy7GSbondpoDFlTnDqM79/KVGPP8VGS1T5RQ==
X-Received: by 2002:a50:a41c:: with SMTP id u28mr36593853edb.185.1569241988538;
        Mon, 23 Sep 2019 05:33:08 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.210.43])
        by smtp.gmail.com with ESMTPSA id d4sm1101810ejm.24.2019.09.23.05.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 05:33:07 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
To:     Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz> <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
 <20190918123123.GC31891@quack2.suse.cz>
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <53b7b7b9-7ada-650c-0a32-291a242601f3@gmail.com>
Date:   Mon, 23 Sep 2019 15:33:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190918123123.GC31891@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/09/2019 15:31, Jan Kara wrote:
<>
>>> Is there a test on xfstests to demonstrate this race?
>>
>> No, but I can try to create one.
> 
> I was experimenting with this but I could not reproduce the issue in my
> test VM without inserting artificial delay at appropriate place... So I
> don't think there's much point in the fstest for this.
> 
> 								Honza
> 

If I understand correctly you will need threads that direct-write
files, then fadvise(WILL_NEED) - in parallel to truncate (punch_hole) these
files - In parallel to trash caches.
(Direct-write is so data is not present in cache when you come to WILL_NEED
 it into the cache, otherwise the xfs b-trees are not exercised. Or are you
 more worried about the page_cache races?
)

Also the d-writes might want to exercise multiple size extents + holes as
well.

I have a very different system but its kind of the test we did for this
problem.

The reason it is never hit is because fadvise(WILL_NEED) is never really
used that much, and there are no applications that actually blindly truncate
during IO, this is only us in testing that do this meaningless thing.

Thanks Jan again for working on this
Boaz
