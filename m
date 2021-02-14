Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39DF31B17E
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNRRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 12:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhBNRRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Feb 2021 12:17:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93F6601FD;
        Sun, 14 Feb 2021 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613322992;
        bh=rt9KivGHTWjFc7frvPj3HqH62Z1WT3dELJ67xjgun70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cpk4bz51qEKvKmmtxjDvtbGxOmipHS2kkQqzrw6fIQ0PLjyZip/97dnHoPVOKzCbF
         xn8UwwkydWjuwNU0aV8gXdZFAwlqmV/CUxmGPIrTX/w+7JoTkdgfBnKipXiRiqTaiQ
         2tGWS/OXtzaQLuDhnqUlFvRHZItLGhOZ7OcQY8cc=
Date:   Sun, 14 Feb 2021 18:16:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
Message-ID: <YCla7cNQxBoG2KCr@kroah.com>
References: <20201207170533.10738-1-mark.rutland@arm.com>
 <202012081319.D5827CF@keescook>
 <X9DkdTGAiAEfUvm5@kroah.com>
 <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com>
 <YCU9zoiw8EZktw5U@kroah.com>
 <161306959090.1254594.16358795480052823449@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161306959090.1254594.16358795480052823449@swboyd.mtv.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 10:53:10AM -0800, Stephen Boyd wrote:
> Quoting Greg Kroah-Hartman (2021-02-11 06:23:10)
> > On Wed, Feb 10, 2021 at 04:36:08PM -0800, Stephen Boyd wrote:
> > > Quoting Greg Kroah-Hartman (2020-12-09 06:51:33)
> > > > On Tue, Dec 08, 2020 at 01:20:56PM -0800, Kees Cook wrote:
> > > > > On Mon, Dec 07, 2020 at 05:05:33PM +0000, Mark Rutland wrote:
> > > > > > [    0.969110] Code: 00000003 00000000 00000000 00000000 (00000000)
> > > > > > [    0.970815] ---[ end trace b5339784e20d015c ]---
> > > > > > 
> > > > > > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > > > > 
> > > > > Oh, eek. Why was a ctor generated at all? But yes, this looks good.
> > > > > Greg, can you pick this up please?
> > > > > 
> > > > > Acked-by: Kees Cook <keescook@chromium.org>
> > > > 
> > > > Now picked up, thanks.
> > > > 
> > > 
> > > Can this be backported to 5.4 and 5.10 stable trees? I just ran across
> > > this trying to use kasan on 5.4 with lkdtm and it blows up early. This
> > > patch applies on 5.4 cleanly but doesn't compile because it's missing
> > > noinstr. Here's a version of the patch that introduces noinstr on 5.4.97
> > > so this patch can be picked to 5.4 stable trees.
> > 
> > Why 5.10?  This showed up in 5.8, so how would it be needed there?
> > 
> 
> Sorry for the confusion. Can commit 655389666643 ("vmlinux.lds.h: Create
> section for protection against instrumentation") and commit 3f618ab33234
> ("lkdtm: don't move ctors to .rodata") be backported to 5.4.y and only
> commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 be backported to 5.10.y?

655389666643 ("vmlinux.lds.h: Create section for protection against
instrumentation") does not apply cleanly to 5.4.y, so can you provide a
working backport for both of those patches to 5.4.y that you have
tested?

thanks,

greg k-h
