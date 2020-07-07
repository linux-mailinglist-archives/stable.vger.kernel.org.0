Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49948216E66
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgGGOLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 10:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGOLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 10:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A7F206E2;
        Tue,  7 Jul 2020 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594131062;
        bh=ubBUY7ArJKNzg22lsThqQ8ZAOcAYveuiTokKIE6DQdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z0YmtCLvzLMTTSJz7bMlY9/umz3SJUGxzibrHoxx6MSAmVFtmgkKROC6C5NtzCysG
         +X4kl+bLGGgRm4RW8UW6LZyXKgip4FvA5xPqeZCiRAPd2BrqrWncOCrwV9kvxkxUqR
         LT7V/c3yvIsB9QAm6OjPDFYiCpneb6i816qgv0uA=
Date:   Tue, 7 Jul 2020 16:11:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gabriel C <nix.or.die@googlemail.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k broken [was: Linux 5.7.3]
Message-ID: <20200707141100.GE4064836@kroah.com>
References: <1592410366125160@kroah.com>
 <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
 <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
 <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
 <CAEJqkghJWGsLCj2Wvt-yhzMewjXwrXhSEDpar6rbDpbSA6R8kQ@mail.gmail.com>
 <20200626133959.GA4024297@kroah.com>
 <CAEJqkgiACMar-iWsWQgJPAViBBURaNpcOD4FKtp6M8Aw_D4FOw@mail.gmail.com>
 <CAEJqkgg4Ka8oNL7ELoJrR0-Abz3=caLns48KyDC=DQcym6SRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEJqkgg4Ka8oNL7ELoJrR0-Abz3=caLns48KyDC=DQcym6SRvA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 04:40:18PM +0200, Gabriel C wrote:
> Am Fr., 26. Juni 2020 um 15:51 Uhr schrieb Gabriel C
> <nix.or.die@googlemail.com>:
> >
> > Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org>:
> > >
> > > On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
> > > > Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
> > > > <nix.or.die@googlemail.com>:
> > > > >
> > > > > Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
> > > > > <nix.or.die@googlemail.com>:
> > > > > >
> > > > > > Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
> > > > > > >
> > > > > > > On 25. 06. 20, 0:05, Gabriel C wrote:
> > > > > > > > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > > > > > > > <gregkh@linuxfoundation.org>:
> > > > > > > >>
> > > > > > > >> I'm announcing the release of the 5.7.3 kernel.
> > > > > > > >>
> > > > > > > >
> > > > > > > > Hello Greg,
> > > > > > > >
> > > > > > > >> Qiujun Huang (5):
> > > > > > > >>       ath9k: Fix use-after-free Read in htc_connect_service
> > > > > > > >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> > > > > > > >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> > > > > > > >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> > > > > > > >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > > > >>
> > > > > > > >
> > > > > > > > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > > > > > > > while working fine on <5.7.3.
> > > > > > > >
> > > > > > > > I don't have myself such HW, and the reported doesn't have any experience
> > > > > > > > in bisecting the kernel, so we build kernels, each with one of the
> > > > > > > > above commits reverted,
> > > > > > > > to find the bad commit.
> > > > > > > >
> > > > > > > > The winner is:
> > > > > > > >
> > > > > > > > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > > > > > > > Author: Qiujun Huang <hqjagain@gmail.com>
> > > > > > > > Date:   Sat Apr 4 12:18:38 2020 +0800
> > > > > > > >
> > > > > > > >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > > > >
> > > > > > > >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > > > > > > > ...
> > > > > > > >
> > > > > > > > Reverting this one fixed his problem.
> > > > > > >
> > > > > > > Obvious question: is 5.8-rc1 (containing the commit) broken too?
> > > > > >
> > > > > > Yes, it does, just checked.
> > > > > >
> > > > > > git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
> > > > > > v5.8-rc1
> > > > > > v5.8-rc2
> > > > > >
> > > > >
> > > > > Sorry, I read the wrong, I just woke up.
> > > > >
> > > > > We didn't test 5.8-rc{1,2} yet but we will today and let you know.
> > > > >
> > > >
> > > > We tested 5.8-rc2 and it is broken too.
> > > >
> > > > The exact HW name is:
> > > >
> > > > TP-link tl-wn722n (Atheros AR9271 chip)
> > >
> > > Great!
> > >
> > > Can you work with the developers to fix this in Linus's tree first?
> >
> > I'm the man in the middle, but sure we will try patches or any suggestions
> > from developers to identify and fix the problem.
> >
> > >
> > > I bet they want to see the output of 'lsusb -v' for this device to see
> > > if the endpoint calculations are correct...
> > >
> >
> > Working on it. As soon the reporter gives me the output, I will post it here.
> > I've told him to run it on a broken and one working kernel.
> 
> That is from a good kernel with reverted commit
> https://gist.github.com/AngryPenguinPL/07c8e2abd3b103eaf8978a39ad8577d1
> 
> That is from the broken kernel without the commit reverted
> https://gist.github.com/AngryPenguinPL/5cdc0dd16ce5e59ff3c32c048e2f5111
> 
> This is from 5.7.5 kernel, I don't have yet a 5.8-rc2 package with the
> reverted commit.

Did this ever get resolved?

thanks,

greg k-h
