Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5AD492CD9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiARR64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiARR6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 12:58:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4C8C061574;
        Tue, 18 Jan 2022 09:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55089614CD;
        Tue, 18 Jan 2022 17:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68705C340E0;
        Tue, 18 Jan 2022 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642528734;
        bh=OSwJ8gD/i/i24wgqvV5ruU3GRdYhopdMAIxlkXZZKkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ESlABa2sQ6fXuugWUBXk73zPTubb9nhmKCUL37WG2BsxB0lVniTrzplnxU7jW4k0Y
         vR1swa0yn/3J36LCZJINXqMJvs18eKvG884L5k8e6fMkeUUKqIEEtY2ALQy54OEdst
         c/akZeRsUG9wgxRzcwXuwj4LwHC8tqemC/MOAmzhht3f4/jgkL1dZDEZhJgxlPM8fC
         adrBtUtDW5lpLwTKb/74wgertcPW/ahmaiaWqgCJDsKW96Rqlfkh0tQxTPkFCyfdKl
         WyRDvrMJ8Jzkj2I0c76j3nm/7AfMMXO9cRF0rs5AC3IDhwZEmGLsLXCEV4a7YiX3IB
         uP4AceA1i+Kag==
Date:   Tue, 18 Jan 2022 11:58:53 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-pci@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        x86@kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH v5 1/5] x86/quirks: Fix stolen detection with
 integrated + discrete GPU
Message-ID: <20220118175853.GA881852@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yeb4WKOFNDNbx6tH@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 06:26:48PM +0100, Borislav Petkov wrote:
> On Tue, Jan 18, 2022 at 08:36:56AM -0800, Lucas De Marchi wrote:
> > I had the impression the subject/title should be imperative, with it
> > more relaxed in the body. It seems we have one more difference among
> > subsystems and I will adapt on next submissions to x86.
> 
> We have written it down properly, in case it explains it better:
> 
> "The tip tree maintainers set value on following these rules, especially
> on the request to write changelogs in imperative mood and not
> impersonating code or the execution of it. This is not just a whim of
> the maintainers. Changelogs written in abstract words are more precise
> and tend to be less confusing than those written in the form of novels."
> 
> from Documentation/process/maintainer-tip.rst

Thanks for writing this down!  I do the same for PCI.  I suspect this
is a pretty conservative style that would be acceptable tree-wide even
if not required everywhere.

> > Although in the review Bjorn suggested just splitting the commit, it was
> > also mentioned that the PCI subsystem has no such logic in its
> > equivalent pci_do_fixups(): a quirk/fixup needing that should instead
> > use a static local.
> 
> Why?

I don't really care much one way or the other.  I think the simplest
approach is to remove QFLAG_APPLY_ONCE from intel_graphics_quirks()
and do nothing else, as I suggested here:

  https://lore.kernel.org/r/20220113000805.GA295089@bhelgaas

Unfortunately that didn't occur to me until I'd already suggested more
complicated things that no longer seem worthwhile to me.

The static variable might be ugly, but it does seem to be what
intel_graphics_quirks() wants -- a "do this at most once per system
but we don't know exactly which device" situation.

> There's perfectly nice ->flags there for exactly stuff like that. static
> vars are ugly and should be avoided if possible.

Bjorn
