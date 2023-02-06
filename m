Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C03F68B37E
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 02:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjBFBCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 20:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBFBCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 20:02:31 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A27126DD;
        Sun,  5 Feb 2023 17:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675645350; x=1707181350;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TYqfXRtKdMz9O0SA4QkLbocvvVmb0qoRQOoP818nNBQ=;
  b=cAjdCn0Xq2akEHh/WynGGCP8s2GJvGT3u1gwp7EmnHz68PnB9oy1vZoY
   Hxq7UbnFXqMQrLwUUtHEcMq8iypWAoblmrG6QY3SukgmVpDf/UFDaeIKJ
   NtFE67HjFTqDdesrdeWN++9qSAYffAxHdedsFM2Lpmq+TK3Qfa5E9qmqX
   nUZlwaSDTol2tqpFevDDNtgyV6ezrP66eK41nBXZnkXqwol0Ijbqc4NDl
   sbHP5zx7ZNzOGqJZP5rkMPAMfHB3e87+JrQ8j39r7U319L+xEPEv5YL72
   VH2XjjgNM9Vy9HltKKPjNRq2bkzIfXhqjvKMNtMubdV5a0guUpiZtbVBe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="331243759"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="331243759"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 17:02:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="643855712"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="643855712"
Received: from mkrysak-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.255.187])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 17:02:29 -0800
Subject: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Date:   Sun, 05 Feb 2023 17:02:29 -0800
Message-ID: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Summary:
--------

CXL RAM support allows for the dynamic provisioning of new CXL RAM
regions, and more routinely, assembling a region from an existing
configuration established by platform-firmware. The latter is motivated
by CXL memory RAS (Reliability, Availability and Serviceability)
support, that requires associating device events with System Physical
Address ranges and vice versa.

The 'Soft Reserved' policy rework arranges for performance
differentiated memory like CXL attached DRAM, or high-bandwidth memory,
to be designated for 'System RAM' by default, rather than the device-dax
dedicated access mode. That current device-dax default is confusing and
surprising for the Pareto of users that do not expect memory to be
quarantined for dedicated access by default. Most users expect all
'System RAM'-capable memory to show up in FREE(1).


Details:
--------

Recall that the Linux 'Soft Reserved' designation for memory is a
reaction to platform-firmware, like EFI EDK2, delineating memory with
the EFI Specific Purpose Memory attribute (EFI_MEMORY_SP). An
alternative way to think of that attribute is that it specifies the
*not* general-purpose memory pool. It is memory that may be too precious
for general usage or not performant enough for some hot data structures.
However, in the absence of explicit policy it should just be 'System
RAM' by default.

Rather than require every distribution to ship a udev policy to assign
dax devices to dax_kmem (the device-memory hotplug driver) just make
that the kernel default. This is similar to the rationale in:

commit 8604d9e534a3 ("memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE")

With this change the relatively niche use case of accessing this memory
via mapping a device-dax instance can be achieved by building with
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=n, or specifying
memhp_default_state=offline at boot, and then use:

    daxctl reconfigure-device $device -m devdax --force

...to shift the corresponding address range to device-dax access.

The process of assembling a device-dax instance for a given CXL region
device configuration is similar to the process of assembling a
Device-Mapper or MDRAID storage-device array. Specifically, asynchronous
probing by the PCI and driver core enumerates all CXL endpoints and
their decoders. Then, once enough decoders have arrived to a describe a
given region, that region is passed to the device-dax subsystem where it
is subject to the above 'dax_kmem' policy. This assignment and policy
choice is only possible if memory is set aside by the 'Soft Reserved'
designation. Otherwise, CXL that is mapped as 'System RAM' becomes
immutable by CXL driver mechanisms, but is still enumerated for RAS
purposes.

This series is also available via:

https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region

...and has gone through some preview testing in various forms.

---

Dan Williams (18):
      cxl/Documentation: Update references to attributes added in v6.0
      cxl/region: Add a mode attribute for regions
      cxl/region: Support empty uuids for non-pmem regions
      cxl/region: Validate region mode vs decoder mode
      cxl/region: Add volatile region creation support
      cxl/region: Refactor attach_target() for autodiscovery
      cxl/region: Move region-position validation to a helper
      kernel/range: Uplevel the cxl subsystem's range_contains() helper
      cxl/region: Enable CONFIG_CXL_REGION to be toggled
      cxl/region: Fix passthrough-decoder detection
      cxl/region: Add region autodiscovery
      tools/testing/cxl: Define a fixed volatile configuration to parse
      dax/hmem: Move HMAT and Soft reservation probe initcall level
      dax/hmem: Drop unnecessary dax_hmem_remove()
      dax/hmem: Convey the dax range via memregion_info()
      dax/hmem: Move hmem device registration to dax_hmem.ko
      dax: Assign RAM regions to memory-hotplug by default
      cxl/dax: Create dax devices for CXL RAM regions


 Documentation/ABI/testing/sysfs-bus-cxl |   64 +-
 MAINTAINERS                             |    1 
 drivers/acpi/numa/hmat.c                |    4 
 drivers/cxl/Kconfig                     |   12 
 drivers/cxl/acpi.c                      |    3 
 drivers/cxl/core/core.h                 |    7 
 drivers/cxl/core/hdm.c                  |    8 
 drivers/cxl/core/pci.c                  |    5 
 drivers/cxl/core/port.c                 |   34 +
 drivers/cxl/core/region.c               |  848 ++++++++++++++++++++++++++++---
 drivers/cxl/cxl.h                       |   46 ++
 drivers/cxl/cxlmem.h                    |    3 
 drivers/cxl/port.c                      |   26 +
 drivers/dax/Kconfig                     |   17 +
 drivers/dax/Makefile                    |    2 
 drivers/dax/bus.c                       |   53 +-
 drivers/dax/bus.h                       |   12 
 drivers/dax/cxl.c                       |   53 ++
 drivers/dax/device.c                    |    3 
 drivers/dax/hmem/Makefile               |    3 
 drivers/dax/hmem/device.c               |  102 ++--
 drivers/dax/hmem/hmem.c                 |  148 +++++
 drivers/dax/kmem.c                      |    1 
 include/linux/dax.h                     |    7 
 include/linux/memregion.h               |    2 
 include/linux/range.h                   |    5 
 lib/stackinit_kunit.c                   |    6 
 tools/testing/cxl/test/cxl.c            |  146 +++++
 28 files changed, 1355 insertions(+), 266 deletions(-)
 create mode 100644 drivers/dax/cxl.c

base-commit: 172738bbccdb4ef76bdd72fc72a315c741c39161
