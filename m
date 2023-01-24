Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA89467971F
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjAXL7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAXL7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:59:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF993C2B6;
        Tue, 24 Jan 2023 03:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674561577; x=1706097577;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=pu6QJ5RV9LyVJNpkIVe152Ce044Cxxkxyc2BLBxj7s0=;
  b=RD/3yl+ElryZ3vyhDqNKNxVyyme0fmvAvPeamzQMNS5YRXXGOWQkxvn3
   Y8ZQFITjGgY5vBGYZftxNIQgJZTNjpFLPfVdu+YFSGk0ZMz6gCjqtbgn9
   2bzpVO2DeBMRFL1mXTfZjZ1vP3hdVlvahMCBKCz8U7Xz0JozSx+5oJTDr
   3Lkb50f3O90oGpKb9608KrnVIv3cYpuXoje6/vkj6Z0lnU3EbKrD+hjVs
   ayA8iW4wu+1MdoPV6cXsA1MntebB3TpjxJAzJ4aPDrjOQYesc6IUr8VgG
   ovLeZdf/eT+QpaoCTwTAmeCmY2+3Sb2TkDfJaCqcXJrVo3geRdqKQrhbQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="412509689"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="412509689"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:59:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="804571134"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="804571134"
Received: from ubik.fi.intel.com (HELO localhost) ([10.237.72.184])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2023 03:59:34 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Marc Zyngier <maz@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        darwi@linutronix.de, elena.reshetova@intel.com,
        kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
In-Reply-To: <86fsc2n8fp.wl-maz@kernel.org>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal> <86fsc2n8fp.wl-maz@kernel.org>
Date:   Tue, 24 Jan 2023 13:59:33 +0200
Message-ID: <87sfg0p2hm.fsf@ubik.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> On Sun, 22 Jan 2023 09:00:04 +0000,
> Leon Romanovsky <leon@kernel.org> wrote:
>> 
>> On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
>> > A malicious device can change its MSIX table size between the table
>> > ioremap() and subsequent accesses, resulting in a kernel page fault in
>> > pci_write_msg_msix().
>> > 
>> > To avoid this, cache the table size observed at the moment of table
>> > ioremap() and use the cached value. This, however, does not help drivers
>> > that peek at the PCIE_MSIX_FLAGS register directly.
>> > 
>> > Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > Cc: stable@vger.kernel.org
>> > ---
>> >  drivers/pci/msi/api.c | 7 ++++++-
>> >  drivers/pci/msi/msi.c | 2 +-
>> >  include/linux/pci.h   | 1 +
>> >  3 files changed, 8 insertions(+), 2 deletions(-)
>> 
>> I'm not security expert here, but not sure that this protects from anything.
>> 1. Kernel relies on working and not-malicious HW. There are gazillion ways
>> to cause crashes other than changing MSI-X.
>> 2. Device can report large table size, kernel will cache it and
>> malicious device will reduce it back. It is not handled and will cause
>> to kernel crash too.
>> 
>
> Indeed, this was my exact reaction reading this patch. This only makes
> sure the same (potentially wrong) value is used at all times. So while
> this results in a consistent use, this doesn't give much guarantee.

It guarantees that the MSIX table is big enough to fit all the vectors,
so it should prevent the page faults from out-of-bounds accesses.

> The only way to deal with this is to actually handle the resulting
> fault, similar to what the kernel does when accessing userspace. Not
> sure how possible this is with something like PCIe.

Do you mean replacing MMIO accesses with exception handling accessors?
That seems like a monumental effort. And then we'd have to figure out
how to handle errors in the __pci_write_msi_msg() path.

Preventing page faults from happening in the first place seems like a
more reasonable solution, or what do you think?

Thanks,
--
Alex
