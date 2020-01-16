Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636C013D0D7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 01:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAPABC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 19:01:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:42166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgAPABC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 19:01:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 451B3AD0F;
        Thu, 16 Jan 2020 00:01:00 +0000 (UTC)
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
To:     Nix <nix@esperi.org.uk>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, stable@vger.kernel.org
References: <20200104065802.113137-1-colyli@suse.de>
 <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
 <87lfqa2p4s.fsf@esperi.org.uk> <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de>
 <875zhc3ncu.fsf@esperi.org.uk>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <931567a8-a81d-a1cd-c7d8-7c193e61f79d@suse.de>
Date:   Thu, 16 Jan 2020 08:00:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <875zhc3ncu.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/1/15 8:39 下午, Nix wrote:
> On 15 Jan 2020, Coly Li stated:
> 
>> I have two reports offline and directly to me, one is from an email
>> address of github and forwarded to me by Jens, one is from a China local
>> storage startup.
>>
>> The first report complains the desktop-pc benchmark is about 50% down
>> and the root cause is located on commit b41c9b0 ("bcache: update
>> bio->bi_opf bypass/writeback REQ_ flag hints").
>>
>> The second report complains their small file workload (mixed read and
>> write) has around 20%+ performance drop and the suspicious change is
>> also focused on the readahead restriction.
>>
>> The second reporter verifies this patch and confirms the performance
>> issue has gone. I don't know who is the first report so no response so far.
> 
> Hah! OK, looks like readahead is frequently-enough useful that caching
> it is better than not caching it :) I guess the problem is that if you
> don't cache it, it never gets cached at all even if it was useful, so
> the next time round you'll end up having to readahead it again :/
> 

Yes, this is the problem. The bypassed data won't have chance to go into
cache always.


> One wonders what effect this will have on a bcache-atop-RAID: will we
> end up caching whole stripes most of the time?
> 

In my I/O pressure testing, I have a raid0 backing device assembled by 3
SSDs. From my observation, the whole stripe size won't be cached for
small read/write requests. The stripe size alignment is handled in md
raid layer, even md returns bio which stays in a stripe size memory
chunk, bcache only takes bi_size part for its I/O.

Thanks.

-- 

Coly Li
