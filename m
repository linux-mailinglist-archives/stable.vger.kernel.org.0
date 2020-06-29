Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E207020E7CE
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391630AbgF2WAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C35624640;
        Mon, 29 Jun 2020 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443965;
        bh=gdqGbviJQ8DPHxHnkuoAUnXO84jNZ/sdL4M8a2yZTZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQBqF9oztiGjtZxlBcMptoZXgvkoIiJQc5iTDnIYyXVoxo7yM6oF0Ut/+OJjlOMxT
         sAiMf4rWBD1pSoX3tdTOhOrNd3zqc9iIBLVXdgF0Ek80i7Pjhu2vzwHZIZ6qU/S6y7
         GuA5RPfryC52Dg7t1DpU+eDMmr+FqaXs88zMyCh0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 068/265] xhci: Poll for U0 after disabling USB2 LPM
Date:   Mon, 29 Jun 2020 11:15:01 -0400
Message-Id: <20200629151818.2493727-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit b3d71abd135e6919ca0b6cab463738472653ddfb upstream.

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
---
 drivers/usb/host/xhci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bee5deccc83d8..10d76205a79ca 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4471,6 +4471,9 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			mutex_lock(hcd->bandwidth_mutex);
 			xhci_change_max_exit_latency(xhci, udev, 0);
 			mutex_unlock(hcd->bandwidth_mutex);
+			readl_poll_timeout(ports[port_num]->addr, pm_val,
+					   (pm_val & PORT_PLS_MASK) == XDEV_U0,
+					   100, 10000);
 			return 0;
 		}
 	}
-- 
2.25.1

