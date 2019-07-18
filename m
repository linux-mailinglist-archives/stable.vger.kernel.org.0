Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC046C418
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 03:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfGRBWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 21:22:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:30788 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfGRBWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 21:22:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:05 -0700
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="170424120"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:05 -0700
Subject: [PATCH v2 0/7] libnvdimm: Fix async operations and locking
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Jane Chu <jane.chu@oracle.com>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Jane Chu <jane.chu@oracle.com>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Wed, 17 Jul 2019 18:07:48 -0700
Message-ID: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v1 [1]:

- Fix an ioctl command corruption regression that manifested as an
  intermittent failure of the monitor.sh unit test. This is handled in
  the patch4 prep patch that makes it safe for nd_ioctl() to be
  re-entrant. (Vishal)

- Update the changelog for the driver-core 'lockdep_lock' hack to
  indicate Greg's non-NAK.

[1]: https://lore.kernel.org/lkml/156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com/

---

The libnvdimm subsystem uses async operations to parallelize device
probing operations and to allow sysfs to trigger device_unregister() on
deleted namepsaces. A multithreaded stress test of the libnvdimm sysfs
interface uncovered a case where device_unregister() is triggered
multiple times, and the subsequent investigation uncovered a broken
locking scenario.

The lack of lockdep coverage for device_lock() stymied the debug. That
is, until patch6 "driver-core, libnvdimm: Let device subsystems add
local lockdep coverage" solved that with a shadow lock, with lockdep
coverage, to mirror device_lock() operations. Given the time saved with
shadow-lock debug-hack, patch6 attempts to generalize device_lock()
debug facility that might be able to be carried upstream. Patch6 is
staged at the end of this fix series in case it is contentious and needs
to be dropped.

Patch1 "drivers/base: Introduce kill_device()" could be achieved with
local libnvdimm infrastructure. However, the existing 'dead' flag in
'struct device_private' aims to solve similar async register/unregister
races so the fix in patch2 "libnvdimm/bus: Prevent duplicate
device_unregister() calls" can be implemented with existing driver-core
infrastructure.

Patch3 is a rare lockdep warning that is intermittent based on
namespaces racing ahead of the completion of probe of their parent
region. It is not related to the other fixes, it just happened to
trigger as a result of the async stress test.

Patch5 and patch6 address an ABBA deadlock tripped by the stress test.

These patches pass the failing stress test and the existing libnvdimm
unit tests with CONFIG_PROVE_LOCKING=y and the new "dev->lockdep_mutex"
shadow lock with no lockdep warnings.

---

Dan Williams (7):
      drivers/base: Introduce kill_device()
      libnvdimm/bus: Prevent duplicate device_unregister() calls
      libnvdimm/region: Register badblocks before namespaces
      libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
      libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
      libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock
      driver-core, libnvdimm: Let device subsystems add local lockdep coverage


 drivers/acpi/nfit/core.c        |   28 +++--
 drivers/acpi/nfit/nfit.h        |   24 ++++
 drivers/base/core.c             |   30 ++++--
 drivers/nvdimm/btt_devs.c       |   16 +--
 drivers/nvdimm/bus.c            |  210 ++++++++++++++++++++++++++-------------
 drivers/nvdimm/core.c           |   10 +-
 drivers/nvdimm/dimm_devs.c      |    4 -
 drivers/nvdimm/namespace_devs.c |   36 +++----
 drivers/nvdimm/nd-core.h        |   71 +++++++++++++
 drivers/nvdimm/pfn_devs.c       |   24 ++--
 drivers/nvdimm/pmem.c           |    4 -
 drivers/nvdimm/region.c         |   24 ++--
 drivers/nvdimm/region_devs.c    |   12 +-
 include/linux/device.h          |    6 +
 14 files changed, 343 insertions(+), 156 deletions(-)
