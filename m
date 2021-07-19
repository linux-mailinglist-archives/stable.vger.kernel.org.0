Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAB43CE227
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346494AbhGSP3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348269AbhGSPYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E104861464;
        Mon, 19 Jul 2021 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710623;
        bh=LmcXQhKHH1Zm46bDdL5hz6apgK7yLEpY0eWSRo6nYS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpNA+9Fe8/7vIi6z8pj8XwAnjRVsbE10BlD9Iie9a+WG2kP9e9bxE7JGBIBInJBgH
         LyKvElXb4EU2JpNkTAW5n2+q7CFvhCxLcRCtLj4aG8VQY9M+FCUvmtePtEFNUGA8pN
         ZOUu0kuYfam4CMELLNm5BlV66od/nQq9Rv3zboHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Raymond Tan <raymond.tan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/351] usb: dwc3: pci: Fix DEFINE for Intel Elkhart Lake
Date:   Mon, 19 Jul 2021 16:49:53 +0200
Message-Id: <20210719144946.097643169@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 1e51460938b8..2b37bdd39a74 100644
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



