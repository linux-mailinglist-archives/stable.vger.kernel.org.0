Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6C67977C
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjAXMQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjAXMQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:16:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DD44BF7;
        Tue, 24 Jan 2023 04:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3535EB8119B;
        Tue, 24 Jan 2023 12:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54894C433EF;
        Tue, 24 Jan 2023 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562557;
        bh=ZoftrceXUaqA2kBi9O+ilwVUQNnrtgaDLfaHZCd8ubA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYm2dIq2ZFMYVNUCwjNz1Dn3HVAf8cuEwyGqDIJ4frSnt1GVNyg28BzWsPUxP9XVf
         VzI4oqRWnCluaQeR8WXD93u74uXe2NpkClV7dqJrRGrdb9QDqUwe/Te0tYuuO2gqZ+
         yASPGcROUDRVlqiNP6sRdyMkvyi0QUI0FChtmuJE6LyrrMWC4Djm01bCgHK0EgPjTA
         CyCQJSrxxT6EDWf0Kg8dsnj5/7Mdwmt22WGtTq/rKXqNo7Dc5LCgjLHVFrBQ2mmI0A
         lHEBRYC4Crgbs08vcrYmBHRvsCSmSLLo/f3im98cuBWG268dUF6QFp1VvTiJlApX5C
         6KR6m5hPqzydw==
Date:   Tue, 24 Jan 2023 14:10:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <Y8/Kyzh+stow83lQ@unreal>
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

Your commit message says nothing about fuzzing, but talks about
malicious device. 
Do you see "gazillion bugs" for devices which don't change their MSI-X
table size under the hood, which is main kernel assumption?

If yes, you should fix these bugs.

> 
> > 2. Device can report large table size, kernel will cache it and
> > malicious device will reduce it back. It is not handled and will cause
> > to kernel crash too.
> 
> How would that happen? If the device decides to have fewer vectors,
> they'll all still fit in the ioremapped MSIX table. The worst thing that
> can happen is 0xffffffff reads from the mmio space, which a device can
> do anyway. But that shouldn't trigger a page fault or otherwise
> crash. Or am I missing something?

Like I said, I'm no expert. You should tell me if it safe for all
callers of pci_msix_vec_count().

Thanks

> 
> Thanks,
> --
> Alex
