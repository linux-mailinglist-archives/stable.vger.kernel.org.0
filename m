Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF026B93CD
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjCNMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjCNMao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:30:44 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C1974A4F;
        Tue, 14 Mar 2023 05:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T7AdpE3kF45Ahs5PgnL6KmsAScwyT077PLll9xZ5w0Q=; b=KfG5JminPgVX72tE/xsbcPH199
        DAt+sP+QEMiv4NBh5HE4BA1EjqCbDYGSSgnvDKbSRZGOv0K3WHupckZKxfbqOVeEMpTgxaC0axKyj
        V5FQl0ZKbKqsq2uHrdFmMZ644YkvtTEzIoyVrUyzlfFwyEgcHrp7zVhfvhW+b0dkVSxI=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pc3l8-001rqH-2X; Tue, 14 Mar 2023 13:28:06 +0100
Message-ID: <519b5bb9-8899-ae7c-4eff-f3116cdfdb56@nbd.name>
Date:   Tue, 14 Mar 2023 13:28:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Content-Language: en-US
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
 <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
 <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
In-Reply-To: <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.03.23 12:20, Alexander Wetzel wrote:
>> assuming that TXQ drivers actually still call
>> ieee80211_txq_schedule_end() which says it's deprecated.
>> 
>> That even has _bh() so the tasklet can't be running anyway ...
>> 
>> So if the concurrency really is only TX vs. tasklet, then you could even
>> just keep the BHs disabled (in _start spin_unlock only and then in _end
>> local_bh_disable)?
>> 
>>> Which may also be the solution for the regression in 6.2:
>>> Do it now for ieee80211_handle_wake_tx_queue() and apply this patch
>>> to the development tree only.
>> 
>> I'd argue the other way around - do it for all to fix these issues, and
>> then audit drivers such as iwlwifi or even make concurrency here opt-in.
>> 
>> Felix did see some benefits of the concurrency I think though, so he
>> might have a different opinion.
> 
> What about handling it that way:
> 
> Keep serializing drv_wake_tx_queue(). But use a new spinlock the drivers
> can opt out from.
>    1) No flag set:
>       drv_wake_tx_queue() can be running only once at any time
> 
>    2) IEEE80211_HW_CONCURRENT_AC_TX
>       drv_wake_tx_queue() can be running once per AC at any time
> 
>    3) IEEE80211_HW_CONCURRENT
>       current behavior.

I think if you really insist on handling this through drv_wake_tx_queue 
locking, it really shouldn't be done through extra hw flags, because the 
locking requirements are too different.

I took a quick look at all the drivers that implement iTXQ themselves 
and what their requirements are.

Only two drivers need changes:
- ath10k: needs a per-AC lock, because it does a scheduling round in the 
wake_tx_queue call.
- iwlwifi: needs a global lock, since it touches a common list. None of 
your proposed locking types are enough for this one.

The rest seem fine to me:
- ath9k has a per-hw-queue lock
- mt76 only schedules a kthread
- rtw88 uses a global lock + workqueue for scheduling
- rtw89 uses a (potentially unnecessary) ieee80211_schedule_txq call + 
workqueue for scheduling

If you want to address this in the least invasive way, add a per-AC lock 
to ath10k's wake_tx_queue handler, a global lock to iwlwifi, and a 
per-AC lock inside ieee80211_handle_wake_tx_queue().

That way no locking is needed around the drv_wake_tx_queue calls.

- Felix
