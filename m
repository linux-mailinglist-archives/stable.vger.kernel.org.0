Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0872E934F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbhADK2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbhADK2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:28:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C6F21D93;
        Mon,  4 Jan 2021 10:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609756057;
        bh=xqhQj6CEMvYWLzotRmaHILISOHVzRJ5T63FrHnlRq+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6mjw8NMsUVn3NyZj4a9V0iiEWC+Ehmfa8xwP3UhZxos83I11yxblT/tgBY4IJetN
         Irz6agsYsrDWxtU+04GLG6E9ZtowW5FXOY8+hDRu7CUDFeqclMNlG4auHLnDfo0yqT
         U318d0snFvVOm5s/hLcJk4AbzMNQ9ENam3nwIh8E=
Date:   Mon, 4 Jan 2021 11:29:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] uapi: move constants from <linux/kernel.h> to
 <linux/const.h>
Message-ID: <X/Lt7/LdYYoU8rRL@kroah.com>
References: <20210101200308.22770-1-petr.vorel@gmail.com>
 <X++AviN6Zb75Yziv@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X++AviN6Zb75Yziv@pevik>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 01, 2021 at 09:06:22PM +0100, Petr Vorel wrote:
> Hi,
> 
> > and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.
> 
> > commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.
> 
> > The reason is to avoid indirect <linux/sysinfo.h> include when using
> > some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
> > -> <linux/sysinfo.h>.
> 
> > This indirect include causes on MUSL redefinition of struct sysinfo when
> > included both <sys/sysinfo.h> and some of UAPI headers:
> 
> >     In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
> >                      from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
> >                      from ../include/tst_netlink.h:14,
> >                      from tst_crypto.c:13:
> >     x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
> >      struct sysinfo {
> >             ^~~~~~~
> >     In file included from ../include/tst_safe_macros.h:15,
> >                      from ../include/tst_test.h:93,
> >                      from tst_crypto.c:11:
> >     x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here
> 
> > Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
> > Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> > Suggested-by: Rich Felker <dalias@aerifal.cx>
> > Acked-by: Rich Felker <dalias@libc.org>
> > Cc: Peter Korsgaard <peter@korsgaard.com>
> > Cc: Baruch Siach <baruch@tkos.co.il>
> > Cc: Florian Weimer <fweimer@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> > Hi,
> 
> > could this fix be backported to stable releases?
> > Maybe safer to wait till v5.11 release.
> 
> > Adjusted for stable/linux-4.9.y.
> I'm sorry, this one is for stable/linux-4.4.y

No worries, queued up everywhere now, thanks!

greg k-h
