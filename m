Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6791414CAA
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhIVPFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236347AbhIVPFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 11:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1616F61107;
        Wed, 22 Sep 2021 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632323016;
        bh=ZyZBZYJg2eNVhp09uT1AzSeEjErBTS+xz2FVwbbw0yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPDxSVsKRLcSV28D9xszU4kKIfXDye/olgwjNr8XzXG0gwRyXHtglDLPqOCLo50uW
         VsmeO9G+3X8dIglXBzznyZeCBTrmiE/dvd2Qettto0DvLiRGy/H3vDmY9j7FamHCIf
         ahfMeGne3rTLo6A0SnrnlYENQ4TYG7P3+VO6cifjfm/a4igXPpr/l4JjCEhhqglTDV
         AEZVkSgz++BesPtHkRuyNCsgTjmx/4cbFYNNjGnPVz5UcxPE3nqyHR1L4u3wkERlsN
         HjWdfi0pclSXd05508O0DfJgYpDaj+c/786o0gfEIgKUot4Fj+foADm2YpbX1f2gJy
         UhjlRwgws4yhg==
Received: by pali.im (Postfix)
        id 9AE8879F; Wed, 22 Sep 2021 17:03:33 +0200 (CEST)
Date:   Wed, 22 Sep 2021 17:03:33 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Fix reporting CRS value"
 failed to apply to 5.14-stable tree
Message-ID: <20210922150333.3p7jjaz7fqt6ovwh@pali>
References: <16317162038625@kroah.com>
 <20210915164643.wuvqooapjccdc2nd@pali>
 <YUtAmk46bRf/qO2i@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YUtAmk46bRf/qO2i@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 22 September 2021 16:41:30 Greg KH wrote:
> On Wed, Sep 15, 2021 at 06:46:43PM +0200, Pali Rohár wrote:
> > On Wednesday 15 September 2021 16:30:03 gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.14-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Hello that patch depends on commit which fixes name of rootcap member:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3
> 
> Thanks, that worked for 5.10 and 5.14, but not for 5.4.y.  If this needs
> to go there too, can you send a working set of backported patches?

Hello Greg!

Applying patches in this order passes:

git cherry-pick e0d9d30b73548fbfe5c024ed630169bdc9a08aee
git cherry-pick b1bd5714472cc72e14409f5659b154c765a76c65
git cherry-pick e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3
git cherry-pick 43f5c77bcbd27cce70bf33c2b86d6726ce95dd66

First patch fixes big endian support in driver code and second patch
fixes filling return value of function call on error (return value is
passed via pointer argument). I do not know why they do not have
appropriate Fixes tag, but for me it looks like that both patches are
suitable for stable backporting.

What do you think, are first two patches suitable for backport? Or do
you need some other solution?

> thanks,
> 
> greg k-h
