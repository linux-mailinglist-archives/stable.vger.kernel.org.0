Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1548907C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbiAJHCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiAJHCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:02:17 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EF0C06173F;
        Sun,  9 Jan 2022 23:02:17 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n6oh3-00076n-RO; Mon, 10 Jan 2022 08:02:14 +0100
Message-ID: <37d074c7-b264-acac-4bf6-65caa4dbab1a@leemhuis.info>
Date:   Mon, 10 Jan 2022 08:02:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Content-Language: en-BS
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info>
 <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1641798137;5d3cb544;
X-HE-SMSGID: 1n6oh3-00076n-RO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 20.12.21 21:41, Marcelo Roberto Jimenez wrote:
> On Mon, Dec 20, 2021 at 11:57 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
>> <regressions@leemhuis.info> wrote:
>>>
>>> [TLDR: I'm adding this regression to regzbot, the Linux kernel
>>> regression tracking bot; most text you find below is compiled from a few
>>> templates paragraphs some of you might have seen already.]
>>>
>>> On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
>>>> Some GPIO lines have stopped working after the patch
>>>> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
>>>>
>>>> And this has supposedly been fixed in the following patches
>>>> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
>>>> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>>>
>>> There seems to be a backstory here. Are there any entries and bug
>>> trackers or earlier discussions everyone that looks into this should be
>>> aware of?
>>
>> Agreed with Thorsten. I'd like to first try to determine what's wrong
>> before reverting those, as they are correct in theory but maybe the
>> implementation missed something.
>>
>> Have you tried tracing the execution on your platform in order to see
>> what the driver is doing?
> 
> Yes. The problem is that there is no list defined for the sysfs-gpio
> interface. The driver will not perform pinctrl_gpio_request() and will
> return zero (failure).
> 
> I don't know if this is the case to add something to a global DTD or
> to fix it in the sysfs-gpio code.

Out of interest, has any progress been made on this front?

BTW, there was a last-minute commit for 5.16 yesterday that referenced
the culprit Marcelo specified:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=c8013355ead68dce152cf426686f8a5f80d88b40

This was for a BCM283x and BCM2711 devices, so I assume it won't help.
Wild guess (I don't know anything about this area of the kernel):
Marcelo, do the dts files for your hardware maybe need a similar fix?

Ciao, Thorsten

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply, that's in everyone's interest.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

#regzbot poke

