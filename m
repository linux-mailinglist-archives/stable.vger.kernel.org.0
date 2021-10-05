Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CF422799
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhJENRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhJENRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:17:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C7096138F;
        Tue,  5 Oct 2021 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633439748;
        bh=f6qLfxaQVzRvxo4GUn6xc3JfsVjx+MwZhu9H/dnhtN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdlPL4gPI/mXUqGwc4RvO5ScKrRoEn73tzoWTkJnXbl7/yYInDiiPsyW0DIKdGsPX
         Gvk8EoKEBH97xGJy1xe+bsyrYaqlKZS/2nGsJf4YKO7GC/5qdxdsHqBfsxMsY6UDhb
         NrameiIPTxj8uMZCBc8N0R4DtDnqJDdrOL4n1n8ZRCVY4f3gSsYUqwAtOd7KuIJmgs
         xMI+sTYKfsBXqepBCqa6iSm8HaDDDAq4sTd3GzT9Ovzmhq3ElcA438TCgl4/aN/B6A
         +5cjTXXuX7J0THbhdoGLNg1WqGhOxZ/6dQJthmvjrlPna4EDq9kLsitfFMAJMNoZGS
         8DkliWLEF8npQ==
Received: by pali.im (Postfix)
        id 10E18812; Tue,  5 Oct 2021 15:15:45 +0200 (CEST)
Date:   Tue, 5 Oct 2021 15:15:45 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked
 interrupts
Message-ID: <20211005131545.ol3rb3zzgzze67uf@pali>
References: <20211001195856.10081-1-kabel@kernel.org>
 <20211001195856.10081-7-kabel@kernel.org>
 <20211004140653.GB24914@lpieralisi>
 <871r50st5h.wl-maz@kernel.org>
 <20211005141340.48c8c0f6@dellmb>
 <87mtnnr6cl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mtnnr6cl.wl-maz@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 05 October 2021 13:42:02 Marc Zyngier wrote:
> On Tue, 05 Oct 2021 13:13:40 +0100,
> Marek Behún <kabel@kernel.org> wrote:
> > 
> > On Mon, 04 Oct 2021 16:31:54 +0100
> > Marc Zyngier <maz@kernel.org> wrote:
> > 
> > > On Mon, 04 Oct 2021 15:06:53 +0100,
> > > Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> > > > 
> > > > [+Marc - always better to have his eyes on IRQ handling code]
> > > > 
> > > > On Fri, Oct 01, 2021 at 09:58:49PM +0200, Marek Behún wrote:  
> > > > > From: Pali Rohár <pali@kernel.org>
> > > > > 
> > > > > It is incorrect to clear status bits of masked interrupts.
> > > > > 
> > > > > The aardvark driver clears all status interrupt bits if no
> > > > > unmasked status bit is set. Masked bits should never be cleared.
> > > > > 
> > > > > Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host
> > > > > controller driver") Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > Reviewed-by: Marek Behún <kabel@kernel.org>
> > > > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/pci/controller/pci-aardvark.c | 5 +----
> > > > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/pci/controller/pci-aardvark.c
> > > > > b/drivers/pci/controller/pci-aardvark.c index
> > > > > d5d6f92e5143..e4986806a189 100644 ---
> > > > > a/drivers/pci/controller/pci-aardvark.c +++
> > > > > b/drivers/pci/controller/pci-aardvark.c @@ -1295,11 +1295,8 @@
> > > > > static void advk_pcie_handle_int(struct advk_pcie *pcie)
> > > > > isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG); isr1_status =
> > > > > isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK); 
> > > > > -	if (!isr0_status && !isr1_status) {
> > > > > -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> > > > > -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);  
> > > > 
> > > > This looks fine - on the other hand if no interrupt is set in the
> > > > status registers (that are filtered with the masks) we are dealing
> > > > with a spurious IRQ right ? Just gauging how severe this is.
> > > > 
> > > > Lorenzo
> > > >   
> > > > > +	if (!isr0_status && !isr1_status)
> > > > >  		return;  
> > > 
> > > The whole thing is a bit odd. What the commit message doesn't say is
> > > whether the status register shows the status of the line before
> > > masking, or after masking.
> > 
> > I don't quite understand what you are asking about.
> > If you are asking about the register itself:
> > the PCIE_ISR1_REG says which interrupts are currently set / active,
> > including those which are masked.
> 
> Then please say so in the commit message.

Very well, we shall do so.

