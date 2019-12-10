Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B24119575
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfLJVUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbfLJVL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A1B246C4;
        Tue, 10 Dec 2019 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012317;
        bh=bNEiotI55wLQVxXG3J1E5ysL89WU/ce2vrCxzOs7Fnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1qKFKpxr0ecmuFgZG6hWFoTo2UvyHNBQ/d9y58hM0wKxukvUd0xRF81QN28UsIbY
         xO1Rlo0pZqG2l4QA1jIHJ4KrqOh/1GtidQtE5pHAVOi++ZyQeybr5FDc66oauVmnTL
         7qIO3mv2X9ZfyBPKvVcnLuMf1JDa1AWcjBVu6hUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Richter <rrichter@marvell.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 251/350] EDAC/ghes: Fix locking and memory barrier issues
Date:   Tue, 10 Dec 2019 16:05:56 -0500
Message-Id: <20191210210735.9077-212-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

[ Upstream commit 23f61b9fc5cc10d87f66e50518707eec2a0fbda1 ]

The ghes registration and refcount is broken in several ways:

 * ghes_edac_register() returns with success for a 2nd instance
   even if a first instance's registration is still running. This is
   not correct as the first instance may fail later. A subsequent
   registration may not finish before the first. Parallel registrations
   must be avoided.

 * The refcount was increased even if a registration failed. This
   leads to stale counters preventing the device from being released.

 * The ghes refcount may not be decremented properly on unregistration.
   Always decrement the refcount once ghes_edac_unregister() is called to
   keep the refcount sane.

 * The ghes_pvt pointer is handed to the irq handler before registration
   finished.

 * The mci structure could be freed while the irq handler is running.

Fix this by adding a mutex to ghes_edac_register(). This mutex
serializes instances to register and unregister. The refcount is only
increased if the registration succeeded. This makes sure the refcount is
in a consistent state after registering or unregistering a device.

Note: A spinlock cannot be used here as the code section may sleep.

The ghes_pvt is protected by ghes_lock now. This ensures the pointer is
not updated before registration was finished or while the irq handler is
running. It is unset before unregistering the device including necessary
(implicit) memory barriers making the changes visible to other CPUs.
Thus, the device can not be used anymore by an interrupt.

Also, rename ghes_init to ghes_refcount for better readability and
switch to refcount API.

