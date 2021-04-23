Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B93695A5
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbhDWPIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242791AbhDWPIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:08:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 163D9613B6;
        Fri, 23 Apr 2021 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190486;
        bh=I3WlJ7Lr9mBlLqwl/1BZ+wUDUjS1JdU9vHpRY2SrhTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTet1Sa9t9kHF8b9Dwpxz5OTsptduCxI0VoLEBFZOcbcVfqgKMG3RGV9bOdQmYFjw
         W5oOd+9It6+ymA9zzbQIno2GbOijGbTC50rK1wdQFqPmq0CEmusM+/lLF7E3e+ac6h
         IcpoAeiBwfJXmGlqMtc7wJwUB3f1WZZ7FWnQMuQQ=
Date:   Fri, 23 Apr 2021 17:08:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bpf: fix userspace access for
 bpf_probe_read{,str}()
Message-ID: <YILi0740FGK78Zy8@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 04:05:32PM +0300, Zidenberg, Tsahi wrote:
> In arm64, kernelspace address accessors cannot be used to access
> userspace addresses, which means bpf_probe_read{,str}() cannot access
> userspace addresses. That causes e.g. command-line parameters to not
> appear when snooping execve using bpf.

Again, this really feels like a new feature, not a regression or bugfix
at all.  And in looking at these patches, that feeling really gets
stronger.

> This patch series takes the upstream solution. This solution also
> changes user API in the following ways:
> * Add probe_read_{user, kernel}{,_str} bpf helpers
> * Add skb_output helper to the enum only (calling it not supported)
> * Add support for %pks, %pus specifiers
> 
> An alternative fix only takes the required logic to existing API without
> adding new API, was suggested here:
> https://www.spinics.net/lists/stable/msg454945.html
> 
> Another option is to only take patches [1-4] of this patchset, and add
> on top of them commit 8d92db5c04d1 ("bpf: rework the compat kernel probe
> handling"). In that case, the last patch would require function renames
> and conflict resolutions that were avoided in this patchset by pulling
> patches [5-7].

The other option is to move your system to a newer kernel release that
has this new feature, right?  :)

What prevents you from doing that today?  What bug is this solving that
worked in previous kernel releases and was broken in 5.4.y?

thanks,

greg k-h
