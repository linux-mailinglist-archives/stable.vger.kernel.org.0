Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF01820E85D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgF2WGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgF2SfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9982B2463E;
        Mon, 29 Jun 2020 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443963;
        bh=giJcWPoG0KotqrnpuGv7hPNXaJdUSSdszAHKNZgTzbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy7Cd39v+FzTDA5bGXmgHFUPODXOxZ4lE3AOvS1AA8s1j/ieJTowEMgcb+eMazd6F
         XZ8/l67eJ3V3lchRg2scldaOJ4uit+ERhWyxZhCRi+qKETQz4JxeKt1M7Ax36IvRP6
         iRRglGCNS76S+lDmCl9ooFlV92/7igWiq4WMLkbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 066/265] USB: ehci: reopen solution for Synopsys HC bug
Date:   Mon, 29 Jun 2020 11:14:59 -0400
Message-Id: <20200629151818.2493727-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

commit 1ddcb71a3edf0e1682b6e056158e4c4b00325f66 upstream.

A Synopsys USB2.0 core used in Huawei Kunpeng920 SoC has a bug which
might cause the host controller not issuing ping.

Bug description:
After indicating an Interrupt on Async Advance, the software uses the
doorbell mechanism to delete the Next Link queue head of the last
executed queue head. At this time, the host controller still references
the removed queue head(the queue head is NULL). NULL reference causes
the host controller to lose the USB device.

Solution:
After deleting the Next Link queue head, when has_synopsys_hc_bug set
to 1，the software can write one of the valid queue head addresses to
the ASYNCLISTADDR register to allow the host controller to get
the valid queue head. in order to solve that problem, this patch set
the flag for Huawei Kunpeng920

There are detailed instructions and solutions in this patch:
commit 2f7ac6c19997 ("USB: ehci: add workaround for Synopsys HC bug")

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1591588019-44284-1-git-send-email-liulongfang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 1a48ab1bd3b2a..7ff2cbdcd0b22 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -216,6 +216,13 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 		ehci_info(ehci, "applying MosChip frame-index workaround\n");
 		ehci->frame_index_bug = 1;
 		break;
+	case PCI_VENDOR_ID_HUAWEI:
+		/* Synopsys HC bug */
+		if (pdev->device == 0xa239) {
+			ehci_info(ehci, "applying Synopsys HC workaround\n");
+			ehci->has_synopsys_hc_bug = 1;
+		}
+		break;
 	}
 
 	/* optional debug port, normally in the first BAR */
-- 
2.25.1

