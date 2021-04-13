Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080AC35D8DA
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbhDMH3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239961AbhDMH3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 03:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E7861249;
        Tue, 13 Apr 2021 07:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618298929;
        bh=MwxzH94W0nVFyShK74oTfKHBEQ3haGzJEWpToG2ouF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RucW9imqIcmYdW+0eiANc98w/HgwA1qQ/1f6MzNUHrp4ACJn7JplU6bozrbikCK3x
         dv12MxlZjH3NH96MRanjrZNP4olkJODuT14kCVFZGhfB0yDmeOjFsq6lQqKSuIuDSX
         Amrn9YbPSnF6Ps1aixQAduKNOsAzeTy+R/K/lb/w=
Date:   Tue, 13 Apr 2021 09:28:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Message-ID: <YHVILoTf9LfQmYGZ@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
 <YGNeIhMNjQ0RGUGr@sashalap>
 <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
 <YGg7zApJnXCFNgL4@kroah.com>
 <655b6f67-787f-80dd-975e-3d1ab87b0c49@amazon.com>
 <YHGMAxjfn1fKfgGE@kroah.com>
 <7f022c63-f0d9-cf5d-9330-d8548e4095b4@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f022c63-f0d9-cf5d-9330-d8548e4095b4@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:01:59PM +0300, Zidenberg, Tsahi wrote:
> 
> 
> On 10/04/2021 14:29, Greg KH wrote:
> > On Sun, Apr 04, 2021 at 12:13:46PM +0300, Zidenberg, Tsahi wrote:
> >> On 03/04/2021 12:56, Greg KH wrote:
> >>>
> >>> Again that would make things different from Linus's tree, which is what
> >>> we want to avoid if at all possible.
> >>>
> >>> What commits in 5.8 are you talking about here, if the changes are there
> >>> that work here in 5.4, that's fine.
> >> In 5.5 (mostly 6ae08ae3dea2) BPF UAPI was changed, bpf_probe_read was split
> >> into compat (original), user and kernel variants. Compat here just calls the
> >> kernel variant, which means it's still broken.
> > That's not a UAPI change, that does not change the userspace-visable
> > part, right?  Did something change?
> >
> >> In 5.8 (8d92db5c04d10), compat was fixed to call user/kernel variants
> >> according to address in machines where it makes sense, and disabled on other
> >> machines. I am trying to take the fix for machines where it's possible, and
> >> leave other machines untouched.
> >>
> >> As I understand it, there are 3 options:
> >> 1)  Implement the same fix as v5.8, while staying with v5.4 code/API.
> >>     That's what my original patch did.
> >> 2)  Import the new 5.5 API + 5.8 fix. It's not trivial to get API-compatibility
> >>     right. Specifically - need to solve skb_output (a7658e1a4164c), another
> >>     entry in the BPF enum, introduced before the new read variants.
> > What "API-compatibility" are you trying for here?  There is no issues
> > with in-kernel changes of apis.
> >
> > What commits exactly does this require?  It is almost always better to
> > keep the same identical patches that are in newer kernels to be
> > backported than to do something different like you are doing in 1).
> > That way any future changes/fixes can easily also be backported.
> > Otherwise it gets harder and harder over time.
> This is how I understand it, please correct me if/where I'm wrong:
> 
> include/uapi/linux/bpf.h is part of the UAPI. Specifically, bpf_func_id
> enum is part of the UAPI. This enum matches function I.D to bpf helper,
> and the indexes are kept constant across kernel versions.
> 
> Kernel 5.5 added skb_output helper (irrelevant to our fix) to that enum,
> and then added probe_read_{user,kernel}* functions on top of that. Taking
> probe_read_{user,kernel}* from commit 6ae08ae3dea2 itself is changing
> UAPI. The mainline fix in 5.8 (8d92db5c04d10) depends on that UAPI change.

So you are just adding new things, not changing existing things.
There's nothing wrong with adding new userspace apis, nothing is
"frozen" in that existing userspace would suddenly be broken here,
right?

> Appending another function is not a terrrible UAPI change, but to
> keep these functions at the same index as later kernel versions - we'd
> also need to either take skb_output or add a replacement.

Yes you need to keep the values identical, that's fine, and expected, we
do that all the time in stable kernels.

thanks,

greg k-h
