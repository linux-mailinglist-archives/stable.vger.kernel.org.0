Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2819166C275
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjAPOoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjAPOn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:43:27 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1941235250;
        Mon, 16 Jan 2023 06:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673878865; x=1705414865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FOtaO11t0Ar8xb01wBzMn/u2p+iPSu1k3qXC9QT7fQ4=;
  b=lZpaMCErDQ+zqSKL73cci11I2GdVzqnMeJg3z2YTtGO+kzgMKMEIMTp+
   Klqql9wDTPaOOp8aegF4WoxuPPhmDsTydiIL0oeQcGramCYGLPx9UlBKX
   VvFR7mxH0Qdc8s5s9rmrsW6W6M750pd5glosPINC+M+i3Rg05V+IycMFp
   /7FUzVcOc/iow4GGpNBjriWzVaQ2SF6jqGDH8qlWipIgpKjhNjHV1hjt4
   dcEPiQRRCGRTLQjgzjv0PXfaMN9PM8lXFYb1ntYiAoeKrPniJbkbshqQ+
   JUthyYaHVAAvIr+hhOYaJbcFV1GHkM/fktsNO/fvb/8u5yGtfCqzafDN3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312322918"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="312322918"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 06:21:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987817173"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="987817173"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 06:21:02 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/7] xhci-pci: set the dma max_seg_size
Date:   Mon, 16 Jan 2023 16:22:10 +0200
Message-Id: <20230116142216.1141605-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

Allow devices to have dma operations beyond 64K, and avoid warnings such
as:

xhci_hcd 0000:00:14.0: mapping sg segment longer than device claims to support [len=98304] [max=65536]

Cc: stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 79d679b3e076..2c0d7038f040 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -455,6 +455,8 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:
-- 
2.25.1

