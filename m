Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259B63DCA42
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 08:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhHAGFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 02:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHAGFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Aug 2021 02:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C93EA60EE9;
        Sun,  1 Aug 2021 06:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627797937;
        bh=lZYTf0hB8SVyjZ0HrbaV7fPUmQEOgzERwyKm7Q3fBQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLu5v5M8nctM7CzmuNibUCbZiHMLwzMLjSskhnFRGVBVgc4UfQ6U9bbMv6DHIGbf0
         RT+KycDF+lmr4CKFDbZk1jxMxtIF4PgaT+7cqEXPjZ6w9b+xZRWNkVXJW7NAO4Rr33
         bQ+WK5Q3GMeb7/5PQxZBSu8Bjx9zuTFx0Qn8tr70=
Date:   Sun, 1 Aug 2021 08:05:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrien Precigout <dev@asdrip.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        erik.kaneda@intel.com, linux-api@vger.kernel.org
Subject: Re: Tr: Unable to boot on multiple kernel with acpi
Message-ID: <YQY5rsWFhk5Okt0Y@kroah.com>
References: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr>
 <eb9250ed-2ae9-07d5-e966-9063fffa34f8@asdrip.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb9250ed-2ae9-07d5-e966-9063fffa34f8@asdrip.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 31, 2021 at 05:27:39PM +0200, Adrien Precigout wrote:
> > Hi,
> > 
> > On my acer swift 3 (SF314-51), I can't boot on my device since 4.19.198
> > (no issue with 4.19.197) without adding "acpi=off" in the parameters.
> > Same thing happens on 5.12.19 (didn't happened in 5.12.16), 5.13.4 and
> > .5 and 5.10.52.
> > 
> > If acpi is not off issue is :
> > -black screen after grub,
> > -no errors, no activity (tested by leaving the pc 10 hours), no tty, no
> > logs whatsoever in journalctl as if the kernel didn't start. Even adding
> > 'debug' or 'initcall_debug' doesn't show anything.
> > 
> > If I add acpi=off, the screen blinks one time and boots normally but
> > after kernel 5.10 (5.12 and 5.13) I loose usage of keyboard and
> > touchpad.
> > 
> > Notes:
> > - I'm using Manjaro KDE
> > - I have tested with 4.19.198 Vanilla (config file attached) and same
> > thing happened
> > - setting nomodeset doesn't change anything
> > - tried every acpi parameters, only =off worked
> > - Bios was not updated, but the bug persisted after upgrading it
> > - Acpi issue is recurrent with this pc it seems below 4.11
> > (https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem
> > <https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem>)
> > 
> > Thank you for your help,
> > Adrien
> > 
> Hi again,
> 
> I've done a bisect on the 4.19.y branch and I've found that it is the commit
> 2bf1f848ca0af4e3d49624df49cbbd5511ec49a3 [ACPICA: Fix memory leak caused by
> _CID repair function] that introduced the bug. By doing a git revert and
> building the kernel I can boot normally but as long as this commit exist I
> just get a black screen as explained above.

Thanks for helping to narrow this down.

Rafael and EriK, this is commit c27bac031413 ("ACPICA: Fix memory leak
caused by _CID repair function") in Linus's tree, that showed up in
5.14-rc1.  Any chance you all can revert this, or provide a fix?

thanks,

greg k-h
