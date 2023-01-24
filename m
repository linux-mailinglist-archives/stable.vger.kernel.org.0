Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4065C679714
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjAXLwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjAXLwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:52:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41753B674;
        Tue, 24 Jan 2023 03:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674561162; x=1706097162;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=9ADtunrMiGDym6aA0HaN4WKyLjJTVN31V1SPJHANX9Q=;
  b=H1ZvT5Sd6chkesGW60BUEUGD4KFRp9cBbMENhjVr3TMlHncYCe3zGKzu
   pSIqcRqvyGRyBG9QyUF3IbAMmsg8pQ97sPgBeaqJTabLDXMUJFUQisRON
   gVoBdOAFF/98b36mpTUhqLU7yrbTl0IyMgsz4ACg07U2mB+kHVZEIVKIS
   1lx5OyIrWTx4RIO2tLf2s8dp7z4BflL6LwE4gXI6Um3RKau1gSkHjfXQE
   jMqhEVkdvsi03fsC+8ny4frtns9hQ3dqonGw+rflxWslnqCKy5kX/OcM1
   4Uarr3PGIxsLwQDf9HSCUQJvDb6OXVbDIOJCndT6tk6OWur+S4Y+H4Q2J
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="323972049"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="323972049"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="694306863"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="694306863"
Received: from ubik.fi.intel.com (HELO localhost) ([10.237.72.184])
  by orsmga001.jf.intel.com with ESMTP; 24 Jan 2023 03:52:38 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
In-Reply-To: <Y8z7FPcuDXDBi+1U@unreal>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal>
Date:   Tue, 24 Jan 2023 13:52:37 +0200
Message-ID: <87v8kwp2t6.fsf@ubik.fi.intel.com>
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

Leon Romanovsky <leon@kernel.org> writes:

> On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
>> A malicious device can change its MSIX table size between the table
>> ioremap() and subsequent accesses, resulting in a kernel page fault in
>> pci_write_msg_msix().
>> 
>> To avoid this, cache the table size observed at the moment of table
>> ioremap() and use the cached value. This, however, does not help drivers
>> that peek at the PCIE_MSIX_FLAGS register directly.
>> 
>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/pci/msi/api.c | 7 ++++++-
>>  drivers/pci/msi/msi.c | 2 +-
>>  include/linux/pci.h   | 1 +
>>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> I'm not security expert here, but not sure that this protects from anything.
> 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> to cause crashes other than changing MSI-X.

This particular bug was preventing our fuzzing from going deeper into
the code and reaching some more of the aforementioned gazillion bugs.

> 2. Device can report large table size, kernel will cache it and
> malicious device will reduce it back. It is not handled and will cause
> to kernel crash too.

How would that happen? If the device decides to have fewer vectors,
they'll all still fit in the ioremapped MSIX table. The worst thing that
can happen is 0xffffffff reads from the mmio space, which a device can
do anyway. But that shouldn't trigger a page fault or otherwise
crash. Or am I missing something?

Thanks,
--
Alex
