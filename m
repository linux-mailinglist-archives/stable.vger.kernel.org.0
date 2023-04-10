Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0F6DC4D2
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjDJJGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDJJGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2654E30C3
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A2D60FC7
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0B6C433D2;
        Mon, 10 Apr 2023 09:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681117592;
        bh=G93a4Y9jW0YHlnpM+4jKittZ9hjQmXw1s1kL924V9RQ=;
        h=Subject:To:Cc:From:Date:From;
        b=D4qjhQbPgwuY981qQiLWXSdHEgEPtlE+OllH3vJiZ5k0fWpmf4/gNqvvH4FfZSwDE
         c+WjUqh3EMh59nb5w26Lk2FsFx2XchGPPzl4Ud872/afjX8celLEVYpPcL8cy+9Hg0
         bmEWpxI+zz0VXh/OLAmQqmChLDJny55ZLVTDyXxc=
Subject: FAILED: patch "[PATCH] xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a" failed to apply to 4.19-stable tree
To:     scott@os.amperecomputing.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, maz@kernel.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 11:06:23 +0200
Message-ID: <2023041023-unweave-bolt-64d3@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x ecaa4902439298f6b0e29f47424a86b310a9ff4f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041023-unweave-bolt-64d3@gregkh' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

ecaa49024392 ("xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu")
f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
05afde1a7ef3 ("xhci: Use device_iommu_mapped()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ecaa4902439298f6b0e29f47424a86b310a9ff4f Mon Sep 17 00:00:00 2001
From: D Scott Phillips <scott@os.amperecomputing.com>
Date: Thu, 30 Mar 2023 17:30:54 +0300
Subject: [PATCH] xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a
 passthrough iommu

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

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6183ce8574b1..bdb6dd819a3b 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
@@ -228,6 +229,7 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct iommu_domain *domain;
 	int err, i;
 	u64 val;
 	u32 intrs;
@@ -246,7 +248,9 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	 * an iommu. Doing anything when there is no iommu is definitely
 	 * unsafe...
 	 */
-	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !device_iommu_mapped(dev))
+	domain = iommu_get_domain_for_dev(dev);
+	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !domain ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
 
 	xhci_info(xhci, "Zeroing 64bit base registers, expecting fault\n");

