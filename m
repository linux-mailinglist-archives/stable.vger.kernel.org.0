Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A393DC6AA
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 17:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhGaP1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 11:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhGaP1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 11:27:51 -0400
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA5C0613CF
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 08:27:45 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GcSnT3zMLzMprMF;
        Sat, 31 Jul 2021 17:27:41 +0200 (CEST)
Received: from [IPv6:2a01:cb00:a36:2c00:aa:7049:abed:a55d] (unknown [IPV6:2a01:cb00:a36:2c00:aa:7049:abed:a55d])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4GcSnS5fBhzlh8TG;
        Sat, 31 Jul 2021 17:27:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=asdrip.fr;
        s=20210424; t=1627745261;
        bh=xe0VfNJnGUmf5zyVeLLOuRkOkSlS2Spd3dthfEc47ao=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=CGaoHCHwDs6gJwSrXJZof0s+Y84uB1abBkJHuvjnjDhCzA4tzdH9Mx0J7TGAZDt2r
         W3YVKbCMzWdLPIDoBPwn1SaoQwulT1oIDDZrH4ShQ7nc6PsDmdLRZ60S3OTvIFIPHi
         Inm2/5gRSxNnSaZ6q7IO5YkyuTARy/OIq4+Xlt80=
From:   Adrien Precigout <dev@asdrip.fr>
Subject: Re: Tr: Unable to boot on multiple kernel with acpi
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, erik.kaneda@intel.com
References: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr>
Message-ID: <eb9250ed-2ae9-07d5-e966-9063fffa34f8@asdrip.fr>
Date:   Sat, 31 Jul 2021 17:27:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi,
>
> On my acer swift 3 (SF314-51), I can't boot on my device since 
> 4.19.198 (no issue with 4.19.197) without adding "acpi=off" in the 
> parameters. Same thing happens on 5.12.19 (didn't happened in 
> 5.12.16), 5.13.4 and .5 and 5.10.52.
>
> If acpi is not off issue is :
> -black screen after grub,
> -no errors, no activity (tested by leaving the pc 10 hours), no tty, 
> no logs whatsoever in journalctl as if the kernel didn't start. Even 
> adding 'debug' or 'initcall_debug' doesn't show anything.
>
> If I add acpi=off, the screen blinks one time and boots normally but 
> after kernel 5.10 (5.12 and 5.13) I loose usage of keyboard and touchpad.
>
> Notes:
> - I'm using Manjaro KDE
> - I have tested with 4.19.198 Vanilla (config file attached) and same 
> thing happened
> - setting nomodeset doesn't change anything
> - tried every acpi parameters, only =off worked
> - Bios was not updated, but the bug persisted after upgrading it
> - Acpi issue is recurrent with this pc it seems below 4.11 
> (https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem 
> <https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem>)
>
> Thank you for your help,
> Adrien
>
Hi again,

I've done a bisect on the 4.19.y branch and I've found that it is the 
commit 2bf1f848ca0af4e3d49624df49cbbd5511ec49a3 [ACPICA: Fix memory leak 
caused by _CID repair function] that introduced the bug. By doing a git 
revert and building the kernel I can boot normally but as long as this 
commit exist I just get a black screen as explained above.

BR,

Adrien



