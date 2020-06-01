Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF911EA26A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgFALHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgFALHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 07:07:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB61820657;
        Mon,  1 Jun 2020 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591009672;
        bh=oeg5LhQy9jYN0KsGCtEYzL2rtk3xXb3RO+RekWTh9gA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uzHMZmy+OOG0e7UVv731fhdgt4V/9SDDlnENqRerylJSTUI9fCfl0fT/Maxxtqnak
         lYPmkfXM4GYg9osUrXOcmsgaV1996F7zDgWJWqmRfdLNNNyqnZd/YX8tLXgQ/2UYZe
         IQrc1CS2WZp0l/j663+qV8faMzbjPoyHbK6IM4Tk=
Date:   Mon, 1 Jun 2020 13:07:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jeff Moyer <jmoyer@redhat.com>, stable <stable@vger.kernel.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible
 namespace alignment
Message-ID: <20200601110750.GB124421@kroah.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200522115800.GA1451824@kroah.com>
 <20200522120009.GA1456052@kroah.com>
 <CAPcyv4jW9P2FP2p6OiLoN+e_wzZY9-c8C-mMMoDqohuTekF7WQ@mail.gmail.com>
 <x491rn6a0bp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4idRgByUTdb=6coYV=kkhqfLTzO1c+LZc7VQXus-BHh6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4idRgByUTdb=6coYV=kkhqfLTzO1c+LZc7VQXus-BHh6Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 01:52:21PM -0700, Dan Williams wrote:
> On Tue, May 26, 2020 at 1:49 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> >
> > Dan Williams <dan.j.williams@intel.com> writes:
> >
> > >> What problems with 5.4.y and 5.6.y is this series fixing
> > >> that used to work before?
> > >
> > > The "used to work" bug fixed by this set is the fact that the kernel
> > > used to force a 128MB (memory hotplug section size) alignment padding
> > > on all persistent memory namespaces to enable DAX operation. The
> > > support for sub-sections (2MB) dropped forced alignment padding, but
> > > unfortunately introduced a regression for the case of trying to create
> > > multiple unaligned namespaces. When that bug triggers namespace
> > > creation for the region is disabled, iirc, previously that lockout
> > > scenario was prevented.
> > >
> > > Jeff, can you corroborate this?
> >
> > So, I don't pretend to remember the exact state of brokenness for each
> > iteration.  :)  As far as I can recall, though, the issue you describe
> > with a misaligned namespace preventing further namespace creation was
> > present in all kernels up until it was finally fixed.
> 
> Well, if it was always there, then there is nothing to fix, and I
> misremembered that we went backwards.
> 
> > > I otherwise agree, if the above never worked then this can all wait
> > > for v5.7 upgrades.
> >
> > I can test specific kernel versions if that would help out.
> 
> Thanks for that offer, but outside of a clear regression I don't think
> this meets -stable criteria.

I agree, I'll drop this series from my pending-queue.

thanks,

greg k-h
