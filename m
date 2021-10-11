Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B225429191
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbhJKOTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243284AbhJKORZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:17:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB29F610F8;
        Mon, 11 Oct 2021 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961420;
        bh=CYi226aFCmG3dK7IyYGdL3Cab4XEkOb9x+YX6Rga9/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y48JT8pKxOhg9qC6K46v/5e+pZHnf+YqdscSHFBQiK+OWzDtOtAcWscDGdb6UpxHa
         YJA8p3lyADvIniXmzhq42AQXani2eWnpEy2OLHD8tX4BdNVlJLOoa5WXp6/0Hv95Eo
         sEw+/iJeX4k3rMQ4/hjG17Y2jZ9omnaPrM3W/hs4=
Date:   Mon, 11 Oct 2021 16:05:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 51/52] x86/hpet: Use another crystalball to evaluate
 HPET usability
Message-ID: <YWREvi4n/PweejB1@kroah.com>
References: <20211011134503.715740503@linuxfoundation.org>
 <20211011134505.483011431@linuxfoundation.org>
 <20211011065931.78965dff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011065931.78965dff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 06:59:31AM -0700, Jakub Kicinski wrote:
> On Mon, 11 Oct 2021 15:46:20 +0200 Greg Kroah-Hartman wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > commit 6e3cd95234dc1eda488f4f487c281bac8fef4d9b upstream.
> > 
> > On recent Intel systems the HPET stops working when the system reaches PC10
> > idle state.
> > 
> > The approach of adding PCI ids to the early quirks to disable HPET on
> > these systems is a whack a mole game which makes no sense.
> > 
> > Check for PC10 instead and force disable HPET if supported. The check is
> > overbroad as it does not take ACPI, intel_idle enablement and command
> > line parameters into account. That's fine as long as there is at least
> > PMTIMER available to calibrate the TSC frequency. The decision can be
> > overruled by adding "hpet=force" on the kernel command line.
> > 
> > Remove the related early PCI quirks for affected Ice Cake and Coffin Lake
> > systems as they are not longer required. That should also cover all
> > other systems, i.e. Tiger Rag and newer generations, which are most
> > likely affected by this as well.
> > 
> > Fixes: Yet another hardware trainwreck
> > Reported-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Tested-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
> > Cc: stable@vger.kernel.org
> > Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> FWIW I've never seen any problems prior to Paul's rework of bad clock
> detection in 5.13. Backports to 5.4 and 5.10 are not necessary.

Given that the hardware is still just as broken in those older kernels,
why not?

thanks,

greg k-h
