Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB531E1E55
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 11:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388396AbgEZJWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 05:22:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57308 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731622AbgEZJWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 05:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fbzELRYcJjrFmOciA2lLMrUinuLmeRjLnUksXmy8vX4=; b=kgFUWgIlVIcg3f3/mKjq51a4XJ
        hqjU/+PU3gfDPjGGAcNeN4Zc/NJjbP4OIR8DaOk5PgRZW9TMyjilPXvbCcj36bmRwmAWQG+Nj14Qb
        78ZtfqFcNCkGRLrXA71CGttYLtaHmHF7Q+BWp7UOCWG+AzIZxCNEVKuoF/XQPWwkWavyNcdSqMkhy
        Pxqi6rWbPxnlhz9s8TI4Lcxfj9JCqWOXUakuSL3Sg8k63nPf11s+vRbkjLkUM8nwGkUjXrezZ17ye
        HRNg0iOjOoz9Kk3Si0IC4Jz7gXA5rZkv3VePI5WVYruVQh50VnSiU/8YZxWPev4Ai+msA16tIdxSY
        t6cLGvLQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdViZ-0004up-CU; Tue, 26 May 2020 09:17:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7522330047A;
        Tue, 26 May 2020 11:17:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4DBD120BD4F39; Tue, 26 May 2020 11:17:45 +0200 (CEST)
Date:   Tue, 26 May 2020 11:17:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526091745.GC325280@hirez.programming.kicks-ass.net>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526075736.GH317569@hirez.programming.kicks-ass.net>
 <20200526081752.GA2650351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526081752.GA2650351@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 10:17:52AM +0200, Greg KH wrote:
> On Tue, May 26, 2020 at 09:57:36AM +0200, Peter Zijlstra wrote:
> > On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > Since there seem to be kernel modules floating around that set
> > > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > > CR4 pinning just checks that bits are set, this also checks
> > > > that the FSGSBASE bit is not set, and if it is clears it again.
> > > 
> > > So we are trying to "protect" ourselves from broken out-of-tree kernel
> > > modules now?  Why stop with this type of check, why not just forbid them
> > > entirely if we don't trust them?  :)
> > 
> > Oh, I have a bunch of patches pending for that :-)
> 
> Ah, I thought I had seen something like that go by a while ago.
> 
> It's sad that we have to write a "don't do stupid things" checker for
> kernel modules now :(

Because people... they get stuff from the interweb and run it :/ The
days that admins actually knew what they're doing is long long gone.

> > It will basically decode the module text and refuse to load the module
> > for most CPL0 instruction.
> 
> Ok, so why would Andi's patch even be needed then?  Andi, why post this?

Andi's patch cures a particularly bad module that floats around that
people use, probably without being aware that it's an insta-root hole.

My patches will be a while (too many things in the fire :/) and will
certainly not be for stable.
