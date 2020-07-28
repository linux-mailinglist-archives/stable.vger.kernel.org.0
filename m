Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FEE230F46
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 18:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgG1QbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 12:31:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:43593 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbgG1QbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 12:31:22 -0400
IronPort-SDR: A1KLpSDw7n/8uQjaYkQUHZDNIyvUOWw9pdA3O6jR6My5SM880iYmXzh+VDlBQL3/lOXgtPY+m2
 u4YsR/cp9ssA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="149115433"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="149115433"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 09:31:20 -0700
IronPort-SDR: FVqAeH1LLFVhb4Lu6gBvZkqAQJvIrGgzbbkNoTPQdFgSd4E1/g0DVdAUfKN0IQuFjFhKOgaADS
 3xF7Ml2zbh7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="272366761"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jul 2020 09:31:20 -0700
Date:   Tue, 28 Jul 2020 09:31:20 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.com>, Lu Baolu <baolu.lu@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v3 1/1] PCI/ATS: Check PRI supported on the PF device
 when SRIOV is enabled
Message-ID: <20200728163120.GA31231@otc-nc-03>
References: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
 <20200727212436.03103207BB@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727212436.03103207BB@mail.kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha

On Mon, Jul 27, 2020 at 09:24:35PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: b16d0cb9e2fc ("iommu/vt-d: Always enable PASID/PRI PCI capabilities before ATS").
> 
> The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

Looks like the dependency is making this more involved with the backport. I

We could pursue a simpler fix for these older versions where there is a
conflict, but I'm not sure if that's recommended. 

In addition from our perspective 5.7 and above if there are other products
that require PASID/PRI on prior versions for SRIOV devices  we can drop the
backports. I see the same issue with other IOMMU's, for e.g. AMD as
well, I'm not sure if there are real regressions. 

> 
> v5.7.10: Build OK!
> v5.4.53: Failed to apply! Possible dependencies:
>     2b0ae7cc3bfc ("PCI/ATS: Handle sharing of PF PASID Capability with all VFs")
>     751035b8dc06 ("PCI/ATS: Cache PASID Capability offset")
>     8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
>     9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
>     c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
>     e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
> 
> v4.19.134: Failed to apply! Possible dependencies:
>     2b0ae7cc3bfc ("PCI/ATS: Handle sharing of PF PASID Capability with all VFs")
>     4f802170a861 ("PCI/DPC: Save and restore config state")
>     6e1ffbb7c2ab ("PCI: Move ATS declarations outside of CONFIG_PCI")
>     751035b8dc06 ("PCI/ATS: Cache PASID Capability offset")
>     8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
>     8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
>     9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
>     9c2120090586 ("PCI: Provide pci_match_id() with CONFIG_PCI=n")
>     b92b512a435d ("PCI: Make pci_ats_init() private")
>     c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
>     e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
>     e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
>     fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")
> 
> v4.14.189: Failed to apply! Possible dependencies:
>     1b79c5284439 ("PCI: cadence: Add host driver for Cadence PCIe controller")
>     1e4511604dfa ("PCI/AER: Expose internal API for obtaining AER information")
>     3133e6dd07ed ("PCI: Tidy Makefiles")
>     37dddf14f1ae ("PCI: cadence: Add EndPoint Controller driver for Cadence PCIe controller")
>     4696b828ca37 ("PCI/AER: Hoist aerdrv.c, aer_inject.c up to drivers/pci/pcie/")
>     4f802170a861 ("PCI/DPC: Save and restore config state")
>     8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
>     8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
>     9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
>     9de0eec29c07 ("PCI: Regroup all PCI related entries into drivers/pci/Makefile")
>     b92b512a435d ("PCI: Make pci_ats_init() private")
>     c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
>     d3252ace0bc6 ("PCI: Restore resized BAR state on resume")
>     e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
>     e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
>     fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")
> 
> v4.9.231: Failed to apply! Possible dependencies:
>     4ebeb1ec56d4 ("PCI: Restore PRI and PASID state after Function-Level Reset")
>     8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
>     8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
>     9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
>     a4f4fa681add ("PCI: Cache PRI and PASID bits in pci_dev")
>     c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
>     e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
>     e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
>     fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")
> 
> v4.4.231: Failed to apply! Possible dependencies:
>     2a2aca316aed ("PCI: Include <asm/dma.h> for isa_dma_bridge_buggy")
>     4d3f13845957 ("PCI: Add pci_unmap_iospace() to unmap I/O resources")
>     4ebeb1ec56d4 ("PCI: Restore PRI and PASID state after Function-Level Reset")
>     8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
>     9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
>     a4f4fa681add ("PCI: Cache PRI and PASID bits in pci_dev")
>     c5076cfe7689 ("PCI, of: Move PCI I/O space management to PCI core code")
>     e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha
