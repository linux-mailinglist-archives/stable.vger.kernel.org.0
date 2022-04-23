Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4524650C7C3
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 08:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiDWGYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 02:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiDWGYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 02:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D2D1C0504;
        Fri, 22 Apr 2022 23:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A12ACB8013B;
        Sat, 23 Apr 2022 06:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5A2C385A5;
        Sat, 23 Apr 2022 06:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650694905;
        bh=b20sV2yJ1WnvFmS8HrfLa0v1wh3ApLeXe5YUGX8rjTs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n0rwkkogCuo8MuvRz/MlyUsqxVHp747Kt7K88Q8dY23WjTBBxhTHhrcp2PQw7aPAK
         +C7tTOQfxNoetnNtx5qNQq9fxgLArqutqorrinUz5Dokwi6OTwEL2ZX8454AOBWANk
         WiBuhSCa+ZRFy/PeK3SGUy5Twjqr5pbFZ14XiftfG4K6eHJVRNo+jLXchtWf/LmC9T
         uWrnugrY2yo0VT9iRolBoXNQnXkSo8eOzKcNXH2plOHjnFFD1YJSAmF6qC2fXkoHnT
         RJ50Mz08ax1VAuihTxsTTSaocoYNv2AtKVw6XECLEEuQ2KxllOJz/h+3Oz9zIp3pfr
         wg8juBM7iplFQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        pa@panix.com
Subject: Re: [PATCH] rtl8180: Prevent using not initialized queues
References: <20220422145228.7567-1-alexander@wetzel-home.de>
Date:   Sat, 23 Apr 2022 09:21:39 +0300
In-Reply-To: <20220422145228.7567-1-alexander@wetzel-home.de> (Alexander
        Wetzel's message of "Fri, 22 Apr 2022 16:52:28 +0200")
Message-ID: <87a6ccqpzg.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander Wetzel <alexander@wetzel-home.de> writes:

> Using not existing queues can panic the kernel with rtl8180/rtl8185
> cards. Ignore the skb priority for those cards, they only have one
> tx queue.
>
> Cc: stable@vger.kernel.org
> Reported-by: pa@panix.com
> Tested-by: pa@panix.com
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>
> Pierre Asselin (pa@panix.com) reported a kernel crash in the Gentoo forum:
> https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html
> He also confirmed that this patch fixes the issue.
>
> In summary this happened:
> After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
> "divide error: 0000" when connecting to an AP.
> Control port tx now tries to use IEEE80211_AC_VO for the priority, which
> wpa_supplicants starts to use in 2.10.
>
> Since only the rtl8187se part of the driver supports QoS, the priority
> of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
> cards.
>
> rtl8180 is then unconditionally reading out the priority and finally crashes on
> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
> patch:
> 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries
>
> "ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
> initialized.

All this after "---" line is very useful information but the actual
commit log is just two sentences. I would copy all to the commit log.
We don't need to limit the size of the commit log, on the contrary we
should include all the information in it.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
