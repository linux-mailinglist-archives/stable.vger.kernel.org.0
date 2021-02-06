Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A51311F4B
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhBFSOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 13:14:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhBFSOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 13:14:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC81A64E5E;
        Sat,  6 Feb 2021 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612635222;
        bh=XhepBwqMpHKpGESnV+lzhOOnLQ1fqZnyLNhjCtmpKrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qf3W1pSJEb2lqXmzcYxVb7aiWpqKP9NWwxCz8ZgeqYluraZfvs/6KwFq/g6Q7NuTU
         rvvEbRunAL9HQUQfceL5V4nPoPBdlAczx62UOMKUu2dveZ6qoOF83MpE6YQZI8+vi7
         /YnQSyWZeB9fLMzYrCEXDCj7NxCSk+SQqe1fxXRI=
Date:   Sat, 6 Feb 2021 19:13:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <YB7cU7SCyBOHFJGS@kroah.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 08:59:42AM -0800, Guenter Roeck wrote:
> On 2/6/21 5:22 AM, Willy Tarreau wrote:
> > On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
> >> Something like this looks more robust to me, it will use SUBLEVEL for
> >> values 0 to 255 and 255 for any larger value:
> >>
> >> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> >> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* (0$(SUBLEVEL) > 255) + 0$(SUBLEVEL) * (0$(SUBLEVEL \<= 255)); \
> > 
> > Bah, I obviously missed a backslash above and forgot spaces around parens.
> > Here's a tested version:
> > 
> > diff --git a/Makefile b/Makefile
> > index 7d86ad6ad36c..9b91b8815b40 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1252,7 +1252,7 @@ endef
> >  
> >  define filechk_version.h
> >  	echo \#define LINUX_VERSION_CODE $(shell                         \
> > -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) + 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
> >  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
> >  endef
> >  
> 
> I like that version.

See the patch that Sasha queued up already, it just fixes it at 255 for
now, and we will update with what is in Linus's tree like the above when
that gets merged in 5.12-rc1.

> Two questions: Are there any concerns that KERNEL_VERSION(4, 4, 256)
> matches KERNEL_VERSION(4, 5. 0),

As that "release" did nothing, no, I'm not too worried about it, are
you?

> and do you plan to send this patch upstream ?

See the series sent upstream here: https://lore.kernel.org/r/20210206035033.2036180-1-sashal@kernel.org

thanks,

greg k-h
