Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0649961B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346411AbiAXU7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442905AbiAXUzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27D60B80FA3;
        Mon, 24 Jan 2022 20:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445C2C340E5;
        Mon, 24 Jan 2022 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057739;
        bh=pVK1zsOv/0tLmL9MAv8ItgdQ70hS1BVlTrlXQD9JcgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChswbOSzSRZb81wsQARLfxY/cdt/ONZPB5YBnioKYQAZO9KJOPPC5TmzWJiBUiRcZ
         Tx3S+bJPhF+SxQ3s+Kvc094zBitwFD2xplVmNDqMWT94lnDZEq6Jwt9syfBogC6C/3
         Q43afBkDR2SsyZfJIewjwmAfqCH29xbRxih1X+9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.16 0064/1039] cxl/pmem: Fix module reload vs workqueue state
Date:   Mon, 24 Jan 2022 19:30:53 +0100
Message-Id: <20220124184127.315214525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 53989fad1286e652ea3655ae3367ba698da8d2ff upstream.

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
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/163665474585.3505991.8397182770066720755.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pmem.c |    8 +++++++-
 drivers/cxl/cxl.h       |    8 ++++++++
 drivers/cxl/pmem.c      |   29 +++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 3 deletions(-)

--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -51,10 +51,16 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_
 }
 EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
 
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
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -196,6 +196,13 @@ struct cxl_decoder {
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
@@ -308,6 +315,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_n
 						     struct cxl_port *port);
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
+bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
 
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -316,6 +316,31 @@ static struct cxl_driver cxl_nvdimm_brid
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
@@ -341,7 +366,7 @@ static __init int cxl_pmem_init(void)
 err_nvdimm:
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
 err_bridge:
-	destroy_workqueue(cxl_pmem_wq);
+	destroy_cxl_pmem_wq();
 	return rc;
 }
 
@@ -349,7 +374,7 @@ static __exit void cxl_pmem_exit(void)
 {
 	cxl_driver_unregister(&cxl_nvdimm_driver);
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
-	destroy_workqueue(cxl_pmem_wq);
+	destroy_cxl_pmem_wq();
 }
 
 MODULE_LICENSE("GPL v2");


