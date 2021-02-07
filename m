Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FBC312294
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 09:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhBGIZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 03:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhBGIX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 03:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5935464E72;
        Sun,  7 Feb 2021 08:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612686167;
        bh=tML2fpxEbgd0c5kgCO0BnSURh4MuFYUYXeMzuTwXXIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fsA4wesmWFnG15nDVuw3kRJY/kUoF27SdL32cV6VUdaTZaa21DEx05IFJv1qQ2uxM
         FDkX6a3pn/2MzSCQAqkz9PUfgPFQiHzLHy3HP9FCeXN1htNqdl1oKERqz6N62WGILZ
         2xxWLyRS0E8CRiiyViv8Nw8JE28KtVQQRSBikW68=
Date:   Sun, 7 Feb 2021 09:22:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <YB+jVD6r4vlzuZO0@kroah.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
 <YB7cU7SCyBOHFJGS@kroah.com>
 <20210206184926.GA19587@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206184926.GA19587@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 10:49:26AM -0800, Guenter Roeck wrote:
> On Sat, Feb 06, 2021 at 07:13:39PM +0100, Greg Kroah-Hartman wrote:
> > On Sat, Feb 06, 2021 at 08:59:42AM -0800, Guenter Roeck wrote:
> > > On 2/6/21 5:22 AM, Willy Tarreau wrote:
> > > > On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
> > > >> Something like this looks more robust to me, it will use SUBLEVEL for
> > > >> values 0 to 255 and 255 for any larger value:
> > > >>
> > > >> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > > >> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* (0$(SUBLEVEL) > 255) + 0$(SUBLEVEL) * (0$(SUBLEVEL \<= 255)); \
> > > > 
> > > > Bah, I obviously missed a backslash above and forgot spaces around parens.
> > > > Here's a tested version:
> > > > 
> > > > diff --git a/Makefile b/Makefile
> > > > index 7d86ad6ad36c..9b91b8815b40 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -1252,7 +1252,7 @@ endef
> > > >  
> > > >  define filechk_version.h
> > > >  	echo \#define LINUX_VERSION_CODE $(shell                         \
> > > > -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > > > +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) + 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
> > > >  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
> > > >  endef
> > > >  
> > > 
> > > I like that version.
> > 
> > See the patch that Sasha queued up already, it just fixes it at 255 for
> > now, and we will update with what is in Linus's tree like the above when
> > that gets merged in 5.12-rc1.
> > 
> > > Two questions: Are there any concerns that KERNEL_VERSION(4, 4, 256)
> > > matches KERNEL_VERSION(4, 5. 0),
> > 
> > As that "release" did nothing, no, I'm not too worried about it, are
> > you?
> > 
> There are lots (35) of "KERNEL_VERSION(4, 5, 0)" in chromeos-4.4.
> That should not matter with the clamped LINUX_VERSION_CODE, but
> I'd prefer to clamp KERNEL_VERSION as well just to be sure. On
> top of that, some of the vendor code we carry along does check
> SUBVERSION, but that is probably more of an academic concern.

Ah, the internal checks, I think the other patch by Sasha will let that
get bigger and should work for you as well.  Can you try it out?

thanks,

greg k-h
