Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309C120D31B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgF2Szt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729974AbgF2SzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DD823F28;
        Mon, 29 Jun 2020 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446117;
        bh=M1QucpjvT5eQKOYWZVjXYjHcyud6sajkmXPvml24HBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmOs17oacklVED4lxuYBoRdHaKPIWTVI1240q9dbQLdrRLyLEaegavEWpqqW1gGe0
         ZoaHn5bEjA8W0i24fidb2TM7Osgew5ps034y9cG+JwcJ1zesw4yranjBwzXi9xpIiz
         Mi70/CVNDGXRvkXh8i6Pdk7itULlfnTU8NvJjgTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 108/135] xhci: Poll for U0 after disabling USB2 LPM
Date:   Mon, 29 Jun 2020 11:52:42 -0400
Message-Id: <20200629155309.2495516-109-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit b3d71abd135e6919ca0b6cab463738472653ddfb ]

USB2 devices with LPM enabled may interrupt the system suspend:
[  932.510475] usb 1-7: usb suspend, wakeup 0
[  932.510549] hub 1-0:1.0: hub_suspend
[  932.510581] usb usb1: bus suspend, wakeup 0
[  932.510590] xhci_hcd 0000:00:14.0: port 9 not suspended
[  932.510593] xhci_hcd 0000:00:14.0: port 8 not suspended
..
[  932.520323] xhci_hcd 0000:00:14.0: Port change event, 1-7, id 7, portsc: 0x400e03
..
[  932.591405] PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -16
[  932.591414] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -16
[  932.591418] PM: Device 0000:00:14.0 failed to suspend async: error -16

During system suspend, USB core will let HC suspends the device if it
doesn't have remote wakeup enabled and doesn't have any children.
However, from the log above we can see that the usb 1-7 doesn't get bus
suspended due to not in U0. After a while the port finished U2 -> U0
transition, interrupts the suspend process.

The observation is that after disabling LPM, port doesn't transit to U0
immediately and can linger in U2. xHCI spec 4.23.5.2 states that the
maximum exit latency for USB2 LPM should be BESL + 10us. The BESL for
the affected device is advertised as 400us, which is still not enough
based on my testing result.

So let's use the maximum permitted latency, 10000, to poll for U0
status to solve the issue.

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200624135949.22611-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 7272c98becb8b..51d84332eb786 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4264,6 +4264,9 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			mutex_lock(hcd->bandwidth_mutex);
 			xhci_change_max_exit_latency(xhci, udev, 0);
 			mutex_unlock(hcd->bandwidth_mutex);
+			readl_poll_timeout(port_array[port_num], pm_val,
+					   (pm_val & PORT_PLS_MASK) == XDEV_U0,
+					   100, 10000);
 			return 0;
 		}
 	}
-- 
2.25.1

