Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1676EE189
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfKDNvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfKDNvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 08:51:40 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F075821744;
        Mon,  4 Nov 2019 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572875499;
        bh=RMjBbcJSX/BFL942aPuRy8u04vdxeLErter4JodBkgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wa5OwO9yWDZ+m4tm147ehFCtVz7pQqLDS8HUpuWjPiRxj5UUWjwSgI5Zh4aPtG1p0
         fvUXZ6Xvt7EQIBzrtiCcJYqhCdOg8zkaDKYXzdQCZVGt4gen9SegcAhX8f+TPsY5Tf
         1m3LhVVTmtXL0lOqeuRoL+WQxbqLJ/lSalfZtklg=
Date:   Mon, 4 Nov 2019 14:51:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        alsa-devel@alsa-project.org, LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.9-rc1-dfe283e.cki (stable)
Message-ID: <20191104135135.GA2162401@kroah.com>
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com>
 <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 08:35:51AM -0500, Jan Stancek wrote:
> 
> 
> ----- Original Message -----
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: dfe283e9fdac - Linux 5.3.9-rc1
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://artifacts.cki-project.org/pipelines/262380
> > 
> > One or more kernel tests failed:
> > 
> >     x86_64:
> >      ❌ LTP lite
> >
> 
> Not a 5.3 -stable regression.
> 
> Failure comes from test that sanity checks all /proc files by doing
> 1k read from each. There are couple issues it hits wrt. snd_hda_*.
> 
> Example reproducer:
>   dd if=/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access of=out.txt count=1 bs=1024 iflag=nonblock

That's not a proc file :)

> It's slow and triggers soft lockups [1]. And it also requires lot
> of memory, triggering OOMs on smaller VMs:
> 0x0000000024f0437b-0x000000001a32b1c8 1073745920 seq_read+0x131/0x400 pages=262144 vmalloc vpages N0=262144
> 
> I'm leaning towards skipping all regmap entries in this test.
> Comments are welcomed.

Randomly poking around in debugfs is a sure way to cause crashes and
major problems.  Also, debugfs files are NOT stable and only for
debugging and should never be enabled on "real" systems.

So what exactly is the test trying to do here?

thanks,

greg k-h
