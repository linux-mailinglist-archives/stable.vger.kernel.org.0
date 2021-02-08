Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490A0312DB6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 10:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhBHJr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 04:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhBHJpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 04:45:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A9E64E82;
        Mon,  8 Feb 2021 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612777463;
        bh=GOl0dX4XJ9jiezrOVmdYVWaj50o6/O5HrY21klLC/E0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0BDpuSi1NzhyopnYfwLbWOTugNOHk7Kqem04z44d32IXLRxoe5y/D7FDqO3dvPu4
         2gQOfHfKUeL4tZCuRDZxjyYjJL+dUrVCN+Xclp7PeFY0MUo/mA36wFUsn+lLEUVYIR
         e+xKrcawXMhcTjIPX1H1Uqr6bLUL9sYzHXaWqiU0=
Date:   Mon, 8 Feb 2021 10:44:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Willy Tarreau' <w@1wt.eu>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>
Subject: Re: Linux 4.4.256
Message-ID: <YCEH9Fwp2vzlyONO@kroah.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <54e88e8d1ba1487ba43eb36ddfec4e5a@AcuMS.aculab.com>
 <7f4be7044f4a4c77ad101d7e3ac71b40@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4be7044f4a4c77ad101d7e3ac71b40@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 09:38:05AM +0000, David Laight wrote:
> From: David Laight
> > Sent: 08 February 2021 09:10
> > 
> > From: Willy Tarreau
> > > Sent: 06 February 2021 13:23
> > >
> > > On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
> > > > Something like this looks more robust to me, it will use SUBLEVEL for
> > > > values 0 to 255 and 255 for any larger value:
> > >
> > > diff --git a/Makefile b/Makefile
> > > index 7d86ad6ad36c..9b91b8815b40 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1252,7 +1252,7 @@ endef
> > >
> > >  define filechk_version.h
> > >  	echo \#define LINUX_VERSION_CODE $(shell                         \
> > > -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > > +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) +
> > > 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
> > >  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
> > >  endef
> > 
> > Why not:
> > 	$(shell echo $$(($(VERSION)<<16 + $(PATCHLEVEL)<<8 + ($(SUBVERSION) < 255 ? $(SUBVERSION) :
> > 255))))
> > Untested, but I think only the one $ needs any kind of escape.
> > The extra leading zeros do have to go - $((...)) does octal :-(
> 
> Or probably even better:
> 
> echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c)))'
> echo '#define LINUX_VERSION_CODE KERNEL_VERSION($(VERSION), $(PATCHLEVEL)+0, $(SUBLEVEL)+0)'
> 
> Which gets rid of the $(shell) as well.

Please comment on the real patch already submitted by Sasha for this.

thanks,

greg k-h
