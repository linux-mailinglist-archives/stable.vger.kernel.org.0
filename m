Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189C0BCFB8
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390975AbfIXQow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409906AbfIXQov (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642E121783;
        Tue, 24 Sep 2019 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343490;
        bh=jiqWDvjr3y286qK70hFFRbHs5tN2gQs8Lk1YAW0uoAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsEOQKdFzwVJSICizMtaVDuLgOCoUUeF0DScwHCmvD7Q4U39ygbc30pa5qJGWzbxN
         uv9bzOf3ZRARzZD+V8QusOCo4fyF9jJMM7GwsPntnbpcVVuPVCQQE4ZeOeRIxF3uQj
         gTEnR7vorAsLGiHkcGyYMeq8gK4YbZUMRfJHGRnw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.3 68/87] powerpc/eeh: Clean up EEH PEs after recovery finishes
Date:   Tue, 24 Sep 2019 12:41:24 -0400
Message-Id: <20190924164144.25591-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 799abe283e5103d48e079149579b4f167c95ea0e ]

When the last device in an eeh_pe is removed the eeh_pe structure itself
(and any empty parents) are freed since they are no longer needed. This
results in a crash when a hotplug driver is involved since the following
may occur:

1. Device is suprise removed.
2. Driver performs an MMIO, which fails and queues and eeh_event.
3. Hotplug driver receives a hotplug interrupt and removes any
   pci_devs that were under the slot.
4. pci_dev is torn down and the eeh_pe is freed.
5. The EEH event handler thread processes the eeh_event and crashes
   since the eeh_pe pointer in the eeh_event structure is no
   longer valid.

Crashing is generally considered poor form. Instead of doing that use
the fact PEs are marked as EEH_PE_INVALID to keep them around until the
end of the recovery cycle, at which point we can safely prune any empty
PEs.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190903101605.2890-2-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 36 ++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/eeh_event.c  |  8 +++++++
 arch/powerpc/kernel/eeh_pe.c     | 23 +++++++++++++++++++-
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 1fbe541856f5e..fe0c32fb9f96f 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -744,6 +744,33 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
  */
 #define MAX_WAIT_FOR_RECOVERY 300
 
+
+/* Walks the PE tree after processing an event to remove any stale PEs.
+ *
+ * NB: This needs to be recursive to ensure the leaf PEs get removed
+ * before their parents do. Although this is possible to do recursively
+ * we don't since this is easier to read and we need to garantee
+ * the leaf nodes will be handled first.
+ */
+static void eeh_pe_cleanup(struct eeh_pe *pe)
+{
+	struct eeh_pe *child_pe, *tmp;
+
+	list_for_each_entry_safe(child_pe, tmp, &pe->child_list, child)
+		eeh_pe_cleanup(child_pe);
+
+	if (pe->state & EEH_PE_KEEP)
+		return;
+
+	if (!(pe->state & EEH_PE_INVALID))
+		return;
+
+	if (list_empty(&pe->edevs) && list_empty(&pe->child_list)) {
+		list_del(&pe->child);
+		kfree(pe);
+	}
+}
+
 /**
  * eeh_handle_normal_event - Handle EEH events on a specific PE
  * @pe: EEH PE - which should not be used after we return, as it may
@@ -782,8 +809,6 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		return;
 	}
 
-	eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
-
 	eeh_pe_update_time_stamp(pe);
 	pe->freeze_count++;
 	if (pe->freeze_count > eeh_max_freezes) {
@@ -973,6 +998,12 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 			return;
 		}
 	}
+
+	/*
+	 * Clean up any PEs without devices. While marked as EEH_PE_RECOVERYING
+	 * we don't want to modify the PE tree structure so we do it here.
+	 */
+	eeh_pe_cleanup(pe);
 	eeh_pe_state_clear(pe, EEH_PE_RECOVERING, true);
 }
 
@@ -1045,6 +1076,7 @@ void eeh_handle_special_event(void)
 		 */
 		if (rc == EEH_NEXT_ERR_FROZEN_PE ||
 		    rc == EEH_NEXT_ERR_FENCED_PHB) {
+			eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
 			eeh_handle_normal_event(pe);
 		} else {
 			pci_lock_rescan_remove();
diff --git a/arch/powerpc/kernel/eeh_event.c b/arch/powerpc/kernel/eeh_event.c
index 64cfbe41174b2..e36653e5f76b3 100644
--- a/arch/powerpc/kernel/eeh_event.c
+++ b/arch/powerpc/kernel/eeh_event.c
@@ -121,6 +121,14 @@ int __eeh_send_failure_event(struct eeh_pe *pe)
 	}
 	event->pe = pe;
 
+	/*
+	 * Mark the PE as recovering before inserting it in the queue.
+	 * This prevents the PE from being free()ed by a hotplug driver
+	 * while the PE is sitting in the event queue.
+	 */
+	if (pe)
+		eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
+
 	/* We may or may not be called in an interrupt context */
 	spin_lock_irqsave(&eeh_eventlist_lock, flags);
 	list_add(&event->list, &eeh_eventlist);
diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 854cef7b18f4d..f0813d50e0b1c 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -491,6 +491,7 @@ int eeh_add_to_parent_pe(struct eeh_dev *edev)
 int eeh_rmv_from_parent_pe(struct eeh_dev *edev)
 {
 	struct eeh_pe *pe, *parent, *child;
+	bool keep, recover;
 	int cnt;
 	struct pci_dn *pdn = eeh_dev_to_pdn(edev);
 
@@ -516,10 +517,21 @@ int eeh_rmv_from_parent_pe(struct eeh_dev *edev)
 	 */
 	while (1) {
 		parent = pe->parent;
+
+		/* PHB PEs should never be removed */
 		if (pe->type & EEH_PE_PHB)
 			break;
 
-		if (!(pe->state & EEH_PE_KEEP)) {
+		/*
+		 * XXX: KEEP is set while resetting a PE. I don't think it's
+		 * ever set without RECOVERING also being set. I could
+		 * be wrong though so catch that with a WARN.
+		 */
+		keep = !!(pe->state & EEH_PE_KEEP);
+		recover = !!(pe->state & EEH_PE_RECOVERING);
+		WARN_ON(keep && !recover);
+
+		if (!keep && !recover) {
 			if (list_empty(&pe->edevs) &&
 			    list_empty(&pe->child_list)) {
 				list_del(&pe->child);
@@ -528,6 +540,15 @@ int eeh_rmv_from_parent_pe(struct eeh_dev *edev)
 				break;
 			}
 		} else {
+			/*
+			 * Mark the PE as invalid. At the end of the recovery
+			 * process any invalid PEs will be garbage collected.
+			 *
+			 * We need to delay the free()ing of them since we can
+			 * remove edev's while traversing the PE tree which
+			 * might trigger the removal of a PE and we can't
+			 * deal with that (yet).
+			 */
 			if (list_empty(&pe->edevs)) {
 				cnt = 0;
 				list_for_each_entry(child, &pe->child_list, child) {
-- 
2.20.1

