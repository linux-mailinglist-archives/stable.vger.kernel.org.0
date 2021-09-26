Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1C24187E8
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 11:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhIZJbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 05:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhIZJbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 05:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C4C3600CC;
        Sun, 26 Sep 2021 09:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632648601;
        bh=pPudxk3CsgGXPqe6PiLOqvYkDNYOXngQaJfkKoq8SEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HgHRn/t9XvYwEP1PZhtjN85StzUNw2GkxQTHSLlqY6CzSMFRMILstlio5qNfs/591
         HWBi/5QElaimM++2tZP/gwfNjMLf8fomcU8sFAUWCKVyrzcUWN9BGvDaUe30AC8p6j
         +wlrghgIsDDOyUmiUY3S09RquXVpfNiDKHQzkI9o=
Date:   Sun, 26 Sep 2021 11:29:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <YVA9l9svFyDgLPJy@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
 <YVAhOlTsb0NK0BVi@kroah.com>
 <YVArDZSq9oaTFakz@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVArDZSq9oaTFakz@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021 at 10:10:53AM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Sun, Sep 26, 2021 at 09:28:58AM +0200, Greg Kroah-Hartman wrote:
> > On Sun, Sep 26, 2021 at 07:23:33AM +0000, Jari Ruusu wrote:
> > > Earlier this year there was some discussion about kernel version numbers
> > > after 4.9.255 and 4.4.255. Problem was 8-bit limitation for SUBLEVEL
> > > number in stable kernel versions. The fix was to freeze LINUX_VERSION_CODE
> > > number at x.x.255 and to continue incrementing SUBLEVEL number. Seems
> > > there are more more fallout from that decision. At least some versions of
> > > glibc do not play well with larger SUBLEVEL numbers.
> > > 
> > > 
> > > # uname -s -r -m
> > > Linux 4.9.283-QEMU armv6l
> > > # apt upgrade
> > > Reading package lists... Done
> > > Building dependency tree
> > > Reading state information... Done
> > > Calculating upgrade... Done
> > > The following packages will be upgraded:
> > >  [SNIP]
> > > Fetched 145 MB in 1min 57s (1244 kB/s)
> > > Reading changelogs... Done
> > > Preconfiguring packages ...
> > > (Reading database ... 39028 files and directories currently installed.)
> > > Preparing to unpack .../libc6-dbg_2.28-10+rpt2+rpi1_armhf.deb ...
> > > Unpacking libc6-dbg:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > > Preparing to unpack .../libc6-dev_2.28-10+rpt2+rpi1_armhf.deb ...
> > > Unpacking libc6-dev:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > > Preparing to unpack .../libc-dev-bin_2.28-10+rpt2+rpi1_armhf.deb ...
> > > Unpacking libc-dev-bin (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
> > > Preparing to unpack .../linux-libc-dev_1%3a1.20210831-3~buster_armhf.deb ...
> > > Unpacking linux-libc-dev:armhf (1:1.20210831-3~buster) over (1:1.20210527-1) ...
> > > Preparing to unpack .../libc6_2.28-10+rpt2+rpi1_armhf.deb ...
> > > ERROR: Your kernel version indicates a revision number
> > > of 255 or greater.  Glibc has a number of built in
> > > assumptions that this revision number is less than 255.
> > > If you\'ve built your own kernel, please make sure that any
> > > custom version numbers are appended to the upstream
> > > kernel number with a dash or some other delimiter.
> > > 
> > > dpkg: error processing archive /var/cache/apt/archives/libc6_2.28-10+rpt2+rpi1_armhf.deb (--unpack):
> > >  new libc6:armhf package pre-installation script subprocess returned error exit status 1
> > > Errors were encountered while processing:
> > >  /var/cache/apt/archives/libc6_2.28-10+rpt2+rpi1_armhf.deb
> > > E: Sub-process /usr/bin/dpkg returned an error code (1)
> > > 
> > > 
> > > 
> > > Above upgrade works normally if I edit top level Linux source Makefile to
> > > say "SUBLEVEL = 0" and re-compile new kernel.
> > > 
> > > I am not pointing any fingers here, but it seems that either glibc code or
> > > stable kernel versioning is messed up.
> > 
> > Are you sure this isn't just a warning coming from a script that apt is
> > running when trying to install glibc?  Or is this from the glibc package
> > itself?
> > 
> > And what exactly is it testing?  We fixed the build time detection of
> > the kernel version here, so you should be able to build glibc properly.
> > 
> > This is the first time we've seen this reported, are people using the
> > newer kernels on systems that are not using glibc?
> 
> They are probably not using a problematic combination or a
> distribution kernel on those systems. Looking from the mentioned
> versions above this looks like a version derived from Debian buster.
> 
> Recently prompted due to https://bugs.debian.org/987266 the check was
> removed in the postinst script of libc in Debian:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=987266 .

Wonderful, thanks for pointing this out!

Jari, try asking whatever distro you are getting these rebuilt packages
from to update their scripts and all should be good.

thanks,

greg k-h
