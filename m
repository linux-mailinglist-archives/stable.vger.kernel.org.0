Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF15ECAE4B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfJCSfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:35:44 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44710 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388309AbfJCSfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 14:35:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbrezillon)
        with ESMTPSA id DD9C028ECEA
Date:   Thu, 3 Oct 2019 20:35:36 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Vitor Soares <Vitor.Soares@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pgaj@cadence.com" <pgaj@cadence.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] i3c: master: make sure ->boardinfo is
 initialized in add_i3c_dev_locked()
Message-ID: <20191003203536.218a3cd8@collabora.com>
In-Reply-To: <CH2PR12MB42162C4459E31D85FD60FB79AE9F0@CH2PR12MB4216.namprd12.prod.outlook.com>
References: <cover.1567608245.git.vitor.soares@synopsys.com>
        <ed18fd927b5759a6a1edb351113ceca615283189.1567608245.git.vitor.soares@synopsys.com>
        <20191003162943.4a0d0274@collabora.com>
        <CH2PR12MB42162C4459E31D85FD60FB79AE9F0@CH2PR12MB4216.namprd12.prod.outlook.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Oct 2019 17:37:40 +0000
Vitor Soares <Vitor.Soares@synopsys.com> wrote:

> Hi Boris,
> 
> From: Boris Brezillon <boris.brezillon@collabora.com>
> Date: Thu, Oct 03, 2019 at 15:29:43
> 
> > On Thu,  5 Sep 2019 12:00:35 +0200
> > Vitor Soares <Vitor.Soares@synopsys.com> wrote:
> >   
> > > The newdev->boardinfo assignment was missing in
> > > i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
> > > propagated to i3c_dev_desc.
> > > 
> > > Fix this by trying to initialize device i3c_dev_boardinfo if available.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> > > Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> > > ---
> > > Change in v3:
> > >   - None
> > > 
> > > Changes in v2:
> > >   - Change commit message
> > >   - Change i3c_master_search_i3c_boardinfo(newdev) to
> > >   i3c_master_init_i3c_dev_boardinfo(newdev)
> > >   - Add fixes, stable tags
> > > 
> > >  /**
> > >   * i3c_master_add_i3c_dev_locked() - add an I3C slave to the bus
> > >   * @master: master used to send frames on the bus
> > > @@ -1818,8 +1834,9 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
> > >  				  u8 addr)
> > >  {
> > >  	struct i3c_device_info info = { .dyn_addr = addr };
> > > -	struct i3c_dev_desc *newdev, *olddev;
> > >  	u8 old_dyn_addr = addr, expected_dyn_addr;
> > > +	enum i3c_addr_slot_status addrstatus;
> > > +	struct i3c_dev_desc *newdev, *olddev;
> > >  	struct i3c_ibi_setup ibireq = { };
> > >  	bool enable_ibi = false;
> > >  	int ret;
> > > @@ -1878,6 +1895,8 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
> > >  	if (ret)
> > >  		goto err_detach_dev;
> > >  
> > > +	i3c_master_init_i3c_dev_boardinfo(newdev);
> > > +
> > >  	/*
> > >  	 * Depending on our previous state, the expected dynamic address might
> > >  	 * differ:
> > > @@ -1895,7 +1914,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
> > >  	else
> > >  		expected_dyn_addr = newdev->info.dyn_addr;
> > >  
> > > -	if (newdev->info.dyn_addr != expected_dyn_addr) {
> > > +	addrstatus = i3c_bus_get_addr_slot_status(&master->bus,
> > > +						  expected_dyn_addr);
> > > +
> > > +	if (newdev->info.dyn_addr != expected_dyn_addr &&
> > > +	    addrstatus == I3C_ADDR_SLOT_FREE) {  
> > 
> > First, this change shouldn't be part of this patch, since the commit
> > message only mentions the boardinfo init stuff,  
> 
> This is not an issue, I can create a patch just for boardinfo init fix.
> 
> > not the extra 'is slot
> > free check'.  
> 
> Even ignoring patch 1, it is necessary to check if the slot is free 
> because if SETDASA fails the boardinfo->init_dyn_addr can be assigned to 
> another device. That's why we need to check if expected_dyn_addr is free.

Correct. I thought we were already pre-reserving the init_addr (as
described here [1]), but it looks like the code is buggy. That's
probably something we should fix  (we should reserve ->init_i3c_addr
here [2], not ->dyn_addr).

> 
> > Plus, I want the fix to be backported so we should avoid
> > any unneeded deps.
> > 
> > But even with those 2 things addressed, I'm still convinced the
> > 'free desc when device is not reachable' change you do in patch 1 is
> > not that great,   
> 
> If I'm doing wrong I really appreciate you tell me the reason.

I just think it's easier to keep track of things (like reserved
addresses) if the descriptor stays around even if the device is not yet
accessible.

> 
> > and the fact that you can't pre-reserve the address to
> > make sure no one uses it until the device had a chance to show up tends
> > to prove me right.  
> 
> This is a different corner case and I though we agreed that the framework 
> doesn't provide guarantees to assign boardinfo->init_dyn_addr [1].

Well, it doesn't, but we should try hard to not use addresses that
have been requested by a device.

> 
> Yet, I don't disagree with the idea of pre-reserve the 
> boardinfo->init_dyn_addr.
> I can do this but we need to align how it should be done.

Keep the device around even if SETDASA fails and make sure the
->init_dyn_addr is reserved. It's how it was supposed to work, there's
just a bug in the logic.

> 
> > 
> > Can we please do what I suggest and solve the "not enough dev slots"
> > problem later on (if we really have to).  
> 
> I have this use case where the HC has only 4 slot for 4 devices. 
> Sometimes the one or more devices can be sleeping and when they trigger 
> HJ there is no space in HC.

Let's address that separately please. I want to solve one problem at a
time.

[1]https://elixir.bootlin.com/linux/latest/source/drivers/i3c/master.c#L1330
[2]https://elixir.bootlin.com/linux/latest/source/drivers/i3c/master.c#L1307
