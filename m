Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D959126B9E
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfLSSyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbfLSSyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6480C24679;
        Thu, 19 Dec 2019 18:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781682;
        bh=jjZHxV4yZ01/8oWwDoDp32mtmf5UykY8WI7u+nv/bLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQy9Y4FBac7M9wUvnt8tSCpQhXBveaASq5bU9Y/AyjEnS8RkLJ2LIF7O5b8mAjZSm
         pq8rlpSNsFGzeR2nAYWL6dvqY2ySbKF61hpOY9Mid0g8Ae7jAksmXD5P4rAfDheCPF
         HVLwmSY1b6w1q+1VfwBqjJFKAZmwR7zc0Tgt7miY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH 5.4 08/80] PCI: pciehp: Avoid returning prematurely from sysfs requests
Date:   Thu, 19 Dec 2019 19:34:00 +0100
Message-Id: <20191219183040.380378119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 157c1062fcd86ade3c674503705033051fd3d401 upstream.

A sysfs request to enable or disable a PCIe hotplug slot should not
return before it has been carried out.  That is sought to be achieved by
waiting until the controller's "pending_events" have been cleared.

However the IRQ thread pciehp_ist() clears the "pending_events" before
it acts on them.  If pciehp_sysfs_enable_slot() / _disable_slot() happen
to check the "pending_events" after they have been cleared but while
pciehp_ist() is still running, the functions may return prematurely
with an incorrect return value.

Fix by introducing an "ist_running" flag which must be false before a sysfs
request is allowed to return.

Fixes: 32a8cef274fe ("PCI: pciehp: Enable/disable exclusively from IRQ thread")
Link: https://lore.kernel.org/linux-pci/1562226638-54134-1-git-send-email-wangxiongfeng2@huawei.com
Link: https://lore.kernel.org/r/4174210466e27eb7e2243dd1d801d5f75baaffd8.1565345211.git.lukas@wunner.de
Reported-and-tested-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/pciehp.h      |    2 ++
 drivers/pci/hotplug/pciehp_ctrl.c |    6 ++++--
 drivers/pci/hotplug/pciehp_hpc.c  |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -72,6 +72,7 @@ extern int pciehp_poll_time;
  * @reset_lock: prevents access to the Data Link Layer Link Active bit in the
  *	Link Status register and to the Presence Detect State bit in the Slot
  *	Status register during a slot reset which may cause them to flap
+ * @ist_running: flag to keep user request waiting while IRQ thread is running
  * @request_result: result of last user request submitted to the IRQ thread
  * @requester: wait queue to wake up on completion of user request,
  *	used for synchronous slot enable/disable request via sysfs
@@ -101,6 +102,7 @@ struct controller {
 
 	struct hotplug_slot hotplug_slot;	/* hotplug core interface */
 	struct rw_semaphore reset_lock;
+	unsigned int ist_running;
 	int request_result;
 	wait_queue_head_t requester;
 };
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -375,7 +375,8 @@ int pciehp_sysfs_enable_slot(struct hotp
 		ctrl->request_result = -ENODEV;
 		pciehp_request(ctrl, PCI_EXP_SLTSTA_PDC);
 		wait_event(ctrl->requester,
-			   !atomic_read(&ctrl->pending_events));
+			   !atomic_read(&ctrl->pending_events) &&
+			   !ctrl->ist_running);
 		return ctrl->request_result;
 	case POWERON_STATE:
 		ctrl_info(ctrl, "Slot(%s): Already in powering on state\n",
@@ -408,7 +409,8 @@ int pciehp_sysfs_disable_slot(struct hot
 		mutex_unlock(&ctrl->state_lock);
 		pciehp_request(ctrl, DISABLE_SLOT);
 		wait_event(ctrl->requester,
-			   !atomic_read(&ctrl->pending_events));
+			   !atomic_read(&ctrl->pending_events) &&
+			   !ctrl->ist_running);
 		return ctrl->request_result;
 	case POWEROFF_STATE:
 		ctrl_info(ctrl, "Slot(%s): Already in powering off state\n",
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -583,6 +583,7 @@ static irqreturn_t pciehp_ist(int irq, v
 	irqreturn_t ret;
 	u32 events;
 
+	ctrl->ist_running = true;
 	pci_config_pm_runtime_get(pdev);
 
 	/* rerun pciehp_isr() if the port was inaccessible on interrupt */
@@ -629,6 +630,7 @@ static irqreturn_t pciehp_ist(int irq, v
 	up_read(&ctrl->reset_lock);
 
 	pci_config_pm_runtime_put(pdev);
+	ctrl->ist_running = false;
 	wake_up(&ctrl->requester);
 	return IRQ_HANDLED;
 }


