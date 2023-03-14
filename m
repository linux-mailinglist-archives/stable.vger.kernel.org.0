Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AA16B9BF6
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCNQpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCNQpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:45:05 -0400
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDE297C95B;
        Tue, 14 Mar 2023 09:45:02 -0700 (PDT)
Message-ID: <82d5623b-8d21-a8c1-e835-e446adf96cde@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1678812299;
        bh=JxAADtcvrt7lJhjVkg+L5gSBPsteQr/58GF55d4CV6Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=OzhWOhgP6ZGsm19lYnqJF092QQEQlaPHKCfBH4+9a/lHQA/m8jvDGdkZBuYaQeIxO
         0hGRsbFVsSsCKs2kbA3L9TPHHxKQ7uj4iPRVKiqd3r6d4cVa6EltmcKjE3qN7iU1OM
         JLBZYaKHdxvHwZHSZG6l8VBA8TWfiRU6BWgP+H30=
Date:   Tue, 14 Mar 2023 17:44:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
 <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
 <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
 <b057bd203e4c0aaf7434b1b52710b888767323aa.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <b057bd203e4c0aaf7434b1b52710b888767323aa.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.03.23 13:22, Johannes Berg wrote:
> Hi,
> 
> On Tue, 2023-03-14 at 12:20 +0100, Alexander Wetzel wrote:
>> On 13.03.23 21:33, Johannes Berg wrote:
>>> On Mon, 2023-03-13 at 21:15 +0100, Alexander Wetzel wrote:
>>>>
>>>> While drivers with native iTXQ support are able to handle that,
>>>>
>>>
>>> questionable. Looking at iwlwifi:
>>>
>>> void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
>>>                                  struct ieee80211_txq *txq)
>>> {
>>>           struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
>>> ...
>>>           list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
>>> ...
>>> }
>>>
>>> which might explain some rare and hard to debug list corruptions in the
>>> driver that we've seen reports of ...
>>>
>>
>> Shall I change the scope of the fix from "only 6.2" to any stable kernel?
>> 'Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue
>> implementation")'
>>
>> Or is that a overreaction and we better stick to what we know for sure
>> and keep the 'Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler
>> for wake_tx_queue")'?
> 
> I think we stick with the latter. I already have a fix for iwlwifi (see
> https://lore.kernel.org/r/20230314103840.30771-1-jtornosm@redhat.com)
> and other drivers should be fine.
> 
> Also that means we should probably restrict the fix to actually be for
> mac80211 only.
> 
>>>> To avoid what seems to be a not needed distinction between native and
>>>> drivers using ieee80211_handle_wake_tx_queue(), the serialization is
>>>> done for drv_wake_tx_queue() here.
>>>
>>> So probably no objection to that, at least for now, though in the common
>>> path (what I showed above was the 'first use' path), iwlwifi actually
>>> hits different HW resources, so it _could_ benefit from concurrent TX
>>> after fixing that bug.
>>>
>>
>> I could also directly add a driver a driver flag, allowing drivers to
>> opt in to overlapping calls. And then set the flag for mt76, since Felix
>> prefers to not change the behavior and knows this driver works with it.
> 
> Too much complexity. I change my position - let's fix mac80211 and
> iwlwifi separately.
> 
>> Exactly. With the benefit that when we run uncontested the overhead is
>> close to zero.
>> But this should also be true for spinlocks. And when we spin on
>> contention it even better... So I'll change it to use a spinlock instead.
> 
> Yeah that was kind of my thought process here too.
> 
> 
>>> Since drivers are supposed to handle concurrent TX per AC, you could
>> I assume you mean multiple drv_wake_tx_queue() can run in parallel, as
>> long as they are serving different ACs?
>> In a prior test patch I just blocked concurrent calls for the same ac.
> 
> No, I meant that drv_tx() was previously allowed concurrently for
> different HW queues, which in practice means at least different ACs.
> 
>> While that may be enough for full iTXQ drivers I have doubts that this
>> is sufficient for the ones using ieee80211_handle_wake_tx_queue.
> 
> No no, that's what I mean, it should've been sufficient for old-style
> drivers.
> 
>> I at least was unable to identify any code in the rt2800usb driver which
>> looked dangerous for concurrent execution. (Large parts are protected by
>> a driver spinlock)
> 
> Indeed, that's not so clear.
> 
>> I ended up with the assumption, that the DMA handover - or something
>> related to that - must cause the queue freezes. (Or my ability to detect
>> critical calls is not good enough, yet.)
> 
> That part is protected by a per-queue lock in
> rt2x00queue_write_tx_frame() though, but I don't see any problem either.
> 

Not really relevant here but to elaborate a bit:
The Hw itself seems to suffer from random freezes. But Thomas tested the 
watchdog in the driver for those. It was not helping.

On the other end the presence of such a watchdog is not exactly an 
indication for trustworthy card...

And I'm also quite surprised that Thomas triggers the issue so reliable 
while may close to be identical card I dug up works fine.
We even both use Gentoo and the same kernel. Build with the same 
compiler. Down to the version and build flags, as far as I can tell.

So nifty run-times differences caused by quite different Intel CPUs - or 
another USB controller/speed - is actually high on the list of suspects.

Effectively I just assume now, that two TX operations too close together 
are enough to kill TX. (This could be missing lock in the firmware or 
even a HW issue the firmware is not (able to) working around.)

If I could reproduce the issue I would try to track that down out of 
sheer curiosity. As things are it's not worth the effort.

Fact is, that the Thomas's driver is frequently running out of internal 
queue buffers, stop the associated mac80211 queue to pause TX. And when 
the queue is stopped during a concurrent TX operation the driver somehow 
needs >30s to start the queue again. Without logging any complaint or a 
enabled watchdog in the driver detecting the hung.

>> The patch still fixed the issue, of course. All races in the examined
>> regression are for IEEE80211_AC_BE, so it's sufficient fix when we
>> decide that's save.
> 
> It seems to me it should be safe, again, since we previously assumed you
> could do TX per HW queue concurrently. However, that's not precisely per
> AC, so we might need to be careful, and maybe that's not worth it.
> 
>> Holding active_txq_lock[ac] all that time - it's normally acquired and
>> released multiple times in between - seems to be a bit too daring for a
>> "stable" patch.
> 
> Fair enough :)
> 
>> I also still would place the spinlock in drv_wake_tx_queue(). After all
>> ieee80211_txq_schedule_start/end is kind of optional and e.g. iwlwifi is
>> not using it.
> 
> True.
> 
>> What about handling it that way:
>>
>> Keep serializing drv_wake_tx_queue(). But use a new spinlock the drivers
>> can opt out from.
>>    1) No flag set:
>>       drv_wake_tx_queue() can be running only once at any time
>>
>>    2) IEEE80211_HW_CONCURRENT_AC_TX
>>       drv_wake_tx_queue() can be running once per AC at any time
>>
>>    3) IEEE80211_HW_CONCURRENT
>>       current behavior.
>>
> 
> I don't like the flags, to be honest.
> 
> Have you considered Felix's proposal of having a separate thread to
> handle all the transmits? Or maybe that's too much for stable too?

