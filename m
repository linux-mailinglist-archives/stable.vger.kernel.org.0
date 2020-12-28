Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D552E3F0E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504863AbgL1OdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504854AbgL1Oc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8860F20739;
        Mon, 28 Dec 2020 14:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165964;
        bh=gRy94s2sbUg0C1X15+6rKhNBxvvc770rBBVwx5EyJ28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhITvIEDAIu2cmrAVOjQbq7Tr80DHypZVZcavNbTaewIKiJEosKWpE9YvEL6kGd9n
         Lw7hSi7g2LVCNhiKDtzCx/apdQYcNe0jrpgsYjoKsLeCVEgN39+zA2m8Sk3VUyXIM0
         yHrjU7RL24FELfzEaWmLpfTEXDLWIV1x56ZkkTPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jubin Zhong <zhongjubin@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 710/717] PCI: Fix pci_slot_release() NULL pointer dereference
Date:   Mon, 28 Dec 2020 13:51:48 +0100
Message-Id: <20201228125055.010697113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jubin Zhong <zhongjubin@huawei.com>

commit 4684709bf81a2d98152ed6b610e3d5c403f9bced upstream.

If kobject_init_and_add() fails, pci_slot_release() is called to delete
slot->list from parent->slots.  But slot->list hasn't been initialized
yet, so we dereference a NULL pointer:

  Unable to handle kernel NULL pointer dereference at virtual address
00000000
  ...
  CPU: 10 PID: 1 Comm: swapper/0 Not tainted 4.4.240 #197
  task: ffffeb398a45ef10 task.stack: ffffeb398a470000
  PC is at __list_del_entry_valid+0x5c/0xb0
  LR is at pci_slot_release+0x84/0xe4
  ...
  __list_del_entry_valid+0x5c/0xb0
  pci_slot_release+0x84/0xe4
  kobject_put+0x184/0x1c4
  pci_create_slot+0x17c/0x1b4
  __pci_hp_initialize+0x68/0xa4
  pciehp_probe+0x1a4/0x2fc
  pcie_port_probe_service+0x58/0x84
  driver_probe_device+0x320/0x470

Initialize slot->list before calling kobject_init_and_add() to avoid this.

Fixes: 8a94644b440e ("PCI: Fix pci_create_slot() reference count leak")
Link: https://lore.kernel.org/r/1606876422-117457-1-git-send-email-zhongjubin@huawei.com
Signed-off-by: Jubin Zhong <zhongjubin@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/slot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -272,6 +272,9 @@ placeholder:
 		goto err;
 	}
 
+	INIT_LIST_HEAD(&slot->list);
+	list_add(&slot->list, &parent->slots);
+
 	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
 				   "%s", slot_name);
 	if (err) {
@@ -279,9 +282,6 @@ placeholder:
 		goto err;
 	}
 
-	INIT_LIST_HEAD(&slot->list);
-	list_add(&slot->list, &parent->slots);
-
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &parent->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot_nr)


