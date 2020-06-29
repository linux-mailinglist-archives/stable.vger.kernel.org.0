Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B220DA7F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgF2T5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbgF2TkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB5C52487D;
        Mon, 29 Jun 2020 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444379;
        bh=0ojqZ3xSEL6DtPWJWKShNDGexKeRTIPRH9yGm9GLi8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utWAqH3o3s2ijbdR3AoguaIoBDYiID+B0jNZbTcagb4SAtUDZH6uP1kSwCo12cB1n
         Nv4KDm46K+10dWJAg5FUkknbBLXq7GUh5AXiXjQ1b2Fv18gg3iQSWwgHfebppflBY8
         nXrOan6l/Iw0R90LTYEImXzEGi0fkjrFZB5Kilyw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 056/178] xhci: Return if xHCI doesn't support LPM
Date:   Mon, 29 Jun 2020 11:23:21 -0400
Message-Id: <20200629152523.2494198-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f0c472a6da51f9fac15e80fe2fd9c83b68754cff upstream.

Just return if xHCI is quirked to disable LPM. We can save some time
from reading registers and doing spinlocks.

Add stable tag as we want this patch together with the next one,
"Poll for U0 after disabling USB2 LPM" which fixes a suspend issue
for some USB2 LPM devices

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200624135949.22611-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 13d2971c35445..11a65854d3f09 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4391,6 +4391,9 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	int		hird, exit_latency;
 	int		ret;
 
+	if (xhci->quirks & XHCI_HW_LPM_DISABLE)
+		return -EPERM;
+
 	if (hcd->speed >= HCD_USB3 || !xhci->hw_lpm_support ||
 			!udev->lpm_capable)
 		return -EPERM;
@@ -4413,7 +4416,7 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
 			enable ? "enable" : "disable", port_num + 1);
 
-	if (enable && !(xhci->quirks & XHCI_HW_LPM_DISABLE)) {
+	if (enable) {
 		/* Host supports BESL timeout instead of HIRD */
 		if (udev->usb2_hw_lpm_besl_capable) {
 			/* if device doesn't have a preferred BESL value use a
-- 
2.25.1

