Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAB71AC300
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897331AbgDPNgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897328AbgDPNg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0041A208E4;
        Thu, 16 Apr 2020 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044185;
        bh=3ScBCzDGVqDqZeQ7247CTqy5NBsjjC2WXKUdOEqo8bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkP4ISPjtOc5QS1734EDSdymCN0AK5USmXH1zzd8xZOA/zgE30NcNWZt/HtSBKVpv
         AM+ymR8HTOz7z3lPhpHtWgxkxBe6e1CAICCTZ+yrgYeZZ4/3DjPouuGRCCwlXDm/yg
         EAZCUIPxBqSnWxd4dooUS+UiP+uJz8bHkS9+nXu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hoyer <David.Hoyer@netapp.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.5 113/257] PCI: pciehp: Fix indefinite wait on sysfs requests
Date:   Thu, 16 Apr 2020 15:22:44 +0200
Message-Id: <20200416131340.380324440@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 3e487d2e4aa466decd226353755c9d423e8fbacc upstream.

David Hoyer reports that powering pciehp slots up or down via sysfs may
hang:  The call to wait_event() in pciehp_sysfs_enable_slot() and
_disable_slot() does not return because ctrl->ist_running remains true.

This flag, which was introduced by commit 157c1062fcd8 ("PCI: pciehp: Avoid
returning prematurely from sysfs requests"), signifies that the IRQ thread
pciehp_ist() is running.  It is set to true at the top of pciehp_ist() and
reset to false at the end.  However there are two additional return
statements in pciehp_ist() before which the commit neglected to reset the
flag to false and wake up waiters for the flag.

That omission opens up the following race when powering up the slot:

* pciehp_ist() runs because a PCI_EXP_SLTSTA_PDC event was requested
  by pciehp_sysfs_enable_slot()

* pciehp_ist() turns on slot power via the following call stack:
  pciehp_handle_presence_or_link_change() -> pciehp_enable_slot() ->
  __pciehp_enable_slot() -> board_added() -> pciehp_power_on_slot()

* after slot power is turned on, the link comes up, resulting in a
  PCI_EXP_SLTSTA_DLLSC event

* the IRQ handler pciehp_isr() stores the event in ctrl->pending_events
  and returns IRQ_WAKE_THREAD

* the IRQ thread is already woken (it's bringing up the slot), but the
  genirq code remembers to re-run the IRQ thread after it has finished
  (such that it can deal with the new event) by setting IRQTF_RUNTHREAD
  via __handle_irq_event_percpu() -> __irq_wake_thread()

* the IRQ thread removes PCI_EXP_SLTSTA_DLLSC from ctrl->pending_events
  via board_added() -> pciehp_check_link_status() in order to deal with
  presence and link flaps per commit 6c35a1ac3da6 ("PCI: pciehp:
  Tolerate initially unstable link")

* after pciehp_ist() has successfully brought up the slot, it resets
  ctrl->ist_running to false and wakes up the sysfs requester

* the genirq code re-runs pciehp_ist(), which sets ctrl->ist_running
  to true but then returns with IRQ_NONE because ctrl->pending_events
  is empty

* pciehp_sysfs_enable_slot() is finally woken but notices that
  ctrl->ist_running is true, hence continues waiting

The only way to get the hung task going again is to trigger a hotplug
event which brings down the slot, e.g. by yanking out the card.

The same race exists when powering down the slot because remove_board()
likewise clears link or presence changes in ctrl->pending_events per commit
3943af9d01e9 ("PCI: pciehp: Ignore Link State Changes after powering off a
slot") and thereby may cause a re-run of pciehp_ist() which returns with
IRQ_NONE without resetting ctrl->ist_running to false.

Fix by adding a goto label before the teardown steps at the end of
pciehp_ist() and jumping to that label from the two return statements which
currently neglect to reset the ctrl->ist_running flag.

Fixes: 157c1062fcd8 ("PCI: pciehp: Avoid returning prematurely from sysfs requests")
Link: https://lore.kernel.org/r/cca1effa488065cb055120aa01b65719094bdcb5.1584530321.git.lukas@wunner.de
Reported-by: David Hoyer <David.Hoyer@netapp.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Cc: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/pciehp_hpc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -625,17 +625,15 @@ static irqreturn_t pciehp_ist(int irq, v
 	if (atomic_fetch_and(~RERUN_ISR, &ctrl->pending_events) & RERUN_ISR) {
 		ret = pciehp_isr(irq, dev_id);
 		enable_irq(irq);
-		if (ret != IRQ_WAKE_THREAD) {
-			pci_config_pm_runtime_put(pdev);
-			return ret;
-		}
+		if (ret != IRQ_WAKE_THREAD)
+			goto out;
 	}
 
 	synchronize_hardirq(irq);
 	events = atomic_xchg(&ctrl->pending_events, 0);
 	if (!events) {
-		pci_config_pm_runtime_put(pdev);
-		return IRQ_NONE;
+		ret = IRQ_NONE;
+		goto out;
 	}
 
 	/* Check Attention Button Pressed */
@@ -664,10 +662,12 @@ static irqreturn_t pciehp_ist(int irq, v
 		pciehp_handle_presence_or_link_change(ctrl, events);
 	up_read(&ctrl->reset_lock);
 
+	ret = IRQ_HANDLED;
+out:
 	pci_config_pm_runtime_put(pdev);
 	ctrl->ist_running = false;
 	wake_up(&ctrl->requester);
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static int pciehp_poll(void *data)


