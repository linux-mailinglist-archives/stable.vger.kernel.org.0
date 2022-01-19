Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3710494239
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbiASU6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:58:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37088 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiASU6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 15:58:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6BA2B81BF9;
        Wed, 19 Jan 2022 20:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B1BC340E1;
        Wed, 19 Jan 2022 20:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642625891;
        bh=NqxKG/cRDn784z+dCz2ahDGoEugjHKm62mozm5aXIDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LhYS3WdXJ7AgC3euyvb9woXaRqza3xo/xtEn5n8hIACnSdySRip8aKg+NRwbk89cE
         OcmiTExYYBSJHG3v3nt5DDM+MR0miQG7P3RKimhqxFJLLihYnkttmFeLZu/FIhKLp7
         sIAQHknIEpvW2z5Fk3CO6MV3jA8XptI0Z2JILm3sSkWJakZWS2HJcDstuJtYESOBkj
         avFFCpLRmDuJETbQ+k3DXfM95geS6JWxvDsMiroRs6GJZHAAogZN/W7nMEHEnh5fIt
         SbouggppabdOp3X2ym2B5H5X3DrrXIoZIiPKxdWmIW+DV6wP/Qk5mLYsoRsC4dqVE0
         pYZ3koWfIRT2g==
Date:   Wed, 19 Jan 2022 14:58:10 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        linux-pci@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        x86@kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH v5 1/5] x86/quirks: Fix stolen detection with
 integrated + discrete GPU
Message-ID: <20220119205810.GA963074@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119203004.mnds3vrxtsqkvso3@ldmartin-desk2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 12:30:04PM -0800, Lucas De Marchi wrote:
> On Tue, Jan 18, 2022 at 02:01:45PM -0600, Bjorn Helgaas wrote:

> > Haha :)  I was hoping not to touch it myself because I think this
> > whole stolen memory thing is kind of nasty.  It's not clear to me why
> > we need it at all, or why we have to keep all this device-specific
> > logic in the kernel, or why it has to be an early quirk as opposed to
> > a regular PCI quirk.  We had a thread [1] about it a while ago but I
> > don't think anything got resolved.
> 
> I was reading that thread again and thinking what we could do to try to
> resolve this. I will reply on that thread.

Great!  I hope there's some way around this.

> > But to try to make forward progress, I applied patch 1/5 (actually,
> > the updated one from [2]) to my pci/misc branch with the updated
> > commit log and code comments below.
> 
> thanks. I found the wording in the title odd as when I read "first" it
> gives me the impression it's saying there could be more, which is not
> possible.

I said "first integrated GPU" because Linux doesn't control what
devices are in the system; it just has to deal with whatever it finds.
All one can tell from the code is that if we find one or more devices
that appear in intel_early_ids[], we reserve stolen memory for the
first such device.

System-specific knowledge might tell you that there should only be one
integrated GPU, but there's no constraint like that in Linux.

Bjorn
