Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625636D983D
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbjDFNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbjDFNaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 09:30:08 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C2761BA
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 06:30:06 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pkPgi-000699-Ma; Thu, 06 Apr 2023 15:30:04 +0200
Message-ID: <c87add10-3e8f-b17e-f3f5-067431a23e16@leemhuis.info>
Date:   Thu, 6 Apr 2023 15:30:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: 6.1.22: Resume from hibernate fails; bisected
Content-Language: en-US, de-DE
To:     Rainer Fiebig <jrf@mailbox.org>, stable@vger.kernel.org,
        tim.huang@amd.com, Alex Deucher <alexander.deucher@amd.com>,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <b52bfd11-0d90-739b-be3e-058e246478f7@mailbox.org>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <b52bfd11-0d90-739b-be3e-058e246478f7@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680787806;ff43d043;
X-HE-SMSGID: 1pkPgi-000699-Ma
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

On 06.04.23 14:06, Rainer Fiebig wrote:
> Hi! Since kernel 6.1.22 starting a resume from hibernate by hitting a
> key on the keyboard fails. However, if the PC was switched off and on
> again (or reset), the resume is OK. The APU  is a Ryzen 5600G.
> 
> Bisecting between 6.1.21/22 turned up this:
> 
> 
> Author: Tim Huang <tim.huang@amd.com>
> Date:   Thu Mar 9 16:27:51 2023 +0800
> 
>     drm/amdgpu: skip ASIC reset for APUs when go to S4
> 
>     commit b589626674de94d977e81c99bf7905872b991197 upstream.
> 
>     For GC IP v11.0.4/11, PSP TMR need to be reserved
>     for ASIC mode2 reset. But for S4, when psp suspend,
>     it will destroy the TMR that fails the ASIC reset.
> [...]
> 
> 
> Reverting the commit solves the problem.
> Thanks.

Please try 6.1.23 and report back, because from the thread
https://lore.kernel.org/all/20230330160740.1dbff94b@schienar/
it sounds a lot like "drm/amdgpu: allow more APUs to do mode2 reset when
go to S4" might be fixing this, which went into 6.1.23.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

