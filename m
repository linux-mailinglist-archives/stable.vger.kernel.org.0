Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992FA24BF6E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgHTNsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgHTNsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 09:48:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547CF2076E;
        Thu, 20 Aug 2020 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597931315;
        bh=FimYMkYiuCDAGzXaOaFsHcjupgUWLh69vV0SwtvI274=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncOdIJhtiTxsJ9QTmxsqNlnXldF8i7NK/RsboPTTA31D0Jjg6CngNl3P/2TehtER2
         Fv2QvLF9/6tVbcAVaNVOYvDmvyl2ZrZ1ZqMG/nZftl1DETQ+18PWb1ncuGRzV/aPml
         NU6S9v22GUrQ4Gu5c7bmSwTLJXmYGSbugShuEsuA=
Date:   Thu, 20 Aug 2020 15:48:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 5.8 164/232] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Message-ID: <20200820134855.GB1533625@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091620.754492308@linuxfoundation.org>
 <MW2PR2101MB10522B1242B1309BF35EFFEED75A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200820132924.GA8670@sasha-vm>
 <20200820134823.GA1533625@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820134823.GA1533625@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 03:48:23PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 20, 2020 at 09:29:24AM -0400, Sasha Levin wrote:
> > On Thu, Aug 20, 2020 at 01:00:51PM +0000, Michael Kelley wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Thursday, August 20, 2020 2:20 AM
> > > > 
> > > > From: Wei Hu <weh@microsoft.com>
> > > > 
> > > > [ Upstream commit d6af2ed29c7c1c311b96dac989dcb991e90ee195 ]
> > > > 
> > > > Kdump could fail sometime on Hyper-V guest because the retry in
> > > > hv_pci_enter_d0() releases child device structures in hv_pci_bus_exit().
> > > > 
> > > > Although there is a second asynchronous device relations message sending
> > > > from the host, if this message arrives to the guest after
> > > > hv_send_resource_allocated() is called, the retry would fail.
> > > > 
> > > > Fix the problem by moving retry to hv_pci_probe() and start the retry
> > > > from hv_pci_query_relations() call.  This will cause a device relations
> > > > message to arrive to the guest synchronously; the guest would then be
> > > > able to rebuild the child device structures before calling
> > > > hv_send_resource_allocated().
> > > > 
> > > > Link:
> > > > https://lore.kernel.org/linux-hyperv/20200727071731.18516-1-weh@microsoft.com/
> > > > Fixes: c81992e7f4aa ("PCI: hv: Retry PCI bus D0 entry on invalid device state")
> > > > Signed-off-by: Wei Hu <weh@microsoft.com>
> > > > [lorenzo.pieralisi@arm.com: fixed a comment and commit log]
> > > > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  drivers/pci/controller/pci-hyperv.c | 71 +++++++++++++++--------------
> > > >  1 file changed, 37 insertions(+), 34 deletions(-)
> > > > 
> > > 
> > > This patch came through three days ago, and I indicated then that we don't want
> > > it backported to 5.8 and earlier.
> > 
> > Uh, I re-added it by mistake, sorry.
> 
> Ok, let me go drop it...

Oops, you already did :)
