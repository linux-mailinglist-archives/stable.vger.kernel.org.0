Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F65A4A3DB0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 07:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiAaGd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 01:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbiAaGd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 01:33:57 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7C1C061714;
        Sun, 30 Jan 2022 22:33:56 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nEQGA-0007O6-6n; Mon, 31 Jan 2022 07:33:54 +0100
Message-ID: <407c2559-4593-c06f-1fdd-cd84d8cfe884@leemhuis.info>
Date:   Mon, 31 Jan 2022 07:33:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Possible ACPI bug/regression in i2c-i801 [plain text]
Content-Language: en-BS
To:     Kim Nilsson <kim@wayoftao.net>, jdelvare@suse.com
Cc:     linux-i2c@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
References: <2cd98d51-f868-2bbb-f048-8096a13aa2f7@wayoftao.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <2cd98d51-f868-2bbb-f048-8096a13aa2f7@wayoftao.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1643610836;b4913829;
X-HE-SMSGID: 1nEQGA-0007O6-6n
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: I'm adding this regression to regzbot, the Linux kernel
regression tracking bot; most text you find below is compiled from a few
templates paragraphs some of you might have seen already.]

Hi, this is your Linux kernel regression tracker speaking.

Adding the regression mailing list to the list of recipients, as it
should be in the loop for all regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

CCing Greg and Stable as well, as it's a stable regression.

On 30.01.22 22:33, Kim Nilsson wrote:
> 
> I've recently been doing some suspend/resume testing related to an
> s2idle bug in amdgpu
> (https://gitlab.freedesktop.org/drm/amd/-/issues/1879) and I've come
> across some problems with C-states.
> 
> After resuming from s2idle, Pkg(HW) will no longer enter any state C2 or
> deeper. Suspending to s3 would not trigger this issue on 5.16.2, but
> after trying out 5.16.4 I'm facing a similar problem where Pkg(HW) will
> rarely if ever go deeper than C3. Now, the reason I am contacting you is
> because I was playing around today and found that unloading i2c-i801
> seems to fix the issue.

Thanks for the report.

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.16.2..v5.16.4
#regzbot title i2c: Possible ACPI bug/regression in i2c-i801 [plain text]
#regzbot ignore-activity

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail) using the kernel.org redirector,
as explained in 'Documentation/process/submitting-patches.rst'. Regzbot
then will automatically mark the regression as resolved once the fix
lands in the appropriate tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

> # CPU: Intel(R) Core(TM) i7-8665U CPU @ 1.90GHz
> # GPU: Intel Corporation WhiskeyLake-U GT2 [UHD Graphics 620], Advanced
> Micro Devices, Inc. [AMD/ATI] Lexa XT [Radeon PRO WX 3100]
> # 00:15.0 Serial bus controller: Intel Corporation Cannon Point-LP
> Serial IO I2C Controller #0 (rev 30)
> # 00:15.1 Serial bus controller: Intel Corporation Cannon Point-LP
> Serial IO I2C Controller #1 (rev 300:19.0 Serial bus controller: Intel
> Corporation Cannon Point-LP Serial IO I2C Host Controller (rev 30)
> 
> 
> dmesg output when loading the module after an unload:
> 
> [ 1002.961091] i801_smbus 0000:00:1f.4: SPD Write Disable is set
> [ 1002.961171] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
> [ 1002.961321] iTCO_wdt iTCO_wdt: unable to reset NO_REBOOT flag, device
> disabled by hardware/BIOS
> [ 1002.975399] i801_smbus 0000:00:1f.4: Accelerometer lis3lv02d is
> present on SMBus but its address is unknown, skipping registration
> [ 1002.975406] i2c i2c-10: 2/2 memory slots populated (from DMI)
> [ 1002.976713] ee1004 10-0050: 512 byte EE1004-compliant SPD EEPROM,
> read-only
> [ 1002.976808] i2c i2c-10: Successfully instantiated SPD at 0x50
> 
> 
> This is my first LKML bug report, so I could use some guidance in how to
> provide more information.


Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)

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

---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c

