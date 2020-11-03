Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DC52A56CA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgKCVbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731475AbgKCU5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C76AE223AC;
        Tue,  3 Nov 2020 20:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437072;
        bh=i6Il6kjpPM77yfeullmaYgn7IGlIDL4NLgMvuN8Hpnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zI7gSVhQ4Z6k7RhClzFIRbgIdxezdp1Z+JhdXImqtHOdQ02LUQfVCfjvKDYaxkxLU
         I1dAQ46CjiKhnxy6gxICKqZdWET/lL6L2RSlRDXasrK0NZFjlnU8szlqq2Z0ZVvc1f
         pvT9jNmsEkFq5iwl3kCozj6eKANbars7Zz8UlKAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 134/214] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality
Date:   Tue,  3 Nov 2020 21:36:22 +0100
Message-Id: <20201103203303.402427062@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Tan <raymond.tan@intel.com>

commit a609ce2a13360d639b384b6ca783b38c1247f2db upstream.

Similar to some other IA platforms, Elkhart Lake too depends on the
PMU register write to request transition of Dx power state.

Thus, we add the PCI_DEVICE_ID_INTEL_EHLLP to the list of devices that
shall execute the ACPI _DSM method during D0/D3 sequence.

[heikki.krogerus@linux.intel.com: included Fixes tag]

Fixes: dbb0569de852 ("usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices")
Cc: stable@vger.kernel.org
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -147,7 +147,8 @@ static int dwc3_pci_quirks(struct dwc3_p
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
-				pdev->device == PCI_DEVICE_ID_INTEL_BXT_M) {
+		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
+		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
 			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
 			dwc->has_dsm_for_pm = true;
 		}


