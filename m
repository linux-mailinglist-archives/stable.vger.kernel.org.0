Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847482F8078
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbhAOQTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:19:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:57457 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbhAOQTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 11:19:09 -0500
IronPort-SDR: X+qmMBJHMdtQQFg7yLWPZdVrVXHrK/uD13Wwz+Vox8OcLwFFUH1mX8p+vMjgTXyu7EQS4xN1O/
 +kL2eq4ZzS+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="242638647"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="242638647"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 08:17:18 -0800
IronPort-SDR: Xwf28O28/g0RHdhuwhK6du15I44lbrOrTGVHe6/9URI9jbLE6Jz20yk33orYj2HIbzEjMU97/U
 FEPTFIegN1hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="465626811"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jan 2021 08:17:17 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, JC Kuo <jckuo@nvidia.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/2] xhci: tegra: Delay for disabling LFPS detector
Date:   Fri, 15 Jan 2021 18:19:07 +0200
Message-Id: <20210115161907.2875631-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JC Kuo <jckuo@nvidia.com>

Occasionally, we are seeing some SuperSpeed devices resumes right after
being directed to U3. This commits add 500us delay to ensure LFPS
detector is disabled before sending ACK to firmware.

[   16.099363] tegra-xusb 70090000.usb: entering ELPG
[   16.104343] tegra-xusb 70090000.usb: 2-1 isn't suspended: 0x0c001203
[   16.114576] tegra-xusb 70090000.usb: not all ports suspended: -16
[   16.120789] tegra-xusb 70090000.usb: entering ELPG failed

The register write passes through a few flop stages of 32KHz clock domain.
NVIDIA ASIC designer reviewed RTL and suggests 500us delay.

Cc: stable@vger.kernel.org
Signed-off-by: JC Kuo <jckuo@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-tegra.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 934be1686352..50bb91b6a4b8 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -623,6 +623,13 @@ static void tegra_xusb_mbox_handle(struct tegra_xusb *tegra,
 								     enable);
 			if (err < 0)
 				break;
+
+			/*
+			 * wait 500us for LFPS detector to be disabled before
+			 * sending ACK
+			 */
+			if (!enable)
+				usleep_range(500, 1000);
 		}
 
 		if (err < 0) {
-- 
2.25.1

