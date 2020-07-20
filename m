Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FEF22723B
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 00:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgGTWXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 18:23:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:19243 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgGTWXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 18:23:42 -0400
IronPort-SDR: UWT7XJUsJF3aT70fmOxzIrzLxdfzCr/wq3B22FpGnxt4XYKpfnfSjNSSdbT7GoW03xWtIJX8DA
 Zdmcy4bi8mhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="129589070"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="129589070"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 15:23:41 -0700
IronPort-SDR: AgaDJwrke57QLb9b+KUIwJFC5H28Pzg1JMmMTEUr8UW+brmvJX22eo3exMVQKWagsBkzXTf6YO
 jAIMAiYYdDFQ==
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="487871967"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 15:23:41 -0700
Subject: [PATCH v3 00/11] ACPI/NVDIMM: Runtime Firmware Activation
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, stable@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 20 Jul 2020 15:07:24 -0700
Message-ID: <159528284411.993790.11733759435137949717.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v2 [1]:
- Drop the "mem-quiet" pm-debug interface in favor of an explicit
  hibernate_quiet_exec() helper that executes firmware activation, or
  any other subsystem provided routine, in a system-quiet context.
  (Rafael)

- Rework the sysfs interface to add an explicit trigger to run
  activation under hibernate_quiet_exec(). Rename
  ndbusX/firmware_activate to ndbusX/firmware/activate, and add a
  ndbusX/firmware/capability. Some ndctl reworks are needed to catch up
  with this change.

- The new ndbusX/firmware/capability attribute indicates the default
  activation method / execution context between "live" and "suspend".

[1]: http://lore.kernel.org/r/159408711335.2385045.2567600405906448375.stgit@dwillia2-desk3.amr.corp.intel.com

---

Quoting the documentation:

    Some persistent memory devices run a firmware locally on the device /
    "DIMM" to perform tasks like media management, capacity provisioning,
    and health monitoring. The process of updating that firmware typically
    involves a reboot because it has implications for in-flight memory
    transactions. However, reboots are disruptive and at least the Intel
    persistent memory platform implementation, described by the Intel ACPI
    DSM specification [1], has added support for activating firmware at
    runtime.

    [1]: https://docs.pmem.io/persistent-memory/

The approach taken is to abstract the Intel platform specific mechanism
behind a libnvdimm-generic sysfs interface. The interface could support
runtime-firmware-activation on another architecture without need to
change userspace tooling.

The ACPI NFIT implementation involves a set of device-specific-methods
(DSMs) to 'arm' individual devices for activation and bus-level
'trigger' method to execute the activation. Informational / enumeration
methods are also provided at the bus and device level.

One complicating aspect of the memory device firmware activation is that
the memory controller may need to be quiesced, no memory cycles, during
the activation. While the platform has mechanisms to support holding off
in-flight DMA during the activation, the device response to that delay
is potentially undefined. The platform may reject a runtime firmware
update if, for example a PCI-E device does not support its completion
timeout value being increased to meet the activation time. Outside of
device timeouts the quiesce period may also violate application
timeouts.

Given the above device and application timeout considerations the
implementation uses a new hibernate_quiet_exec() facility to carry-out
firmware activation. This imposes the same conditions that allow for a
stable memory image snapshot to be taken for a hibernate-to-disk
sequence. However, if desired, runtime activation without the hibernate
freeze can be forced as an override.

The ndctl utility grows the following extensions / commands to drive
this mechanism:

1/ The existing update-firmware command will 'arm' devices where the
   firmware image is staged by default.

    ndctl update-firmware all -f firmware_image.bin

2/ The existing ability to enumerate firmware-update capabilities now
   includes firmware activate capabilities at the 'bus' and 'dimm/device'
   level:

    ndctl list -BDF -b nfit_test.0
    [
      {
        "provider":"nfit_test.0",
        "dev":"ndbus2",
        "scrub_state":"idle",
        "firmware":{
          "activate_method":"suspend",
          "activate_state":"idle"
        },
        "dimms":[
          {
            "dev":"nmem1",
            "id":"cdab-0a-07e0-ffffffff",
            "handle":0,
            "phys_id":0,
            "security":"disabled",
            "firmware":{
              "current_version":0,
              "can_update":true
            }
          },
    ...

3/ The new activate-firmware command triggers firmware activation per
   the platform enumerated context, "suspend" vs "live", or can be forced
   to "live" if there is a explicit knowledge that allowing applications
   and devices to race the quiesce timeout will have no adverse effects.

    ndctl activate-firmware nfit_test.0 [--force]

These patches are passing an updated version of the ndctl
"firmware-update.sh" unit test (to be posted).

---

Dan Williams (11):
      libnvdimm: Validate command family indices
      ACPI: NFIT: Move bus_dsm_mask out of generic nvdimm_bus_descriptor
      ACPI: NFIT: Define runtime firmware activation commands
      tools/testing/nvdimm: Cleanup dimm index passing
      tools/testing/nvdimm: Add command debug messages
      tools/testing/nvdimm: Prepare nfit_ctl_test() for ND_CMD_CALL emulation
      tools/testing/nvdimm: Emulate firmware activation commands
      driver-core: Introduce DEVICE_ATTR_ADMIN_{RO,RW}
      libnvdimm: Convert to DEVICE_ATTR_ADMIN_RO()
      PM, libnvdimm: Add runtime firmware activation support
      ACPI: NFIT: Add runtime firmware activate support


 Documentation/ABI/testing/sysfs-bus-nfit           |   19 +
 Documentation/ABI/testing/sysfs-bus-nvdimm         |    2 
 .../driver-api/nvdimm/firmware-activate.rst        |   86 ++++
 drivers/acpi/nfit/core.c                           |  142 +++++--
 drivers/acpi/nfit/intel.c                          |  386 ++++++++++++++++++++
 drivers/acpi/nfit/intel.h                          |   61 +++
 drivers/acpi/nfit/nfit.h                           |   38 ++
 drivers/nvdimm/bus.c                               |   16 +
 drivers/nvdimm/core.c                              |  149 ++++++++
 drivers/nvdimm/dimm_devs.c                         |  119 ++++++
 drivers/nvdimm/namespace_devs.c                    |    2 
 drivers/nvdimm/nd-core.h                           |    1 
 drivers/nvdimm/pfn_devs.c                          |    2 
 drivers/nvdimm/region_devs.c                       |    2 
 include/linux/device.h                             |    4 
 include/linux/libnvdimm.h                          |   52 +++
 include/linux/suspend.h                            |    6 
 include/linux/sysfs.h                              |    7 
 include/uapi/linux/ndctl.h                         |    5 
 kernel/power/hibernate.c                           |   97 +++++
 tools/testing/nvdimm/test/nfit.c                   |  367 +++++++++++++++----
 21 files changed, 1449 insertions(+), 114 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-nvdimm
 create mode 100644 Documentation/driver-api/nvdimm/firmware-activate.rst

base-commit: 48778464bb7d346b47157d21ffde2af6b2d39110
