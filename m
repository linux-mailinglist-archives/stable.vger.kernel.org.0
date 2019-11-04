Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0118EE4AC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 17:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfKDQah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 11:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfKDQah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 11:30:37 -0500
Received: from localhost (host6-102.lan-isdn.imaginet.fr [195.68.6.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D4420848;
        Mon,  4 Nov 2019 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572885036;
        bh=LAgGrLgKpPDH4JoKlSYbiJE2P0LnY+YWKSFwGFoyof4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLRmcQtayL0Ww8WXWF4NtrWd+fnrVdGADzIgSXa/r38+ParsPH7oMtF/EK/4dtV+G
         j6jnDur3TtCmoDLb3MrA1PjLeMEcONgnS1RR5lALo2HJC1ihUqNz6GpxiT/XUvn1uX
         doyvn5mudQR7Z4l2pSnYkvUAQ6G4sSJyaiNHP+Mo=
Date:   Mon, 4 Nov 2019 17:30:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        alsa-devel@alsa-project.org, LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.9-rc1-dfe283e.cki (stable)
Message-ID: <20191104163033.GB2253150@kroah.com>
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com>
 <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com>
 <20191104135135.GA2162401@kroah.com>
 <1341418315.10342806.1572877690830.JavaMail.zimbra@redhat.com>
 <20191104145947.GA2211991@kroah.com>
 <251943262.10356408.1572881121044.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <251943262.10356408.1572881121044.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 10:25:21AM -0500, Jan Stancek wrote:
> 
> ----- Original Message -----
> > On Mon, Nov 04, 2019 at 09:28:10AM -0500, Jan Stancek wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > On Mon, Nov 04, 2019 at 08:35:51AM -0500, Jan Stancek wrote:
> > > > > 
> > > > > 
> > > > > ----- Original Message -----
> > > > > > 
> > > > > > Hello,
> > > > > > 
> > > > > > We ran automated tests on a recent commit from this kernel tree:
> > > > > > 
> > > > > >        Kernel repo:
> > > > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > > >             Commit: dfe283e9fdac - Linux 5.3.9-rc1
> > > > > > 
> > > > > > The results of these automated tests are provided below.
> > > > > > 
> > > > > >     Overall result: FAILED (see details below)
> > > > > >              Merge: OK
> > > > > >            Compile: OK
> > > > > >              Tests: FAILED
> > > > > > 
> > > > > > All kernel binaries, config files, and logs are available for
> > > > > > download
> > > > > > here:
> > > > > > 
> > > > > >   https://artifacts.cki-project.org/pipelines/262380
> > > > > > 
> > > > > > One or more kernel tests failed:
> > > > > > 
> > > > > >     x86_64:
> > > > > >      ❌ LTP lite
> > > > > >
> > > > > 
> > > > > Not a 5.3 -stable regression.
> > > > > 
> > > > > Failure comes from test that sanity checks all /proc files by doing
> > > > > 1k read from each. There are couple issues it hits wrt. snd_hda_*.
> > > > > 
> > > > > Example reproducer:
> > > > >   dd if=/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access of=out.txt
> > > > >   count=1 bs=1024 iflag=nonblock
> > > > 
> > > > That's not a proc file :)
> > > 
> > > Right. It's same test that's used for /proc too.
> > > 
> > > > 
> > > > > It's slow and triggers soft lockups [1]. And it also requires lot
> > > > > of memory, triggering OOMs on smaller VMs:
> > > > > 0x0000000024f0437b-0x000000001a32b1c8 1073745920 seq_read+0x131/0x400
> > > > > pages=262144 vmalloc vpages N0=262144
> > > > > 
> > > > > I'm leaning towards skipping all regmap entries in this test.
> > > > > Comments are welcomed.
> > > > 
> > > > Randomly poking around in debugfs is a sure way to cause crashes and
> > > > major problems.  Also, debugfs files are NOT stable and only for
> > > > debugging and should never be enabled on "real" systems.
> > > > 
> > > > So what exactly is the test trying to do here?
> > > 
> > > It's (unprivileged) user trying to open/read anything it can (/proc, /sys)
> > > to see if that triggers anything bad.
> > > 
> > > It can run as privileged user too, which was the case above.
> > 
> > Sure, you can do tons of bad things as root poking around in sysfs,
> > debugfs, and procfs.  What exactly are you trying to do, break the
> > system?
> 
> We are talking about read-only here. Is it unreasonable to expect
> that root can read all /proc entries without crashing the system?

You are NOT reading /proc/ here.  You are reading debugfs which you
really have NOT idea what is in there.  As you saw, you are reading from
hardware that is slow and doing odd things when you read from it.

And yes, there are some /proc/ files that you should not read from as
root and expect things to always work.  PCI devices are notorious for
this, and if you are reading those files as root, you "know" you know
what you are doing and can accept the risk for when things go wrong.

It is fine to write tests to read specific /proc/ files that you know
what is happening in them.  To pick random ones is never a good idea.

thanks,

greg k-h
