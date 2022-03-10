Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FCD4D4428
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbiCJKDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241162AbiCJKDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:03:06 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7E513D57A;
        Thu, 10 Mar 2022 02:02:05 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nSFcR-0007oo-Nx; Thu, 10 Mar 2022 11:02:03 +0100
Message-ID: <3f86f46d-947b-8485-bf87-2ebd4477a6c7@leemhuis.info>
Date:   Thu, 10 Mar 2022 11:02:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Content-Language: en-US
To:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>
Cc:     stable@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646906525;9a6d15ed;
X-HE-SMSGID: 1nSFcR-0007oo-Nx
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 09.03.22 14:44, Hans de Goede wrote:
> 
> We (Fedora) have been receiving a whole bunch of bug reports about
> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> and this seems to still happen with 5.17-rc7 too.

I was about to sent a similar mail, but then I found this one. Thx for
making my life easier. :-D

But could you do me a big favor and CC the regression mailing list
(regressions@lists.linux.dev) in case similar situations arise in the
future? tia!

> The following are all bugzilla.redhat.com bug numbers:
> 
>    1750910 - Laptop failed to suspend and completely drained the battery
>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
>    2053957 - Package c-states never go below C2
>    2056729 - No lid events when closing lid / laptop does not suspend
>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> 
> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> the reporter:
> 
>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10

Here is another, but it's basically linking to reports you already
mentioned:
https://bugzilla.kernel.org/show_bug.cgi?id=215661

> The common denominator here (besides the kernel version) seems to
> be that these are all Ice or Tiger Lake systems (I did not do
> check this applies 100% to all bugs, but it does see, to be a pattern).
> 
> A similar arch-linux report:
> 
> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> 
> Suggest that reverting 
> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> 
> which was cherry-picked into 5.16.10 fixes things.

From the thread I gather that it looks like 5.17 is not affected; if
that changes, could anybody please give me a heads up please?

> If you want I can create Fedora kernel test-rpms of a recent
> 5.16.y with just that one commit reverted and ask users to
> confirm if that helps. Please let me know if doing that woulkd
> be useful ?

FWIW: To be sure below issue doesn't fall through the cracks unnoticed,
I'm adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced 4287509b4d21e34dc49266c
#regzbot ignore-activity

If it turns out this isn't a regression, free free to remove it from the
tracking by sending a reply to this thread containing a paragraph like
"#regzbot invalid: reason why this is invalid" (without the quotes).

Reminder for developers: when fixing the issue, please add a 'Link:'
tags pointing to the report (the mail quoted above) using
lore.kernel.org/r/, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'. Regzbot needs them to
automatically connect reports with fixes, but they are useful in
general, too.

I'm sending this to everyone that got the initial report, to make
everyone aware of the tracking. I also hope that messages like this
motivate people to directly get at least the regression mailing list and
ideally even regzbot involved when dealing with regressions, as messages
like this wouldn't be needed then. And don't worry, if I need to send
other mails regarding this regression only relevant for regzbot I'll
send them to the regressions lists only (with a tag in the subject so
people can filter them away). With a bit of luck no such messages will
be needed anyway.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

-- 
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
CC the regression list and tell regzbot about the issue, as that ensures
the regression makes it onto the radar of the Linux kernel's regression
tracker -- that's in your interest, as it ensures your report won't fall
through the cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include 'Link:' tag in the patch descriptions pointing to all reports
about the issue. This has been expected from developers even before
regzbot showed up for reasons explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'.
