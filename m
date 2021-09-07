Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933BE402DC3
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 19:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbhIGRgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 13:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhIGRgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 13:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9234261100;
        Tue,  7 Sep 2021 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631036114;
        bh=YfxSwWHZRzMGmkWC/hAviiwiNsQyNxzFxgDEWaJnTGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cvUITHmy/USDmBAUJ01846IpEWExmkc+1lTFRQFAUWxCMLgiMMmcTUbAbn19ehfEh
         e1DUgN7NoibOD0LBpoi74fS7A1aHz4wqcecsyKCUFlI2orTNRKZE2pd6Wifei3/pll
         PyIqy7pxegeYC9UB+atZViBP0YmMjBOqMcHow5ldU4HQLJfDAbI+ZbdQGPAZMUkhaF
         ImUeIH2OSvi+3450yswPUbmEGV/cpWcra+qiaq4alDsEd91Arf0AMuAXNyeoYEF8zg
         LQpRdHgCzqFQ0f65UtKF/GS16S2F2rGAma9PEiKSwX1pSCzqO5KCm9vj4ws4teoEPF
         LzwuoBCTum47A==
Date:   Tue, 7 Sep 2021 12:35:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Quan, Evan" <Evan.Quan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Message-ID: <20210907173513.GA746796@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144184FB2D6686C1B00ADE4F7D39@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Rafael, beginning of thread:
https://lore.kernel.org/all/20210903063311.3606226-1-evan.quan@amd.com/]

On Tue, Sep 07, 2021 at 04:09:40PM +0000, Deucher, Alexander wrote:
> > -----Original Message-----
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Friday, September 3, 2021 3:55 PM
> > To: Quan, Evan <Evan.Quan@amd.com>
> > Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> > and UCSI controllers
> > 
> > On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > > device link support for them.
> > 
> > Please comment on
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.k
> > ernel.org%2Flinus%2F6d2e369f0d4c&amp;data=04%7C01%7CAlexander.Deu
> > cher%40amd.com%7C9fa0d66e5f29424df36b08d96f14c710%7C3dd8961fe488
> > 4e608e11a82d994e183d%7C0%7C0%7C637662957313172831%7CUnknown%7
> > CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi
> > LCJXVCI6Mn0%3D%7C1000&amp;sdata=6IlPLWlcO7iptbTqfh71fe5wmHN7RN
> > 13OvScyYaWyI8%3D&amp;reserved=0 .
> > 
> > Is there something the PCI core is missing here?  Or is there
> > something that needs to be added to ACPI or the PCI firmware spec?
> > 
> > We want a generic way to discover dependencies like this.
> > 
> > A quirk should not be necessary for spec-compliant devices.
> > Quirks are an ongoing maintenance burden, and they mean that new
> > hardware won't work correctly until the OS is patched to know
> > about it.  That's not what we want.
> > 
> > I expect we'll still need *this* quirk, but first I'd like to know
> > whether there's a plan to handle this more generically in the
> > future.
> 
> The requirement here is that all of the additional endpoints are
> dependencies for powering down the GPU.  E.g., the audio controller
> and USB endpoints need to be in d3 before you put the GPU into d3,
> otherwise the non-GPU endpoints will be powered down as well behind
> their drivers' backs.  On newer AMD hardware there is logic in the
> hardware to wait for all dependent devices to go into d3 before
> powering down everything or power up everything if anything enters
> d0, but this requires additional software setup in the GPU driver as
> well and older versions of the driver didn't set this up correctly,
> instead relying on software logic via dependencies.  Earlier
> hardware didn't have that logic and needed software help.  That
> said, I think all of the relevant drivers expect the hardware state
> to be powered down when d3 is entered and they may not handle a wake
> up properly if not all devices entered d3 and hence all of the
> devices never entered a powered down state.  

I'm not sure whether this answered my question.  Will we need more
quirks for future devices?

You said "On newer AMD hardware there is logic to wait for all
dependent devices to go to d3 ...," which sounds promising, but then
it "requires additional setup in the GPU driver."

So maybe PM works as per PCIe spec, but only after the driver sets
things up?  I'm not sure what, if any, PM we do before a driver claims
the device.

The above suggests that if we put some (but not all) functions, in D3,
the new logic will keep them from entering D3 until later.  That
doesn't really *sound* spec-compliant -- if we write D3 to a
function's PCI_PM_CTRL and then read it back, the function will remain
in D0 indefinitely, until we put that last function in D3?

pci_raw_set_power_state() does this read then write, and it expects
PCI_PM_CTRL to change to the new state after the delay prescribed by
the spec, which of course has nothing to do with sibling functions.

And if all the functions are in D3, and we write D0 to one function's
PCI_PM_CTRL, *all* the functions magically go to D0?  That sounds
potentially confusing.

Bjorn
