Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F546B83B6
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 22:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCMVHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 17:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjCMVHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 17:07:33 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A66EC67D;
        Mon, 13 Mar 2023 14:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rPVBUVq+AJVWj4nP3Zp9d9JZjQMiQahOiXcAF0sclA4=; b=GOojPxUWdB6qIhiY6h39jPP++t
        D2liKYgGwtk1uAefNQnBMJD1pVF8nAbm2dhqWcP8L7ijd+PEykBi/DQyVVb0FQLjpP1fVFDEdaTwT
        /4GBUDob6mEmEhdZse7piDXJFZoWX50GEsKpLBgYPJ4WiuSzAvcgUrtamgWkRpCi0eqI=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pbpLS-001Z2s-Iv; Mon, 13 Mar 2023 22:04:38 +0100
Message-ID: <88c400d4-e162-3cc8-62f2-af07b545a6c3@nbd.name>
Date:   Mon, 13 Mar 2023 22:04:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Content-Language: en-US
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org
References: <20230313201542.72325-1-alexander@wetzel-home.de>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
In-Reply-To: <20230313201542.72325-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.03.23 21:15, Alexander Wetzel wrote:
> drv_wake_tx_queue() has no protection against running concurrent
> multiple times. It's normally executed within the task calling
> ndo_start_xmit(). But wake_txqs_tasklet is also calling into it,
> regardless if the function is already running on another CPU or not.
> 
> While drivers with native iTXQ support are able to handle that, calls to
> ieee80211_handle_wake_tx_queue() - used by the drivers without
> native iTXQ support - must be serialized. Otherwise drivers can get
> unexpected overlapping drv_tx() calls from mac80211. Which causes issues
> for at least rt2800usb.
> 
> To avoid what seems to be a not needed distinction between native and
> drivers using ieee80211_handle_wake_tx_queue(), the serialization is
> done for drv_wake_tx_queue() here.
> 
> The serialization works by detecting and blocking concurrent calls into
> drv_wake_tx_queue() and - when needed - restarting all queues after the
> wake_tx_queue ops returned from the driver.
> 
> This fix here is only required when a tree has 'c850e31f79f0 ("wifi:
> mac80211: add internal handler for wake_tx_queue")', which introduced
> the buggy code path in mac80211. Drivers were switched to it with
> 'a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to
> drivers")'. But only after fixing an independent bug with commit
> '4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")'
> problematic concurrent calls to drv_wake_tx_queue() really happened and
> exposed the initial issue.
> 
> Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
> Reported-by: Thomas Mann <rauchwolke@gmx.net>
> Tested-by: Thomas Mann <rauchwolke@gmx.net>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217119
> Link: https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.info/
> CC: <stable@vger.kernel.org>
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
> 
> There are multiple variations how we can fix the issue.
> 
> But this fix has to go directly into 6.2 to solve an ongoing
> regression.
> I tried to prevent an outright redesign while still having a
> full fix:

This serialization approach confuses me a bit, and I worry that it might 
cause performance regressions on mt76 somehow, though I can't point to 
any specific scenario in which this would happen.

> Most questionable decision here probably is, if we should fix it in
> drv_wake_tx_queue() or only in ieee80211_handle_wake_tx_queue().
> But the decision how to serialize - tasklet vs some kind of locking
> - may also be an issue.
> 
> Personally, I did not like the overhead of checking all iTXQ for every
> drv_wake_tx_queue(). These are happening per-packet AND can be easily
> avoided when we are not using a tasklet. Most of the time.

Moving the scheduling to a tasklet wouldn't involve checking all iTXQ 
for every wake call, only the active ones that have packets queued.
If you use a kthread instead, multiple concurrent events (and in some 
cases even consecutive ones when busy enough) can be handled in a single 
scheduling run, which can be flexible about which CPU to run on as well.

> I also assume that drivers don't *want* concurrent drv_wake_tx_queue()
> calls and it's a benefit to all drivers to serialize it.

I think the main problem with your patch is that it does not solve the 
issue completely, just one instance of it. Concurrent calls to 
ieee80211_handle_wake_tx_queue for multiple iTXQs belonging to the same 
WMM AC are just as problematic as concurrent calls for the same iTXQ. 
Your patch does not seem to handle that.

Also, mt76 is completely fine with concurrent drv_wake_tx_queue calls, 
as it only uses them to schedule the main tx kthread.

In my opinion, the best approach is still to use a single kthread for 
the ieee80211_handle_wake_tx_queue case and leave drivers alone that 
take care of scheduling on their own.

- Felix