> > If you are asking about the isr1_status variable, it is the
> > status of the line after masking. I.e. masked interrupts are not set in
> > this variable, only active interrupts which are also unmasked. That is
> > obvious from the code.
> 
> Which is what I have said... two lines below. If you are going to
> reply, please do so in context.
> 
> > 
> > > The code seems to imply the former, but then the behaviour is
> > > awkward. How did we end-up here the first place?
> > 
> > I answered this in reply to Lorenzo's comment on this patch, see
> > https://lore.kernel.org/linux-pci/20211004171823.0288684e@thinkpad/
> 
> It did grace my inbox, thanks.
> 
> > > if that's only a
> > > spurious interrupt, then I'd probably simplify the code altogether,
> > > and drop all the early return code. Something like below, as usual
> > > completely untested.
> > > 
> > > 	M.
> > > 
> > > diff --git a/drivers/pci/controller/pci-aardvark.c
> > > b/drivers/pci/controller/pci-aardvark.c index
> > > 596ebcfcc82d..1d8f257ecb63 100644 ---
> > > a/drivers/pci/controller/pci-aardvark.c +++
> > > b/drivers/pci/controller/pci-aardvark.c @@ -1275,7 +1275,8 @@ static
> > > void advk_pcie_handle_msi(struct advk_pcie *pcie) static void
> > > advk_pcie_handle_int(struct advk_pcie *pcie) {
> > >  	u32 isr0_val, isr0_mask, isr0_status;
> > > -	u32 isr1_val, isr1_mask, isr1_status;
> > > +	u32 isr1_val, isr1_mask;
> > > +	unsigned long isr1_status;
> > >  	int i;
> > >  
> > >  	isr0_val = advk_readl(pcie, PCIE_ISR0_REG);
> > > @@ -1285,22 +1286,14 @@ static void advk_pcie_handle_int(struct
> > > advk_pcie *pcie) isr1_val = advk_readl(pcie, PCIE_ISR1_REG);
> > >  	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
> > >  	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
> > > -
> > > -	if (!isr0_status && !isr1_status) {
> > > -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> > > -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);
> > > -		return;
> > > -	}
> > > +	isr1_status >> 8;

Hello!

I dislike this approach. It adds another magic number which is just
causing issues. Please read commit message for patch 11/13 where we
describe why such magic constants are bad and already caused lot of
issues in this driver.

> > >  	/* Process MSI interrupts */
> > >  	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
> > >  		advk_pcie_handle_msi(pcie);
> > >  
> > >  	/* Process legacy interrupts */
> > > -	for (i = 0; i < PCI_NUM_INTX; i++) {
> > > -		if (!(isr1_status & PCIE_ISR1_INTX_ASSERT(i)))
> > > -			continue;
> > > -
> > > +	for_each_set_bit(i, &isr1_status, PCI_NUM_INTX) {
> > >  		advk_writel(pcie, PCIE_ISR1_INTX_ASSERT(i),
> > >  			    PCIE_ISR1_REG);
> > 
> > 1. what you are doing here is code cleanup. We are currently in the
> >    state where we have lots of fixes for this driver, which we are
> >    hoping will go also to stable.
> 
> Yes, it is code cleanup. Because I don't find this patch to be very
> good, TBH. As for going into stable, that's not relevant for this
> discussion.
> 
> >    Some of them depend on these changes.
> >    Can we please first apply those fixes (we want to send them in
> >    batches to avoid sending 60 patchs in one series, since last time
> >    nobody wanted to review all of that) and do this afterwards?
> 
> It would be better to start with patches that are in a better
> shape. After all, this is what the code review process is about. This
> isn't "just take my patches".
> 
> > 2. you are throwing away lower 8 bits of isr1_status. We have follow-up
> >    patches (not in this series, but in another batch which we want to
> >    send after this) that will be using those lower 8 bits, so we do not
> >    want to throw away them now.
> 
> I'm discarding these bits because *in isolation*, that's the correct
> thing to do. Feel free to propose a better patch that doesn't discard
> these bits and still makes the code more palatable.

The code pattern in this function is: compose irs*_status variable and
then compare it with register macros defined at the top of driver. Each
bit in this register represent some event and for each event there is
simple macro to match.

So with your proposed change it would break all macros (as they are
going to be shifted by magic constant) and then this code disallow
access to events represented by low bits. And also it makes code pattern
different for isr0_status and isr1_status variables which is very
confusing and probably source for introduction of new bugs.

Also the whole early-return optimization can be removed as it does not
change functionality. So we will do so.

But we do not agree with the lower 8 bit discard of the isr1_status
variable as explained above.

So if we add the explanation to commit message and drop the early
return, would it be ok?
