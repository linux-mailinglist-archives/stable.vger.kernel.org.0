Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B450C828
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiDWIDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 04:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiDWIDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 04:03:54 -0400
X-Greylist: delayed 61699 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Apr 2022 01:00:56 PDT
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13578230D1D;
        Sat, 23 Apr 2022 01:00:55 -0700 (PDT)
Message-ID: <d6b8540f-da10-5103-8321-4c7e37e89314@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1650700851;
        bh=9eq82fgG4skizTeC+ITC4fUGMFtOrrdQQkhV1P0VF4Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=t+wqvTPWJ5ygJKBILx8k3YSiAETMKcex7R+4BixO02950fqNCUKWhRoEUyN6mfNpF
         ykD7iaJeg76MReFKtMbESJc1r/qwM3Rm9/8u6WI1O9JOIyBeHOtD+Wf5Nyz8qeTvb8
         +sVCyteX2GQzVy9hgx+yvY/KY3d9iZESA+ibMiTE=
Date:   Sat, 23 Apr 2022 10:00:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] rtl8180: Prevent using not initialized queues
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        pa@panix.com
References: <20220422145228.7567-1-alexander@wetzel-home.de>
 <87a6ccqpzg.fsf@tynnyri.adurom.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <87a6ccqpzg.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.04.22 08:21, Kalle Valo wrote:
> Alexander Wetzel <alexander@wetzel-home.de> writes:
> 
>> Using not existing queues can panic the kernel with rtl8180/rtl8185
>> cards. Ignore the skb priority for those cards, they only have one
>> tx queue.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: pa@panix.com
>> Tested-by: pa@panix.com
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>
>> Pierre Asselin (pa@panix.com) reported a kernel crash in the Gentoo forum:
>> https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html
>> He also confirmed that this patch fixes the issue.
>>
>> In summary this happened:
>> After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
>> "divide error: 0000" when connecting to an AP.
>> Control port tx now tries to use IEEE80211_AC_VO for the priority, which
>> wpa_supplicants starts to use in 2.10.
>>
>> Since only the rtl8187se part of the driver supports QoS, the priority
>> of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
>> cards.
>>
>> rtl8180 is then unconditionally reading out the priority and finally crashes on
>> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
>> patch:
>> 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries
>>
>> "ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
>> initialized.
> 
> All this after "---" line is very useful information but the actual
> commit log is just two sentences. I would copy all to the commit log.
> We don't need to limit the size of the commit log, on the contrary we
> should include all the information in it.
> 

I see what you mean, fine for me.
If you prefer I can also make an update but feel to handle that at your 
convenience. If you e.g. see a better way to do that drop the patch and 
simply submit your version.

While I spent some time figuring out how QoS is intended to work and I'm 
pretty sure I finally got the outline it I'm still wondering why we 
never set the priority for skb's on the normal transmit path.

Obviously the idea is to keep the queue from whoever set it prior to us 
and just overwriting it with good reason.

I plan to look a bit more into that, especially since Pierre's system 
was working when wpa_supplicant is not using control Port. Thus 
skb_get_queue_mapping() must return zero - or max one - on that path. 
That only makes sense when the network subsystem knows that QoS is not 
supported and is not bothering to set the queue. (Or if we would map 
zero to IEEE80211_AC_BE, but we are not handling it that way)

It basically drills down to the fact that we only call 
_ieee80211_select_queue() on the normal tx path for drivers supporting 
wake_tx_queue. I would have expected that call to be done for all 
drivers. (Or at least all drivers supporting QoS.)

So there is either a strange bug or - so far more likely - some serious 
gap in my still evolving understanding of QoS.
