Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A115E13B972
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 07:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgAOGVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 01:21:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:37530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgAOGVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 01:21:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8BBA9B027;
        Wed, 15 Jan 2020 06:21:10 +0000 (UTC)
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
To:     Nix <nix@esperi.org.uk>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, stable@vger.kernel.org
References: <20200104065802.113137-1-colyli@suse.de>
 <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
 <87lfqa2p4s.fsf@esperi.org.uk>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de>
Date:   Wed, 15 Jan 2020 14:21:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87lfqa2p4s.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/1/14 8:34 下午, Nix wrote:
> On 6 Jan 2020, Eric Wheeler spake thusly:
> 
>> On Sat, 4 Jan 2020, Coly Li wrote:
>>
>>> In year 2007 high performance SSD was still expensive, in order to
>>> save more space for real workload or meta data, the readahead I/Os
>>> for non-meta data was bypassed and not cached on SSD.
> 
> It's also because readahead data is more likely to be useless.
> 
>>> In now days, SSD price drops a lot and people can find larger size
>>> SSD with more comfortable price. It is unncessary to bypass normal
>>> readahead I/Os to save SSD space for now.
> 

Hi Nix,

> Doesn't this reduce the utility of the cache by polluting it with
> unnecessary content? It seems to me that we need at least a *litle*
> evidence that this change is beneficial. (I mean, it might be beneficial
> if on average the data that was read ahead is actually used.)
> 
> What happens to the cache hit rates when this change has been running
> for a while?
> 

I have two reports offline and directly to me, one is from an email
address of github and forwarded to me by Jens, one is from a China local
storage startup.

The first report complains the desktop-pc benchmark is about 50% down
and the root cause is located on commit b41c9b0 ("bcache: update
bio->bi_opf bypass/writeback REQ_ flag hints").

The second report complains their small file workload (mixed read and
write) has around 20%+ performance drop and the suspicious change is
also focused on the readahead restriction.

The second reporter verifies this patch and confirms the performance
issue has gone. I don't know who is the first report so no response so far.

I don't have exact hit rate number because the reporter does not provide
(BTW, because the readahead request is bypassed, I feel the hit rate
won't count on them indeed). But from the reports and one verification,
IMHO this change makes sense.

Thanks.

-- 

Coly Li
