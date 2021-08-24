Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E83F6232
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhHXQGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:06:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:6056 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhHXQGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:06:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204540983"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204540983"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:27 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="643232071"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:24 -0700
Subject: [PATCH v3 00/28] cxl_test: Enable CXL Topology and UAPI regression
 tests
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        kernel test robot <lkp@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com,
        ira.weiny@intel.com, ben.widawsky@intel.com,
        vishal.l.verma@intel.com, alison.schofield@intel.com
Date:   Tue, 24 Aug 2021 09:05:24 -0700
Message-ID: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v1* [1]:
- Rearrange setters to be next to getters (Jonathan)
- Fix endian bug in nsl_set_slot() (kbuild robot)
- Return NULL instead of !name (Jonathan)
- Use {import,export}_uuid() where UUIDs are used in external interface
  structures (Andy)
- Fix uuid_to_nvdimm_class() to be static (kbuild robot)
- Fixup changelog to note uuid copying fixups (Jonathan)
- Fix the broken nlabel/nrange confusion for CXL labels (Jonathan)
  - Add a dedicated nlabel validation helper
  - Add nrange helpers for CXL
- Introduce __mock to fix unnecessary global symbols (kbuild robot)
- Include core.h to fix some missing prototype warnings (kbuild robot)
- Fix excessive stack usage from devm_cxl_add_decoder() (kbuild robot)
- Add spec reference for namespace label fields (Jonathan)
- Fix uninitialized variable use in cxl_nvdimm_probe() (kbuild robot)
- Move cxl region definition to its own patch for readability (Jonathan)
- Move exclusive command validation to cxl_validate_cmd_from_user() (Ben)
- Fix exclusive command locking (Ben)
- Fold in Alison's acpi_pci_find_root() fix and rebase (Alison)
- Rebase on 0day-induced fixups of the baseline

[1]: https://lore.kernel.org/r/162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com

Note that there were some one-off direct replies marked v2, but now this
set supersedes those.

---

Changed or new(*) patches since v1 are:

[ PATCH v3 03/28] libnvdimm/labels: Introduce label setter helpers
[ PATCH v3 09/28] libnvdimm/labels: Add address-abstraction uuid definitions
[ PATCH v3 10/28] libnvdimm/labels: Add uuid helpers
[*PATCH v3 11/28] libnvdimm/label: Add a helper for nlabel validation
[*PATCH v3 12/28] libnvdimm/labels: Introduce the concept of multi-range namespace labels
[*PATCH v3 13/28] libnvdimm/label: Define CXL region labels
[ PATCH v3 14/28] libnvdimm/labels: Introduce CXL labels
[ PATCH v3 17/28] cxl/mbox: Move mailbox and other non-PCI specific infrastructure to the core
[ PATCH v3 20/28] cxl/mbox: Add exclusive kernel command support
[ PATCH v3 21/28] cxl/pmem: Translate NVDIMM label commands to CXL label commands
[ PATCH v3 22/28] cxl/pmem: Add support for multiple nvdimm-bridge objects
[*PATCH v3 23/28] cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports
[ PATCH v3 24/28] tools/testing/cxl: Introduce a mocked-up CXL port hierarchy
[ PATCH v3 27/28] tools/testing/cxl: Introduce a mock memory device + driver
[*PATCH v3 28/28] cxl/core: Split decoder setup into alloc + add

---

As mentioned in patch 24 in this series the response of upstream QEMU
community to CXL device emulation has been underwhelming to date. Even
if that picked up it still results in a situation where new driver
features and new test capabilities for those features are split across
multiple repositories.

The "nfit_test" approach of mocking up platform resources via an
external test module continues to yield positive results catching
regressions early and often. So this attempts to repeat that success
with a "cxl_test" module to inject custom crafted topologies and command
responses into the CXL subsystem's sysfs and ioctl UAPIs.

The first target for cxl_test to verify is the integration of CXL with
LIBNVDIMM and the new support for the CXL namespace label + region-label
format. The first 14 patches introduce support for the new label format.

The next 9 patches rework the CXL PCI driver and to move more common
infrastructure into the core for the unit test environment to reuse. The
largest change here is disconnecting the mailbox command processing
infrastructure from the PCI specific transport. The unit test
environment replaces the PCI transport with a custom backend with mocked
responses to command requests.

Patch 24 introduces just enough mocked functionality for the cxl_acpi
driver to load against cxl_test resources. Patch 21 fixes the first bug
discovered by this framework, namely that HDM decoder target list maps
were not being filled out.

Finally patches 26 and 27 introduce a cxl_test representation of memory
expander devices. In this initial implementation these memory expander
targets implement just enough command support to pass the basic driver
init sequence and enable label command passthrough to LIBNVDIMM.

The topology of cxl_test includes:
- (4) platform fixed memory windows. One each of a x1-volatile,
  x4-volatile, x1-persistent, and x4-persistent.
- (4) Host bridges each with (2) root ports
- (8) CXL memory expanders, one for each root port
- Each memory expander device supports the GET_SUPPORTED_LOGS, GET_LOG,
  IDENTIFY, GET_LSA, and SET_LSA commands.

