Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA998582F03
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiG0RUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241655AbiG0RSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:18:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B6979EFD;
        Wed, 27 Jul 2022 09:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E03E601C3;
        Wed, 27 Jul 2022 16:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF77C433D6;
        Wed, 27 Jul 2022 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940237;
        bh=gZtPCMQ0JD9Ip4j75/GtiuMQLZb64IKyLIRcJaTpJzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAhagIZXgDd+pGcjRjNB+F7Fqu6UAqQ+V2tjbX8exDNcXaHZ0keHku2r1Sp8ivyMR
         J8l+d2fbbFPG3vKd/+oTAymn8Sa/sLr7ytTvoS5U7Qh73EBXeC34lyfvXJpbz1BqN5
         y55kituK6kne9qwiqL2mniwY1KDHm30GcKdmlUlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/201] xhci: dbc: Rename xhci_dbc_init and xhci_dbc_exit
Date:   Wed, 27 Jul 2022 18:10:58 +0200
Message-Id: <20220727161034.207557773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 5c44d9d7570b244ca08fef817c4c90aa7a1f1b5f ]

These names give the impression the functions are related to
module init calls, but are in fact creating and removing the dbc
fake device

Rename them to xhci_create_dbc_dev() and xhci_remove_dbc_dev().

We will need the _init and _exit names for actual dbc module init
and exit calls.

No functional changes

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220216095153.1303105-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.c | 5 +++--
 drivers/usb/host/xhci-dbgcap.h | 8 ++++----
 drivers/usb/host/xhci.c        | 4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index f4da5708a40f..46c8f3c187f7 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -1017,7 +1017,8 @@ void xhci_dbc_remove(struct xhci_dbc *dbc)
 	kfree(dbc);
 }
 
-int xhci_dbc_init(struct xhci_hcd *xhci)
+
+int xhci_create_dbc_dev(struct xhci_hcd *xhci)
 {
 	struct device		*dev;
 	void __iomem		*base;
@@ -1041,7 +1042,7 @@ int xhci_dbc_init(struct xhci_hcd *xhci)
 	return ret;
 }
 
-void xhci_dbc_exit(struct xhci_hcd *xhci)
+void xhci_remove_dbc_dev(struct xhci_hcd *xhci)
 {
 	unsigned long		flags;
 
diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index 5d8c7815491c..8b5b363a0719 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -194,8 +194,8 @@ static inline struct dbc_ep *get_out_ep(struct xhci_dbc *dbc)
 }
 
 #ifdef CONFIG_USB_XHCI_DBGCAP
-int xhci_dbc_init(struct xhci_hcd *xhci);
-void xhci_dbc_exit(struct xhci_hcd *xhci);
+int xhci_create_dbc_dev(struct xhci_hcd *xhci);
+void xhci_remove_dbc_dev(struct xhci_hcd *xhci);
 int xhci_dbc_tty_probe(struct device *dev, void __iomem *res, struct xhci_hcd *xhci);
 void xhci_dbc_tty_remove(struct xhci_dbc *dbc);
 struct xhci_dbc *xhci_alloc_dbc(struct device *dev, void __iomem *res,
@@ -211,12 +211,12 @@ int xhci_dbc_suspend(struct xhci_hcd *xhci);
 int xhci_dbc_resume(struct xhci_hcd *xhci);
 #endif /* CONFIG_PM */
 #else
-static inline int xhci_dbc_init(struct xhci_hcd *xhci)
+static inline int xhci_create_dbc_dev(struct xhci_hcd *xhci)
 {
 	return 0;
 }
 
-static inline void xhci_dbc_exit(struct xhci_hcd *xhci)
+static inline void xhci_remove_dbc_dev(struct xhci_hcd *xhci)
 {
 }
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 94fe7d64e762..a4e99f8668b3 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,7 +693,7 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
-	xhci_dbc_init(xhci);
+	xhci_create_dbc_dev(xhci);
 
 	xhci_debugfs_init(xhci);
 
@@ -723,7 +723,7 @@ static void xhci_stop(struct usb_hcd *hcd)
 		return;
 	}
 
-	xhci_dbc_exit(xhci);
+	xhci_remove_dbc_dev(xhci);
 
 	spin_lock_irq(&xhci->lock);
 	xhci->xhc_state |= XHCI_STATE_HALTED;
-- 
2.35.1



