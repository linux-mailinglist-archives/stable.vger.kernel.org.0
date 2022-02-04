Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2304A9572
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiBDIs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiBDIs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:48:28 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA93C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:48:28 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nFuGW-0006hE-PR; Fri, 04 Feb 2022 09:48:24 +0100
Message-ID: <f0e5b970-5982-313b-8c75-b839086ce100@leemhuis.info>
Date:   Fri, 4 Feb 2022 09:48:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Regression/boot failure on 5.16.3
Content-Language: en-BS
To:     Jason Self <jason@bluehome.net>, stable@vger.kernel.org
References: <20220203161959.3edf1d6e@valencia>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
In-Reply-To: <20220203161959.3edf1d6e@valencia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1643964508;b6182172;
X-HE-SMSGID: 1nFuGW-0006hE-PR
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

On 04.02.22 01:19, Jason Self wrote:
> The computer (amd64) fails to boot. The init was stuck at the
> synchronization of the time through the network. This began between
> 5.16.2 (good) and 5.16.3 (bad.) This continues on 5.16.4 and 5.16.5.
> Git bisect revealed the following. In this case the nonfree firmwre is
> not present on the system. Blacklisting the iwflwifi module works as a
> workaround for now.
> 
> 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1 is the first bad commit
> commit 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Dec 10 11:12:42 2021 +0200

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1
#regzbot title net: iwlwifi: system fails to boot since 5.16.3
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


>     iwlwifi: fix leaks/bad data after failed firmware load
>     
>     [ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]
>     
>     If firmware load fails after having loaded some parts of the
>     firmware, e.g. the IML image, then this would leak. For the
>     host command list we'd end up running into a WARN on the next
>     attempt to load another firmware image.
>     
>     Fix this by calling iwl_dealloc_ucode() on failures, and make
>     that also clear the data so we start fresh on the next round.
>     
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Link:
>     https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

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
