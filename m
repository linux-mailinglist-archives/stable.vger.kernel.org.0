Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2570E4EC45E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344789AbiC3MjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245749AbiC3Mhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:37:40 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A2BA66DE;
        Wed, 30 Mar 2022 05:27:30 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nZXQ7-0005Vx-JJ; Wed, 30 Mar 2022 14:27:27 +0200
Message-ID: <44abc738-1532-63fa-9cd1-2b3870a963bc@leemhuis.info>
Date:   Wed, 30 Mar 2022 14:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Content-Language: en-US
To:     =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        jkosina@suse.cz
Cc:     tiwai@suse.de, benjamin.tissoires@redhat.com,
        regressions@leemhuis.info, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220321184404.20025-1-jose.exposito89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1648643250;87a12d18;
X-HE-SMSGID: 1nZXQ7-0005Vx-JJ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 21.03.22 19:44, José Expósito wrote:
> This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> 
> The touchpad present in the Dell Precision 7550 and 7750 laptops
> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> the device is not a clickpad, it is a touchpad with physical buttons.
> 
> In order to fix this issue, a quirk for the device was introduced in
> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> 
> 	[Precision 7x50 Touchpad]
> 	MatchBus=i2c
> 	MatchUdevType=touchpad
> 	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> 	AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> 
> However, because of the change introduced in 37ef4c19b4 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> anymore breaking the device right click button and making impossible to
> workaround it in user space.
> 
> In order to avoid breakage on other present or future devices, revert
> the patch causing the issue.
> 
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> [...]

Jiri, Benjamin, what the status here? Sure, this is not a crucial
regression and we are in the middle of the merge window, but it looks
like nothing has happened for a week now. Or was progress made somewhere
and I just missed it?

#regzbot ^backmonitor:
https://lore.kernel.org/stable/s5htubv32s8.wl-tiwai@suse.de/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.


