Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A801D0A52
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 09:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgEMH6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 03:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729026AbgEMH6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 03:58:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345E023128;
        Wed, 13 May 2020 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589356729;
        bh=hHQLiwk3ACnrGqvswXFe1S8TiVFOobdSVA/WcG4aRls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dr/3BkmcD8wV1dnVi5A1h9YmPfEVKsV1d5M6qVFmM0k12wyrqFOGFZPtN8MX2VJFq
         eJwrIX7fSuxqP9J1T2XQrOtdIjN7F9ywwXEIpWH0lkHe05vjXC27shObf12tMTWon7
         e64t8bBzTD5qcEJS2+QN+0opZRNYXxEgfl3vZOKQ=
Date:   Wed, 13 May 2020 10:58:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Wan, Kaike" <kaike.wan@intel.com>
Cc:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Message-ID: <20200513075845.GS4814@unreal>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
 <20200512055521.GA4814@unreal>
 <MW3PR11MB4665BDCA7CA57498D631FF5EF4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW3PR11MB4665BDCA7CA57498D631FF5EF4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 11:52:34AM +0000, Wan, Kaike wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > Sent: Tuesday, May 12, 2020 1:55 AM
> > To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> > Cc: jgg@ziepe.ca; dledford@redhat.com; linux-rdma@vger.kernel.org;
> > Marciniszyn, Mike <mike.marciniszyn@intel.com>; stable@vger.kernel.org;
> > Wan, Kaike <kaike.wan@intel.com>
> > Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
> > the device is shut down
> >
> > On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> > > From: Kaike Wan <kaike.wan@intel.com>
> > >
> > > The workqueue hfi1_wq is destroyed in function shutdown_device(),
> > > which is called by either shutdown_one() or remove_one(). The function
> > > shutdown_one() is called when the kernel is rebooted while
> > > remove_one() is called when the hfi1 driver is unloaded. When the
> > > kernel is rebooted, hfi1_wq is destroyed while all qps are still
> > > active, leading to a kernel crash:
> >
> > I was under impression that kernel reboot should follow same logic as
> > module removal. This is what graceful reboot will do anyway. Can you please
> > give me a link where I can read about difference in those flows?
> >
> I used to think the same. However, by adding traces to the hfi driver, I found out that the shutdown function of the pci_driver was called when typing "reboot"  while the remove function  of the pci_driver was called when typing "modprobe -r hfi1".

I took a look on what mlx5_core is doing in shutdown flow and it can be
summarized in the following:
1. Drain workqueues
2. Close PCI
3. Don't release anything.

So maybe you didn't flush the hfi1_wq?

>
> I am not an expert on kernel reboot and can someone give some hints?
>
> Kaike
>
>
>
>