I was planning to respond to Felix mail, too.
But guess it makes more sense here now and not have multiple concurrent 
discussions:-)

For the immediate fix I do not like the kthread. Which simply may be due 
to the fact that I would need more time to delve into that.

Not so sure how we can get the queue wakes as cheap as they currently 
are, though. Each time we kick off the kthread it would have to check 
the scheduling lists for each AC. Or use one kthread per AC... (That 
from someone who knows close to nothing about kthread and needs do more 
reading...)

Generally it sounds like improvement for mac80211 roadmap. But nothing I 
would want to pickup right now.
I first want to wrap up the migration to iTXQ. (Which now also redesigns 
how filtered and pending frames are handled, btw.)

> 
> I think my personal order of options would be:
> 
> 1) for stable, just add a spinlock to ieee80211_handle_wake_tx_queue()
> 
> 2) for later, maybe consider making ieee80211_handle_wake_tx_queue()
>     just wake up a kthread or something, and handle the schedule loop
>     there
> 
> However we may need to think more about 2), maybe we could even map to
> hardware queues and do concurrency there, but better we just say screw
> it and remove all that cruft instead ...
> 

I like that.

I try to work on that this evening and hopefully can share a new patch 
later today or tomorrow. (No V2, title and solution has changed.)

I'll just use per-ac spinlocks in ieee80211_handle_wake_tx_queue(), 
allowing multiple ACs to TX at the same time.

That's probably not able to prevent the stopped queue issue Thomas got 
with 6.2 kernels when mutliply ACs have concurrent TX.
But it will bring back the driver to the level it operated on kernel 
<6.1. Which sounds acceptable for me.

Someone planning to fix the issue for ath10k?
If not I'll look into that, too. (Since we don't have known issues for 
that it's not exactly a priority.)

Alexander
