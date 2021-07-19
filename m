Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C733CE448
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbhGSPnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347296AbhGSPjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E5261175;
        Mon, 19 Jul 2021 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711543;
        bh=LTJWYMUPiITN3Wa6Cf/Hoco6oaVd8XiUe0xBl1/a+Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIAmSnwFapjC7zzP2Ye2rZvfI4o1i66rsAMaRmWG/wUpGIpwRXwRS5WmjjCm2gzsd
         PBvqR733n54N4izZlg0O9x/vYfK3wPq9AKv9PAGgFXkasfwi2da9ysn0Fx4SJLZTJ6
         /kMLmSMEidH5JvpzqyJ64ewjeflO4pjgD6e/1WyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Raymond Tan <raymond.tan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 040/292] usb: dwc3: pci: Fix DEFINE for Intel Elkhart Lake
Date:   Mon, 19 Jul 2021 16:51:42 +0200
Message-Id: <20210719144943.835218100@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Tan <raymond.tan@intel.com>

[ Upstream commit 457d22850b27de3aea336108272d08602c55fdf7 ]

There's no separate low power (LP) version of Elkhart Lake, thus
this patch updates the PCI Device ID DEFINE to indicate this.

Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210512135901.28495-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 19789e94bbd0..45ec5ac9876e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -36,7 +36,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
 #define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
-#define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
+#define PCI_DEVICE_ID_INTEL_EHL			0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
@@ -167,7 +167,7 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
 		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
-		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
+		    pdev->device == PCI_DEVICE_ID_INTEL_EHL) {
 			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
 			dwc->has_dsm_for_pm = true;
 		}
@@ -375,8 +375,8 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICLLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHLLP),
-	  (kernel_ulong_t) &dwc3_pci_intel_swnode },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
-- 
2.30.2



