Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E22604BEC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiJSPnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiJSPnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:43:18 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FF7FF8F0
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 08:38:57 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 8D6DEC80098;
        Wed, 19 Oct 2022 17:33:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 4nsJa2kGY0JR; Wed, 19 Oct 2022 17:33:11 +0200 (CEST)
Received: from [192.168.178.52] (business-24-134-105-141.pool2.vodafone-ip.de [24.134.105.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPSA id 43D4AC80091;
        Wed, 19 Oct 2022 17:33:11 +0200 (CEST)
Message-ID: <7b18bd9d-6a61-b48b-f2ac-e2f50d3de932@tuxedocomputers.com>
Date:   Wed, 19 Oct 2022 17:33:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] ACPI: video: Force backlight native for more TongFang
 devices
Content-Language: en-US
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20221019140142.17558-1-wse@tuxedocomputers.com>
 <Y1AQRaEvqmVWHusI@kroah.com>
 <53909937-74b3-df33-5136-d7de0e812ea2@tuxedocomputers.com>
In-Reply-To: <53909937-74b3-df33-5136-d7de0e812ea2@tuxedocomputers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 19.10.22 um 17:18 schrieb Werner Sembach:
> Am 19.10.22 um 16:57 schrieb Greg KH:
>
>> On Wed, Oct 19, 2022 at 04:01:42PM +0200, Werner Sembach wrote:
>>> commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.
>> That is not this commit at all :(
>
> Yes, that commit is obsoleting these quirks. I think I misinterpreted 
> the doc. I thought some kind of upstream commit has to be always 
> included. Now reading it again, I should have just left that line out?
>
> What I wanted to say: These quirks are not required on upstream, but 
> only on <= 6.0.y
>
> I'm sorry for causing confusion (again q.q)
Sent again as v2, hopefully correct his time.
>
>>
>>> The upstream commit "ACPI: video: Make backlight class device 
>>> registration
>>> a separate step (v2)" changes the logic in a way that these quirks 
>>> are not
>>> required anymore, but kernel <= 6.0 still need these.
>>>
>>> The TongFang GKxNRxx, GMxNGxx, GMxZGxx, and GMxRGxx / TUXEDO
>>> Stellaris/Polaris Gen 1-4, have the same problem as the Clevo NL5xRU 
>>> and
>>> NL5xNU / TUXEDO Aura 15 Gen1 and Gen2:
>>> They have a working native and video interface for screen backlight.
>>> However the default detection mechanism first registers the video 
>>> interface
>>> before unregistering it again and switching to the native interface 
>>> during
>>> boot. This results in a dangling SBIOS request for backlight change for
>>> some reason, causing the backlight to switch to ~2% once per boot on 
>>> the
>>> first power cord connect or disconnect event. Setting the native 
>>> interface
>>> explicitly circumvents this buggy behaviour by avoiding the 
>>> unregistering
>>> process.
>>>
>>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>>> ---
>>>   drivers/acpi/video_detect.c | 64 
>>> +++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 64 insertions(+)
>>>
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read:
>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.
>>
>> </formletter>
