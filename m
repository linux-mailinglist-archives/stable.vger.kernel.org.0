Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4529F50C8CC
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 11:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiDWJv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiDWJvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 05:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C3CB10;
        Sat, 23 Apr 2022 02:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82705B806A0;
        Sat, 23 Apr 2022 09:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B628C385A0;
        Sat, 23 Apr 2022 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650707332;
        bh=l6tflEWSR5lV+o/JXBVWUDuffggsvkyGue5F4BmnWsg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OhCz8b0yZd6aaJCPkrVHdqBEq+ZnNxkuzjdQYjil/2+Tk6x2+pAEPeh7wSd0GjkEz
         cNxt7lQ+huRFuxK1YkdHa9ZYNnTiaviN/pnxb5xkfLcjnkhqulXIT1U0+HVHheXj//
         OGgAdMFiIEOtMHxop+S73XD74lZd9wLoAE1KwGU0Q8VJyfgl3X+5DM8JXREogK/GBh
         6EbDImuWvbhMeAwXf8SIPHTdppn5L18CdozFTNyEcUcTwEScZONPbPSB2h3ObOD8PA
         IgTyX2OHTAtcUjVrVq6ZswNzVkgmrJqIsqehKsQPXJAfPv3JtEYaWvJoK2PfoW8YM1
         iCX/fQLvZUL1g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        pa@panix.com
Subject: Re: [PATCH] rtl8180: Prevent using not initialized queues
References: <20220422145228.7567-1-alexander@wetzel-home.de>
        <87a6ccqpzg.fsf@tynnyri.adurom.net>
        <d6b8540f-da10-5103-8321-4c7e37e89314@wetzel-home.de>
Date:   Sat, 23 Apr 2022 12:48:47 +0300
In-Reply-To: <d6b8540f-da10-5103-8321-4c7e37e89314@wetzel-home.de> (Alexander
        Wetzel's message of "Sat, 23 Apr 2022 10:00:48 +0200")
Message-ID: <877d7gm8ow.fsf@kernel.org>
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

> On 23.04.22 08:21, Kalle Valo wrote:
>> Alexander Wetzel <alexander@wetzel-home.de> writes:
>>
>>> Using not existing queues can panic the kernel with rtl8180/rtl8185
>>> cards. Ignore the skb priority for those cards, they only have one
>>> tx queue.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: pa@panix.com
>>> Tested-by: pa@panix.com
>>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>>> ---
>>>
>>> Pierre Asselin (pa@panix.com) reported a kernel crash in the Gentoo forum:
>>> https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html
>>> He also confirmed that this patch fixes the issue.
>>>
>>> In summary this happened:
>>> After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
>>> "divide error: 0000" when connecting to an AP.
>>> Control port tx now tries to use IEEE80211_AC_VO for the priority, which
>>> wpa_supplicants starts to use in 2.10.
>>>
>>> Since only the rtl8187se part of the driver supports QoS, the priority
>>> of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
>>> cards.
>>>
>>> rtl8180 is then unconditionally reading out the priority and finally crashes on
>>> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
>>> patch:
>>> 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries
>>>
>>> "ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
>>> initialized.
>>
>> All this after "---" line is very useful information but the actual
>> commit log is just two sentences. I would copy all to the commit log.
>> We don't need to limit the size of the commit log, on the contrary we
>> should include all the information in it.
>>
>
> I see what you mean, fine for me.
> If you prefer I can also make an update but feel to handle that at
> your convenience. If you e.g. see a better way to do that drop the
> patch and simply submit your version.

I can edit the commit log during commit, no need to resubmit because of
this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
