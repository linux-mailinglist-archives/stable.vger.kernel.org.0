Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6135ACF0
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhDJL3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhDJL3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A12610CD;
        Sat, 10 Apr 2021 11:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618054149;
        bh=xmx867FrFj5pZSUyCYeL5+WJfhFXdOHETD7WE9dxYxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxVYu+cfPfATwPc1qqqO+e1cBaeVtMONkO2q4SPqfDwnF8Daltoej6RJ5b8tfmYqo
         79PXoHqyXWoOM1scplRNY7UbL18C5F8rCmHaQsdOeh40DhxnNv8qQvzFXCnpXDA1r6
         eRzoSWn/D4j+4N7y7NJkFZm3rTaQDRSqAeNYG1wQ=
Date:   Sat, 10 Apr 2021 13:29:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Message-ID: <YHGMAxjfn1fKfgGE@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
 <YGNeIhMNjQ0RGUGr@sashalap>
 <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
 <YGg7zApJnXCFNgL4@kroah.com>
 <655b6f67-787f-80dd-975e-3d1ab87b0c49@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <655b6f67-787f-80dd-975e-3d1ab87b0c49@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 04, 2021 at 12:13:46PM +0300, Zidenberg, Tsahi wrote:
> 
> 
> On 03/04/2021 12:56, Greg KH wrote:
> > On Wed, Mar 31, 2021 at 09:37:28PM +0300, Zidenberg, Tsahi wrote:
> >> On 30/03/2021 20:21, Sasha Levin wrote:
> >>
> >>> What stops us from taking that API back to 5.4? I took a look at the
> >>> dependencies and they don't look too scary.
> >>>
> >>> Can we try that route instead? We really don't want to diverge from
> >>> upstream that much.
> >>>
> >> probe_read_{user,kernel}* functions themselves seem simple enough.
> >> Importing them in a forward-compliant way to 5.4 would require either
> >> adding an unused entry in bpf.h's __BPF_FUNC_MAPPER or also pulling
> >> skb_output bpf helper functions into 5.4. To me, it seems like too
> >> much of a UAPI change to go into a stable release.
> > Why is anything changing in the user api here?  The user api should not
> > be changing in incompatible ways, otherwise you would not be able to
> > upgrade to new kernels without breaking things.
> >
> >> Another option would be to import more code to make it somewhat closer
> >> to upstream implementation without changing UAPI. As in v5.8, I could
> >> internally map these helpers to probe_read_compat* functions, which
> >> will in turn call probe_read_{user,kernel}*_common functions.
> >> Func names might seem weird out of context, but it will be closer.
> >> Implementation will still defer, e.g. to avoid warnings on platforms
> >> without ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> >>
> >> Does that sound like a reasonable solution?
> > Again that would make things different from Linus's tree, which is what
> > we want to avoid if at all possible.
> >
> > What commits in 5.8 are you talking about here, if the changes are there
> > that work here in 5.4, that's fine.
> In 5.5 (mostly 6ae08ae3dea2) BPF UAPI was changed, bpf_probe_read was split
> into compat (original), user and kernel variants. Compat here just calls the
> kernel variant, which means it's still broken.

That's not a UAPI change, that does not change the userspace-visable
part, right?  Did something change?

> In 5.8 (8d92db5c04d10), compat was fixed to call user/kernel variants
> according to address in machines where it makes sense, and disabled on other
> machines. I am trying to take the fix for machines where it's possible, and
> leave other machines untouched.
> 
> As I understand it, there are 3 options:
> 1)  Implement the same fix as v5.8, while staying with v5.4 code/API.
>     That's what my original patch did.
> 2)  Import the new 5.5 API + 5.8 fix. It's not trivial to get API-compatibility
>     right. Specifically - need to solve skb_output (a7658e1a4164c), another
>     entry in the BPF enum, introduced before the new read variants.

What "API-compatibility" are you trying for here?  There is no issues
with in-kernel changes of apis.

What commits exactly does this require?  It is almost always better to
keep the same identical patches that are in newer kernels to be
backported than to do something different like you are doing in 1).
That way any future changes/fixes can easily also be backported.
Otherwise it gets harder and harder over time.

thanks,

greg k-h
