Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE7492EEC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245599AbiARUBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:01:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbiARUBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 15:01:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88937B81807;
        Tue, 18 Jan 2022 20:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E11EC340E0;
        Tue, 18 Jan 2022 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642536107;
        bh=fsDK43J7cKmaXH0GWguIfk086zyQHhjRpTXIglu/iBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NxCogauHIzsxVfLw++tJw2kbRoNHB4Fi60OLaRn7v/waH4TBKzmTEr/RtKK1hntDa
         fJvp4ViO9ioQuxmYsxC8llwG3yqFJYVQFHemVn0EzRxKnjoOTgSEitgXtMkhewfLZg
         Hpr2dKJ7AQ/vS1242/GsObKBf8q4KgsmRrUS02dJkNvfeFDwCBxYaJ09KAnIXBIgSX
         w17DxuRUukzZbaGojbyDZDN5CQeganJn//G8Lu7UPaWThX+okWPnhOkirtgc4K0m8z
         e3rFszi9k09wkQo6cf+gNnS7Fy+sHWR+gA59bCqU4Y+TJsxpGhXnODZ1/ycWryM430
         DXrfTaFc7FKuA==
Date:   Tue, 18 Jan 2022 14:01:45 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH v5 1/5] x86/quirks: Fix stolen detection with
 integrated + discrete GPU
Message-ID: <20220118200145.GA887728@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YecI6S9Cx5esqL+H@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 07:37:29PM +0100, Borislav Petkov wrote:
> On Tue, Jan 18, 2022 at 11:58:53AM -0600, Bjorn Helgaas wrote:
> > I don't really care much one way or the other.  I think the simplest
> > approach is to remove QFLAG_APPLY_ONCE from intel_graphics_quirks()
> > and do nothing else, as I suggested here:
> > 
> >   https://lore.kernel.org/r/20220113000805.GA295089@bhelgaas
> > 
> > Unfortunately that didn't occur to me until I'd already suggested more
> > complicated things that no longer seem worthwhile to me.
> > 
> > The static variable might be ugly, but it does seem to be what
> > intel_graphics_quirks() wants -- a "do this at most once per system
> > but we don't know exactly which device" situation.
> 
> I see.
> 
> Yeah, keeping it solely inside intel_graphics_quirks() and maybe with a
> comment ontop, why it is done, is simple. I guess if more quirks need
> this once-thing people might have to consider a more sensible scheme - I
> was just objecting to sprinkling those static vars everywhere.
> 
> But your call. :)

Haha :)  I was hoping not to touch it myself because I think this
whole stolen memory thing is kind of nasty.  It's not clear to me why
we need it at all, or why we have to keep all this device-specific
logic in the kernel, or why it has to be an early quirk as opposed to
a regular PCI quirk.  We had a thread [1] about it a while ago but I
don't think anything got resolved.

But to try to make forward progress, I applied patch 1/5 (actually,
the updated one from [2]) to my pci/misc branch with the updated
commit log and code comments below.

IMO it's probably not worth doing patches 2-5 since I don't think
they fix anything and I'm not sure it improves readability.  I'm sorry
because it was my mistake to encourage that route initially.

I think we could still get this into v5.17 since it's small and the
merge window is still open.

[1] https://lore.kernel.org/linux-pci/20201104120506.172447-1-tejaskumarx.surendrakumar.upadhyay@intel.com/
[2] https://lore.kernel.org/r/20220118190558.2ququ4vdfjuahicm@ldmartin-desk2

commit 7329e2608d04 ("x86/gpu: Reserve stolen memory for first integrated Intel GPU")
Author: Lucas De Marchi <lucas.demarchi@intel.com>
Date:   Thu Jan 13 16:28:39 2022 -0800

    x86/gpu: Reserve stolen memory for first integrated Intel GPU
    
    "Stolen memory" is memory set aside for use by an Intel integrated GPU.
    The intel_graphics_quirks() early quirk reserves this memory when it is
    called for a GPU that appears in the intel_early_ids[] table of integrated
    GPUs.
    
    Previously intel_graphics_quirks() was marked as QFLAG_APPLY_ONCE, so it
    was called only for the first Intel GPU found.  If a discrete GPU happened
    to be enumerated first, intel_graphics_quirks() was called for it but not
    for any integrated GPU found later.  Therefore, stolen memory for such an
    integrated GPU was never reserved.
    
    For example, this problem occurs in this Alderlake-P (integrated) + DG2
    (discrete) topology where the DG2 is found first, but stolen memory is
    associated with the integrated GPU:
    
      - 00:01.0 Bridge
        `- 03:00.0 DG2 discrete GPU
      - 00:02.0 Integrated GPU (with stolen memory)
    
    Remove the QFLAG_APPLY_ONCE flag and call intel_graphics_quirks() for every
    Intel GPU.  Reserve stolen memory for the first GPU that appears in
    intel_early_ids[].
    
    [bhelgaas: commit log, add code comment, squash in
    https://lore.kernel.org/r/20220118190558.2ququ4vdfjuahicm@ldmartin-desk2]
    Link: https://lore.kernel.org/r/20220114002843.2083382-1-lucas.demarchi@intel.com
    Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Cc: stable@vger.kernel.org

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 391a4e2b8604..8690fab95ae4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -515,6 +515,7 @@ static const struct intel_early_ops gen11_early_ops __initconst = {
 	.stolen_size = gen9_stolen_size,
 };
 
+/* Intel integrated GPUs for which we need to reserve "stolen memory" */
 static const struct pci_device_id intel_early_ids[] __initconst = {
 	INTEL_I830_IDS(&i830_early_ops),
 	INTEL_I845G_IDS(&i845_early_ops),
@@ -591,6 +592,13 @@ static void __init intel_graphics_quirks(int num, int slot, int func)
 	u16 device;
 	int i;
 
+	/*
+	 * Reserve "stolen memory" for an integrated GPU.  If we've already
+	 * found one, there's nothing to do for other (discrete) GPUs.
+	 */
+	if (resource_size(&intel_graphics_stolen_res))
+		return;
+
 	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 
 	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
@@ -703,7 +711,7 @@ static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
-	  QFLAG_APPLY_ONCE, intel_graphics_quirks },
+	  0, intel_graphics_quirks },
 	/*
 	 * HPET on the current version of the Baytrail platform has accuracy
 	 * problems: it will halt in deep idle state - so we disable it.
