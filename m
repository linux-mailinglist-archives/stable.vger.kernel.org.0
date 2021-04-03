Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04EC353354
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 11:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhDCJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 05:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhDCJ4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Apr 2021 05:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69A261205;
        Sat,  3 Apr 2021 09:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617443791;
        bh=PaL4jEGo2HIX+y9nNjqb8hL1+BKPhsS5lsU7BTo0oFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xw4TFwjgCANKkg781HfxfsOkmi2CyJMlTf1OdtQvXLf9N7qvAaSjdxQdQjIhfhje/
         nJYCb/j8ZCYPlYoNZbCqt7Y06IkkfIOVwsit+U9JmjMoMbeKQ7ws8AQw88jzhv7Uxn
         AZq+7yTQTPzwcm9tRNLUo/DLajgXcqSMoD/NeYIU=
Date:   Sat, 3 Apr 2021 11:56:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Message-ID: <YGg7zApJnXCFNgL4@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
 <YGNeIhMNjQ0RGUGr@sashalap>
 <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 31, 2021 at 09:37:28PM +0300, Zidenberg, Tsahi wrote:
> 
> On 30/03/2021 20:21, Sasha Levin wrote:
> > commit 8d92db5c04d10381f4db70ed99b1b576f5db18a7 upstream.
> >>
> >> This is an adaptation of parts from above commit to kernel 5.4.
> >
> > This is very different from the upstream commit, let's not annotate it
> > as that commit.
> >
> No problem.
> >>
> >> To generally fix the issue, upstream includes new BPF helpers:
> >> bpf_probe_read_{user,kernel}_str(). For details on them, see
> >> commit 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers")
> >
> > What stops us from taking that API back to 5.4? I took a look at the
> > dependencies and they don't look too scary.
> >
> > Can we try that route instead? We really don't want to diverge from
> > upstream that much.
> >
> probe_read_{user,kernel}* functions themselves seem simple enough.
> Importing them in a forward-compliant way to 5.4 would require either
> adding an unused entry in bpf.h's __BPF_FUNC_MAPPER or also pulling
> skb_output bpf helper functions into 5.4. To me, it seems like too
> much of a UAPI change to go into a stable release.

Why is anything changing in the user api here?  The user api should not
be changing in incompatible ways, otherwise you would not be able to
upgrade to new kernels without breaking things.

> Another option would be to import more code to make it somewhat closer
> to upstream implementation without changing UAPI. As in v5.8, I could
> internally map these helpers to probe_read_compat* functions, which
> will in turn call probe_read_{user,kernel}*_common functions.
> Func names might seem weird out of context, but it will be closer.
> Implementation will still defer, e.g. to avoid warnings on platforms
> without ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> 
> Does that sound like a reasonable solution?

Again that would make things different from Linus's tree, which is what
we want to avoid if at all possible.

What commits in 5.8 are you talking about here, if the changes are there
that work here in 5.4, that's fine.

thanks,

greg k-h
