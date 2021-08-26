Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217FD3F8C8E
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243080AbhHZQ51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 12:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhHZQ51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 12:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B280260F42;
        Thu, 26 Aug 2021 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629997000;
        bh=Sdch8X0otKtSPDpNPDcyA2dbJPDXupeY4yKkLojSNgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=PLpHEoTX8XMr7eS8sKDfSN7Wk21t5UKFAtp72cb2VF8bPUtYS3Te3k2zc69ABLQHF
         LEUWCG9EdTEoJS3PaRxPY045Fm1iRpbSehFQP+7TC8hlyMcRErMgAgFO/V/fsmH0QR
         KCDXJqQMf+YvkCH/FS95duDi82JSMmr0nHqYgSzsrtMPU3VQld/xBUf3tEfALHco8v
         /8fb4PB3ps5MmsOS60KQ1eEAW+RJ8rz3lYKdRAmlpIxh6rCzKOpISemkcF9pRnnxjC
         Tfwh3GuxflCERNdOFpY/1PWMCakkDhhUxorzIrQu4Js/bqAlA9Y6fcm5i4E70ucWLW
         wYJX9y1kW54tg==
Date:   Thu, 26 Aug 2021 11:56:38 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI/MSI: skip masking MSI on Xen PV
Message-ID: <20210826165638.GA3686936@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSfDIkAmTu+PM4nE@mail-itl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 06:36:49PM +0200, Marek Marczykowski-G�recki wrote:
> On Thu, Aug 26, 2021 at 09:55:32AM -0500, Bjorn Helgaas wrote:
> > If/when you repost this, please run "git log --oneline
> > drivers/pci/msi.c" and follow the convention of capitalizing the
> > subject line.
> > 
> > Also, I think this patch refers specifically to MSI-X, not MSI, so
> > please update the subject line and the "masking MSI" below to reflect
> > that.
> 
> Sure, thanks for pointing this out. Is the patch otherwise ok? Should I
> post v2 with just updated commit message?

Wouldn't hurt to post a v2.  I don't have any objections to the patch,
but ultimately up to Thomas.

> > On Thu, Aug 26, 2021 at 03:43:37PM +0200, Marek Marczykowski-G�recki wrote:
> > > When running as Xen PV guest, masking MSI is a responsibility of the
> > > hypervisor. Guest has no write access to relevant BAR at all - when it
> > > tries to, it results in a crash like this:
> > > 
> > >     BUG: unable to handle page fault for address: ffffc9004069100c
> > >     #PF: supervisor write access in kernel mode
> > >     #PF: error_code(0x0003) - permissions violation
> > >     PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 80100000febd4075
> > >     Oops: 0003 [#1] SMP NOPTI
> > >     CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W         5.14.0-rc7-1.fc32.qubes.x86_64 #15
> > >     Workqueue: events work_for_cpu_fn
> > >     RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> > >     Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 01 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> > >     RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> > >     RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc9004069105c
> > >     RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90040691000
> > >     RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000febd404f
> > >     R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800ed41000
> > >     R13: 0000000000000000 R14: 0000000000000040 R15: 00000000feba0000
> > >     FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlGS:0000000000000000
> > >     CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >     CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000000000660
> > >     Call Trace:
> > >      e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
> > >      e1000_probe+0x41f/0xdb0 [e1000e]
> > >      local_pci_probe+0x42/0x80
> > >     (...)
> > > 
> > > There is pci_msi_ignore_mask variable for bypassing MSI masking on Xen
> > > PV, but msix_mask_all() missed checking it. Add the check there too.
> > > 
> > > Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
> > > Cc: stable@vger.kernel.org
> > 
> > 7d5ec3d36123 appeared in v5.14-rc6, so if this fix is merged before
> > v5.14, the stable tag will be unnecessary.  But we are running out of
> > time there.
> 
> 7d5ec3d36123 was already backported to stable branches (at least 5.10
> and 5.4), and in fact this is how I discovered the issue...

Oh, right, of course.  Sorry :)

> > > Signed-off-by: Marek Marczykowski-G�recki <marmarek@invisiblethingslab.com>
> > > ---
> > > Cc: xen-devel@lists.xenproject.org
> > > ---
> > >  drivers/pci/msi.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > > index e5e75331b415..3a9f4f8ad8f9 100644
> > > --- a/drivers/pci/msi.c
> > > +++ b/drivers/pci/msi.c
> > > @@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *base, int tsize)
> > >  	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
> > >  	int i;
> > >  
> > > +	if (pci_msi_ignore_mask)
> > > +		return;
> > > +
> > >  	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
> > >  		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
> > >  }
> > > -- 
> > > 2.31.1
> > > 
> 
> -- 
> Best Regards,
> Marek Marczykowski-G�recki
> Invisible Things Lab


