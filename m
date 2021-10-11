Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC208428E7B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhJKNr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhJKNr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D7260EB4;
        Mon, 11 Oct 2021 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633959958;
        bh=wR2GDuPk12FtS1VIShGLmmBnQ4ZmDzRxG+OK3oVe8Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/KBWHUwb/QCM8t4lFyAEDKrKR9vCXPGkVDuRBRJOs9TjK7JSlL0OGp05uklnVJeo
         fe4B87d08ULHTUqrzjiq4QHE+b1cEbQMxJFybfQMEhgBH6SnpHirbIZC4FcdkaRjrl
         0UX1C53Lv9VMDi/6Gx0dghycR6g6ZIFRJsR9zMMw=
Date:   Mon, 11 Oct 2021 15:45:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: Linux 5.14.11
Message-ID: <YWRACxAz3zlvBQg8@kroah.com>
References: <163378600110591@kroah.com>
 <20211011063040.7ab8c623@bellevue.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011063040.7ab8c623@bellevue.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 06:30:40AM -0700, Jason Self wrote:
> On Sat,  9 Oct 2021 15:26:41 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > I'm announcing the release of the 5.14.11 kernel.
> 
> Starting with 5.14.10 I get this when doing make bindeb-pkg when
> compiling for MIPS, for the Loongson 2F. I do have a sufficient
> version of binutils installed (2.37), which was working well until
> until 5.14.10 came out.
> 
>   OBJCOPY arch/mips/boot/compressed/vmlinux.bin
>   GZIP    arch/mips/boot/compressed/vmlinux.bin.z
>   OBJCOPY arch/mips/boot/compressed/piggy.o
>   HOSTCC  arch/mips/boot/compressed/calc_vmlinuz_load_addr
>   LD      vmlinuz
>   STRIP   vmlinuz
> make KERNELRELEASE=5.14.11-gnu.loongson-2f ARCH=mips
>   KBUILD_BUILD_VERSION=1.0 -f ./Makefile intdeb-pkg sh
>   ./scripts/package/builddeb arch/mips/loongson2ef//Platform:36: ***
>   only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.
>   Stop. cp: cannot stat '': No such file or directory
>   scripts/Makefile.package:87: recipe for target 'intdeb-pkg' failed
>   make[4]: *** [intdeb-pkg] Error 1 Makefile:1576: recipe for target
>   'intdeb-pkg' failed make[3]: *** [intdeb-pkg] Error 2
> debian/rules:13: recipe for target 'binary-arch' failed
> make[2]: *** [binary-arch] Error 2
> dpkg-buildpackage: error: debian/rules binary subprocess returned exit
>   status 2 scripts/Makefile.package:82: recipe for target 'bindeb-pkg'
>   failed make[1]: *** [bindeb-pkg] Error 2
> Makefile:1576: recipe for target 'bindeb-pkg' failed
> make: *** [bindeb-pkg] Error 2

Can you use 'git bisect' to try to find the issue?

And does the same thing happen in 5.15-rc5, or does that build properly
for you?

thanks,

greg k-h
