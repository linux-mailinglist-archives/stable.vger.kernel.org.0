Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E466692D9
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 10:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbjAMJ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 04:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbjAMJ0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 04:26:42 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12533F102
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 01:20:34 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pGGEj-0000R9-9T; Fri, 13 Jan 2023 10:20:33 +0100
Message-ID: <21fdd6fe-c8f8-2ab6-fb73-3a2883cb1679@leemhuis.info>
Date:   Fri, 13 Jan 2023 10:20:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Kernel v6.0.18: Resume from hibernate fails, system hangs;
 bisected
Content-Language: en-US, de-DE
To:     Rainer Fiebig <jrf@mailbox.org>, stable@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Alex Deucher <alexander.deucher@amd.com>
References: <2d59ed2b-ba8f-6695-9764-fd3b109acd4c@mailbox.org>
From:   "Linux kernel regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <2d59ed2b-ba8f-6695-9764-fd3b109acd4c@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673601635;20216a28;
X-HE-SMSGID: 1pGGEj-0000R9-9T
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ccing Alex and the regressions list]

Hi, this is your Linux kernel regression tracker.

On 12.01.23 22:03, Rainer Fiebig wrote:
> Hi! Since kernel 6.0.18

Note, 6.0.y is now EOL, you should move to 6.1.y.

> resume from hibernate fails, the system hangs
> and a hard reset is necessary.  The CPU is a Ryzen 5600G, the system is
> Linux From Scratch-11.1.

FWIW, there is a report with a problems that looks somewhat similar here:

https://bugzilla.kernel.org/show_bug.cgi?id=216917

But the reporter doesn't care anymore, as 6.1 works.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

> I found this in the system log:
> 
> [...]
> Jan 12 19:30:03 LUX kernel: [   50.248036] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:67:crtc-0] flip_done timed out
> Jan 12 19:30:03 LUX kernel: [   50.248040] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:70:crtc-1] flip_done timed out
> Jan 12 19:30:14 LUX kernel: [   60.488034] amdgpu 0000:30:00.0: [drm]
> *ERROR* flip_done timed out
> Jan 12 19:30:14 LUX kernel: [   60.488040] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:67:crtc-0] commit wait timed out
> ^@^@^@^@^@^@^@^@^@^[...]@^@^@^@^@^@^@^@^@^@^@^@^@^@Jan 12 19:31:20 LUX
> syslogd 1.5.1: restart.
> [...]
> 
> 
> Bisecting the problem turned up this:
> 
> ~/Downloads/linux-stable-BLFS-11.1> git bisect bad
> 306df163069e78160e7a534b892c5cd6fefdd537 is the first bad commit
> commit 306df163069e78160e7a534b892c5cd6fefdd537
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Wed Dec 7 11:08:53 2022 -0500
> 
>     drm/amdgpu: make display pinning more flexible (v2)
> 
>     commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.
> 
>     Only apply the static threshold for Stoney and Carrizo.
>     This hardware has certain requirements that don't allow
>     mixing of GTT and VRAM.  Newer asics do not have these
>     requirements so we should be able to be more flexible
>     with where buffers end up.
>     [...]
> 
> 
> Let me know if you need more info. Thanks.
> 
> Rainer Fiebig