Going forward the expectation is that where possible new UAPI visible
subsystem functionality comes with cxl_test emulation of the same.

The build process for cxl_test is:

    make M=tools/testing/cxl
    make M=tools/testing/cxl modules_install

The implementation methodology of the test module is the same as
nfit_test where the bulk of the emulation comes from replacing symbols
that cxl_acpi and the cxl_core import with mocked implementation of
those symbols. See the "--wrap=" lines in tools/testing/cxl/Kbuild. Some
symbols need to be replaced, but are local to the modules like
match_add_root_ports(). In those cases the local symbol is marked __weak
(via __mock) with a strong implementation coming from
tools/testing/cxl/. The goal being to be minimally invasive to
production code paths.

---

Alison Schofield (1):
      cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports

Dan Williams (27):
      libnvdimm/labels: Introduce getters for namespace label fields
      libnvdimm/labels: Add isetcookie validation helper
      libnvdimm/labels: Introduce label setter helpers
      libnvdimm/labels: Add a checksum calculation helper
      libnvdimm/labels: Add blk isetcookie set / validation helpers
      libnvdimm/labels: Add blk special cases for nlabel and position helpers
      libnvdimm/labels: Add type-guid helpers
      libnvdimm/labels: Add claim class helpers
      libnvdimm/labels: Add address-abstraction uuid definitions
      libnvdimm/labels: Add uuid helpers
      libnvdimm/label: Add a helper for nlabel validation
      libnvdimm/labels: Introduce the concept of multi-range namespace labels
      libnvdimm/label: Define CXL region labels
      libnvdimm/labels: Introduce CXL labels
      cxl/pci: Make 'struct cxl_mem' device type generic
      cxl/mbox: Introduce the mbox_send operation
      cxl/mbox: Move mailbox and other non-PCI specific infrastructure to the core
      cxl/pci: Use module_pci_driver
      cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
      cxl/mbox: Add exclusive kernel command support
      cxl/pmem: Translate NVDIMM label commands to CXL label commands
      cxl/pmem: Add support for multiple nvdimm-bridge objects
      tools/testing/cxl: Introduce a mocked-up CXL port hierarchy
      cxl/bus: Populate the target list at decoder create
      cxl/mbox: Move command definitions to common location
      tools/testing/cxl: Introduce a mock memory device + driver
      cxl/core: Split decoder setup into alloc + add


 Documentation/driver-api/cxl/memory-devices.rst |    3 
 drivers/cxl/acpi.c                              |  143 ++-
 drivers/cxl/core/Makefile                       |    1 
 drivers/cxl/core/bus.c                          |   87 +-
 drivers/cxl/core/core.h                         |    8 
 drivers/cxl/core/mbox.c                         |  798 +++++++++++++++++
 drivers/cxl/core/memdev.c                       |  115 ++-
 drivers/cxl/core/pmem.c                         |   32 +
 drivers/cxl/cxl.h                               |   45 +
 drivers/cxl/cxlmem.h                            |  188 ++++
 drivers/cxl/pci.c                               | 1051 +----------------------
 drivers/cxl/pmem.c                              |  160 +++-
 drivers/nvdimm/btt.c                            |   11 
 drivers/nvdimm/btt_devs.c                       |   14 
 drivers/nvdimm/core.c                           |   40 -
 drivers/nvdimm/label.c                          |  361 +++++---
 drivers/nvdimm/label.h                          |  121 ++-
 drivers/nvdimm/namespace_devs.c                 |  204 ++--
 drivers/nvdimm/nd-core.h                        |    5 
 drivers/nvdimm/nd.h                             |  289 ++++++
 drivers/nvdimm/pfn_devs.c                       |    2 
 include/linux/nd.h                              |    4 
 tools/testing/cxl/Kbuild                        |   38 +
 tools/testing/cxl/config_check.c                |   13 
 tools/testing/cxl/mock_acpi.c                   |  109 ++
 tools/testing/cxl/mock_pmem.c                   |   24 +
 tools/testing/cxl/test/Kbuild                   |   10 
 tools/testing/cxl/test/cxl.c                    |  587 +++++++++++++
 tools/testing/cxl/test/mem.c                    |  255 ++++++
 tools/testing/cxl/test/mock.c                   |  171 ++++
 tools/testing/cxl/test/mock.h                   |   27 +
 31 files changed, 3422 insertions(+), 1494 deletions(-)
 create mode 100644 drivers/cxl/core/mbox.c
 create mode 100644 tools/testing/cxl/Kbuild
 create mode 100644 tools/testing/cxl/config_check.c
 create mode 100644 tools/testing/cxl/mock_acpi.c
 create mode 100644 tools/testing/cxl/mock_pmem.c
 create mode 100644 tools/testing/cxl/test/Kbuild
 create mode 100644 tools/testing/cxl/test/cxl.c
 create mode 100644 tools/testing/cxl/test/mem.c
 create mode 100644 tools/testing/cxl/test/mock.c
 create mode 100644 tools/testing/cxl/test/mock.h

base-commit: ceeb0da0a0322bcba4c50ab3cf97fe9a7aa8a2e4
