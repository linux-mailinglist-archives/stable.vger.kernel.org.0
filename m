Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F579422609
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhJEMPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 08:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233924AbhJEMPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 08:15:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054C161186;
        Tue,  5 Oct 2021 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633436024;
        bh=ZR+lmMqNdt8MNBNHviCdxPZ6gQh9UKu+/XtzPis9US8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pthivfmyuTnXsEIgPLGfFOPYUxZq9vJFEk+H+jwxeaShTmT+Wllj2b9qEEhY8LffB
         oueiBlI4PyNTti7Hg3CHYtOMLFZodlByJIK2Xy9pUd2C+cULKDII8tbP64Z4SZ0qLd
         uV0v8FqYEt8CcuzJcLq7JBxyLXI+uggJwKJ0SsNpaM8lZxzfweb3xc6XerLnmnxXcv
         vUhWakfCxobwtAYwk89cepUS7GRCxfUBlhCQhMlhQDunQ0mk8fnTYs5h73IwzZ/vbK
         ujG1JEb6j4ZiZ/V158ZD1SPlObkmnHgsemN0mVoj6ftrV0uitjuDZB0FM7c9CS6eG/
         XaumrL4Ke0FsQ==
Date:   Tue, 5 Oct 2021 14:13:40 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked
 interrupts
Message-ID: <20211005141340.48c8c0f6@dellmb>
In-Reply-To: <871r50st5h.wl-maz@kernel.org>
References: <20211001195856.10081-1-kabel@kernel.org>
 <20211001195856.10081-7-kabel@kernel.org>
 <20211004140653.GB24914@lpieralisi>
 <871r50st5h.wl-maz@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 04 Oct 2021 16:31:54 +0100
Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 04 Oct 2021 15:06:53 +0100,
> Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> >=20
> > [+Marc - always better to have his eyes on IRQ handling code]
> >=20
> > On Fri, Oct 01, 2021 at 09:58:49PM +0200, Marek Beh=C3=BAn wrote: =20
> > > From: Pali Roh=C3=A1r <pali@kernel.org>
> > >=20
> > > It is incorrect to clear status bits of masked interrupts.
> > >=20
> > > The aardvark driver clears all status interrupt bits if no
> > > unmasked status bit is set. Masked bits should never be cleared.
> > >=20
> > > Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host
> > > controller driver") Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/pci/controller/pci-aardvark.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/pci/controller/pci-aardvark.c
> > > b/drivers/pci/controller/pci-aardvark.c index
> > > d5d6f92e5143..e4986806a189 100644 ---
> > > a/drivers/pci/controller/pci-aardvark.c +++
> > > b/drivers/pci/controller/pci-aardvark.c @@ -1295,11 +1295,8 @@
> > > static void advk_pcie_handle_int(struct advk_pcie *pcie)
> > > isr1_mask =3D advk_readl(pcie, PCIE_ISR1_MASK_REG); isr1_status =3D
> > > isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);=20
> > > -	if (!isr0_status && !isr1_status) {
> > > -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> > > -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG); =20
> >=20
> > This looks fine - on the other hand if no interrupt is set in the
> > status registers (that are filtered with the masks) we are dealing
> > with a spurious IRQ right ? Just gauging how severe this is.
> >=20
> > Lorenzo
> >  =20
> > > +	if (!isr0_status && !isr1_status)
> > >  		return; =20
>=20
> The whole thing is a bit odd. What the commit message doesn't say is
> whether the status register shows the status of the line before
> masking, or after masking.

I don't quite understand what you are asking about.
If you are asking about the register itself:
the PCIE_ISR1_REG says which interrupts are currently set / active,
including those which are masked.

If you are asking about the isr1_status variable, it is the
status of the line after masking. I.e. masked interrupts are not set in
this variable, only active interrupts which are also unmasked. That is
obvious from the code.

> The code seems to imply the former, but then the behaviour is
> awkward. How did we end-up here the first place?

I answered this in reply to Lorenzo's comment on this patch, see
https://lore.kernel.org/linux-pci/20211004171823.0288684e@thinkpad/

> if that's only a
> spurious interrupt, then I'd probably simplify the code altogether,
> and drop all the early return code. Something like below, as usual
> completely untested.
>=20
> 	M.
>=20
> diff --git a/drivers/pci/controller/pci-aardvark.c
> b/drivers/pci/controller/pci-aardvark.c index
> 596ebcfcc82d..1d8f257ecb63 100644 ---
> a/drivers/pci/controller/pci-aardvark.c +++
> b/drivers/pci/controller/pci-aardvark.c @@ -1275,7 +1275,8 @@ static
> void advk_pcie_handle_msi(struct advk_pcie *pcie) static void
> advk_pcie_handle_int(struct advk_pcie *pcie) {
>  	u32 isr0_val, isr0_mask, isr0_status;
> -	u32 isr1_val, isr1_mask, isr1_status;
> +	u32 isr1_val, isr1_mask;
> +	unsigned long isr1_status;
>  	int i;
> =20
>  	isr0_val =3D advk_readl(pcie, PCIE_ISR0_REG);
> @@ -1285,22 +1286,14 @@ static void advk_pcie_handle_int(struct
> advk_pcie *pcie) isr1_val =3D advk_readl(pcie, PCIE_ISR1_REG);
>  	isr1_mask =3D advk_readl(pcie, PCIE_ISR1_MASK_REG);
>  	isr1_status =3D isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
> -
> -	if (!isr0_status && !isr1_status) {
> -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);
> -		return;
> -	}
> +	isr1_status >> 8;
>
>  	/* Process MSI interrupts */
>  	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
>  		advk_pcie_handle_msi(pcie);
> =20
>  	/* Process legacy interrupts */
> -	for (i =3D 0; i < PCI_NUM_INTX; i++) {
> -		if (!(isr1_status & PCIE_ISR1_INTX_ASSERT(i)))
> -			continue;
> -
> +	for_each_set_bit(i, &isr1_status, PCI_NUM_INTX) {
>  		advk_writel(pcie, PCIE_ISR1_INTX_ASSERT(i),
>  			    PCIE_ISR1_REG);

1. what you are doing here is code cleanup. We are currently in the
   state where we have lots of fixes for this driver, which we are
   hoping will go also to stable. Some of them depend on these changes.
   Can we please first apply those fixes (we want to send them in
   batches to avoid sending 60 patchs in one series, since last time
   nobody wanted to review all of that) and do this afterwards?

2. you are throwing away lower 8 bits of isr1_status. We have follow-up
   patches (not in this series, but in another batch which we want to
   send after this) that will be using those lower 8 bits, so we do not
   want to throw away them now.

Marek

PS: You can look at all the prepared changes at
https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=3Dpci=
-aardvark