A refcount is needed because there can be multiple GHES structures being
defined (see ACPI 6.3 specification, 18.3.2.7 Generic Hardware Error
Source, "Some platforms may describe multiple Generic Hardware Error
Source structures with different notification types, ...").

Another approach to use the mci's device refcount (get_device()) and
have a release function does not work here. A release function will be
called only for device_release() with the last put_device() call. The
device must be deleted *before* that with device_del(). This is only
possible by maintaining an own refcount.

 [ bp: touchups. ]

Fixes: 0fe5f281f749 ("EDAC, ghes: Model a single, logical memory controller")
Fixes: 1e72e673b9d1 ("EDAC/ghes: Fix Use after free in ghes_edac remove path")
Co-developed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Co-developed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20191105200732.3053-1-rrichter@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ghes_edac.c | 90 +++++++++++++++++++++++++++++-----------
 1 file changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 0bb62857ffb24..f6f6a688c009d 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -26,9 +26,18 @@ struct ghes_edac_pvt {
 	char msg[80];
 };
 
-static atomic_t ghes_init = ATOMIC_INIT(0);
+static refcount_t ghes_refcount = REFCOUNT_INIT(0);
+
+/*
+ * Access to ghes_pvt must be protected by ghes_lock. The spinlock
+ * also provides the necessary (implicit) memory barrier for the SMP
+ * case to make the pointer visible on another CPU.
+ */
 static struct ghes_edac_pvt *ghes_pvt;
 
+/* GHES registration mutex */
+static DEFINE_MUTEX(ghes_reg_mutex);
+
 /*
  * Sync with other, potentially concurrent callers of
  * ghes_edac_report_mem_error(). We don't know what the
@@ -79,9 +88,8 @@ static void ghes_edac_count_dimms(const struct dmi_header *dh, void *arg)
 		(*num_dimm)++;
 }
 
-static int get_dimm_smbios_index(u16 handle)
+static int get_dimm_smbios_index(struct mem_ctl_info *mci, u16 handle)
 {
-	struct mem_ctl_info *mci = ghes_pvt->mci;
 	int i;
 
 	for (i = 0; i < mci->tot_dimms; i++) {
@@ -198,14 +206,11 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 	enum hw_event_mc_err_type type;
 	struct edac_raw_error_desc *e;
 	struct mem_ctl_info *mci;
-	struct ghes_edac_pvt *pvt = ghes_pvt;
+	struct ghes_edac_pvt *pvt;
 	unsigned long flags;
 	char *p;
 	u8 grain_bits;
 
-	if (!pvt)
-		return;
-
 	/*
 	 * We can do the locking below because GHES defers error processing
 	 * from NMI to IRQ context. Whenever that changes, we'd at least
@@ -216,6 +221,10 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 
 	spin_lock_irqsave(&ghes_lock, flags);
 
+	pvt = ghes_pvt;
+	if (!pvt)
+		goto unlock;
+
 	mci = pvt->mci;
 	e = &mci->error_desc;
 
@@ -348,7 +357,7 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 			p += sprintf(p, "DIMM DMI handle: 0x%.4x ",
 				     mem_err->mem_dev_handle);
 
-		index = get_dimm_smbios_index(mem_err->mem_dev_handle);
+		index = get_dimm_smbios_index(mci, mem_err->mem_dev_handle);
 		if (index >= 0) {
 			e->top_layer = index;
 			e->enable_per_layer_report = true;
@@ -443,6 +452,8 @@ void ghes_edac_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 		       grain_bits, e->syndrome, pvt->detail_location);
 
 	edac_raw_mc_handle_error(type, mci, e);
+
+unlock:
 	spin_unlock_irqrestore(&ghes_lock, flags);
 }
 
@@ -457,10 +468,12 @@ static struct acpi_platform_list plat_list[] = {
 int ghes_edac_register(struct ghes *ghes, struct device *dev)
 {
 	bool fake = false;
-	int rc, num_dimm = 0;
+	int rc = 0, num_dimm = 0;
 	struct mem_ctl_info *mci;
+	struct ghes_edac_pvt *pvt;
 	struct edac_mc_layer layers[1];
 	struct ghes_edac_dimm_fill dimm_fill;
+	unsigned long flags;
 	int idx = -1;
 
 	if (IS_ENABLED(CONFIG_X86)) {
@@ -472,11 +485,14 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		idx = 0;
 	}
 
+	/* finish another registration/unregistration instance first */
+	mutex_lock(&ghes_reg_mutex);
+
 	/*
 	 * We have only one logical memory controller to which all DIMMs belong.
 	 */
-	if (atomic_inc_return(&ghes_init) > 1)
-		return 0;
+	if (refcount_inc_not_zero(&ghes_refcount))
+		goto unlock;
 
 	/* Get the number of DIMMs */
 	dmi_walk(ghes_edac_count_dimms, &num_dimm);
@@ -494,12 +510,13 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(struct ghes_edac_pvt));
 	if (!mci) {
 		pr_info("Can't allocate memory for EDAC data\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto unlock;
 	}
 
-	ghes_pvt	= mci->pvt_info;
-	ghes_pvt->ghes	= ghes;
-	ghes_pvt->mci	= mci;
+	pvt		= mci->pvt_info;
+	pvt->ghes	= ghes;
+	pvt->mci	= mci;
 
 	mci->pdev = dev;
 	mci->mtype_cap = MEM_FLAG_EMPTY;
@@ -541,23 +558,48 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	if (rc < 0) {
 		pr_info("Can't register at EDAC core\n");
 		edac_mc_free(mci);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto unlock;
 	}
-	return 0;
+
+	spin_lock_irqsave(&ghes_lock, flags);
+	ghes_pvt = pvt;
+	spin_unlock_irqrestore(&ghes_lock, flags);
+
+	/* only increment on success */
+	refcount_inc(&ghes_refcount);
+
+unlock:
+	mutex_unlock(&ghes_reg_mutex);
+
+	return rc;
 }
 
 void ghes_edac_unregister(struct ghes *ghes)
 {
 	struct mem_ctl_info *mci;
+	unsigned long flags;
 
-	if (!ghes_pvt)
-		return;
+	mutex_lock(&ghes_reg_mutex);
 
-	if (atomic_dec_return(&ghes_init))
-		return;
+	if (!refcount_dec_and_test(&ghes_refcount))
+		goto unlock;
 
-	mci = ghes_pvt->mci;
+	/*
+	 * Wait for the irq handler being finished.
+	 */
+	spin_lock_irqsave(&ghes_lock, flags);
+	mci = ghes_pvt ? ghes_pvt->mci : NULL;
 	ghes_pvt = NULL;
-	edac_mc_del_mc(mci->pdev);
-	edac_mc_free(mci);
+	spin_unlock_irqrestore(&ghes_lock, flags);
+
+	if (!mci)
+		goto unlock;
+
+	mci = edac_mc_del_mc(mci->pdev);
+	if (mci)
+		edac_mc_free(mci);
+
+unlock:
+	mutex_unlock(&ghes_reg_mutex);
 }
-- 
2.20.1

