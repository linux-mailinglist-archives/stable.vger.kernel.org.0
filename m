Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377976B9182
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCNLVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 07:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjCNLVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 07:21:17 -0400
X-Greylist: delayed 54233 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 04:20:51 PDT
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C91829F20E;
        Tue, 14 Mar 2023 04:20:50 -0700 (PDT)
Message-ID: <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1678792845;
        bh=AKdufBax7JBm+SdHfz0SyRXWzbmYWFvYmCpJ06ilROo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Et23m/TURJzthnvYmuaBRWYozsMNaqlavpAo04KDShMgHIiUXLEWYlOwXPdDciJjv
         iOxYI40PUtgwA24urhMO81k9AD7aPGi1p8vLIBn4YkjqHyJZ6xYN+U0EU8Z8WtV8U5
         qKPX6guILmIYBFCMq8RJhovEQyy8zEWqfqjGduEo=
Date:   Tue, 14 Mar 2023 12:20:43 +0100
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
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
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

On 13.03.23 21:33, Johannes Berg wrote:
> On Mon, 2023-03-13 at 21:15 +0100, Alexander Wetzel wrote:
>>
>> While drivers with native iTXQ support are able to handle that,
>>
> 
> questionable. Looking at iwlwifi:
> 
> void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
>                                 struct ieee80211_txq *txq)
> {
>          struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
> ...
>          list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
> ...
> }
> 
> which might explain some rare and hard to debug list corruptions in the
> driver that we've seen reports of ...
> 

Shall I change the scope of the fix from "only 6.2" to any stable kernel?
'Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue 
implementation")'

Or is that a overreaction and we better stick to what we know for sure 
and keep the 'Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler 
for wake_tx_queue")'?

>> To avoid what seems to be a not needed distinction between native and
>> drivers using ieee80211_handle_wake_tx_queue(), the serialization is
>> done for drv_wake_tx_queue() here.
> 
> So probably no objection to that, at least for now, though in the common
> path (what I showed above was the 'first use' path), iwlwifi actually
> hits different HW resources, so it _could_ benefit from concurrent TX
> after fixing that bug.
> 

I could also directly add a driver a driver flag, allowing drivers to 
opt in to overlapping calls. And then set the flag for mt76, since Felix 
prefers to not change the behavior and knows this driver works with it.

>> The serialization works by detecting and blocking concurrent calls into
>> drv_wake_tx_queue() and - when needed - restarting all queues after the
>> wake_tx_queue ops returned from the driver.
> 
> This seems ... overly complex? It feels like you're implementing a kind
> of spinlock (using atomic bit ops) with very expensive handling of
> contention?
> 

Exactly. With the benefit that when we run uncontested the overhead is 
close to zero.
But this should also be true for spinlocks. And when we spin on 
contention it even better... So I'll change it to use a spinlock instead.

> Since drivers are supposed to handle concurrent TX per AC, you could
I assume you mean multiple drv_wake_tx_queue() can run in parallel, as 
long as they are serving different ACs?
In a prior test patch I just blocked concurrent calls for the same ac.

While that may be enough for full iTXQ drivers I have doubts that this 
is sufficient for the ones using ieee80211_handle_wake_tx_queue.

I at least was unable to identify any code in the rt2800usb driver which 
looked dangerous for concurrent execution. (Large parts are protected by 
a driver spinlock)

I ended up with the assumption, that the DMA handover - or something 
related to that - must cause the queue freezes. (Or my ability to detect 
critical calls is not good enough, yet.)

The patch still fixed the issue, of course. All races in the examined 
regression are for IEEE80211_AC_BE, so it's sufficient fix when we 
decide that's save.

Nevertheless I decided to better serialize any calls to 
drv_wake_tx_queue(). When we don't do that we may get a much harder to 
detect/trigger regression. Even more rarely hit and due to that probably 
never reported and fixed.

> almost just do something like this:
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index f07a3c1b4d9a..1946e28868ea 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -7108,10 +7108,8 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac);
>    */
>   void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
>   
> -/* (deprecated) */
> -static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
> -{
> -}
> +/** ... */
> +void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac);
>   
>   void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
>   			      struct ieee80211_txq *txq, bool force);
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1fae44fb1be6..606ca8620d20 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -4250,11 +4250,17 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
>   	} else {
>   		local->schedule_round[ac] = 0;
>   	}
> -
> -	spin_unlock_bh(&local->active_txq_lock[ac]);
>   }
>   EXPORT_SYMBOL(ieee80211_txq_schedule_start);
>   
> +void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +
> +	spin_unlock_bh(&local->active_txq_lock[ac]);
> +}
> +EXPORT_SYMBOL(ieee80211_txq_schedule_end);
> +
>   void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>   				  struct net_device *dev,
>   				  u32 info_flags,
>

Holding active_txq_lock[ac] all that time - it's normally acquired and 
released multiple times in between - seems to be a bit too daring for a 
"stable" patch. I would feel better using a new spinlock - one drivers 
can opt out of. Would that be acceptable, too?

Scheduling it in ieee80211_schedule_txq() also requires that lock.
Would your idea not often force userspace TX to spin for 
active_txq_lock[ac] after the skb has been added to the iTXQ, just to 
then find a empty queue?

I also still would place the spinlock in drv_wake_tx_queue(). After all 
ieee80211_txq_schedule_start/end is kind of optional and e.g. iwlwifi is 
not using it.

> 
> 
> assuming that TXQ drivers actually still call
> ieee80211_txq_schedule_end() which says it's deprecated.
> 
> That even has _bh() so the tasklet can't be running anyway ...
> 
> So if the concurrency really is only TX vs. tasklet, then you could even
> just keep the BHs disabled (in _start spin_unlock only and then in _end
> local_bh_disable)?
> 
>> Which may also be the solution for the regression in 6.2:
>> Do it now for ieee80211_handle_wake_tx_queue() and apply this patch
>> to the development tree only.
> 
> I'd argue the other way around - do it for all to fix these issues, and
> then audit drivers such as iwlwifi or even make concurrency here opt-in.
> 
> Felix did see some benefits of the concurrency I think though, so he
> might have a different opinion.

What about handling it that way:

Keep serializing drv_wake_tx_queue(). But use a new spinlock the drivers 
can opt out from.
  1) No flag set:
     drv_wake_tx_queue() can be running only once at any time

  2) IEEE80211_HW_CONCURRENT_AC_TX
     drv_wake_tx_queue() can be running once per AC at any time

  3) IEEE80211_HW_CONCURRENT
     current behavior.

Alexander
