Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B865D1E1F7C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgEZKQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgEZKQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8660E2071A;
        Tue, 26 May 2020 10:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590488202;
        bh=BLF1aeSWrq0oAE8ttqy5E/lpdZVSxkVQ5hkjIbIvKV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VqYSlz8VoIrC2jDUhxsAWfZHyHetd2E3NpQLlcQ0Mxkm3zXgZTrAAvfOfPUH3SN3a
         3e2FRNqG5KrIGxaGD+ZntFqYuji1TZtgMJ/78yXHcobrTn++hN4THf7+Ik5pz8S+V+
         JPIzAdJ0KK2X0FClI+P57pfziC8inf5dsw+6HSSE=
Date:   Tue, 26 May 2020 12:16:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526101639.GC2759907@kroah.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526075736.GH317569@hirez.programming.kicks-ass.net>
 <20200526081752.GA2650351@kroah.com>
 <20200526091745.GC325280@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526091745.GC325280@hirez.programming.kicks-ass.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 11:17:45AM +0200, Peter Zijlstra wrote:
> On Tue, May 26, 2020 at 10:17:52AM +0200, Greg KH wrote:
> > On Tue, May 26, 2020 at 09:57:36AM +0200, Peter Zijlstra wrote:
> > > On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > > > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > > > From: Andi Kleen <ak@linux.intel.com>
> > > > > 
> > > > > Since there seem to be kernel modules floating around that set
> > > > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > > > CR4 pinning just checks that bits are set, this also checks
> > > > > that the FSGSBASE bit is not set, and if it is clears it again.
> > > > 
> > > > So we are trying to "protect" ourselves from broken out-of-tree kernel
> > > > modules now?  Why stop with this type of check, why not just forbid them
> > > > entirely if we don't trust them?  :)
> > > 
> > > Oh, I have a bunch of patches pending for that :-)
> > 
> > Ah, I thought I had seen something like that go by a while ago.
> > 
> > It's sad that we have to write a "don't do stupid things" checker for
> > kernel modules now :(
> 
> Because people... they get stuff from the interweb and run it :/ The
> days that admins actually knew what they're doing is long long gone.

{sigh}

> > > It will basically decode the module text and refuse to load the module
> > > for most CPL0 instruction.
> > 
> > Ok, so why would Andi's patch even be needed then?  Andi, why post this?
> 
> Andi's patch cures a particularly bad module that floats around that
> people use, probably without being aware that it's an insta-root hole.

Ok, fair enough, thanks for the context.

greg k-h
