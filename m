Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389EB3B418C
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFYKYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhFYKYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA86B61439;
        Fri, 25 Jun 2021 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624616542;
        bh=TOcbaUztKO2e1mYBAw64ee9NuniluuPC6ZDvM9kA/og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQNjrYcoFkrpO0bIRBGwclSHx9DAvYUCLsr6tfIbXR6zdbWTVPR5a8tHHJNbHjFe1
         1ot4WlRffIed6w1JGCfeZmmTm9K8B23dPQCwWQ1PV24T6ZozyOfttVRRvp61uXyIvO
         hy6xDZC0j4DcbRILLnD7T2RSfYhfSkxY02i0QkTI=
Date:   Fri, 25 Jun 2021 12:22:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Aman Priyadarshi <apeureka@amazon.de>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexander Graf <graf@amazon.de>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        Ali Saidi <alisaidi@amazon.com>
Subject: Re: [PATCH] arm64: perf: Disable PMU while processing counter
 overflows
Message-ID: <YNWuW3GX4HATEr2W@kroah.com>
References: <YMoQ1MZgsL2hF2EL@kroah.com>
 <20210616192859.21708-1-apeureka@amazon.de>
 <YMrUt+Vhs5exEqVt@kroah.com>
 <87r1h1c5bo.wl-maz@kernel.org>
 <a9104042094d658a9ee86f332505dee1d2ed06fd.camel@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9104042094d658a9ee86f332505dee1d2ed06fd.camel@amazon.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 17, 2021 at 10:57:00AM +0200, Aman Priyadarshi wrote:
> On Thu, 2021-06-17 at 08:34 +0100, Marc Zyngier wrote:
> > CAUTION: This email originated from outside of the organization. Do not
> > click links or open attachments unless you can confirm the sender and
> > know the content is safe.
> > 
> > 
> > 
> > On Thu, 17 Jun 2021 05:51:03 +0100,
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > 
> > > On Wed, Jun 16, 2021 at 09:28:59PM +0200, Aman Priyadarshi wrote:
> > > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > 
> > > > [ Upstream commit 3cce50dfec4a5b0414c974190940f47dd32c6dee ]
> > > > 
> > > > The arm64 PMU updates the event counters and reprograms the
> > > > counters in the overflow IRQ handler without disabling the
> > > > PMU. This could potentially cause skews in for group counters,
> > > > where the overflowed counters may potentially loose some event
> > > > counts, while they are reprogrammed. To prevent this, disable
> > > > the PMU while we process the counter overflows and enable it
> > > > right back when we are done.
> > > > 
> > > > This patch also moves the PMU stop/start routines to avoid a
> > > > forward declaration.
> > > > 
> > > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > > Cc: Will Deacon <will.deacon@arm.com>
> > > > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > > Signed-off-by: Aman Priyadarshi <apeureka@amazon.de>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  arch/arm64/kernel/perf_event.c | 50 +++++++++++++++++++-------------
> > > > --
> > > >  1 file changed, 28 insertions(+), 22 deletions(-)
> > > 
> > > What stable tree(s) do you want this applied to?
> > 
> > I guess that'd be 4.14 and previous stables if the patch actually
> > applies.
> > 
> 
> Correct. I have tested the patch on 4.14.y, can confirm that it applies
> cleanly on 4.9.y as well.

Now queued up, thanks.

greg k-h
