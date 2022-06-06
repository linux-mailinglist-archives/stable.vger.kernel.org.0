Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1819753E6AB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiFFLg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiFFLfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:35:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1E1B7B1;
        Mon,  6 Jun 2022 04:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654515314; x=1686051314;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mqq/I6JH+2jc6rqeS+J0c5Od7x0FtTJYCRFam/X/jKg=;
  b=hHaO0KZpSifBautd06hNy312GX7xF+otQFjJCA89/VSkWmamOJmTWIbJ
   j9vxYCCw9goNGAa3J/F8JbYFGj097Icca0bOXQlYgntZ3W6ZQiGJarQvO
   l0tmVStJUlfXA6nwmeLDukXI75GHFojv4gK+pfZYORC9wuGT0xNCg5aA/
   BB7nK0WPHFIabH4rE7aY+M2PwLM1typgOw2XKnYXmnuoxjDAZuu09JEr/
   Rb2VsEKYFuJTAMj0xUIH9RQC86/7XRM8g2Q4kAvMYKoJukLdQPbLzCi1L
   EFmttjML6xPC0CR9FzTYsoF39bhRuZagigToK8K01vq7RCASXEHTbBkel
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="257093549"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="257093549"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 04:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="532095386"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2022 04:35:12 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     rydberg@bitmath.org
Cc:     linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Subject: [PATCH] Input: bcm5974 - Set missing URB_NO_TRANSFER_DMA_MAP urb flag
Date:   Mon,  6 Jun 2022 14:36:36 +0300
Message-Id: <20220606113636.588955-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bcm5974 driver does the allocation and dma mapping of the usb urb
data buffer, but driver does not set the URB_NO_TRANSFER_DMA_MAP flag
to let usb core know the buffer is already mapped.

usb core tries to map the already mapped buffer, causing a warning:
"xhci_hcd 0000:00:14.0: rejecting DMA map of vmalloc memory"

Fix this by setting the URB_NO_TRANSFER_DMA_MAP, letting usb core
know buffer is already mapped by bcm5974 driver

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/input/mouse/bcm5974.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 59a14505b9cd..ca150618d32f 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -942,17 +942,22 @@ static int bcm5974_probe(struct usb_interface *iface,
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
-	if (dev->bt_urb)
+	if (dev->bt_urb) {
 		usb_fill_int_urb(dev->bt_urb, udev,
 				 usb_rcvintpipe(udev, cfg->bt_ep),
 				 dev->bt_data, dev->cfg.bt_datalen,
 				 bcm5974_irq_button, dev, 1);
 
+		dev->bt_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	}
+
 	usb_fill_int_urb(dev->tp_urb, udev,
 			 usb_rcvintpipe(udev, cfg->tp_ep),
 			 dev->tp_data, dev->cfg.tp_datalen,
 			 bcm5974_irq_trackpad, dev, 1);
 
+	dev->tp_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));
-- 
2.25.1

