Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E1449CEE
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbhKHUPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238492AbhKHUPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 15:15:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D2DF610FF;
        Mon,  8 Nov 2021 20:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636402372;
        bh=SLHrJGPlptWG4wM3hA+8zEcf0wasxqjylPj+dqMVE/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+kuVTs44sfD1wvHblMCf/9H/IfoLhjrFvpCha3K/THzQc+sXWIUQnJQKR1eclV3f
         RZrNqHhqU5MeXh/XaBF1jAUv/rdZvfVVoBQcjOFV6ohJPyy7vj7ObvspcUZSiZlMq5
         hWu1bFlv45h7fHwr2YZ50UQBXwvVO+YC/bumvF0ZweWW3yWwIcTZVe1AduSQcWCWzR
         sV4Vjmxu+t8O/ItggEHuDi0r+P7d0W33hVrjDo3tcgEsyTYjcBf+ld/KJ5vbpei1Ux
         RiTO670DtUvuMEJUXtVTxmr79KAm9PnYt5a9xjaqzSlpiCq8ehq16/OAO9INElmBa7
         cL9I+BGKu2HXw==
Date:   Mon, 8 Nov 2021 22:12:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Message-ID: <YYmEwobYw+jGBSwV@iki.fi>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
 <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
 <d7a6dedb-03c5-fad1-e112-c912473c7214@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a6dedb-03c5-fad1-e112-c912473c7214@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 11:48:18AM -0800, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 11/7/2021 8:47 AM, Jarkko Sakkinen wrote:
> > On Sun, 2021-11-07 at 18:45 +0200, Jarkko Sakkinen wrote:
> > > On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
> > > > The consequence of sgx_nr_free_pages not being protected is that
> > > > its value may not accurately reflect the actual number of free
> > > > pages on the system, impacting the availability of free pages in
> > > > support of many flows. The problematic scenario is when the
> > > > reclaimer never runs because it believes there to be sufficient
> > > > free pages while any attempt to allocate a page fails because there
> > > > are no free pages available. The worst scenario observed was a
> > > > user space hang because of repeated page faults caused by
> > > > no free pages ever made available.
> > > 
> > > Can you go in detail with the "concrete scenario" in the commit
> > > message? It does not have to describe all the possible scenarios
> > > but at least one sequence of events.
> 
> 
> I provided significant detail regarding the "concrete scenario" in a
> separate response to Greg:
> https://lore.kernel.org/lkml/a636290d-db04-be16-1c86-a8dcc3719b39@intel.com/
> 
> That message details the test that was run (the test hangs before the fix
> and can complete after the fix), the traces captured at the time the test
> hung, analysis of the traces with root cause of why the system is hung,
> traces after fix applied demonstrating why user space is able to make
> progress and explaining why the test can complete.

For me that sequence looks like something that you could "abstract"
a bit and get a rough description of the concurrency scenario.

It is as important in this type of patch, as the code change itself,
not least because it helps with maintaining in the future to have
that info in some level of detail in the commit log.

/Jarkko
