Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718DA6BA19F
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 22:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCNVzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCNVzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 17:55:12 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C0125BAF;
        Tue, 14 Mar 2023 14:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+a/ZpeZeYfXnQyDihNzhrEWtGla2rXqTqPydF7Rud3I=; b=g9MyFh+ad75VWGxm5j+oMhOszR
        +jCeX1SXWPcKd/u5eSsjlWwNPgJDA4oK63BM5x4y/zcwCWWfVgdk0ArwPomvXMoGEyLhyqulQIYEW
        n5UavGRCx8+bB2qF00i85j7qVcdHHJdR5NynXIa2JkjOhE1cMvp1bYebtalP9wjSv2R4=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pcCbr-0020lu-R3; Tue, 14 Mar 2023 22:55:07 +0100
Message-ID: <fc263550-13a6-4cfa-c0b6-c8b2f7bccf96@nbd.name>
Date:   Tue, 14 Mar 2023 22:55:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: mac80211: Serialize
 ieee80211_handle_wake_tx_queue()
Content-Language: en-US
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org
References: <20230314211122.111688-1-alexander@wetzel-home.de>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230314211122.111688-1-alexander@wetzel-home.de>
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

On 14.03.23 22:11, Alexander Wetzel wrote:
> ieee80211_handle_wake_tx_queue must not run concurrent multiple times.
> It calls ieee80211_txq_schedule_start() and the drivers migrated to iTXQ
> do not expect overlapping drv_tx() calls.
> 
> This fixes 'c850e31f79f0 ("wifi: mac80211: add internal handler for
> wake_tx_queue")', which introduced ieee80211_handle_wake_tx_queue.
> Drivers started to use it with 'a790cc3a4fad ("wifi: mac80211: add
> wake_tx_queue callback to drivers")'.
> But only after fixing an independent bug with
> '4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")'
> problematic concurrent calls really happened and exposed the initial
> issue.
> 
> Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
> Reported-by: Thomas Mann <rauchwolke@gmx.net>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217119
> Link: https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.info/
> Link: https://lore.kernel.org/r/b7445607128a6b9ed7c17fcdcf3679bfaf4aaea.camel@sipsolutions.net>
> CC: <stable@vger.kernel.org>
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
> 
> @Thomas
> Would be good when you can test that patch again.
> But it would be really strange if it's not working, too...
> 
> @Johannes
> Based on your last mail you prefer to hard serialize it and not use a
> spin lock per AC. So I kept that part from the first patch.

This is missing the spin_lock_init() call.

- Felix
