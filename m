Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38239427C14
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhJIQpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 12:45:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:64755 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhJIQpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 12:45:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10132"; a="213623195"
X-IronPort-AV: E=Sophos;i="5.85,360,1624345200"; 
   d="scan'208";a="213623195"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2021 09:43:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,360,1624345200"; 
   d="scan'208";a="590861940"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2021 09:43:56 -0700
Subject: [PATCH v3 00/10] cxl_pci refactor for reusability
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Donnellan <ajd@linux.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Date:   Sat, 09 Oct 2021 09:43:56 -0700
Message-ID: <163379783658.692348.16064992154261275220.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v2 [1]:
- Rework some of the changelogs per feedback (Bjorn, and I)
- Move the cxl_register_map refactor earlier in the series to make the
  cxl_setup_pci_regs() refactor easier to read.
- Fix a bug added in v5.14 for handling the error return case
  cxl_pci_map_regblock()
- Split the addition of @base to cxl_register_map to its own patch
- Drop the cxl_pci_dvsec() wrapper (Christoph)
- Drop the SIOV conversion patch given Baolu's feedback about it being
  dead code

[1]: https://lore.kernel.org/r/20210923172647.72738-1-ben.widawsky@intel.com

---
I am helping out with the review feedback on this set while Ben is
focusing on region provisioning. It appears this rework will be suitable
to just carry in cxl/next, no need to make a cross-tree dependency for
"PCI: Add pci_find_dvsec_capability to find designated VSEC" at this
time.

Ben's original cover:

Provide the ability to obtain CXL register blocks as discrete functionality.
This functionality will become useful for other CXL drivers that need access to
CXL register blocks. It is also in line with other additions to core which moves
register mapping functionality.

At the introduction of the CXL driver the only user of CXL MMIO was cxl_pci
(then known as cxl_mem). As the driver has evolved it is clear that cxl_pci will
not be the only entity that needs access to CXL MMIO. This series stops short of
moving the generalized functionality into cxl_core for the sake of getting eyes
on the important foundational bits sooner rather than later. The ultimate plan
is to move much of the code into cxl_core.

Via review of two previous patches [1] & [2] it has been suggested that the bits
which are being used for DVSEC enumeration move into PCI core. As CXL core is
soon going to require these, let's try to get the ball rolling now on making
that happen.

---

[1]: https://lore.kernel.org/linux-pci/20210913190131.xiiszmno46qie7v5@intel.com/
[2]: https://lore.kernel.org/linux-cxl/20210920225638.1729482-1-ben.widawsky@intel.com/
[3]: https://lore.kernel.org/linux-cxl/20210921220459.2437386-1-ben.widawsky@intel.com/

---

Ben Widawsky (8):
      cxl/pci: Convert register block identifiers to an enum
      cxl/pci: Remove dev_dbg for unknown register blocks
      cxl/pci: Remove pci request/release regions
      cxl/pci: Make more use of cxl_register_map
      cxl/pci: Split cxl_pci_setup_regs()
      PCI: Add pci_find_dvsec_capability to find designated VSEC
      cxl/pci: Use pci core's DVSEC functionality
      ocxl: Use pci core's DVSEC functionality

Dan Williams (2):
      cxl/pci: Fix NULL vs ERR_PTR confusion
      cxl/pci: Add @base to cxl_register_map


 arch/powerpc/platforms/powernv/ocxl.c |    3 -
 drivers/cxl/cxl.h                     |    1 
 drivers/cxl/pci.c                     |  157 +++++++++++++--------------------
 drivers/cxl/pci.h                     |   14 ++-
 drivers/misc/ocxl/config.c            |   13 ---
 drivers/pci/pci.c                     |   32 +++++++
 include/linux/pci.h                   |    1 
 7 files changed, 105 insertions(+), 116 deletions(-)

base-commit: ed97afb53365cd03dde266c9644334a558fe5a16
