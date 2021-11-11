Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDAF44DB82
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhKKSV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:21:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:46403 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhKKSV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 13:21:59 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="256696589"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="256696589"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 10:19:06 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="492642362"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 10:19:05 -0800
Subject: [PATCH] cxl/pmem: Fix module reload vs workqueue state
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        ben.widawsky@intel.com, ira.weiny@intel.com,
        alison.schofield@intel.com, Jonathan.Cameron@huawei.com
Date:   Thu, 11 Nov 2021 10:19:05 -0800
Message-ID: <163665474585.3505991.8397182770066720755.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A test of the form:

    while true; do modprobe -r cxl_pmem; modprobe cxl_pmem; done

May lead to a crash signature of the form:

    BUG: unable to handle page fault for address: ffffffffc0660030
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    [..]
    Workqueue: cxl_pmem 0xffffffffc0660030
    RIP: 0010:0xffffffffc0660030
    Code: Unable to access opcode bytes at RIP 0xffffffffc0660006.
    [..]
    Call Trace:
     ? process_one_work+0x4ec/0x9c0
     ? pwq_dec_nr_in_flight+0x100/0x100
     ? rwlock_bug.part.0+0x60/0x60
     ? worker_thread+0x2eb/0x700

In that report the 0xffffffffc0660030 address corresponds to the former
function address of cxl_nvb_update_state() from a previous load of the
module, not the current address. Fix that by arranging for ->state_work
in the 'struct cxl_nvdimm_bridge' object to be reinitialized on cxl_pmem
module reload.

Details:

Recall that CXL subsystem wants to link a CXL memory expander device to
an NVDIMM sub-hierarchy when both a persistent memory range has been
registered by the CXL platform driver (cxl_acpi) *and* when that CXL
memory expander has published persistent memory capacity (Get Partition
Info). To this end the cxl_nvdimm_bridge driver arranges to rescan the
CXL bus when either of those conditions change. The helper
bus_rescan_devices() can not be called underneath the device_lock() for
any device on that bus, so the cxl_nvdimm_bridge driver uses a workqueue
for the rescan.

Typically a driver allocates driver data to hold a 'struct work_struct'
for a driven device, but for a workqueue that may run after ->remove()
returns, driver data will have been freed. The 'struct
cxl_nvdimm_bridge' object holds the state and work_struct directly.
Unfortunately it was only arranging for that infrastructure to be
initialized once per device creation rather than the necessary once per
workqueue (cxl_pmem_wq) creation.

Introduce is_cxl_nvdimm_bridge() and cxl_nvdimm_bridge_reset() in
support of invalidating stale references to a recently destroyed
cxl_pmem_wq.

Cc: <stable@vger.kernel.org>
Fixes: 8fdcb1704f61 ("cxl/pmem: Add initial infrastructure for pmem support")
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    8 +++++++-
 drivers/cxl/cxl.h       |    8 ++++++++
 drivers/cxl/pmem.c      |   29 +++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 76a4fa39834c..cc402cb7a905 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -51,10 +51,16 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm_bridge, CXL);
 
-__mock int match_nvdimm_bridge(struct device *dev, const void *data)
+bool is_cxl_nvdimm_bridge(struct device *dev)
 {
 	return dev->type == &cxl_nvdimm_bridge_type;
 }
+EXPORT_SYMBOL_NS_GPL(is_cxl_nvdimm_bridge, CXL);
+
+__mock int match_nvdimm_bridge(struct device *dev, const void *data)
+{
+	return is_cxl_nvdimm_bridge(dev);
+}
 
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5e2e93451928..ca979ee11017 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -221,6 +221,13 @@ struct cxl_decoder {
 };
 
 
+/**
+ * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
+ * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
+ * @CXL_NVB_DEAD: Set at brige unregistration to preclude async probing
+ * @CXL_NVB_ONLINE: Target state after successful ->probe()
+ * @CXL_NVB_OFFLINE: Target state after ->remove() or failed ->probe()
+ */
 enum cxl_nvdimm_brige_state {
 	CXL_NVB_NEW,
 	CXL_NVB_DEAD,
@@ -333,6 +340,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 						     struct cxl_port *port);
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
+bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
 
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 17e82ae90456..b65a272a2d6d 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -315,6 +315,31 @@ static struct cxl_driver cxl_nvdimm_bridge_driver = {
 	.id = CXL_DEVICE_NVDIMM_BRIDGE,
 };
 
+/*
+ * Return all bridges to the CXL_NVB_NEW state to invalidate any
+ * ->state_work referring to the now destroyed cxl_pmem_wq.
+ */
+static int cxl_nvdimm_bridge_reset(struct device *dev, void *data)
+{
+	struct cxl_nvdimm_bridge *cxl_nvb;
+
+	if (!is_cxl_nvdimm_bridge(dev))
+		return 0;
+
+	cxl_nvb = to_cxl_nvdimm_bridge(dev);
+	device_lock(dev);
+	cxl_nvb->state = CXL_NVB_NEW;
+	device_unlock(dev);
+
+	return 0;
+}
+
+static void destroy_cxl_pmem_wq(void)
+{
+	destroy_workqueue(cxl_pmem_wq);
+	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_nvdimm_bridge_reset);
+}
+
 static __init int cxl_pmem_init(void)
 {
 	int rc;
@@ -340,7 +365,7 @@ static __init int cxl_pmem_init(void)
 err_nvdimm:
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
 err_bridge:
-	destroy_workqueue(cxl_pmem_wq);
+	destroy_cxl_pmem_wq();
 	return rc;
 }
 
@@ -348,7 +373,7 @@ static __exit void cxl_pmem_exit(void)
 {
 	cxl_driver_unregister(&cxl_nvdimm_driver);
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
-	destroy_workqueue(cxl_pmem_wq);
+	destroy_cxl_pmem_wq();
 }
 
 MODULE_LICENSE("GPL v2");

