Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956E929F494
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgJ2TMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJ2TMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 15:12:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F8120728;
        Thu, 29 Oct 2020 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603998759;
        bh=pCNMmpnsx69VJQqTHTzQSUX7WSLANUjiWqyo7kzaxZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=brr/4ARi3aEz2HJg0WcqiiJq3RpPrRgPFNXPCCt0uMC93zLIRp7uH58ViBy+b2gOX
         neX4K3LZ5rOg6MEU+maQWAyBrSUXLOplqr6ttGm+m1gnKcgLrsK/qDTXNuKBF4JAoL
         Xz0A9TCyEVqfGGKgjk4H9lV5sKSSIu9WwMGeaOuU=
Date:   Thu, 29 Oct 2020 20:13:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc:     Kamal Mostafa <kamal@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>
Subject: Re: v4.4.y broken by "Fix race while processing OPAL dump"
Message-ID: <20201029191328.GA986195@kroah.com>
References: <20201029150259.30375-1-kamal@canonical.com>
 <7d12bc74-b737-9ed0-cb48-e394c96e1dcd@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d12bc74-b737-9ed0-cb48-e394c96e1dcd@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 09:53:52PM +0530, Vasant Hegde wrote:
> On 10/29/20 8:32 PM, Kamal Mostafa wrote:
> > Hi-
> > 
> > This commit from v4.4.241 breaks the v4.4.y build for powerpc:
> > 
> > 217f139551c0 powerpc/powernv/dump: Fix race while processing OPAL dump
> > 
> > Like this:
> > 
> > .../arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
> >    dump = create_dump_obj(dump_id, dump_size, dump_type);
> >         ^
> > 
> > 
> > The commit descriptions says:
> > 
> > "... the return value of create_dump_obj() function isn't being used today ..."
> > 
> > But that's only true for kernels >= v4.19, because they carry this commit:
> > 
> > b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler
> > 
> > In v4.4 process_dump(), the only caller of create_dump_obj(), still tries to
> > use the return value (see the error above).
> > 
> > 
> > Applying "b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED ..." to
> > v4.4.y fixes the problem.
> 
> 
> Makes sense. Can you please pick above commit as well?

Now queued up there, and in 4.9.y as well, thanks.

greg k-h
