Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA25285BAA
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgJGJMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgJGJMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:12:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FFF204EC;
        Wed,  7 Oct 2020 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061960;
        bh=GGf3v+keEJl27fl/reXppAsR7VWyzAcjRjLjHR8aKhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EyrmmIMEHS8nKj4+hHnrFi7/ht0wmdlNWzy2ijninxCkJewmjZ/iULg60WcIW5ah5
         yrGJ8/3H2nJ2EdPA3BKyHAJqFg3+6lN2L7X0pgNX4Wskvemqsu8pWq4f8pCj7Zd2Jr
         S8vfkVlb86Aj/Pg9iZ2YW+YXCyATor6AVJN49pHQ=
Date:   Wed, 7 Oct 2020 11:13:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 5.8 05/85] Revert "usbip: Implement a match function to
 fix usbip"
Message-ID: <20201007091324.GF614379@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <20201005142115.000911358@linuxfoundation.org>
 <ad55b590-da4a-4aa8-7a04-302a8d55d723@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad55b590-da4a-4aa8-7a04-302a8d55d723@runbox.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 04:26:27PM +0300, M. Vefa Bicakci wrote:
> On 05/10/2020 18.26, Greg Kroah-Hartman wrote:
> > From: M. Vefa Bicakci <m.v.b@runbox.com>
> > 
> > commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.
> > 
> > This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
> > function to fix usbip").
> > 
> > In summary, commit d5643d2249b2 ("USB: Fix device driver race")
> > inadvertently broke usbip functionality, which I resolved in an incorrect
> > manner by introducing a match function to usbip, usbip_match(), that
> > unconditionally returns true.
> > 
> > However, the usbip_match function, as is, causes usbip to take over
> > virtual devices used by syzkaller for USB fuzzing, which is a regression
> > reported by Andrey Konovalov.
> > 
> > Furthermore, in conjunction with the fix of another bug, handled by another
> > patch titled "usbcore/driver: Fix specific driver selection" in this patch
> > set, the usbip_match function causes unexpected USB subsystem behaviour
> > when the usbip_host driver is loaded. The unexpected behaviour can be
> > qualified as follows:
> > - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
> >    in the kernel, then all USB devices are bound to the usbip_host
> >    driver, which appears to the user as if all USB devices were
> >    disconnected.
> > - If the same commit (41160802ab8e) is not in the kernel (as is the case
> >    with v5.8.10) then all USB devices are re-probed and re-bound to their
> >    original device drivers, which appears to the user as a disconnection
> >    and re-connection of USB devices.
> > 
> > Please note that this commit will make usbip non-operational again,
> > until yet another patch in this patch set is merged, titled
> > "usbcore/driver: Accommodate usbip".
> > 
> > Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
> > Cc: <stable@vger.kernel.org> # 5.8
> 
> Hello Greg,
> 
> Sorry for the lateness of this e-mail.
> 
> I had noted commit 41160802ab8e ("USB: Simplify USB ID table match") as a
> prerequisite in the commit message, but I just realized that the commit
> identifier refers to a commit in my local git tree, and not to the actual
> commit in Linus Torvalds' git tree! I apologize for this mistake.
> 
> Here is the correct commit identifier:
>   0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944 ("USB: Simplify USB ID table match")
> 
> Perhaps this is why the prerequisite commit was not cherry-picked to the 5.8.y
> branch.
> 
> As a justification for the cherry-pick, commit 0ed9498f9ecf actually resolves
> a bug. In summary, this commit works together with commit adb6e6ac20ee ("USB:
> Also match device drivers using the ->match vfunc", which has been cherry-picked
> as part of v5.8.6) and ensures that a USB driver's ->match function is also
> called during the search for a more specialized/appropriate USB driver, in case
> the driver in question does not have an id_table.
> 
> If I am to be the devil's advocate, however, then given that there is only one
> specialized USB device driver ("apple-mfi-fastcharge"), which conveniently has
> an id_table, and also given that usbip no longer has a match function, I also
> realize that it may not be crucial to cherry-pick 0ed9498f9ecf as a prerequisite
> commit.

I'm sorry, but I don't really understand.  Does 5.8.y need an additional
patch here, or is all ok because I missed the above patch?

thanks,

greg k-h
