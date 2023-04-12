Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A786DEE9B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjDLInd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDLInO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ACF975A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FBEF6306F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50F8C433D2;
        Wed, 12 Apr 2023 08:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288912;
        bh=J8k/ZPAuNUgwFx/OaEXQKRiBPzPd7xSlMUB02YKmDRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzAyT3DIku+MYUyzA1h4drN/sjh9CjtYB5uwlcuGv79Qx2IQ0JqaD7dvveogIFFBu
         Go1Mn/SE7p/XAE8B6XTFmoe6F/M5SGgxQ9qu53D8xxchWC/YbqTR9uPcMZU9XelpcI
         chYG4JCMbsHNFCOgwWW6GnfqwKXR/zKh+WFOgGgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Marc Zyngier <maz@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 064/164] xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu
Date:   Wed, 12 Apr 2023 10:33:06 +0200
Message-Id: <20230412082839.524912340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D Scott Phillips <scott@os.amperecomputing.com>

commit ecaa4902439298f6b0e29f47424a86b310a9ff4f upstream.

Previously the quirk was skipped when no iommu was present. The same
rationale for skipping the quirk also applies in the iommu.passthrough=1
case.

Skip applying the XHCI_ZERO_64B_REGS quirk if the device's iommu domain is
passthrough.

Fixes: 12de0a35c996 ("xhci: Add quirk to zero 64bit registers on Renesas PCIe controllers")
Cc: stable <stable@kernel.org>
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
@@ -228,6 +229,7 @@ int xhci_reset(struct xhci_hcd *xhci, u6
 static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct iommu_domain *domain;
 	int err, i;
 	u64 val;
 	u32 intrs;
@@ -246,7 +248,9 @@ static void xhci_zero_64b_regs(struct xh
 	 * an iommu. Doing anything when there is no iommu is definitely
 	 * unsafe...
 	 */
-	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !device_iommu_mapped(dev))
+	domain = iommu_get_domain_for_dev(dev);
+	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !domain ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
 
 	xhci_info(xhci, "Zeroing 64bit base registers, expecting fault\n");


