Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11E8679D8B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjAXPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjAXPdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEEA15C86;
        Tue, 24 Jan 2023 07:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B7F8B81269;
        Tue, 24 Jan 2023 15:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34198C4339B;
        Tue, 24 Jan 2023 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674574375;
        bh=DwJJrM9m9X5aOEJGDC5pjUO5kR+z8HBfLBtrc4OZg3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T79R7rRSYHrr9wQ+z64lcDBsZpl7FvIU+2jHr4eJ6qqXeJIfkKWxhMRmEI/2Ptm+1
         sr74k2zR68RWoZ65WG4swS17bwLygM3ouL9HtnnESrEnkPAr3aN46tsywg3mHwfeXz
         hh9Qmp3ALIRPq5YNd68B7/9QgTCW7NXzQng/9LUY=
Date:   Tue, 24 Jan 2023 16:32:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <Y8/6InIxcpwM5u2M@kroah.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal>
 <87v8kwp2t6.fsf@ubik.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8kwp2t6.fsf@ubik.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 01:52:37PM +0200, Alexander Shishkin wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> > On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
> >> A malicious device can change its MSIX table size between the table
> >> ioremap() and subsequent accesses, resulting in a kernel page fault in
> >> pci_write_msg_msix().
> >> 
> >> To avoid this, cache the table size observed at the moment of table
> >> ioremap() and use the cached value. This, however, does not help drivers
> >> that peek at the PCIE_MSIX_FLAGS register directly.
> >> 
> >> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> >> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  drivers/pci/msi/api.c | 7 ++++++-
> >>  drivers/pci/msi/msi.c | 2 +-
> >>  include/linux/pci.h   | 1 +
> >>  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> > I'm not security expert here, but not sure that this protects from anything.
> > 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> > to cause crashes other than changing MSI-X.
> 
> This particular bug was preventing our fuzzing from going deeper into
> the code and reaching some more of the aforementioned gazillion bugs.

As per our documentation, if you are "fixing" things based on a tool you
have, you HAVE TO document that in the changelog.  Otherwise we just get
to reject the patch flat out (hint, this has caused more than one group
of developers to just be flat out banned for ignoring...)

And what kind of tool is now fuzzing PCI config accesses with
"malicious" devices?  Again, this is NOT something that Linux currently
even attempts to want to protect itself against.  If you are wanting to
change that model, wonderful, let's discuss that and work on defining
the scope of your new security threat model and go from there.  Don't
throw random patches at us and expect us to think they are even valid.

Again, Linux trusts PCI devices.  If you don't want to trust PCI
devices, we already have a framework in place to prevent that which is
independant of this area of the PCI code.  Use that, or let's discuss
why that is insufficient.

Note, this is NOT the first time I have told developers from Intel about
this.  Why you all keep ignoring this is beyond me, I think you keep
thinking that if you don't send patches through me, you can just ignore
my statements about this.  Odd...

greg k-h
