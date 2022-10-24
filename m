Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015B960B506
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiJXSMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiJXSLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:11:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CC92681C8;
        Mon, 24 Oct 2022 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666630384; x=1698166384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ib3qb+K+OVQ9lpRpy2KLde05xSnKkYgU+kMBtNcI5ZY=;
  b=AbNT4qBbFZrICFZGm/Pbu6W1zuSgBd3MNdSoCLpX4RTuQT2kuInswkQ3
   RzzqFX+q6Be8K921Anb+ny3gqTd7li8Cb/NLngcMhODWpGoURmPhXbxPH
   j1+nUUIsu09/Y/70uN8oy0o6cw6VAXqpfxSib73sZ+GkBeN1YvZ+Kk/i6
   yiv1frEjaWNCreS0Q3MoKEnq31CpcfokBTHBqeCgSAlPxYFpzez+mw06L
   nMOnimmHH6l0dGeypFIncsu2x5mIsQqKfcarXuBHbLj0Af2/zsNeCG1Us
   dWQl3MRiUCl7ZFBYUaKY7EQTUzUG8RXp6+KK9KaRhMl3La+UMdpIba7ox
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="290732899"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="290732899"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 07:26:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="700177651"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="700177651"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga004.fm.intel.com with ESMTP; 24 Oct 2022 07:26:06 -0700
From:   Mathias Nyman <mathias.nyman@intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH 4/4] xhci: Remove device endpoints from bandwidth list when freeing the device
Date:   Mon, 24 Oct 2022 17:27:20 +0300
Message-Id: <20221024142720.4122053-5-mathias.nyman@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221024142720.4122053-1-mathias.nyman@intel.com>
References: <20221024142720.4122053-1-mathias.nyman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

Endpoints are normally deleted from the bandwidth list when they are
dropped, before the virt device is freed.

If xHC host is dying or being removed then the endpoints aren't dropped
cleanly due to functions returning early to avoid interacting with a
non-accessible host controller.

So check and delete endpoints that are still on the bandwidth list when
freeing the virt device.

Solves a list_del corruption kernel crash when unbinding xhci-pci,
caused by xhci_mem_cleanup() when it later tried to delete already freed
endpoints from the bandwidth list.

This only affects hosts that use software bandwidth checking, which
currenty is only the xHC in intel Panther Point PCH (Ivy Bridge)

Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 9e56aa28efcd..81ca2bc1f0be 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -889,15 +889,19 @@ void xhci_free_virt_device(struct xhci_hcd *xhci, int slot_id)
 		if (dev->eps[i].stream_info)
 			xhci_free_stream_info(xhci,
 					dev->eps[i].stream_info);
-		/* Endpoints on the TT/root port lists should have been removed
-		 * when usb_disable_device() was called for the device.
-		 * We can't drop them anyway, because the udev might have gone
-		 * away by this point, and we can't tell what speed it was.
+		/*
+		 * Endpoints are normally deleted from the bandwidth list when
+		 * endpoints are dropped, before device is freed.
+		 * If host is dying or being removed then endpoints aren't
+		 * dropped cleanly, so delete the endpoint from list here.
+		 * Only applicable for hosts with software bandwidth checking.
 		 */
-		if (!list_empty(&dev->eps[i].bw_endpoint_list))
-			xhci_warn(xhci, "Slot %u endpoint %u "
-					"not removed from BW list!\n",
-					slot_id, i);
+
+		if (!list_empty(&dev->eps[i].bw_endpoint_list)) {
+			list_del_init(&dev->eps[i].bw_endpoint_list);
+			xhci_dbg(xhci, "Slot %u endpoint %u not removed from BW list!\n",
+				 slot_id, i);
+		}
 	}
 	/* If this is a hub, free the TT(s) from the TT list */
 	xhci_free_tt_info(xhci, dev, slot_id);
-- 
2.25.1

