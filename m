Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE7B60B4FE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiJXSLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiJXSLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:11:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF44264E63;
        Mon, 24 Oct 2022 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666630369; x=1698166369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mydry6pvXJm6Uq+Hqk5qsF2zCLjzA4jKAd1M7m1H4t0=;
  b=klgUeNiiSgcfBRic48ET2DYed9T6vD3YHH1Kp7qT1aBqNOO+YFGyvKXj
   dFWCdfoybt5iuWhK9E4vtiEE8xe0+Wz1MM6AATgYxSl9ryFdvz896i9fS
   efvB7r6jTYLkKvKowA0P7sXvmaulUodVfXL403NRo3T5mltonlpnaizBh
   /VGdsLvKJeQS+YT4B6DohBD9HsAGe5JUinP271bfqrJKD05qJeXgl/oXO
   LmuMDqtvrC+TArUi1wluv6CKZPISdQQSd9RaeJ1+J1neV3L6xx4GqosON
   FgRCTmeuBh/HdskXqgWrif73hbwYaQvpF59Xo2hOduBvqrKXaZDFQ2Zbx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="290732861"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="290732861"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 07:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="700177611"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="700177611"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga004.fm.intel.com with ESMTP; 24 Oct 2022 07:26:00 -0700
From:   Mathias Nyman <mathias.nyman@intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/4] usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller
Date:   Mon, 24 Oct 2022 17:27:17 +0300
Message-Id: <20221024142720.4122053-2-mathias.nyman@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221024142720.4122053-1-mathias.nyman@intel.com>
References: <20221024142720.4122053-1-mathias.nyman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

This appears to fix the error:
"xhci_hcd <address>; ERROR Transfer event TRB DMA ptr not part of
current TD ep_index 2 comp_code 13" that appear spuriously (or pretty
often) when using a r8152 USB3 ethernet adapter with integrated hub.

ASM1042 reports as a 0.96 controller, but appears to behave more like 1.0

Inspired by this email thread: https://markmail.org/thread/7vzqbe7t6du6qsw3

Cc: stable@vger.kernel.org
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 40228a3d77a0..6dd3102749b7 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -306,8 +306,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
-- 
2.25.1

