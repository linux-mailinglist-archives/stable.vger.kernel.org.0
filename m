Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9094CCEEE
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 08:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiCDHQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 02:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbiCDHQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 02:16:21 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDD1134DCC;
        Thu,  3 Mar 2022 23:13:13 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nQ27i-00078Q-8L; Fri, 04 Mar 2022 08:13:10 +0100
Message-ID: <cadc5208-2eb1-beb1-4f6d-d07939072ca3@leemhuis.info>
Date:   Fri, 4 Mar 2022 08:13:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
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
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
 <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
 <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
 <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com>
 <CACRpkdZGVq19GZuOP1BwLB2-qxj1_=O9tHMVRvphvy3m6KbNig@mail.gmail.com>
 <CAMRc=McPSFQFPP1nSTXj3snKWqQyzNgz0j_J5ooyUrhRFRMqJQ@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
In-Reply-To: <CAMRc=McPSFQFPP1nSTXj3snKWqQyzNgz0j_J5ooyUrhRFRMqJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646377993;d52bd367;
X-HE-SMSGID: 1nQ27i-00078Q-8L
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 16.02.22 15:40, Bartosz Golaszewski wrote:
> On Tue, Feb 15, 2022 at 10:56 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> On Mon, Feb 14, 2022 at 12:24 AM Marcelo Roberto Jimenez
>> <marcelo.jimenez@gmail.com> wrote:
>>> On Sat, Feb 12, 2022 at 1:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>>>> I am curious about the usecases and how deeply you have built
>>>> yourselves into this.
>>>
>>> I don't know if I understand what you mean, sorry.
>>
>> Why does the user need the sysfs ABI? What is it used for?
>>
>> I.e what is the actual use case?
>>
>>>>> In any case, the upstream file should be enough to test the issue reported here.
>>>>
>>>> The thing is that upstream isn't super happy that you have been
>>>> making yourselves dependent on features that we are actively
>>>> discouraging and then demanding that we support these features.
>>>
>>> Hum, demanding seems to be a strong word for what I am doing here.
>>>
>>> Deprecated should not mean broken. My point is: the API seems to be
>>> currently broken. User space apps got broken, that's a fact. I even
>>> took the time to bisect the kernel and show you which commit broke it.
>>> So, no, I am not demanding. More like reporting and providing a
>>> temporary solution to those with a similar problem.
>>>
>>> Maybe it is time to remove the API, but this is up to "upstream".
>>> Leaving the API broken seems pointless and unproductive.
>>>
>>> Sorry for the "not super happiness of upstream", but maybe upstream
>>> got me wrong.
>>>
>>> We are not "making ourselves dependent on features ...". The API was
>>> there. We used it. Now it is deprecated, ok, we should move on. I got
>>> the message.
>>
>> Ouch I deserved some slamming for this.
>>
>> I'm sorry if I came across as harsh :(
>>
>> I just don't know how to properly push for this.
>>
>> I have even pushed the option of the deprecated sysfs ABI
>> behind the CONFIG_EXPERT option, which should mean that
>> the kernel config has been made by someone who has checked
>> the option "yes I am an expert I know what I am doing"
>> yet failed to observe that this ABI is obsoleted since 5 years
>> and hence failed to be an expert.
>>
>> Of course the ABI (not API really) needs to be fixed if we can find the
>> problem. It's frustrating that fixing it seems to fix broken other
>> features which are not deprecated, hence the annoyance on my
>> part.
>>
> 
> I'm afraid we'll earn ourselves a good old LinusRant if we keep
> pushing the character device as a solution to the problem here.
> Marcelo is right after all: he used an existing user interface, the
> interface broke, it must be fixed.
> 
> I would prefer to find a solution that fixes Marcelo's issue while
> keeping the offending patches in tree but it seems like the issue is
> more complicated and will require some rework of the sysfs interface.
> 
> In which case unless there are objections I lean towards reverting the
> relevant commits.

Sounds good to me, but that was two weeks ago and afaics nothing
happened since then. Or did the discussion continue somewhere else?

>>> And I will also tell the dev team that they must use the GPIO char dev
>>> and libgpiod from now on and must port everything to it. And we will
>>> likely have another group of people who are not super happy, but
>>> that's life... :)
>>
>> I'm happy to hear this!

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot poke
