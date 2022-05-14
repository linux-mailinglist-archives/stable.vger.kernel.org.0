Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF552727C
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiENPMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 11:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiENPMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 11:12:44 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A125EB8
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:12:38 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nptRb-0000jF-AL; Sat, 14 May 2022 17:12:35 +0200
Message-ID: <eed25dd6-36ba-cd1c-1828-08a1535ce6c6@leemhuis.info>
Date:   Sat, 14 May 2022 17:12:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Christian Casteyde <casteyde.christian@free.fr>,
        stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, kai.heng.feng@canonical.com,
        alexander.deucher@amd.com, gregkh@linuxfoundation.org
References: <2584945.lGaqSPkdTl@geek500.localdomain>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
In-Reply-To: <2584945.lGaqSPkdTl@geek500.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1652541158;b2f341d0;
X-HE-SMSGID: 1nptRb-0000jF-AL
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Thanks for the report.

On 14.05.22 16:41, Christian Casteyde wrote:
> #regzbot introduced v5.17.3..v5.17.4
> #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9

FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA function is
suspended before ASIC reset") upstream.

Recently a regression was reported where 887f75cfd0da was suspected as
the culprit:
https://gitlab.freedesktop.org/drm/amd/-/issues/2008

And a one related to it:
https://gitlab.freedesktop.org/drm/amd/-/issues/1982

You might want to take a look if what was discussed there might be
related to your problem (I'm not directly involved in any of this, I
don't know the details, it's just that 887f75cfd0da looked familiar to
me). If it is, a fix for these two bugs was committed to master earlier
this week:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a56f445f807b0276

It will likely be backported to 5.17.y, maybe already in the over-next
release. HTH.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

> Hello
> Since 5.17.4 my laptop doesn't resume from suspend anymore. At resume, 
> symptoms are variable:
> - either the laptop freezes;
> - either the screen keeps blank;
> - either the screen is OK but mouse is frozen;
> - either display lags with several logs in dmesg:
> [  228.275492] [drm] Fence fallback timer expired on ring gfx
> [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for fences 
> timed out!
> [  228.779490] [drm] Fence fallback timer expired on ring gfx
> [  229.283484] [drm] Fence fallback timer expired on ring sdma0
> [  229.283485] [drm] Fence fallback timer expired on ring gfx
> [  229.787487] [drm] Fence fallback timer expired on ring gfx
> ...
> 
> I've bisected the problem.
> 
> Please note this laptop has a strange behaviour on suspend:
> The first suspend request always fails (this point has never been fixed and 
> plagues us when trying to diagnose another regression on touchpad not resuming 
> in the past). The screen goes blank and I can get it OK when pressing the 
> power button, this seems to reset it. After that all suspend/resume works OK.
> 
> Since 5.17.4, it is not possible anymore to get the laptop working again after 
> the first suspend failure.
> 
> HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated + NVidia 1650Ti 
> (turned off with ACPI call in order to get more battery, I'm not using NVidia 
> driver).
> 
> 
> 
> 
> 
