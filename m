Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C04240F06B
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 05:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhIQDeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 23:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhIQDeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 23:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9984B61056;
        Fri, 17 Sep 2021 03:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631849595;
        bh=Q9PGtU5xvpxOOFAIBeN38KDl83cB2YIXJ+mu/SnJDUo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=bkXzkfwOGHvzs27DtLCuvclKLhbyfIft2aoHfdly7VwN+kQCfcBU1e69naYIX5kcd
         y8r0Ny3F97DpN06jU+4bz3GAzQzx/EnURemOWq0N8KjHK+KJN1KWBqvGFmPXAS6KcP
         CBUVQQVz5Nt4HlSEhpizojqo/87rNk9gCDTAVMufs0pxTFq/9zF6soPEPolrQqeFv0
         XEKhC4RHLm7XjfDRtgy3JXJFJgnjOK/BpQNA9n1dgRgCmG6kuDwv6Clupw4X7ZlVif
         z2XoMKdmZ6au0IiP9pb5LWoyrMg6aIpQmkolrPJdweQHqMXYtYkK2mmt0Ze5JNJti5
         vthwAOCIbl2Yw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 704D45C08DB; Thu, 16 Sep 2021 20:33:15 -0700 (PDT)
Date:   Thu, 16 Sep 2021 20:33:15 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, x86@kernel.org,
        jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210917033315.GO4156@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <20210916083042.5f63163a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210916163547.GD4156@paulmck-ThinkPad-P17-Gen-1>
 <20210916195713.289a7889@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916195713.289a7889@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 07:57:13PM -0700, Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 09:35:47 -0700 Paul E. McKenney wrote:
> > > > How did you pick v5.13?  force_disable_hpet() was added by
> > > > 62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail
> > > > platform"), which appeared in v3.15.  
> > > 
> > > Erm, good question, it started happening for me (and others with the
> > > same laptop) with v5.13. I just sort of assumed it was 2e27e793e280
> > > ("clocksource: Reduce clocksource-skew threshold"). 
> > > 
> > > It usually takes  a day to repro (4 hours was the quickest repro I've
> > > seen) so bisection was kind of out of question.  
> > 
> > OK, so this is an intermittent condition where HPET is sometimes slow to
> > access for a short period of time?  If that is the case, my thought is
> > to set the clocksource to be reinitialized (without a splat and without
> > marking the clocksource unstable), and to splat (and mark the clocksource
> > unstable) if it is not get a good read after 100 subsequent attempts.
> > 
> > So as long as the period of slowness lasts for less than 50 seconds,
> > things would work fine.
> > 
> > Seem reasonable?
> 
> Could well be. Initially I thought it was suspend/resume related, then
> I looked closer and it did happen mostly after resume... but anywhere
> between 20 minutes to few hours after the resume.
> 
> I'm here to test less crude patches but since that may take some time
> I'd hope we can get this merged and into stable ASAP. Hopefully it can
> make it to 5.13 while that branch is alive and into Fedora. It really
> makes Coffee Lake machines pretty much unusable.

Indeed, I could see where your reproducer is at best rather annoying.
But a good data point for me either way, so thank you!

							Thanx, Paul
