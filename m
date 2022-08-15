Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D51592EEF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiHOMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHOMdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:33:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D62A656D;
        Mon, 15 Aug 2022 05:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660566804; x=1692102804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EYwYwSlIeNzhQSlUibBSk545qRVa1cPAS+299hUPz7k=;
  b=ncFFUSoVogKZDkGJRkEs5M/X3VWbIgK3aOVY0ENvkI0G6qtjMs2+9dSE
   ztXJYeKA1q0ZLTVHx3XoNZ0MDz3YLLNqpPa0mcDN5fnIJ5gTHO6d5nXun
   JdtcyE/nua0j7BNotf3/fBFlXdH3ClxwVhd/TXa83kgmSErM0LKuEBY9N
   mzj6ZUGrFfYjygdL6MrE9BKZ4lq/2G8/yR5xzHsuYMwc6BQCifRRrgA+3
   BBHVu3QSQJwSvSnp8pq7h59liW3rKSNpu0pQnUnEgTc2L+Qt2eulDxV4x
   LDxzy0CUD+3x0ylhl84uwrxOO+qdg3WONHgCZKHe3rQg0/5Nb8MM9QN8z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="353689479"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="353689479"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 05:33:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="748907209"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2022 05:33:22 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: pci: Add support for Intel Raptor Lake
Date:   Mon, 15 Aug 2022 15:33:34 +0300
Message-Id: <20220815123334.87526-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds the necessary PCI device ID for the controller
inside the Intel Raptor Lake CPU block. The controllers that
are part of the PCH (chipset) have separate device IDs.

Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 6b018048fe2e1..4ee4ca09873af 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -44,6 +44,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
+#define PCI_DEVICE_ID_INTEL_RPL			0x460e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
@@ -456,6 +457,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-- 
2.35.1

