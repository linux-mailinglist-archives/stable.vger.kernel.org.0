Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2F284C82
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 15:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJFN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 09:26:46 -0400
Received: from aibo.runbox.com ([91.220.196.211]:41138 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgJFN0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 09:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=TeGxjBzT6R6tYdJmUFRAv74SJEyv88BooIGE4Bn2zy8=; b=IlpqtjLCedSA/jGCw/o/KSMVmN
        IUf1rufygTDXaKVJCQ4m7JnH0gpjYClTpHm+g+uxBOSLjPWr85UQZ9gd9juk9k/YoGmvF1gIUEIPz
        7/h4ENchER4gMQ8r5kpoE1SQqRfmvxltF/SJFgKRBOOQCRsyuLF4gOSUQZzJfSSyrzSbpYHPmeVM4
        28WzqsQdGabkJXM7HvI2HnMuytYOdttxl2P6/9FvzJ23FWN2SwArjC5UA7dozzeUGQmx7eyZjRIOb
        NKVwnkB/XWxwqDLRFvIuFV43TWIPi7mGbnuMIb0Ehy0N0yKgiFsHZvkpq+zb1evKUjUbitPZdY2eN
        6HPiOP7w==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kPmzE-0002BJ-Tq; Tue, 06 Oct 2020 15:26:37 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kPmz8-0000RQ-Tk; Tue, 06 Oct 2020 15:26:31 +0200
Subject: Re: [PATCH 5.8 05/85] Revert "usbip: Implement a match function to
 fix usbip"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
 <20201005142115.000911358@linuxfoundation.org>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <ad55b590-da4a-4aa8-7a04-302a8d55d723@runbox.com>
Date:   Tue, 6 Oct 2020 16:26:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005142115.000911358@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/10/2020 18.26, Greg Kroah-Hartman wrote:
> From: M. Vefa Bicakci <m.v.b@runbox.com>
> 
> commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.
> 
> This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
> function to fix usbip").
> 
> In summary, commit d5643d2249b2 ("USB: Fix device driver race")
> inadvertently broke usbip functionality, which I resolved in an incorrect
> manner by introducing a match function to usbip, usbip_match(), that
> unconditionally returns true.
> 
> However, the usbip_match function, as is, causes usbip to take over
> virtual devices used by syzkaller for USB fuzzing, which is a regression
> reported by Andrey Konovalov.
> 
> Furthermore, in conjunction with the fix of another bug, handled by another
> patch titled "usbcore/driver: Fix specific driver selection" in this patch
> set, the usbip_match function causes unexpected USB subsystem behaviour
> when the usbip_host driver is loaded. The unexpected behaviour can be
> qualified as follows:
> - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
>    in the kernel, then all USB devices are bound to the usbip_host
>    driver, which appears to the user as if all USB devices were
>    disconnected.
> - If the same commit (41160802ab8e) is not in the kernel (as is the case
>    with v5.8.10) then all USB devices are re-probed and re-bound to their
>    original device drivers, which appears to the user as a disconnection
>    and re-connection of USB devices.
> 
> Please note that this commit will make usbip non-operational again,
> until yet another patch in this patch set is merged, titled
> "usbcore/driver: Accommodate usbip".
> 
> Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
> Cc: <stable@vger.kernel.org> # 5.8

Hello Greg,

Sorry for the lateness of this e-mail.

I had noted commit 41160802ab8e ("USB: Simplify USB ID table match") as a
prerequisite in the commit message, but I just realized that the commit
identifier refers to a commit in my local git tree, and not to the actual
commit in Linus Torvalds' git tree! I apologize for this mistake.

Here is the correct commit identifier:
   0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944 ("USB: Simplify USB ID table match")

Perhaps this is why the prerequisite commit was not cherry-picked to the 5.8.y
branch.

As a justification for the cherry-pick, commit 0ed9498f9ecf actually resolves
a bug. In summary, this commit works together with commit adb6e6ac20ee ("USB:
Also match device drivers using the ->match vfunc", which has been cherry-picked
as part of v5.8.6) and ensures that a USB driver's ->match function is also
called during the search for a more specialized/appropriate USB driver, in case
the driver in question does not have an id_table.

If I am to be the devil's advocate, however, then given that there is only one
specialized USB device driver ("apple-mfi-fastcharge"), which conveniently has
an id_table, and also given that usbip no longer has a match function, I also
realize that it may not be crucial to cherry-pick 0ed9498f9ecf as a prerequisite
commit.

I just wanted to bring this to your attention.

Thank you,

Vefa
