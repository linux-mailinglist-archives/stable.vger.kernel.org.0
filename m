Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216FC44A400
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbhKIBfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243601AbhKIBdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02F76610CB;
        Tue,  9 Nov 2021 01:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636421418;
        bh=5z6TWhdFMQk1gL5oxmD2fxZ7CtBItaMocNOJZwNfzPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t89kRIHv9SZoV/lY55zqqQ1bd1DzE1HAtw4pwhZyoXt13xn27f59QvHOasrMOlZa5
         RSwpyZxK5fAwyH+C0yTKF/9BJJTFqihMcfCZpXDtG5Kl5Y6CrO1QPQYXs+g3mi8krf
         E7KS95bBNWkcvw9VQ1A0E1jSGovPEzdjvQX/TVLlBeC5WX8YPL6gpl/LeN9aV0Iyew
         Q1pkshfpy+MuYli0SFspIjXvJdVqSnEISHYLqTaliCx5315V8z/MbCYqrZhdTsbFLC
         YA13JvBls9hOLPxupDVasnWELr1cvhJMHSs8mnFjQ1mJrYVYcWSYpea7pMwb9d7OR8
         d/d+eUpZe8qjw==
Date:   Tue, 9 Nov 2021 03:30:15 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Message-ID: <YYnPJ3a9PSSy/gFZ@iki.fi>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
 <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
 <d7a6dedb-03c5-fad1-e112-c912473c7214@intel.com>
 <YYmEwobYw+jGBSwV@iki.fi>
 <ced9786a-b8ac-2575-02b0-04323c83ca4e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced9786a-b8ac-2575-02b0-04323c83ca4e@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 12:56:21PM -0800, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 11/8/2021 12:12 PM, Jarkko Sakkinen wrote:
> > On Mon, Nov 08, 2021 at 11:48:18AM -0800, Reinette Chatre wrote:
> > > Hi Jarkko,
> > > 
> > > On 11/7/2021 8:47 AM, Jarkko Sakkinen wrote:
> > > > On Sun, 2021-11-07 at 18:45 +0200, Jarkko Sakkinen wrote:
> > > > > On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
> > > > > > The consequence of sgx_nr_free_pages not being protected is that
> > > > > > its value may not accurately reflect the actual number of free
> > > > > > pages on the system, impacting the availability of free pages in
> > > > > > support of many flows. The problematic scenario is when the
> > > > > > reclaimer never runs because it believes there to be sufficient
> > > > > > free pages while any attempt to allocate a page fails because there
> > > > > > are no free pages available. The worst scenario observed was a
> > > > > > user space hang because of repeated page faults caused by
> > > > > > no free pages ever made available.
> > > > > 
> > > > > Can you go in detail with the "concrete scenario" in the commit
> > > > > message? It does not have to describe all the possible scenarios
> > > > > but at least one sequence of events.
> > > 
> > > 
> > > I provided significant detail regarding the "concrete scenario" in a
> > > separate response to Greg:
> > > https://lore.kernel.org/lkml/a636290d-db04-be16-1c86-a8dcc3719b39@intel.com/
> > > 
> > > That message details the test that was run (the test hangs before the fix
> > > and can complete after the fix), the traces captured at the time the test
> > > hung, analysis of the traces with root cause of why the system is hung,
> > > traces after fix applied demonstrating why user space is able to make
> > > progress and explaining why the test can complete.
> > 
> > For me that sequence looks like something that you could "abstract"
> > a bit and get a rough description of the concurrency scenario.
> > 
> > It is as important in this type of patch, as the code change itself,
> > not least because it helps with maintaining in the future to have
> > that info in some level of detail in the commit log.
> 
> My apologies. I understood your comment to be a concern with the change
> itself instead of just the commit message. I will add more detail about the
> failing scenario encountered to the commit message.

Yeah, I went through the log and the code change makes sense :-)

/Jarkko
