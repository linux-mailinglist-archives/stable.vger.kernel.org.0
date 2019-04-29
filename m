Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9ACE0F0
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfD2K4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 06:56:10 -0400
Received: from 8.mo68.mail-out.ovh.net ([46.105.74.219]:43257 "EHLO
        8.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbfD2K4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 06:56:10 -0400
X-Greylist: delayed 1136 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2019 06:56:07 EDT
Received: from player158.ha.ovh.net (unknown [10.109.159.7])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id C2F5E122CEA
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 12:37:09 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player158.ha.ovh.net (Postfix) with ESMTPSA id C9E2051F45C6;
        Mon, 29 Apr 2019 10:37:01 +0000 (UTC)
Date:   Mon, 29 Apr 2019 12:36:59 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alistair Popple <alistair@popple.id.au>, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/powernv/npu: Fix reference leak
Message-ID: <20190429123659.00c0622b@bahia.lan>
In-Reply-To: <962c1d9e-719c-cb82-cabc-1cf619e1510b@ozlabs.ru>
References: <155568805354.600470.13376593185688810607.stgit@bahia.lan>
        <962c1d9e-719c-cb82-cabc-1cf619e1510b@ozlabs.ru>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15264106512109181429
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddriedvgdefudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Apr 2019 16:01:29 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> On 20/04/2019 01:34, Greg Kurz wrote:
> > Since 902bdc57451c, get_pci_dev() calls pci_get_domain_bus_and_slot(). This
> > has the effect of incrementing the reference count of the PCI device, as
> > explained in drivers/pci/search.c:
> > 
> >  * Given a PCI domain, bus, and slot/function number, the desired PCI
> >  * device is located in the list of PCI devices. If the device is
> >  * found, its reference count is increased and this function returns a
> >  * pointer to its data structure.  The caller must decrement the
> >  * reference count by calling pci_dev_put().  If no device is found,
> >  * %NULL is returned.
> > 
> > Nothing was done to call pci_dev_put() and the reference count of GPU and
> > NPU PCI devices rockets up.
> > 
> > A natural way to fix this would be to teach the callers about the change,
> > so that they call pci_dev_put() when done with the pointer. This turns
> > out to be quite intrusive, as it affects many paths in npu-dma.c,
> > pci-ioda.c and vfio_pci_nvlink2.c.  
> 
> 
> afaict this referencing is only done to protect the current traverser
> and what you've done is actually a natural way (and the generic
> pci_get_dev_by_id() does exactly the same), although this looks a bit weird.
> 

Not exactly the same: pci_get_dev_by_id() always increment the refcount
of the returned PCI device. The refcount is only decremented when this
device is passed to pci_get_dev_by_id() to continue searching.

That means that the users of the PCI device pointer returned by
pci_get_dev_by_id() or its exported variants pci_get_subsys(),
pci_get_device() and pci_get_class() do handle the refcount. They
all pass the pointer to pci_dev_put() or continue the search,
which calls pci_dev_put() internally.

Direct and indirect callers of get_pci_dev() don't care for the
refcount at all unless I'm missing something.

> 
> > Also, the issue appeared in 4.16 and
> > some affected code got moved around since then: it would be problematic
> > to backport the fix to stable releases.
> > 
> > All that code never cared for reference counting anyway. Call pci_dev_put()
> > from get_pci_dev() to revert to the previous behavior.  
> >> Fixes: 902bdc57451c ("powerpc/powernv/idoa: Remove unnecessary pcidev  
> from pci_dn")
> > Cc: stable@vger.kernel.org # v4.16
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >  arch/powerpc/platforms/powernv/npu-dma.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/platforms/powernv/npu-dma.c b/arch/powerpc/platforms/powernv/npu-dma.c
> > index e713ade30087..d8f3647e8fb2 100644
> > --- a/arch/powerpc/platforms/powernv/npu-dma.c
> > +++ b/arch/powerpc/platforms/powernv/npu-dma.c
> > @@ -31,9 +31,22 @@ static DEFINE_SPINLOCK(npu_context_lock);
> >  static struct pci_dev *get_pci_dev(struct device_node *dn)
> >  {
> >  	struct pci_dn *pdn = PCI_DN(dn);
> > +	struct pci_dev *pdev;
> >  
> > -	return pci_get_domain_bus_and_slot(pci_domain_nr(pdn->phb->bus),
> > +	pdev = pci_get_domain_bus_and_slot(pci_domain_nr(pdn->phb->bus),
> >  					   pdn->busno, pdn->devfn);
> > +
> > +	/*
> > +	 * pci_get_domain_bus_and_slot() increased the reference count of
> > +	 * the PCI device, but callers don't need that actually as the PE
> > +	 * already holds a reference to the device.  
> 
> Imho this would be just enough.
> 
> Anyway,
> 
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 

Thanks !

I now realize that I forgot to add the --cc option for stable on my stgit
command line :-\.

Cc'ing now.

> 
> How did you find it? :)
> 

While reading code to find some inspiration for OpenCAPI passthrough. :)

I saw the following in vfio_pci_ibm_npu2_init():

	if (!pnv_pci_get_gpu_dev(vdev->pdev))
		return -ENODEV;

and simply followed the function calls.

> 
> > Since callers aren't
> > +	 * aware of the reference count change, call pci_dev_put() now to
> > +	 * avoid leaks.
> > +	 */
> > +	if (pdev)
> > +		pci_dev_put(pdev);
> > +
> > +	return pdev;
> >  }
> >  
> >  /* Given a NPU device get the associated PCI device. */
> >   
> 

