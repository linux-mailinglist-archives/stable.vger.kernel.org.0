Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0772A5882
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgKCUqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbgKCUqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FB822404;
        Tue,  3 Nov 2020 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436412;
        bh=i6Il6kjpPM77yfeullmaYgn7IGlIDL4NLgMvuN8Hpnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0wTnDZllarW5W+0E/Blu65EhBoUNLllWVhlPtKIkomFksi43+i1nQ+nH8yHx1gb6
         gt0CQYYy7gh2wT5cMYxgaB2+w8Z9Y4hd6VNk3roo/MsLM3PWMtzURdkjaHBrimXckF
         RzSyC/y7d3D/T2050UXVLcVUBflbaf7nmdbzy/fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 239/391] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality
Date:   Tue,  3 Nov 2020 21:34:50 +0100
Message-Id: <20201103203403.132715049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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


