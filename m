Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72724D5DA
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHUNLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 09:11:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:10174 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbgHUNLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 09:11:05 -0400
IronPort-SDR: U+YrHDpjup7NxW0jLkl1Penkc7RL/jGnA8aPOnWIMMUr0t+jG0FuYA/uQ9MRt8oi8KffhTDI2h
 78ARsDijIuFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="217066237"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="217066237"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 06:11:04 -0700
IronPort-SDR: 8U91G06QaJ0NAgrU8ctscmNGvUGByjpjYjMxjMWbHvV9sF7E8Q+cKsMtSBP/hXbOwP6qbzaSXV
 yMdHGdLw5ObA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="401466638"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 21 Aug 2020 06:11:03 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     linux-usb@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality
Date:   Fri, 21 Aug 2020 16:11:01 +0300
Message-Id: <20200821131101.81915-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Tan <raymond.tan@intel.com>

Similar to some other IA platforms, Elkhart Lake too depends on the
PMU register write to request transition of Dx power state.

Thus, we add the PCI_DEVICE_ID_INTEL_EHLLP to the list of devices that
shall execute the ACPI _DSM method during D0/D3 sequence.

[heikki.krogerus@linux.intel.com: included Fixes tag]

Fixes: dbb0569de852 ("usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices")
Cc: stable@vger.kernel.org
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index f5a61f57c74f0..242b6210380a4 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -147,7 +147,8 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
-				pdev->device == PCI_DEVICE_ID_INTEL_BXT_M) {
+		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
+		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
 			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
 			dwc->has_dsm_for_pm = true;
 		}
-- 
2.28.0

