Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD58AD3F47
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 14:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJKMNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 08:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfJKMND (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 08:13:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF4221D56;
        Fri, 11 Oct 2019 12:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570795983;
        bh=Bzg5lD50FCPnI9bRVeMc/8EtzNUsMRaJrmt7cWmJkMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjdvWE0AWcAP9CkgUYnlIqP9aNLs3d/PMBO140eICkj2BDXlnev7AIJDOeO8Y0lQC
         HmokVddV4qtiLA2/VvJQTlD6gf1heffYxmSCMAqoJBYeCybsWgQdxHEddEwl8HY3k0
         f+luKDCfEnc0ERddpORhecsaxVHirAlw4gXnlT40=
Date:   Fri, 11 Oct 2019 14:13:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
Message-ID: <20191011121300.GA1144378@kroah.com>
References: <20191010122922.GA720144@kroah.com>
 <20191010131943.26822-1-suzuki.poulose@arm.com>
 <20191011045538.GA977916@kroah.com>
 <433563f1-1aad-f43b-a294-08cb39ba4818@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433563f1-1aad-f43b-a294-08cb39ba4818@arm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 11:31:30AM +0100, Suzuki K Poulose wrote:
> Hi Greg,
> 
> On 11/10/2019 05:55, Greg KH wrote:
> > On Thu, Oct 10, 2019 at 02:19:43PM +0100, Suzuki K Poulose wrote:
> > > A signed feature value is truncated to turn to an unsigned value
> > > causing bad state in the system wide infrastructure. This affects
> > > the discovery of FP/ASIMD support on arm64. Fix this by making sure
> > > we cast it properly.
> > > 
> > > This was inadvertently fixed upstream in v4.6 onwards with the following :
> > > commit 28c5dcb22f90113dea ("arm64: Rename cpuid_feature field extract routines")
> > 
> > What prevents us from just taking that commit instead?  You did not
> > document that here at all, which I thought I asked for.
> 
> Sorry, I missed that part. So, that change introduces helpers to
> extract feature fields based on the sign. And it also depends on
> 
> commit ff96f7bc7bf6 ("arm64: capabilities: Handle sign of the feature bit")
> 
> which introduces "sign" bit for the "capability" list and modifies
> the generic capability->matches() helpers to use the hint to switch to the
> appropriate helpers.

That's ok, does that cause any problems?  We always want the original
patch instead of a one-off patch as that way we do not diverge.

> I could backport parts of the commit 28c5dcb22f90 dropping the bits
> that affect the changes mentioned above.

Please do, that is always prefered as well, but do the first thing above
if at all possible.

> > 
> > Also, you only need 12 digits for a sha1, 28c5dcb22f90 ("arm64: Rename
> > cpuid_feature field extract routines") would be just fine :)
> 
> Yea, I understand. Its simply a pain to count the numbers, so I make sure
> to pickup something that looks larger than the 12 ;-). I will try to stick
> to that :-)

	git show -s --abbrev-commit --abbrev=12 --pretty=format:"%h (\"%s\")%n"
will give you the correct format.  I suggest making it a git alias :)

Or, use:
	[core]
	        abbrev = 12
in your .gitconfig file.

thanks,

greg k-h
