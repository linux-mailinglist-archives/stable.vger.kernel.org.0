Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F207691F0A
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 13:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjBJMZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 07:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjBJMZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 07:25:09 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C7E7359E;
        Fri, 10 Feb 2023 04:24:57 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pQSSV-00082x-0K; Fri, 10 Feb 2023 13:24:55 +0100
Message-ID: <10a47408-3019-403d-97b1-c9f36e52e130@leemhuis.info>
Date:   Fri, 10 Feb 2023 13:24:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Resume after suspend broken, reboots instead on kernel 6.1
 onwards x86_64 RTW88
Content-Language: en-US, de-DE
To:     gary.chang@realtek.com, Yan-Hsuan Chuang <tony0620emma@gmail.com>
Cc:     regressions@lists.linux.dev, linux-wireless@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        Kalle Valo <kvalo@kernel.org>,
        Paul Gover <pmw.gover@yahoo.co.uk>, stable@vger.kernel.org
References: <3739412.kQq0lBPeGt.ref@ryzen> <3739412.kQq0lBPeGt@ryzen>
From:   "Linux kernel regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <3739412.kQq0lBPeGt@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1676031897;76a6ebd0;
X-HE-SMSGID: 1pQSSV-00082x-0K
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[adding Chih-Kang Chang (author), Kalle (committer) and LKML to the list
of recipients]

[anyone who replies to this: feel free to remove stable@vger.kernel.org
from the recipients, this is a mainline regression]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 09.02.23 20:59, Paul Gover wrote:
> Suspend/Resume was working OK on kernel 6.0.13, broken since 6.1.1
> (I've not tried kernels between those, except in the bisect below.)
> All subsequent 6,1 kernels exhibit the same behaviour.
> 
> Suspend works OK, but on Resume, there's a flicker, and then it reboots.
> Sometimes the screen gets restored to its contents at the time of suspend. but 
> less than a second later, it starts rebooting.
> To reproduce, simply boot, suspend, and resume.
> 
> Git bisect blames RTW88
> commit 6bf3a083407b5d404d70efc3a5ac75b472e5efa9

TWIMC, that's "wifi: rtw88: add flag check before enter or leave IPS"

> I'll attach bisect log, dmesg and configs to the bug I've opened 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=217016
> 
> dmesg from the following boot show a hardware error.
> It's not there when the system resumes or reboots with 6.0.13,
> and if I don't suspend & resume, there are no reported errors.
> 
> The problem occurs under both Wayland and X11, and from the command line via 
> echo mem>/sys/power.state
> 
> 
> Vanilla kernels, untainted, compiled with GCC; my system is Gentoo FWIW, but I 
> do my own kernels direct from a git clone of stable.
> 
> Couldn't find anything similar with Google or the mailing lists.
> 
> **Hardware:**
> 
> HP Laptop 15-bw0xx
> AMD A9-9420 RADEON R5, 5 COMPUTE CORES
> Stoney [Radeon R2/R3/R4/R5 Graphics]
> 4 GB memory
> RTL8723DE PCIe adapter
> 
> **Kernel**
> 
> Kernel command line:
> psmouse.synaptics_intertouch=1 pcie_aspm=force rdrand=force rootfstype=f2fs 
> root=LABEL=gentoo
> 
> CONFIG_RTW88=m
> CONFIG_RTW88_CORE=m
> CONFIG_RTW88_PCI=m
> CONFIG_RTW88_8723D=m
> # CONFIG_RTW88_8822BE is not set
> # CONFIG_RTW88_8822CE is not set
> CONFIG_RTW88_8723DE=m
> # CONFIG_RTW88_8821CE is not set
> # CONFIG_RTW88_DEBUG is not set
> # CONFIG_RTW88_DEBUGFS is not set
> # CONFIG_RTW89 is not set

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced 6bf3a083407b
#regzbot title wifi: rtw88: resume broken (reboot)
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
