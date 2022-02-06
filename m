Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365FD4AAEAF
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 10:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiBFJwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 04:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiBFJwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 04:52:11 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED19C06173B;
        Sun,  6 Feb 2022 01:52:09 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nGeDE-0005xC-Nn; Sun, 06 Feb 2022 10:52:04 +0100
Message-ID: <74cf71d9-8c9f-6b3d-8019-2d7f4e9d0d2d@leemhuis.info>
Date:   Sun, 6 Feb 2022 10:52:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
Content-Language: en-BS
To:     dann frazier <dann.frazier@canonical.com>,
        Rob Herring <robh@kernel.org>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20211129173637.303201-1-robh@kernel.org>
 <Yf2wTLjmcRj+AbDv@xps13.dannf>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Yf2wTLjmcRj+AbDv@xps13.dannf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1644141129;e2bf8b3e;
X-HE-SMSGID: 1nGeDE-0005xC-Nn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: I'm adding the regression report below to regzbot, the Linux
kernel regression tracking bot; nearly all text you find below is
compiled from a few templates paragraphs you likely have encountered
already already from mails similar to this one.]

Hi, this is your Linux kernel regression tracker speaking.

CCing the regression mailing list, as it should be in the loop for all
regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

On 05.02.22 00:01, dann frazier wrote:
> On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
>> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
>> broke PCI support on XGene. The cause is the IB resources are now sorted
>> in address order instead of being in DT dma-ranges order. The result is
>> which inbound registers are used for each region are swapped. I don't
>> know the details about this h/w, but it appears that IB region 0
>> registers can't handle a size greater than 4GB. In any case, limiting
>> the size for region 0 is enough to get back to the original assignment
>> of dma-ranges to regions.
> 
> hey Rob!
> 
> I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
> only during network installs - that I also bisected down to commit
> 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
> hoping that this patch that fixed the issue on Stéphane's X-Gene2
> system would also fix my issue, but no luck. In fact, it seems to just
> makes it fail differently. Reverting both patches is required to get a
> v5.17-rc kernel to boot.
> 
> I've collected the following logs - let me know if anything else would
> be useful.
> 
> 1) v5.17-rc2+ (unmodified):
>    http://dannf.org/bugs/m400-no-reverts.log
>    Note that the mlx4 driver fails initialization.
> 
> 2) v5.17-rc2+, w/o the commit that fixed Stéphane's system:
>    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
>    Note the mlx4 MSI-X timeout, and later panic.
> 
> 3) v5.17-rc2+, w/ both commits reverted (works)
>    http://dannf.org/bugs/m400-both-reverted.log

Thanks for the report.

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced c7a75d07827a1f33d
#regzbot title Follow-up error for the commit fixing "PCIe regression on
APM Merlin (aarch64 dev platform) preventing NVME initialization"
#regzbot ignore-activity

Reminder for developers: when fixing the issue, please add a 'Link:'
tags pointing to the report (the mail quoted above) using the
lore.kernel.org/r/, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst', as this allows the bot to assign
any fixes posted or commited with the report to always show the current
status of things and automatically close the issue when the fix hits the
right tree.

I'm sending this to everyone that got the initial report, to make them
aware of the tracking. I also hope that messages like this motivate
people to directly get at least the regression mailing list and ideally
even regzbot involved when dealing with regressions, as messages like
this wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), if
they are relevant just for regzbot. With a bit of luck no such messages
will be needed anyway.

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
