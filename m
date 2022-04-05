Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338824F3721
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346511AbiDELKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348810AbiDEJsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:38 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1422090FE4;
        Tue,  5 Apr 2022 02:35:54 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nbfbM-0002uq-9O; Tue, 05 Apr 2022 11:35:52 +0200
Message-ID: <4746cf3e-a9e7-4968-2695-22dd3356638f@leemhuis.info>
Date:   Tue, 5 Apr 2022 11:35:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Content-Language: en-US
To:     Peter Hutterer <peter.hutterer@who-t.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        lkml <linux-kernel@vger.kernel.org>
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
 <44abc738-1532-63fa-9cd1-2b3870a963bc@leemhuis.info>
 <CAO-hwJJweSuSBE_18ZbvqS12eX9GcS+aJoe7SRFJdASOrN3bqw@mail.gmail.com>
 <YkUqajiNZmi+lAPC@google.com> <YkUwRIa4ZI3TLAs0@quokka>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <YkUwRIa4ZI3TLAs0@quokka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1649151356;6ef4cca2;
X-HE-SMSGID: 1nbfbM-0002uq-9O
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just a quick add-on note for the record about another affected device:

On 31.03.22 06:38, Peter Hutterer wrote:
> On Wed, Mar 30, 2022 at 09:13:30PM -0700, Dmitry Torokhov wrote:
>> On Wed, Mar 30, 2022 at 02:30:37PM +0200, Benjamin Tissoires wrote:
>>> On Wed, Mar 30, 2022 at 2:27 PM Thorsten Leemhuis
>>> <regressions@leemhuis.info> wrote:
>>>> On 21.03.22 19:44, José Expósito wrote:
>>>>> This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
>>>>>
>>>>> The touchpad present in the Dell Precision 7550 and 7750 laptops
>>>>> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
>>>>> the device is not a clickpad, it is a touchpad with physical buttons.
>>>>>
>>>>> In order to fix this issue, a quirk for the device was introduced in
>>>>> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
>>>>>
>>>>>       [Precision 7x50 Touchpad]
>>>>>       MatchBus=i2c
>>>>>       MatchUdevType=touchpad
>>>>>       MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
>>>>>       AttrInputPropDisable=INPUT_PROP_BUTTONPAD
>>>>>
>>>>> However, because of the change introduced in 37ef4c19b4 ("Input: clear
>>>>> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
>>>>> anymore breaking the device right click button and making impossible to
>>>>> workaround it in user space.
>>>>>
>>>>> In order to avoid breakage on other present or future devices, revert
>>>>> the patch causing the issue.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
>>>>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
>>>>> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
>>>>> [...]
>>>>
>>>> Jiri, Benjamin, what the status here? Sure, this is not a crucial
>>>> regression and we are in the middle of the merge window, but it looks
>>>> like nothing has happened for a week now. Or was progress made somewhere
>>>> and I just missed it?
>>>
>>> No, I think it just wasn't picked up by the input maintainer yet
>>> (Dmitry, now in CC).
>>>
>>> FWIW:
>>> Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>>
>>> José, please do not forget to add the input maintainer when you target
>>> the input tree, not the HID one :)
>>
>> I see that there were several ACKs, but how many devices misuse the
>> HID_DG_BUTTONTYPE? Would it be better to quirk against either affected
>> Dell models, or particular touchpads (by HID IDs) instead of reverting
>> wholesale?
> 
> fwiw, a quick git grep in libinput shows 12 entries for disabling BTN_RIGHT
> and 9 entries for enabling/disabling INPUT_PROP_BUTTONPAD. That's not the
> number of devices affected by this bug, merely devices we know advertise the
> wrong combination.
> 
> Note that the cause for the revert is loss of functionality. Previously, a
> device was just advertising buttons incorrectly but still worked fine. This
> was mostly a cosmetic issue (and could be worked around in userspace). With
> the patch in place some devices right button no longer works because it's
> filtered by the kernel. That's why the revert is needed.
> 
> The device could/should still be quirked to drop INPUT_PROP_BUTTONPAD but that
> is only required to work around the cosmetic issues then.

I anyone cares now or in the future: seems the patch meanwhile reverted
(thx) also broke the ICL Si1516:
https://bugzilla.kernel.org/show_bug.cgi?id=215771

Ciao, Thorsten

P.S.: Any while at it, let me let regzbot about the fix as well:

#regzbot fixed-by: 8b188fba75195745026e11d408e4a7e94e01d701
